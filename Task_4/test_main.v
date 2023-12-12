module test_main;
  
  // Входы
  reg [7:0] x;
  reg [1:0] on;
  reg start;
  reg clk, rst;

  // Выходы
  wire [7:0] y;
  wire [2:0] s;
  wire b, active;
  wire [1:0] regime;

  main _main(
    .x(x),
    .on(on),
    .start(start),
    .y(y),
    .s(s),
    .b(b),
    .active(active),
    .regime(regime),
    .clk(clk),
    .rst(rst)
  );

  initial begin
      $dumpfile("simulation.vcd");
      $dumpvars(0, test_main);
      
      #0
      clk = 0; rst = 1; x = 98; start = 0;
      #2
      rst = 0;

      #2
      on = 2; start = 1;

      #36
      start = 0; on = 0;

      #8
      on = 3;

      #2 
      on = 0;

      #8
      on = 1;

      #2 
      on = 0;

      #4
      start = 1;

      #20
      $finish;
  end
    
  always #1 clk = !clk;

endmodule

