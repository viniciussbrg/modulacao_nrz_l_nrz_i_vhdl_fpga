## ============ Basys 3 - Constraints para NRZ-I ============

## Clock 100 MHz
set_property PACKAGE_PIN W5 [get_ports clk]
    set_property IOSTANDARD LVCMOS33 [get_ports clk]
    create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Switches (data_in[0] = SW0; data_in[15] = SW15)
set_property PACKAGE_PIN V17 [get_ports {data_in[0]}]
set_property PACKAGE_PIN V16 [get_ports {data_in[1]}]
set_property PACKAGE_PIN W16 [get_ports {data_in[2]}]
set_property PACKAGE_PIN W17 [get_ports {data_in[3]}]
set_property PACKAGE_PIN W15 [get_ports {data_in[4]}]
set_property PACKAGE_PIN V15 [get_ports {data_in[5]}]
set_property PACKAGE_PIN W14 [get_ports {data_in[6]}]
set_property PACKAGE_PIN W13 [get_ports {data_in[7]}]
set_property PACKAGE_PIN V2  [get_ports {data_in[8]}]
set_property PACKAGE_PIN T3  [get_ports {data_in[9]}]
set_property PACKAGE_PIN T2  [get_ports {data_in[10]}]
set_property PACKAGE_PIN R3  [get_ports {data_in[11]}]
set_property PACKAGE_PIN W2  [get_ports {data_in[12]}]
set_property PACKAGE_PIN U1  [get_ports {data_in[13]}]
set_property PACKAGE_PIN T1  [get_ports {data_in[14]}]
set_property PACKAGE_PIN R2  [get_ports {data_in[15]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {data_in[*]}]

## Botão central (BTNC) como reset
set_property PACKAGE_PIN U18 [get_ports rst]
    set_property IOSTANDARD LVCMOS33 [get_ports rst]

## LED0 - saída modulada NRZ-I
set_property PACKAGE_PIN U16 [get_ports nrz_out]
    set_property IOSTANDARD LVCMOS33 [get_ports nrz_out]

## LED12 a LED15 - bit_index em binário
set_property PACKAGE_PIN P3 [get_ports {bit_index_out[0]}]
set_property PACKAGE_PIN N3 [get_ports {bit_index_out[1]}]
set_property PACKAGE_PIN P1 [get_ports {bit_index_out[2]}]
set_property PACKAGE_PIN L1 [get_ports {bit_index_out[3]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {bit_index_out[*]}]