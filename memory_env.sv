class memory_env extends uvm_env;
  `uvm_component_utils(memory_env)
  
  memory_agent      mem_agent;
  memory_scoreboard mem_sb;
  memory_coverage   mem_cov;
  
  function new(string name="", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    mem_agent = memory_agent::type_id::create("mem_agent", this);
    mem_sb = memory_scoreboard::type_id::create("mem_sb", this);
    mem_cov = memory_coverage::type_id::create("mem_cov", this);
  endfunction
    
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    mem_agent.mem_mon.analysis_port.connect(mem_sb.analysis_export);
    mem_agent.mem_mon.analysis_port.connect(mem_cov.analysis_export);
  endfunction
endclass