
# SystemVerilog Structures Examples

## About

This repo provides examples of how to use structures in IEEE 1800 SystemVerilog.

```systemverilog
typedef struct packed {
    logic sign;
    logic [7:0] biased_exponent;
    logic [22:0] mantissa;
} float_t;
```

## Getting Started

### Installation of Required Tools

```bash
# OSS-CAD-Suite and Zachjs-sv2v
wget -O - https://raw.githubusercontent.com/sifferman/hdl-tool-installer/main/install | bash -s -- <build_dir> --oss-cad-suite --zachjs-sv2v
```

* netlistsvg: <https://github.com/nturley/netlistsvg>
* Vivado: <https://www.xilinx.com/support/download.html>

### Run Examples

```bash
cd float_example
make
```

## References

### IEEE 1800 Specifications

<https://ieeexplore.ieee.org/document/8299595>

* 5.10 Structure literals
* 6.22.2 Equivalent types
* 7.2 Structures
* 7.2.1 Packed structures
* 7.4.1 Packed arrays
* 10.9 Assignment patterns
* 11.4.12 Concatenation operators
* 13.4.1 Return values and void functions
* 23.2.2 Port declarations
* 23.7 Member selects and hierarchical names

### Examples of Structures

* <https://github.com/openhwgroup/cva6/blob/b143be15/core/frontend/bht.sv#L46-L51>
* <https://github.com/lowRISC/ibex/blob/bac72d96/rtl/ibex_cs_registers.sv#L163-L205>

### Style Guides

* [BSG System Verilog Coding Standards](https://docs.google.com/document/d/1xA5XUzBtz_D6aSyIBQUwFk_kSUdckrfxa2uzGjMgmCU/edit#heading=h.3ncybxldrngo)

### Alternate for Structures in &leq; Verilog-2005

* Examples of bit-select macros
    * <https://github.com/nsat/uhd/blob/b7e0c1ea/fpga/usrp2/opencores/spi/rtl/verilog/spi_top.v#L103-L110>
    * <https://github.com/mrehkopf/sd2snes/blob/b2b8d576/verilog/sd2snes_sgb/sgb.v#L356>

### Other References

* Sutherland, S. (2017). *RTL Modeling with SystemVerilog For Simulation and Synthesis*. Section 4.5, pg.124
