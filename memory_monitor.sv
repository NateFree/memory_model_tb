class memory_monitor extends uvm_monitor;
  `uvm_component_utils(memory_monitor)
  
  virtual memory_if mem_vif;
  
  uvm_analysis_port #(memory_pkt) analysis_port;
  
  function new(string name="", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual memory_if)::get(this,"","mem_vif",mem_vif))
      `uvm_fatal(get_full_name(), "Could not get handle to VIF!")
      
      analysis_port = new("analysis_port", this);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    memory_pkt pkt;
    
    pkt = memory_pkt::type_id::create("pkt");
    
    forever begin
      @(posedge mem_vif.clk) begin
        if(mem_vif.rst_b) begin
          pkt.addr  = mem_vif.addr;
          pkt.wr_en = mem_vif.wr_en;
          pkt.rd_en = mem_vif.rd_en;
          pkt.wdata = mem_vif.wdata;
          
          if(mem_vif.stable_cnt == 0)
            analysis_port.write(pkt);
        end
      end
    end
  endtask
endclass