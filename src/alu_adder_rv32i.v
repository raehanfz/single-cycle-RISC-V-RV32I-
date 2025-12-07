module alu_adder_rv32i (
    input wire [31:0] in1, 
    input wire [31:0] in2,
    input wire        type,//Selector: 0 = Add, 1 = Sub
    output reg [31:0] out
);
    always @(*) begin
        if (type == 1'b0) begin
            out = in1 + in2;
        end else begin
            out = in1 - in2;
        end
    end
endmodule