module QUEUE #(
        parameter WIDTH = 8,
        parameter DEPTH = 8
    )
    (
        input       logic           [0 : 0]                 clk,
        input       logic           [0 : 0]                 rstn,
        input       logic           [0 : 0]                 en,

        input       logic           [0 : 0]                 enqueue,
        input       logic           [0 : 0]                 dequeue,
        input       logic           [WIDTH - 1 : 0]         enqueue_data,
        output      logic           [WIDTH - 1 : 0]         queue_head_data,

        output      logic           [0 : 0]                 empty,
        output      logic           [0 : 0]                 full
    );

    logic     [WIDTH - 1 : 0]     fifo_queue      [0 : (1 << DEPTH) - 1];
    logic     [DEPTH - 1 : 0]     head, rear;

    integer i;

    initial begin
        for(i = 0; i < 1 << DEPTH; i = i + 1) begin
            fifo_queue[i] = 0;
        end
        head = 0;
        rear = 0;
    end

    always @(posedge clk) begin
        if(!rstn | ~en) begin	                    // synchronous reset, but should be logicarded asynchronous with cpu_clk
            head <= 0;
            rear <= 0;
        end
        else begin                              // a substitution for always @(posedge cpu_clk)
            if(enqueue && dequeue) begin
                fifo_queue[rear] <= enqueue_data;
                head <= head + 1;
                rear <= rear + 1;
            end
            else begin
                if(enqueue && !full) begin
                    fifo_queue[rear] <= enqueue_data;
                    rear <= rear + 1;
                end
                if(dequeue && !empty) begin
                    head <= head + 1;
                end
            end
        end
    end

    assign queue_head_data = fifo_queue[head];
    assign empty = (head == rear);
    assign full = ((rear + 1) % (1 << DEPTH) == head);

endmodule
