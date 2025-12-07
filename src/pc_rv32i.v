module pc_rv32i (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [31:0] PCin, 
    output reg  [31:0] PCout
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            PCout <= 32'h00000000;
        end else begin
            PCout <= PCin;
        end
    end

endmodule