`timescale 1ns/1ns 
module sccomp_tb();
   reg    clk, rstn;
   reg  [4:0] reg_sel;
   wire [31:0] reg_data;

   // instantiation of sccomp
   sccomp sccomp(.clk(clk), .rstn(rstn), .reg_sel(reg_sel), .reg_data(reg_data));

   initial begin
     // input instructions for simulation
      $readmemh("rv32_sc_sim.dat", sccomp.U_imem.RAM);
      //初始化时钟和复位信号
      clk = 1;
      rstn = 1;
      #10 ;//#10ns后rstn变低
      rstn = 0;// 产生复位脉冲
      reg_sel = 7;// 默认监控x7寄存器
   end
   
   always begin
      #(5) clk = ~clk;// 10ns周期(50MHz)的时钟
   end
   
endmodule
