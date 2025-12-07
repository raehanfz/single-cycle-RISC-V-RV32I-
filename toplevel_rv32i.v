module toplevel_rv32i(
    input wire clock,
    input wire reset,

    // Sinyal-sinyal intermediat terekspos
    output wire [31:0] PC, PC_in, instr,
    output wire [6:0] opcode, funct7,
    output wire [2:0] funct3,
    output wire [31:0] imm,
    output wire [4:0] rs1_addr, rs2_addr, rd_addr,
    output wire [31:0] rs1, rs2, rd_in,
    output wire [31:0] ALU_in1, ALU_in2, ALU_output,
    output wire [31:0] dmem_addr, dmem_out, load_out
);

    assign opcode    = instr[6:0];
    assign funct3    = instr[14:12];
    assign funct7    = instr[31:25];
    assign rs1_addr  = instr[19:15];
    assign rs2_addr  = instr[24:20];
    assign rd_addr   = instr[11:7];

//INSTRUCTION FETCH
    wire [31:0] PC_4_add, PC_jump, PC_new;


    mux_2to1_32bit blok_21mux_jumper(
        .A(PC_4_add),
        .B(ALU_output),
        .sel(cu_jump),
        .D(PC_new)
    );

    wire [31:0] PC_branch;                                                                                                                                                                       /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    brancher_rv32i blok_brancher(
        .PC_new(PC_new),
        .ALU_out(ALU_output),
        .in1(rs1),
        .in2(rs2),
        .cu_branch(cu_branch),
        .cu_branchtype(cu_branchtype),
        .PCin(PC_in)
    );

    wire [31:0] PC_out;
    pc_rv32i blok_pc(
        .clk(clock),
        .rst_n(reset),
        .PCin(PC_in),
        .PCout(PC_out)
    );

    assign PC = PC_out;

    pc_4_adder_rv32i blok_4adder(
        .PC_old(PC_out),
        .PC_4_inc(PC_4_add)
    );

    instr_rom_rv32i blok_imem(
        .clock(clock),
        .PC(PC_out),
        .INSTR(instr)
    );

//INSTRUCTION DECODE
    wire cu_ALU1src;
    wire cu_ALU2src;
    wire [2:0] cu_immtype;
    wire [1:0] cu_ALUtype;
    wire cu_adtype;
    wire [1:0] cu_gatype;
    wire [1:0] cu_shiftype;
    wire cu_sltype;
    wire [1:0] cu_rdtype;
    wire cu_rdwrite;
    wire [2:0] cu_loadtype;
    wire cu_store;
    wire [1:0] cu_storetype;
    //wire cu_jump;
    //wire cu_branch;
    //wire [2:0] cu_branchtype;

    ctrl_unit_rv32i blok_cu(
        .opcode(instr[6:0]),
        .funct3(instr[14:12]),
        .funct7(instr[31:25]),
        .cu_ALU1src(cu_ALU1src),
        .cu_ALU2src(cu_ALU2src),
        .cu_immtype(cu_immtype),
        .cu_ALUtype(cu_ALUtype),
        .cu_adtype(cu_adtype),
        .cu_gatype(cu_gatype),
        .cu_shiftype(cu_shiftype),
        .cu_sltype(cu_sltype),
        .cu_rdtype(cu_rdtype),
        .cu_rdwrite(cu_rdwrite),
        .cu_loadtype(cu_loadtype),
        .cu_store(cu_store),
        .cu_storetype(cu_storetype),
        .cu_branch(cu_branch),
        .cu_branchtype(cu_branchtype),
        .cu_jump(cu_jump)
    );

    reg_file_rv32i blok_regfile(
        .rs1_addr(instr[19:15]),
        .rs2_addr(instr[24:20]),
        .rd_addr(instr[11:7]),
        .rd_in(rd_in),
        .cu_rdwrite(cu_rdwrite),
        .clock(clock),
        .rs1(rs1),
        .rs2(rs2)
    );

    imm_select_rv32i blok_immselect(
        .trimmed_instr(instr[31:7]),
        .cu_immtype(cu_immtype),
        .imm(imm)
    );

    mux_2to1_32bit blok_21mux_rs1(
        .A(rs1),
        .B(PC_out),
        .sel(cu_ALU1src),
        .D(ALU_in1)
    );

    mux_2to1_32bit blok_21mux_rs2(
        .A(rs2),
        .B(imm),
        .sel(cu_ALU2src),
        .D(ALU_in2)
    );

//EXECUTE
    alu_rv32i blok_alu(
        .in1(ALU_in1),
        .in2(ALU_in2),
        .cu_ALUtype(cu_ALUtype),
        .cu_adtype(cu_adtype),
        .cu_gatype(cu_gatype),
        .cu_shiftype(cu_shiftype),
        .cu_sltype(cu_sltype),
        .out(ALU_output)
    );

//MEMORY ACCESS
    data_mem_rv32i blok_dmem(
        .clock(clock),
        .cu_store(cu_store),
        .cu_storetype(cu_storetype),
        .rs2(rs2),
        .dmem_addr(ALU_output),
        .dmem_out(dmem_out)
    );
    assign dmem_addr = ALU_output;
    loadselect_rv32i blok_loadselect(
        .dmem_out(dmem_out),
        .cu_loadtype(cu_loadtype),
        .load_out(load_out)
    );

//WRITE BACK
    mux_4to1_32bit blok_41mux_rd(
        .W(ALU_output),
        .X(load_out),
        .Y(PC_4_add),
        .Z(imm),
        .sel(cu_rdtype),
        .D(rd_in)
    );
endmodule