`include "ctrl_encode_def.v"
//流水线冒险检测
module Hazard_Detect(
    input clk,          // 时钟信号(当前未使用)
    input [4:0] IF_ID_rs1,  // IF/ID阶段的源寄存器1
    input [4:0] IF_ID_rs2,  // IF/ID阶段的源寄存器2  
    input [4:0] ID_EX_rd,   // ID/EX阶段的目标寄存器
    input ID_EX_MemRead,    // ID/EX阶段是否有load指令
    // input branch_taken,     // branch hazard
    // input jal_taken,        // jal hazard

    output reg stall
    // output reg fflush,
    // output reg jal_flush
);

    always @(*) begin
        // default
        stall = 1'b0;

        // load-use hazard
        if (ID_EX_MemRead && ((ID_EX_rd != 0) && ((ID_EX_rd == IF_ID_rs1) || (ID_EX_rd == IF_ID_rs2)))) begin
            stall = 1'b1;
        end
        $display("stall=%b", stall);
    end
endmodule
//实现数据前递(旁路)逻辑
module Forwarding(
    input EX_MEM_RegWrite,  // EX/MEM阶段寄存器写使能
    input MEM_WB_RegWrite,  // MEM/WB阶段寄存器写使能
    input [4:0] EX_MEM_rd,  // EX/MEM阶段目标寄存器
    input [4:0] MEM_WB_rd,  // MEM/WB阶段目标寄存器
    input [4:0] ID_EX_rs1,  // ID/EX阶段源寄存器1
    input [4:0] ID_EX_rs2,  // ID/EX阶段源寄存器2
    output reg [1:0] ForwardA, // 前递到ALU输入A的选择信号
    output reg [1:0] ForwardB  // 前递到ALU输入B的选择信号
);

    // ForwardA
    always @(*) begin
        ForwardA = `forwarding_none;    // default

        // Top priority: EX/MEM(latest) EX/M -> EX（最新数据）
        if (EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs1)) begin
            ForwardA = `forwarding_typeA;   // choose EX/MEM as the source
        end
        // Second priority: MEM/WB(earlier) MEM/W -> EX
        else if (MEM_WB_RegWrite && (MEM_WB_rd != 0) && (MEM_WB_rd == ID_EX_rs1)) begin
            ForwardA = `forwarding_typeB;   // choose MEM/WB as the source
        end 
    end

    // ForwardB
    always @(*) begin
        ForwardB = `forwarding_none;    // default

        if(EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs2)) begin
            ForwardB = `forwarding_typeA;   // choose EX/MEM as the source
        end
        else if(MEM_WB_RegWrite && (MEM_WB_rd != 0) && (MEM_WB_rd == ID_EX_rs2)) begin
            ForwardB = `forwarding_typeB;   // choose MEM/WB as the source
        end
    end

endmodule