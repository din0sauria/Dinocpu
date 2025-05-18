module RF(     input         clk, 
               input         rst,
               input         RFWr, 
               input  [4:0]  A1, A2, A3, 
               input  [31:0] WD, 
               output [31:0] RD1, RD2
               //input [4:0] reg_sel,
               //output [31:0] reg_data
         );

  reg [31:0] rf[31:0]; // 32个32位寄存器
  integer i;

  // 同步写操作
  always @(posedge clk, posedge rst) begin
    if (rst) begin    // 复位时清零所有寄存器(x0-x31)
       for (i=1; i<32; i=i+1)
           rf[i] <= 0;
    end
    else if (RFWr) begin // 写使能有效时写入数据
      if(A3 != 5'b0)begin // x0寄存器永远为0
          rf[A3] <= WD;
          $write("x%d = %h  ", A3, WD); // 调试信息
      end
    end
  end

  // 异步读操作
  assign RD1 = (A1 != 0) ? rf[A1] : 0; // x0寄存器永远返回0
  assign RD2 = (A2 != 0) ? rf[A2] : 0;
  //assign reg_data = (reg_sel != 0) ? rf[reg_sel] : 0; 

endmodule 
