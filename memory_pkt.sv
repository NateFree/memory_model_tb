class memory_pkt extends uvm_sequence_item;
  rand bit [1:0] addr;
  rand bit       wr_en;
  rand bit       rd_en;
  rand bit [7:0] wdata;
  
  `uvm_object_utils_begin(memory_pkt)
    `uvm_field_int(addr, UVM_DEFAULT)
    `uvm_field_int(wr_en, UVM_DEFAULT)
    `uvm_field_int(rd_en, UVM_DEFAULT)
    `uvm_field_int(wdata, UVM_DEFAULT)
  `uvm_object_utils_end
  
  constraint wr_rd_enables { $onehot0({wr_en,rd_en}) == 1; }
  
  function new(string name = "");
    super.new(name);
  endfunction
  
endclass