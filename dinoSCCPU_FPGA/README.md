# dinoSCCPU_FPGA 项目

## 项目概述
`dinoSCCPU_FPGA` 项目基于 Xilinx Vivado 2019.2 开发，围绕 `SCCPU_SOC` 展开，主要聚焦于 CPU 相关的 FPGA 开发工作，涵盖综合、实现、仿真等多个关键流程，旨在完成一个完整的 CPU 设计并在 FPGA 上进行验证。

## 主要功能介绍

### 综合（Synthesis）
对设计进行逻辑综合，将硬件描述语言（如 Verilog 等）编写的设计代码转换为门级网表，为后续的实现工作做准备。在 `SCCPU_SOC.srcs` 目录下的 `sources_1` 文件夹包含了设计的源文件。

### 实现（Implementation）
完成设计的布局布线等实现工作，生成可用于 FPGA 编程的比特流文件。`SCCPU_SOC.runs\impl_1` 目录下包含了实现过程的相关文件和脚本。

### 仿真（Simulation）
支持多种仿真器（如 Questa、VCS、Xcelium 等）对设计进行功能验证，确保设计的正确性。`SCCPU_SOC.ip_user_files\sim_scripts\imem` 目录下为不同仿真器提供了相应的仿真脚本和说明文件：
- 每个仿真器子目录（如 `questa`、`vcs` 等）下的 `README.txt` 文件详细说明了如何运行仿真脚本。
- 执行 `./imem.sh` 命令可以启动仿真流程，不同仿真器的具体流程可能有所差异。

## 项目结构
```plaintext
dinoSCCPU_FPGA/
├── .Xil/
├── README.md
├── SCCPU_SOC.cache/
│   ├── compile_simlib/
│   ├── ip/
│   └── wt/
├── SCCPU_SOC.hw/
│   ├── SCCPU_SOC.lpr
│   └── hw_1/
├── SCCPU_SOC.ip_user_files/
│   ├── README.txt
│   ├── ip/
│   ├── ipstatic/
│   ├── mem_init_files/
│   └── sim_scripts/
├── SCCPU_SOC.runs/
│   ├── .jobs/
│   ├── imem_synth_1/
│   ├── impl_1/
│   └── synth_1/
├── SCCPU_SOC.sim/
│   └── sim_1/
├── SCCPU_SOC.srcs/
│   ├── constrs_1/
│   └── sources_1/
├── SCCPU_SOC.xpr
├── dino.asm
├── dino.coe
├── vivado.jou
├── vivado_4052.backup.jou
└── vivado_pid3820.str
```

## 快速开始
### 综合和实现
1. 打开 Xilinx Vivado 2019.2。
2. 打开 `SCCPU_SOC.xpr` 项目文件。
3. 在 Vivado 中执行综合和实现流程，可以参考 `SCCPU_SOC.runs\impl_1\runme.sh` 脚本。

## 注意事项
- `SCCPU_SOC.ip_user_files` 目录下的文件由 Vivado 自动生成和管理，不建议手动编辑。
- 仿真时需要确保 Xilinx 预编译的仿真库组件路径正确，可参考各仿真器目录下的 `README.txt` 文件。 