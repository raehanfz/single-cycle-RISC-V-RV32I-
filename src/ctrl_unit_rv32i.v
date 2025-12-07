module ctrl_unit_rv32i (
    input wire [6:0] opcode, 
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    
    output reg       cu_ALU1src,
    output reg       cu_ALU2src,
    output reg [2:0] cu_immtype,
    output reg [1:0] cu_ALUtype,
    output reg       cu_adtype,
    output reg [1:0] cu_gatype,
    output reg [1:0] cu_shiftype,
    output reg       cu_sltype,
    output reg [1:0] cu_rdtype,
    output reg       cu_rdwrite,
    output reg [2:0] cu_loadtype,
    output reg       cu_store,
    output reg [1:0] cu_storetype,
    output reg       cu_branch,
    output reg [2:0] cu_branchtype,
    output reg       cu_jump
);

always @ (*)
begin
    // Default assignments using non-blocking
    cu_ALU1src    <= 1'b0; 
    cu_ALU2src    <= 1'b0; 
    cu_immtype    <= 3'b000; 
    cu_ALUtype    <= 2'b00; 
    cu_adtype     <= 1'b0; 
    cu_gatype     <= 2'b00; 
    cu_shiftype   <= 2'b00; 
    cu_sltype     <= 1'b0; 
    cu_rdtype     <= 2'b00; 
    cu_rdwrite    <= 1'b0; 
    cu_loadtype   <= 3'b000; 
    cu_store      <= 1'b0;  
    cu_storetype  <= 2'b00; 
    cu_branch     <= 1'b0; 
    cu_branchtype <= 3'b000; 
    cu_jump       <= 1'b0; 

    case (opcode)
        
        //R-TYPE (ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU)
        7'h33: 
        begin
            cu_rdwrite <= 1'b1;
            case (funct3)
                3'h0: begin // ADD atau SUB
                    if (funct7 == 7'h20) cu_adtype <= 1'b1; // SUB
                    else                 cu_adtype <= 1'b0; // ADD
                end
                3'h1: cu_ALUtype <= 2'b10; // SLL
                3'h2: cu_ALUtype <= 2'b11; // SLT
                3'h3: begin               // SLTU
                    cu_ALUtype <= 2'b11; 
                    cu_sltype  <= 1'b1; 
                end
                3'h4: begin               // XOR
                    cu_ALUtype <= 2'b01; 
                    cu_gatype  <= 2'b00;
                end
                3'h5: begin               // SRL atau SRA
                    cu_ALUtype <= 2'b10; 
                    if (funct7 == 7'h20) cu_shiftype <= 2'b11; // SRA
                    if (funct7 == 7'h00) cu_shiftype <= 2'b01; // SRL
                end
                3'h6: begin               // OR
                    cu_ALUtype <= 2'b01; 
                    cu_gatype  <= 2'b01; 
                end
                3'h7: begin               // AND
                    cu_ALUtype <= 2'b01; 
                    cu_gatype  <= 2'b10; 
                end
            endcase
        end

        //I-TYPE (ADDI, ANDI, ORI, XORI, SLTI, SLTIU, SLLI, SRLI, SRAI)
        7'h13: 
        begin
            cu_ALU2src <= 1'b1;
            cu_rdwrite <= 1'b1;
            cu_immtype <= 3'b000;
            
            case (funct3)
                3'h0: cu_adtype <= 1'b0; // ADDI
                3'h1: cu_ALUtype <= 2'b10; // SLLI
                3'h2: cu_ALUtype <= 2'b11; // SLTI
                3'h3: begin // SLTIU
                    cu_ALUtype <= 2'b11; 
                    cu_sltype  <= 1'b1; 
                end
                3'h4: begin // XORI
                    cu_ALUtype <= 2'b01; 
                    cu_gatype  <= 2'b00; 
                end
                3'h5: begin // SRLI atau SRAI
                    cu_ALUtype <= 2'b10;
                    if (funct7 == 7'h20) cu_shiftype <= 2'b11; // SRAI
                    if (funct7 == 7'h00) cu_shiftype <= 2'b01; // SRLI
                end
                3'h6: begin // ORI
                    cu_ALUtype <= 2'b01; 
                    cu_gatype  <= 2'b01; 
                end
                3'h7: begin // ANDI
                    cu_ALUtype <= 2'b01; 
                    cu_gatype  <= 2'b10; 
                end
            endcase
        end

        //LOAD (LW, LH, LB, LHU, LBU)
        7'h03: 
        begin
            cu_ALU2src  <= 1'b1;
            cu_rdtype   <= 2'b01;
            cu_rdwrite  <= 1'b1;
            cu_immtype  <= 3'b000;
            cu_loadtype <= funct3;
        end

        //STORE (SW, SH, SB)
        7'h23: 
        begin
            cu_ALU2src   <= 1'b1;
            cu_store     <= 1'b1;
            cu_immtype   <= 3'b001;
            cu_storetype <= funct3[1:0];
        end

        // BRANCH (BEQ, BNE, BLT, BGE, BGEU, BLTU)
        7'h63: 
        begin
            cu_ALU1src    <= 1'b1;
            cu_ALU2src    <= 1'b1;
            cu_branch     <= 1'b1;
            cu_immtype    <= 3'b010;
            cu_branchtype <= funct3;
            cu_jump       <= 1'b0;
        end

        //LUI
        7'h37: 
        begin
            cu_rdtype   <= 2'b11;
            cu_rdwrite  <= 1'b1;
            cu_immtype  <= 3'b011;
        end

        //AUIPC
        7'h17: 
        begin
            cu_ALU1src  <= 1'b1;
            cu_ALU2src  <= 1'b1;
            cu_rdtype   <= 2'b00;
            cu_rdwrite  <= 1'b1;
            cu_immtype  <= 3'b011;
            cu_adtype   <= 1'b0;
        end

        //JAL
        7'h6F: 
        begin
            cu_ALU1src  <= 1'b1;
            cu_ALU2src  <= 1'b1;
            cu_rdtype   <= 2'b10;
            cu_rdwrite  <= 1'b1;
            cu_branch   <= 1'b0;
            cu_immtype  <= 3'b100;
            cu_jump     <= 1'b1;
        end

        //JALR
        7'h67: 
        begin
            cu_ALU1src  <= 1'b0;
            cu_ALU2src  <= 1'b1;
            cu_rdtype   <= 2'b10;
            cu_rdwrite  <= 1'b1;     
            cu_branch   <= 1'b0;
            cu_immtype  <= 3'b000;
            cu_jump     <= 1'b1;
        end

    endcase
end

endmodule