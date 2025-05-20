//`include "ctrl_encode_def.v"
// data memory
module dm(clk, DMWr,DMRe, addr, din, dout);
   input          clk;
   input          DMWr;
   input          DMRe;          // new add
   input  [31:0]  addr;
   input  [31:0]  din;
   output reg [31:0]  dout;
   
   reg [31:0] dmem[127:0];
   reg [31:0] write_data;
   reg [31:0] write_addr;
   reg        write_enable;
   
   always @(posedge clk) begin
      if (write_enable) begin
          dmem[write_addr[8:2]] <= write_data;
          $write(" memaddr = %h, memdata = %h \n", write_addr, write_data);
      end
      write_enable <= DMWr;
      write_addr <= addr;
      write_data <= din;
   end
   
   //load
   always @(*)
      if (DMRe) begin
         dout <= dmem[addr[8:2]];
      end
     
endmodule    
