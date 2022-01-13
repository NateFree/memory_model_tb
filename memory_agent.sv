class memory_agent extends uvm_agent;
  `uvm_component_utils(memory_agent)
  
  memory_driver    mem_driver;
  memory_sequencer mem_seqr;
  memory_monitor   mem_mon;
  
  function new(string name="", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
 
    if(get_is_active()) begin
      mem_driver = memory_driver::type_id::create("mem_driver", this);
      mem_seqr   = memory_sequencer::type_id::create("mem_seqr", this);
    end
    
    mem_mon = memory_monitor::type_id::create("mem_mon", this);
  endfunction
    
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    if(get_is_active())
      mem_driver.seq_item_port.connect(mem_seqr.seq_item_export);
  endfunction
endclass