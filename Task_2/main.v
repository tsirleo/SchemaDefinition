module main (
    input wire clk,
    input wire rst,
    input wire [7:0] in,
    input wire [2:0] op,
    input wire apply,
    output wire [7:0] tail,
    output wire empty,
    output reg valid
);
    integer i;
    reg [7:0] trash;

    // Constants
    integer queue_size = 5;
    parameter QUEUE_SIZE = 5;
    parameter QUEUE_WIDTH = 8;

    // Internal registers
    reg [QUEUE_WIDTH-1:0] queue [QUEUE_SIZE-1:0];
    reg [3:0] queue_head, queue_tail;
    reg [3:0] queue_count;
    reg [7:0] result;
    
    // Outputs
    assign tail = (valid && queue_count > 0) ? queue[queue_tail] : trash;
    assign empty = (valid) ? (queue_count == 0) : trash[0];

    // Always block to handle operations
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            queue_count <= 3'b0;
            queue_head <= 3'b0;
            queue_tail <= 3'b0;
            valid <= 1'b1;
        end else if (apply) begin
            if (op == 0) begin
                if (queue_count < queue_size) begin
                    if (queue_count == 0) begin
                        queue[queue_tail] <= in;
                        queue_count <= (queue_count + 1) % QUEUE_SIZE;
                    end else begin
                        queue[(queue_tail + 1) % queue_size] <= in;
                        queue_tail <= (queue_tail + 1) % queue_size;
                        queue_count <= queue_count + 1;
                    end 
                end else begin 
                    valid <= 1'b0;
                end
            end else if (op == 1) begin
                if (queue_count > 0) begin
                    if (queue_count != 1) begin
                        queue_head <= (queue_head + 1) % queue_size;
                    end 
                    queue_count <= queue_count - 1;
                end else begin
                    valid <= 1'b0;
                end
            end else if (op > 1 && op <= 6) begin
                if (queue_count >= 2) begin
                    if (op != 5 && op != 6 || ((op == 5 || op == 6) && queue[queue_head] != 0)) begin
                        case(op)
                            2: queue[(queue_tail + 1) % queue_size] <= queue[queue_head] + queue[(queue_head + 1) % queue_size];
                            3: queue[(queue_tail + 1) % queue_size] <= queue[queue_head] * queue[(queue_head + 1) % queue_size];
                            4: queue[(queue_tail + 1) % queue_size] <= queue[(queue_head + 1) % queue_size] - queue[queue_head];
                            5: queue[(queue_tail + 1) % queue_size] <= queue[(queue_head + 1) % queue_size] / queue[queue_head];
                            6: queue[(queue_tail + 1) % queue_size] <= queue[(queue_head + 1) % queue_size] % queue[queue_head];
                        endcase
                        queue_count <= queue_count - 1;
                        queue_head <= (queue_head + 2) % queue_size;
                        queue_tail <= (queue_tail + 1) % queue_size;
                    end else begin
                        valid <= 1'b0;
                    end
                end else begin
                    valid <= 1'b0;
                end
            end else begin
                valid <= 1'b0;
            end
        end
    end
endmodule
