module brancher_rv32i(
    input wire [31:0] PC_new,
    input wire [31:0] ALU_out,
    input wire signed [31:0] in1,
    input wire signed [31:0] in2,
    input wire cu_branch,
    input wire [2:0] cu_branchtype, 
    output reg [31:0] PCin
);
always @ (*)
begin
    if (cu_branch)
    begin
        case (cu_branchtype)
            3'b000: // BEQ
                PCin <= (in1==in2) ? ALU_out : PC_new;
            3'b001: // BNE
                PCin <= (in1 != in2) ? ALU_out : PC_new;
            3'b010: // BLT
                PCin <= (in1 < in2) ? ALU_out : PC_new;
            3'b011: // BGE
                PCin <= (in1 >= in2) ? ALU_out : PC_new;
            3'b100: // BLTU
                PCin <= ($unsigned(in1) < $unsigned(in2)) ? ALU_out : PC_new;
            3'b101: // BGEU
                PCin <= ($unsigned(in1) >= $unsigned(in2)) ? ALU_out : PC_new;
            default:
                PCin <= PC_new;
        endcase
    end
    else
        PCin <= PC_new;
end
endmodule