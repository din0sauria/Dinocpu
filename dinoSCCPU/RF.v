//寄存器文件
  module RF(   input         clk, 
               input         rst,
               input         RFWr, // 寄存器写使能
               input  [4:0]  A1, A2, A3, // 读端口地址
               input  [31:0] WD, // 写入数据
               output [31:0] RD1, RD2,// 读端口数据
               input  [4:0]  reg_sel,// 调试选择信号
               output [31:0] reg_data
           );

    reg [31:0] rf[31:0];
    integer i;

    always @(posedge clk, posedge rst) begin
      if (rst) begin    //  reset
        for (i=1; i<32; i=i+1)
            rf[i] <= 0; 
      end
      
      else 
        if (RFWr) begin
          if(A3 != 5'b0) begin // x0寄存器不可写
              rf[A3] <= WD;
              $write("x%d = %h  ", A3, WD);
          end
        end
      end

    assign RD1 = (A1 != 0) ? rf[A1] : 0;
    assign RD2 = (A2 != 0) ? rf[A2] : 0;
    assign reg_data = (reg_sel != 0) ? rf[reg_sel] : 0; 

  endmodule 
