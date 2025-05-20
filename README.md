# DinoCPU单周期/多周期设计文档

本项目基于powchan/SCCPU_SIM_RISCV32,powchan/SCCPU_FPGA,powchan/PLCPU_sim_RV32I

## DinoSCCPU - 单周期RISC-V CPU实现

这是一个基于RISC-V指令集的单周期CPU实现，采用Verilog HDL编写，包含完整的指令执行流水线和存储系统。

## 模块功能说明

### 1. 顶层模块

- **sccomp.v**: CPU顶层封装模块，集成CPU核心与存储系统
- **sccomp_tb.v**: 测试平台模块，用于仿真验证

### 2. CPU核心模块

- **SCCPU.v**: 单周期CPU核心实现，包含完整的指令执行流水线
- **ctrl.v**: 控制单元，生成各种控制信号
- **ctrl_encode_def.v**: 控制信号编码定义文件

### 3. 执行单元

- **alu.v**: 算术逻辑单元(ALU)，执行各种算术和逻辑运算
- **EXT.v**: 立即数扩展模块，处理不同格式的立即数
- **RF.v**: 寄存器文件，包含32个32位寄存器

### 4. 存储系统

- **im.v**: 指令存储器(ROM)
- **dm.v**: 数据存储器(RAM)
- **PC.v**: 程序计数器
- **NPC.v**: 下一条指令地址计算模块

## 模块关系图

```
sccomp_tb (测试平台)
    |
sccomp (顶层模块)
├── SCCPU (CPU核心)
│   ├── ctrl (控制单元)
│   ├── alu (算术逻辑单元)
│   ├── EXT (立即数扩展)
│   ├── RF (寄存器文件)
│   ├── PC (程序计数器)
│   └── NPC (下条指令计算)
├── im (指令存储器)
└── dm (数据存储器)
```

## 关键数据通路

1. **取指阶段**:
   
   - PC → im → inst_in → SCCPU

2. **执行阶段**:
   
   - 寄存器读(RF) → ALU运算 → 存储器访问(dm)

3. **写回阶段**:
   
   - 存储器/ALU结果 → 寄存器写(RF)

## 调试接口

通过`reg_sel`和`reg_data`信号可以监控任意寄存器的值，便于调试。

## 仿真测试

测试程序通过`rv32_sc_sim.dat`文件加载到指令存储器，测试平台自动生成时钟和复位信号。

## DinoPLCPU - 五级流水线RISC-V CPU实现

## 模块关系

### 1. 顶层模块

* **plcomp.v** - 顶层测试模块，实例化PLCPU和存储器
* **PLCPU.v** - 核心CPU模块，集成所有流水线阶段

### 2. 取指阶段(IF)

* **PC.v** - 程序计数器寄存器
* **NPC.v** - 计算下一条指令地址
* **im.v** - 指令存储器

### 3. 译码阶段(ID)

* **ctrl.v** - 主控制器，生成控制信号
* **EXT.v** - 立即数扩展单元
* **RF.v** - 寄存器文件

### 4. 执行阶段(EX)

* **alu.v** - 算术逻辑单元
* **hazard.v** - 处理数据冒险(前递和阻塞)

### 5. 访存阶段(MEM)

* **dm.v** - 数据存储器

### 6. 写回阶段(WB)

* 通过PLCPU内部的流水线寄存器完成

### 7. 流水线控制

* **pl_reg.v** - 通用流水线寄存器
* **hazard.v** - 冒险检测单元

### 数据流向

1. **取指**：PC → im → IF/ID流水线寄存器
2. **译码**：IF/ID → ctrl + EXT + RF → ID/EX流水线寄存器
3. **执行**：ID/EX → alu + hazard → EX/MEM流水线寄存器
4. **访存**：EX/MEM → dm → MEM/WB流水线寄存器
5. **写回**：MEM/WB → RF写端口

### 控制信号流

* ctrl模块生成的控制信号通过流水线寄存器逐级传递
* hazard模块根据流水线状态产生stall和forward信号

## 文件结构

    src/
    ├── alu.v               # ALU运算单元
    ├── ctrl.v              # 主控制单元
    ├── ctrl_encode_def.v   # 控制信号定义
    ├── dm.v                # 数据存储器
    ├── EXT.v               # 立即数扩展单元
    ├── hazard.v            # 冒险检测单元
    ├── im.v                # 指令存储器
    ├── NPC.v               # 下一条PC计算单元
    ├── PC.v                # PC寄存器
    ├── PLCPU.v             # 顶层CPU模块
    ├── pl_reg.v            # 流水线寄存器
    ├── plcomp.v            # CPU测试顶层模块
    ├── plcomp_tb.v         # 测试激励
    ├── RF.v                # 寄存器文件

## 使用方法

### 仿真运行

1. 准备测试程序：
   
   * 将RISC-V汇编代码编译为机器码
   * 将机器码保存为`riscv_sidascsorting_sim.dat`文件

2. 运行仿真 

# SCCPU_FPGA 项目

## 主要功能介绍

本项目基于 Xilinx Vivado 2019.2 开发，围绕 `SCCPU_SOC` 展开，主要涉及 CPU 相关的 FPGA 开发工作，包含综合、实现、仿真等多个流程。完成了运行学号排序的功能。

# 
