class memory_sequencer extends uvm_sequencer #(memory_pkt);
  `uvm_component_utils(memory_sequencer)
  
  function new(string name="", uvm_component parent=null);
    super.new(name, parent);
  endfunction
endclass