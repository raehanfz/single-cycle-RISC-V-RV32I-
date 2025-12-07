module imm_select_rv32i (
    input wire [31:7] trimmed_instr, // Trimmed instruction, bits 31 downto 7
    input wire [2:0] cu_immtype,     // I=000, S=001, B=010, U=011, J=100
    output reg [31:0] imm            // 32-bit immediate
);

always @ (*)
begin
    case (cu_immtype)
        3'b000: // I-type
            imm <= { {20{trimmed_instr[31]}}, trimmed_instr[31:20] };

        3'b001: // S-type
            imm <= { {20{trimmed_instr[31]}}, trimmed_instr[31:25], trimmed_instr[11:7] };

        3'b010: // B-type
            imm <= { {20{trimmed_instr[31]}}, trimmed_instr[7], trimmed_instr[30:25], trimmed_instr[11:8], 1'b0 };

        3'b011: // U-type
            imm <= { trimmed_instr[31:12], 12'b0 };

        3'b100: // J-type
            imm <= { {12{trimmed_instr[31]}}, trimmed_instr[19:12], trimmed_instr[20], trimmed_instr[30:21], 1'b0 };

        default:
            imm <= 32'd0;
    endcase
end
endmodule