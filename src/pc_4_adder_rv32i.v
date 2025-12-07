module pc_4_adder_rv32i (
    input  wire [31:0] PC_old,
    output wire [31:0] PC_4_inc
);
    assign PC_4_inc = PC_old + 32'h4;

endmodule