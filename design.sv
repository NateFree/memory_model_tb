interface memory_if  #(parameter ADDR_WIDTH = 2, parameter DATA_WIDTH = 8);
  logic clk, rst_b;
  logic [ADDR_WIDTH-1:0] addr;
  logic                  wr_en;
  logic                  rd_en;
  logic [DATA_WIDTH-1:0] wdata;
  logic [DATA_WIDTH-1:0] rdata;
  
  int                    stable_cnt = 0;
endinterface

`include "uvm_macros.svh"

module memory
  #(  
  parameter ADDR_WIDTH = 2,
  parameter DATA_WIDTH = 8
  )
  (
    input clk,
    input rst_b,
    
    //control signals
    input [ADDR_WIDTH-1:0]  addr,
    input                   wr_en,
    input                   rd_en,
    
    //data signals
    input  [DATA_WIDTH-1:0] wdata,
    output [DATA_WIDTH-1:0] rdata
  ); 
  
  reg [DATA_WIDTH-1:0] rdata;
  
  //Memory
  reg [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH];

  //Reset 
  always @(negedge rst_b) 
    for(int i=0;i<2**ADDR_WIDTH;i++) mem[i]=8'hFF;
   
  // Write data to Memory
  always @(posedge clk) 
    if (wr_en)    mem[addr] <= wdata;

  // Read data from memory
  always @(posedge clk)
    if (rd_en) rdata <= mem[addr];
  
  always @(posedge clk)
    if (wr_en && rd_en)
      $display("Error: Both wr_en and rd_en are high");

endmodule