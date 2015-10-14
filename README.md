zedboard-serdes-sfp-fmc
=======================

Example design for the SERDES SFP FMC on the ZedBoard

### No Longer Maintained

Due to a lack of demand for the SERDES SFP FMC, this project is no longer being
maintained and supported. The Vivado project has been updated to version 2015.3
and no longer passes timing. The SDK application is still version 2014.4.

### Description

This project demonstrates the Opsero SERDES SFP FMC (FPGA Mezzanine Card).
In this design, the Zynq PS constructs a packet in the DDR3 memory and then
uses the AXI DMA to send the packet through the serial transmitter. The
packet is sent through two SFP modules connected by a fiber patch cable
and returns through the serial receiver and back into the FPGA. The AXI DMA
receives the packet and writes it to memory, where the Zynq PS can verify
the received data.

### Requirements

To use this design, you will need to have two (2) SFP modules that can be
used to loopback the two transceivers of the SERDES SFP FMC. The model of
SFP module used is not particularly important, but it must support at least
3.125Gbps. The SFP used for testing the design was the Cisco DS-SFP-FC4G-SW
which you can easily find on Amazon.com.

Alternatively, you can buy an SFP loopback cable.

* Vivado 2015.3
* ZedBoard (http://www.zedboard.org)
* SERDES SFP FMC
* 1x SFP loopback cable or 2x SFP modules with fiber patch cable

### License

Feel free to modify the code for your specific application.

### Fork and share

If you port this project to another hardware platform, please send me the
code or push it onto GitHub and send me the link so I can post it on my
website. The more people that benefit, the better.

### About the author

I'm an FPGA consultant and I provide FPGA design services and training to
innovative companies around the world. I believe in sharing knowledge and
I regularly contribute to the open source community.

Jeff Johnson
http://www.fpgadeveloper.com