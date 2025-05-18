`include "ctrl_encode_def.v"
// 数据存储器模块
module dm(clk, DMWr, addr, din, dout);
   input          clk;
   input          DMWr;
   input  [31:0]  addr;
   input  [31:0]  din;
   output reg [31:0]  dout;
   
   reg [31:0] dmem[127:0];
   
   always @(posedge clk) //在时钟上升沿触发
      if (DMWr) begin
         dmem[addr[8:2]] <= din;//当DMWr为真时，将din写入dmem
         $write(" memaddr = %h, memdata = %h", addr[31:0], din);
      end
   
     //load
     always @(*) begin
         dout <= dmem[addr[8:2]];
     end
     
endmodule    
