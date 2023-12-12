module test_main;

    reg clk;
    reg rst;
    reg [7:0] in;
    reg [2:0] op;
    reg apply;
    wire [7:0] tail;
    wire empty;
    wire valid;

    // Instantiate the main module
    main _main(
        .clk(clk),
        .rst(rst),
        .in(in),
        .op(op),
        .apply(apply),
        .tail(tail),
        .empty(empty),
        .valid(valid)
    );

    // Initializations
    initial begin
        $dumpfile("simulation.vcd");
        $dumpvars(0, test_main);
        clk = 0; apply = 0; rst = 1;
        #2
        rst = 0;

        // Test scenario 1: Adding an elements to the queue
        #2 
        op = 0; in = 1; apply = 1; 
        #2 
        in = 2;
        #2
        in = 4;
        #2
        in = 6; 
        #2
        in = 8; 

        // Test scenario 2: Removing an element from the queue
        #2 
        op = 1; in = 0;
        #2
        op = 1;

        // Add more elements
        #2 
        op = 0; in = 10;
        #2
        in = 12;

        // Test scenario 3: Performing an addition operation
        #2
        op = 2; in = 0;

        // Test scenario 4:  Performing a multiplication operation
        #2 
        op = 3;

        // Test scenario 5:  Performing a subtraction operation
        #2 
        op = 4;

        // Test scenario 6:  Performing getting the quotient from division operation
        #2 
        op = 5;

        // Test scenario 2: Removing an element from the queue
        #2 
        op = 1;

        // Add more elements
        #2 
        op = 0; in = 14;
        #2
        in = 16;
        #2
        in = 18;

        // Test scenario 7:  Performing getting the remainder of the division operation
        #2 
        op = 6; in = 0; 

        // Test scenario 8:  Apply is null
        #2 
        apply = 0; op = 1; in = 2;
        #2
        in = 7;
        #2 
        op = 2; 

        // Test scenario 9:  Use the incorrect operation and use reset
        #2
        op = 7; apply = 1; // incorrect oppertion
        #4
        rst = 1;
        #2
        in = 21; op = 0; rst = 0;
        #12
        apply = 0; // queue overload 
        #4
        rst = 1;
        #2 
        op = 0; in = 5; rst = 0; apply = 1;
        #2
        op = 2; rst = 0; // not enough operands for operation
        #4
        rst = 1;
        #2
        in = 0; op = 0; rst = 0;
        #2
        in = 3;
        #2
        op = 5; // zero division
        #2 
        rst = 1;
        #2
        op = 0; in = 111; rst = 0;
        #2
        apply = 0;
        


        #5
        $finish;
    end
    always #1 clk = !clk;
endmodule
