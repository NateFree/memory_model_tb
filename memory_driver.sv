class memory_driver extends uvm_driver #(memory_pkt);
  `uvm_component_utils(memory_driver)
  
  virtual memory_if  mem_vif;
  
  function new(string name="", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual memory_if)::get(this, "", "mem_vif", mem_vif))
      `uvm_fatal(get_full_name(), "Could not get handle to VIF!");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    fork
      reset();
      drive_if();
    join_none
  endtask
  
  task reset();
    forever begin
      @(posedge mem_vif.clk) begin
        if(!mem_vif.rst_b) begin
          mem_vif.addr  = 0;
          mem_vif.wr_en = 0;
          mem_vif.rd_en = 0;
          mem_vif.wdata = 0;
        end
      end
    end
  endtask
  
  task drive_if();
    memory_pkt pkt;
    
    forever begin
      @(posedge mem_vif.clk) begin
        while(mem_vif.rst_b) begin
          seq_item_port.get_next_item(pkt);
        
          repeat(2) @(posedge mem_vif.clk) begin
            mem_vif.stable_cnt++;
            mem_vif.addr  = pkt.addr;
            mem_vif.wr_en = pkt.wr_en;
            mem_vif.rd_en = pkt.rd_en;
            mem_vif.wdata = pkt.wdata;
          end
  
          seq_item_port.item_done();
        
          mem_vif.stable_cnt = 0;
        end
      end
    end
  endtask
endclass