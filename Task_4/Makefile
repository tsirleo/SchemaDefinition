all: gtk

simulation: datapath.v main.v test_main.v
	iverilog datapath.v main.v test_main.v -o simulation
	./simulation

gtk: simulation
	gtkwave simulation.vcd

clean:
	rm -f simulation simulation.vcd
