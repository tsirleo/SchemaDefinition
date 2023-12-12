module main(x, on, start, y, s, b, regime, active, clk, rst);
  input [7:0] x;
  input [1:0] on;
  input start;
  output [7:0] y;
  output [2:0] s;
  output b;
  output reg active;
  output [1:0] regime;
  input clk, rst;
  
  reg [1:0] y_select_next, s_step;
  reg y_en, s_en, y_upd, s_sub, s_zero;
  
  // Основная часть операционного автомата.
  datapath _datapath(
    .x(x),
    .y(y),
    .s(s),
    .b(b),
    .s_en(s_en),
    .s_step(s_step),
    .s_sub(s_sub),
    .s_zero(s_zero),
    .y_en(y_en),
    .y_select_next(y_select_next),
    .y_upd(y_upd),
    .clk(clk),
    .rst(rst)
  );
  

  // Распознавание свойств данных в операционном автомате.
  reg [2:0] state, next_state, counter;

  localparam SWITCHED_OFF        = 0;
  localparam ENUMERATE_NONACTIVE = 1;
  localparam COUNT               = 2;
  localparam UPDATE              = 3;
  localparam ENUMERATE_ACTIVE    = 4;

  assign regime = (state == SWITCHED_OFF) ? 0 : ((state == ENUMERATE_NONACTIVE || state == ENUMERATE_ACTIVE) ? 1 : ((state == COUNT) ? 2 : 3));
  assign overflow_flag = s == 7;

  // Управляющий автомат.
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      state <= SWITCHED_OFF;
      counter <= 0;
    end else begin
      state <= next_state;
    end
  end

  // Счетчик тактов для 1 и 3 режимов
  always @(posedge clk) begin
    if (state == SWITCHED_OFF || state == ENUMERATE_NONACTIVE || state == COUNT) begin
      counter <= 0;
    end else begin
      counter <= counter + 1 ;
    end
  end

  // Функция перехода по состояниям
  always @* begin
    next_state <= SWITCHED_OFF;
    case (state)
      SWITCHED_OFF: begin
        case (on) 
          0: next_state <= SWITCHED_OFF;
          1: next_state <= ENUMERATE_NONACTIVE;
          2: next_state <= COUNT;
          3: next_state <= UPDATE;
        endcase
      end
      ENUMERATE_NONACTIVE: begin
        case (start) 
          0: next_state <= ENUMERATE_NONACTIVE;
          1: next_state <= ENUMERATE_ACTIVE;
        endcase
      end
      ENUMERATE_ACTIVE: begin
        if (counter == 5) begin
          next_state <= SWITCHED_OFF;
        end else begin
          next_state <= ENUMERATE_ACTIVE;
        end
      end
      COUNT: begin
        case (start) 
          0: next_state <= SWITCHED_OFF;
          1: next_state <= COUNT;
        endcase
      end
      UPDATE: begin
        if (counter == 3) begin
          next_state <= SWITCHED_OFF;
        end else begin
          next_state <= UPDATE;
        end
      end
    endcase
  end


  // Функция выхода управляющих сигналов
  always @* begin
    active <= 0; s_zero <= 1; s_step <= 0; s_sub <= 0; s_en <= 0; y_select_next <= 0; y_upd <= 1; y_en <= 0;
    case (state)
      SWITCHED_OFF: begin
        active <= 0;
        s_zero <= 1;
        s_step <= 0;
        s_sub <= 0;
        s_en <= 0;
        y_select_next <= 0;
        y_upd <= 1;
        y_en <= 0;
      end
      ENUMERATE_NONACTIVE: begin
        active <= 0;
        s_zero <= 1;
        s_step <= 0;
        s_sub <= 0;
        s_en <= 0;
        y_select_next <= 0;
        y_upd <= 1;
        y_en <= 0;
      end
      ENUMERATE_ACTIVE: begin
        y_select_next <= 0;
        y_upd <= 1;
        if (counter == 0) begin
          active <= 1;
          y_en <= 1;
          s_zero <= 1;
          s_step <= 1;
          s_sub <= 1;
          s_en <= 1;
        end else if (counter == 1) begin
          active <= 1;
          y_en <= 1;
          s_zero <= 0;
          s_step <= 2;
          s_sub <= 1;
          s_en <= 1;
        end else if (counter == 2) begin
          active <= 1;
          y_en <= 1;
          s_zero <= 0;
          s_step <= 2;
          s_sub <= 1;
          s_en <= 1;
        end else if (counter == 3) begin
          active <= 1;
          y_en <= 1;
          s_zero <= 0;
          s_step <= 2;
          s_sub <= 1;
          s_en <= 1;
        end else if (counter == 4) begin
          active <= 1;
          y_en <= 1;
          s_zero <= 0;
          s_step <= 0;
          s_sub <= 0;
          s_en <= 1;
        end else if (counter == 5) begin
          active <= 1;
          y_en <= 0; 
          s_zero <= 1;
          s_step <= 1;
          s_sub <= 1;
          s_en <= 1;
        end
      end
      COUNT: begin
        active <= 0;
        case (start) 
          0: begin
            s_en <= 0;
            y_select_next <= 0;
            s_step <= 0;
            y_en <= 0;
          end 
          1: begin
            if (overflow_flag) begin
                y_select_next <= 3;    
            end else begin
              y_select_next <= 0;
            end
            s_zero <= 0;
            s_step <= 1;
            s_sub <= 0;
            s_en <= 1;
            y_upd <= 1;
            y_en <= 1;
          end
        endcase
      end
      UPDATE: begin
        active <= 0;
        if (counter == 0) begin
          s_en <= 0;
          y_upd <= 0;
          y_en <= 1;
        end else if (counter == 1) begin
          s_zero <= 0;
          s_step <= 0;
          s_sub <= 0;
          s_en <= 1;
          y_select_next <= 1;
          y_upd <= 1;
          y_en <= 1;
        end else if (counter == 2) begin
          y_select_next <= 0;
          y_en <= 0;
          s_zero <= 0;
          s_step <= 1;
          s_sub <= 1;
          s_en <= 1;
        end else if (counter == 3) begin
          s_step <= 0;
          s_en <= 0;
        end
      end
    endcase
  end

endmodule
