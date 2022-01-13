class memory_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(memory_scoreboard)
  
  virtual memory_if mem_vif;
  
  uvm_analysis_imp #(memory_pkt, memory_scoreboard) analysis_export;
  
  bit[7:0] byte_array[logic[1:0]];
  
  function new(string name="", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual memory_if)::get(this,"","mem_vif",mem_vif))
      `uvm_fatal(get_full_name(), "Could not get handle to VIF")
    
    analysis_export = new("analysis_export", this);
    
    byte_array = '{ 'b00 : 'hFF,
                    'b01 : 'hFF,
                    'b10 : 'hFF,
                    'b11 : 'hFF };
  endfunction
  
  virtual function void write(memory_pkt pkt);
    if(!mem_vif.rst_b) begin
      set_array_to_default_values();
    end
    else begin
      if(pkt.wr_en) begin
          `uvm_info(get_full_name(), $sformatf("Writing to ADDR:%b, with DATA:%h", pkt.addr, pkt.wdata), UVM_LOW)
          byte_array[pkt.addr] = pkt.wdata;
          `uvm_info(get_full_name(), $sformatf("Data in array:%h", byte_array[pkt.addr]), UVM_LOW) 
      end
      else if(pkt.rd_en)
          if(mem_vif.rdata != byte_array[pkt.addr])
            `uvm_error("scoreboard", $sformatf("Data mismatch for address %b: Expected - %0h, Actual - %0h",pkt.addr,byte_array[pkt.addr],mem_vif.rdata))
    end
  endfunction
  
  function void set_array_to_default_values();
    foreach (byte_array[addr]) begin
      byte_array[addr] = 'hFF;
    end
  endfunction
      
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    //`uvm_info("DBG", "Getting snapshot of byte array", UVM_LOW)
    //foreach (byte_array[addr]) begin
    //  `uvm_info("DBG", $sformatf("KEY:%b, DATA:%h",addr,byte_array[addr]), UVM_LOW)
    //end
  endfunction
endclass