# Known issues

## XSA file

Vivado 2025.1 is unable to the generate XSA files using the non-project mode flow. I opened a [support request thread](https://adaptivesupport.amd.com/s/question/0D5KZ00000yl5y30AA/writehwplatform-fails-with-20251-in-nonproject-mode) on Xilinx's community forums.

| Vivado version   | 2025.2 | 2025.1 | 2024.2 | 2024.1 |
| ---------------- | ------ | ------ | ------ | ------ |
| Non-project mode | N/A    | Fails  | OK     | OK     |
| Project mode     | N/A    | OK     | TBD    | TBD    |

# Block design creation

Th is repository contains `bd_ps_<Vivado version>.tcl` TCL scripts used for generating the block design containing the PS. They were created using the following steps:

- Open Vivado GUI, create an empty new project targeting the ZC702 board
- Create a new block design named `bd_ps`
- Add a `ZYNQ7 Processing System` IP
- Open the re-customize IP panel, in the presets list select the `ZC702`
- Under *PS-PL Configuration > General > Enable Clock Resets*
    - Deselect *MFCLK_RESET0_N*
- Under *PS-PL Configuration > AXI Non Secure Enablement > GP Master AXI Interface*
    - Deselect *M AXI GP0 Interface*
- Under *Peripheral I/O Pins*
    - Deselect all **except** *UART 1*; *I2C 0* and *GPIO MIO*
- Under *MIO Configuration > I/O Peripherals > GPIO*
    - Deselect *USB Reset*
- Under *Clock Configuration > PL Fabric Clocks*
    - Deselect *FCLK_CLK0*
- Use the *Run Block Automation* feature
- Validate the design
- Export the block design using a filename matching the Vivado version, such as `bd_ps_2025_1.tcl` when using Vivado 2025.1

The resulting block design must be identical to the following:

![](/docs/diagram-bd_ps.png)
