`include "ctrl_encode_def.v"
//下一条指令地址计算
module NPC( PC, NPCOp, IMM, aluout, NPC );  // next pc module
   input  [31:0] PC;        // pc
   input  [2:0]  NPCOp;     // next pc operation
   input  [31:0] IMM;       // immediate
   input  [31:0] aluout;    // alu output
   output reg [31:0] NPC;   // next pc
   
   wire [31:0] PCPLUS4;
   assign PCPLUS4 = PC + 4; // pc + 4
   
   always @(*) begin
      case (NPCOp)
          `NPC_PLUS4:  NPC = PCPLUS4;   //普通指令顺序执行
          `NPC_BRANCH: NPC = PC+IMM;    //B type, 条件分支指令
          `NPC_JUMP:   NPC = PC+IMM;    //J type, 无条件跳转指令
          `NPC_JALR:   NPC = aluout;   // JALR指令使用ALU计算结果
          default:     NPC = PCPLUS4;
      endcase
   end 
   
endmodule
