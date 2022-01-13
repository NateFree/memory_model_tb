class memory_traffic_sequence extends uvm_sequence #(memory_pkt);
  `uvm_object_utils(memory_traffic_sequence)
  
  rand int num_txns;

  constraint num_pkts_to_send { num_txns inside {[25:100]}; }
  
  function new(string name="");
    super.new(name);
  endfunction
  
  task body();
    memory_pkt mem_pkt;
    
    mem_pkt = memory_pkt::type_id::create("mem_pkt");
    
    repeat(num_txns) begin
      //`uvm_do(mem_pkt)
      start_item(mem_pkt);
      assert(mem_pkt.randomize());
      finish_item(mem_pkt);
    end
  endtask
endclass