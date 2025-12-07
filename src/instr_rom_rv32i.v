module instr_rom_rv32i (
    input wire clock,
    input wire [31:0] PC, 
    output wire [31:0] INSTR
);
    wire [5:0] waddr = PC[7:2];
    wire       inv_clock = ~clock; 

    altsyncram #(
        .operation_mode("ROM"),
        .width_a(32),
        .widthad_a(6), 
        .init_file("imemory.mif"),
        .outdata_reg_a("UNREGISTERED")
    ) 
    rom (
        .clock0 (inv_clock),
        .address_a(waddr),
        .q_a (INSTR),
        .wren_a (1'b0),
        .data_a (32'b0)
    );
endmodule