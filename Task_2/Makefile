all: gtk

simulation: main.v test_main.v
	iverilog main.v test_main.v -o simulation
	./simulation

gtk: simulation
	gtkwave simulation.vcd

clean:
	rm -f simulation simulation.vcd
