# UART-Communication-Protocol-Developed-in-FPGA-Using-Vivado-Platform

In this project, we aimed to implement UART communication using the Vivado program. The code is written in VHDL, with separate implementations for both transmitting and receiving, which were practically tested using a terminal. 

For the first program that handles UART data transmission, you can choose a byte to send based on the variable 'data'. The output of this program will be a constant character of choice sent periodically. 

For the second program, we focused on receiving data. We connected a receiver and transmitter in series so that the data could be sent through the terminal. After being saved, the data is transmitted again to the terminal, effectively creating an echo program for testing the UART receiver.
