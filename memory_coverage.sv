class memory_coverage extends uvm_subscriber#(memory_pkt);
  `uvm_component_utils(memory_coverage)
  
  memory_pkt pkt;
  
  virtual memory_if mem_vif;
  
  covergroup mem_cg;
    coverpoint pkt.addr;
    coverpoint pkt.wr_en;
    coverpoint pkt.rd_en;
    coverpoint pkt.wdata;
    coverpoint mem_vif.rdata;
  endgroup
  
  function new(string name="", uvm_component parent=null);
    super.new(name, parent);
    
    mem_cg = new();
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    uvm_config_db#(virtual memory_if)::get(this, "", "mem_vif", mem_vif);
  endfunction

  virtual function void write(T t);
    pkt = t;
    mem_cg.sample();    
  endfunction
  
  virtual function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    
    `uvm_info(get_type_name(), $sformatf("Coverage Report: %0f", mem_cg.get_coverage()), UVM_LOW)
  endfunction
endclass