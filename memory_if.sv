interface memory_if  #(parameter ADDR_WIDTH = 2, parameter DATA_WIDTH = 8);
  logic clk, rst_b;
  logic [ADDR_WIDTH-1:0] addr;
  logic                  wr_en;
  logic                  rd_en;
  logic [DATA_WIDTH-1:0] wdata;
  logic [DATA_WIDTH-1:0] rdata;
  
  int                    stable_cnt = 0;
endinterface