`include "uvm_macros.svh"
`include "my_testbench_pkg.svh"

module top;
  import uvm_pkg::*;
  import my_testbench_pkg::*;
  
  memory_if mem_if();
  
  memory mem();
  
  assign mem_if.rdata = mem.rdata;
  
  assign mem.clk = mem_if.clk;
  assign mem.addr = mem_if.addr;
  assign mem.wr_en = mem_if.wr_en;
  assign mem.rd_en = mem_if.rd_en;
  assign mem.wdata = mem_if.wdata;
  assign mem.rst_b = mem_if.rst_b;
  
  initial begin
    mem_if.clk = 0;
    forever #5 mem_if.clk = ~mem_if.clk;
  end
  
  initial begin
    uvm_config_db#(virtual memory_if)::set(null, "*", "mem_vif", mem_if);
    
    run_test("my_test");
  end
  
  // Dump waves
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, top);
  end
  
endmodule
