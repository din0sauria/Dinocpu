##########################################################################################
#
# Designer: Qin Liu
#
# Description:
# As part of the project of Computer Organization Experiments, Wuhan University
# Spring 2025
# RISCV assembly code for sorting the sid digital numbers in the acending order for FPGA.
#
##########################################################################################

##########################################################################################
# 按升序对学生学号数字进行排序的C语言伪代码
##########################################################################################
#   sortedsid = sid;  # 初始化排序后的学号为原始学号
#   mask0 = 0x0f;     # 初始化掩码0，用于提取十六进制数字
#   每次迭代从未处理的数字中选择最大的数字
#   for (int i= 0; i < 8; i++) {
#       a = sortedsid & mask0; // 每次提取一个十六进制数字并处理
#       a = a >> (4 * i); // 移动到最后位置，a是待排序的数字
#       mask1 = mask0 << 4;
#       bestj = i;
#       tmpMax = a;
#       for (int j = i + 1; j < 8) {
#       b = sortedsid & mask1;
#       b = b >> (4 * j);
#       if (tmpMax < b) {
#          tmpMax = b;
#          bestj = j;
#       }
#       mask1 = mask1 << 4;
#     }
#     if (a < tmpMax) { // 交换位置分别为i和bestj的数字a和tmpMax
#         mask1 = 0x0f;
#         bestj4 = bestj << 2;
#         mask1 = mask1 << bestj4
#         mask2 = mask0 | mask1;
#         mask2 = ~mask2;
#         sortedsid = sortedsid & mask2;  // 将i和j位置的数字置为0，其他保持不变
#         tmpMax = tmpMax << (4 * i);
#         sortedsid = sortedsid | tmpMax;
#         a = a << bestj4;
#         sortedsid = sortedsid | a;
#       }
#     mask0 = mask0 << 4;
#   }
##########################################################################################
# 寄存器的使用说明
##########################################################################################
# mem[0x180]: 学生学号
# mem[0x184]: 排序后的学生学号
# x15: 部分排序的学生学号
# x1: 开关的地址
# x2: 外循环变量i / 七段数码管的地址
# x3: 内循环变量j / 开关输入
# x4: 掩码0
# x5: 掩码1
# x6: 掩码2
# x7: 变量a
# x8: 变量b
# x9: 4 * i
# x10: 4 * j
# x11: N = 8
# x12: bestj
# x13: tmpMax
# x14: 比较结果
##########################################################################################
# RISCV assembly language program for sorting the student id.
# The following instructions are used.
# 9 + 9 instructions
# R: add or slt + and sll srl
# I: addi lw + andi ori slli xori jalr
# S: sw
# B: beq + bne
# J: jal
# U: lui
##########################################################################################
      addi    x2, x0, 0x02        # This is the BCD encoding for the studnet id: a hex digit for each decimal digit
      slli    x2, x2, 8
      addi    x2, x2, 0x18
      slli    x2, x2, 16
      addi    x3, x0, 0x12
      slli    x3, x3, 8
      addi    x3, x3, 0x51
      add     x2, x2, x3          # set the student id, USE YOUR OWN STUDENT NO.!!!
      sw      x2, 0x180(x0)       # store the original sid at data memory
      addi    x11, x0, 8          # the size of sid, N = 8
      lw      x15, 0x180(x0)      # x15 = [0x180] = sid
      add     x2, x0, x0          # the outer loop variable initilization, i = 0,
      addi    x4, x0, 0x0f        # mask0 = 0xf
loop1:
      and     x7, x15, x4         # a = sortedsid & mask0, get the BCD to be processed
      slli    x9, x2, 2           # (4 * i)
      srl     x7, x7, x9          # a = a >> (4 * i), shift the BCD to the LSB 4 bits
      slli    x5, x4, 4           # mask1 = mask0 << 4
      add     x12, x2, x0         # bestj = i, remmember the position of the largest BCD in this loop
      add     x13, x7, x0         # tmpMax = a, remember the largest BCD in this loop
      addi    x3, x2, 1           # j = i + 1, the inner loop variable initilization, j = i + 1
loop2:
      beq     x3, x11, checkswap  # to check if j == 8
      and     x8, x15, x5         # b = sortedsid & mask1
      slli    x10, x3, 2          # (4 * j)
      srl     x8, x8, x10         # b = b >> (4 * j), shift the BCD to the LSB 4 bits
      slt     x14, x13, x8        #
      beq     x14, x0, incrLoop2  # if (tmpMax >= b), increase j
      add     x13, x8, x0         # tmpMax = b, remember the largest BCD in this loop
      add     x12, x3, x0         # bestj = j, remmember the position of the largest BCD in this loop
incrLoop2:
      slli    x5, x5, 4           # mask1 = mask1 << 4
      addi    x3, x3, 1           # j = j + 1
      jal     x0, loop2
checkswap:
      slt     x14, x2, x12        # to check if the position of the largest BCD in the this loop has been changed
      beq     x14, x0, incrLoop1
      jal     x1, swap
incrLoop1:
      slli    x4, x4, 4           # mask0 = mask0 << 4
      addi    x2, x2, 1           # i = i + 1
      bne     x2, x11, loop1      # to check if i <> 8

result:
      sw      x15, 0x184(x0)      # [0x184] = sortedsid
      
########################  
# sorting finished, ready to display
########################  
      lui     x2, 0xffff0         # x2 = 0xffff0000
      ori     x1, x2, 0x004       # x1 = 0xffff0004
      ori     x2, x2, 0x00c       # x2 = 0xffff000c # seg7 as output
display:
      lw      x5, 0x00(x1)
      andi    x5, x5, 0x100       # test if bit 8 is 1
      beq     x5, x0, dispsid     # if bit 8 = 0, display the original sid. if bit 8 = 1, display the sorted sid.
dispsortedsid:
      lw      x3, 0x184(x0)       # load the sorted student id
      jal     x0, displayseg7label
dispsid:
      lw      x3, 0x180(x0)       # load the orginal student id
displayseg7label:
      sw      x3, 0x00(x2)        # output to seg7
      jal     x0, display         # jump to result, dead loop
############
# the above code: a deadloop for display
# mem[0x180] = mem[384] = unsorted student id
# mem[0x184] = mem[388] = sorted student id

############
#swap procedure
############  
swap:                             # change the nibble at i with the nibble at bestj
      addi    x5, x0, 0x0f
      slli    x10, x12, 2         # 4 * bestj
      sll     x5, x5, x10         # mask1 = mask (4 * bestj)
      or      x6, x4, x5          # mask2 = mask0 | mask1
      xori    x6, x6, -1          # mask2 = ~mask2
      and     x15, x15, x6        # sortedsid = sortedsid & mask2
      sll     x8, x13,x9          # tmpmax = tmpmax << (4*i)
      or      x15, x15, x8        # sortedsid = sortedsid | tmpmax
      sll     x7, x7, x10         # a = a << (4 * bestj)
      or      x15, x15, x7        # sortedsid = sortedsid | a
      jalr    x0, x1, 0