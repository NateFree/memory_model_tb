  class my_test extends uvm_test;
    `uvm_component_utils(my_test)
    
    virtual memory_if mem_vif;

    memory_env mem_env;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      uvm_config_db#(virtual memory_if)::get(this, "", "mem_vif", mem_vif);
      
      mem_env = memory_env::type_id::create("mem_env", this);
    endfunction
    
    task run_phase(uvm_phase phase);
      memory_traffic_sequence traffic_seq;
 
      phase.raise_objection(this);
      #1;
      mem_vif.rst_b = 0;
      #10;
      mem_vif.rst_b = 1;

      //`uvm_do_on(traffic_seq, mem_env.mem_agent.mem_seqr)
      traffic_seq = memory_traffic_sequence::type_id::create("traffic_seq");
      traffic_seq.randomize() with {num_txns == 100;};
      traffic_seq.start(mem_env.mem_agent.mem_seqr);
      //`uvm_warning("", "Hello World!")
      phase.drop_objection(this);
    endtask

  endclass