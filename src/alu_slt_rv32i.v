module alu_slt_rv32i (
    input wire [31:0]   in1,
    input wire [31:0]   in2,
    output wire [31:0]  out,
    input wire          type
);

assign out = (type) ? (in1 < in2 ? 32'b1 : 32'b0) :
                      ($signed(in1) < $signed(in2) ? 32'b1 : 32'b0);
endmodule