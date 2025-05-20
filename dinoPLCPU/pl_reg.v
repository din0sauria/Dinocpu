// pl_reg 模块用于实现一个参数化的流水线寄存器
// 参数 WIDTH 表示寄存器的位宽，默认值为 32 位
module pl_reg #(parameter WIDTH = 32)(
    input clk, rst, flush, stall_id_ex, stall_if_id,
    input [WIDTH-1:0] in,
    // 寄存器的输出数据，位宽为 WIDTH，使用 reg 类型以便在 always 块中赋值
    output reg [WIDTH-1:0] out
    );
    
    // 时序逻辑块，在时钟上升沿或复位信号上升沿触发
    always@(posedge clk, posedge rst)
        begin
            // 当复位信号有效时，将寄存器输出清零
            if(rst)
                out <= 0;
            // 当冲刷信号有效时，将寄存器输出清零
            else if (flush)
                out <= 0;
            // 当 ID 到 EX 阶段的暂停信号有效时，将寄存器输出清零，为避免无效指令执行，防止错误传播
            else if (stall_id_ex)
                out <= 0;
            // 当 IF 到 ID 阶段的暂停信号有效时，寄存器输出保持不变，防止数据冒险，维持流水线状态
            else if (stall_if_id)
                out <= out;
            // 其他情况，将输入数据赋值给寄存器输出
            else 
                out <= in;
        end
    
endmodule
