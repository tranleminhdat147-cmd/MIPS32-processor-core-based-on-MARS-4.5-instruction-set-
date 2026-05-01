create_clock -name clk -period 16.667 [get_ports {clk}]
derive_pll_clocks
derive_clock_uncertainty