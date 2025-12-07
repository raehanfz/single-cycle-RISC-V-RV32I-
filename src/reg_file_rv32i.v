module reg_file_rv32i (
    input wire clock, 
    input wire cu_rdwrite, 
    input wire [4:0] rs1_addr, 
    input wire [4:0] rs2_addr, 
    input wire [4:0] rd_addr, 
    input wire [31:0] rd_in, 
    output wire [31:0] rs1, 
    output wire [31:0] rs2 
);

    reg [31:0] rf [0:31];

    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) rf[i] = 32'b0; 
    end

    always @(posedge clock) begin
        if (cu_rdwrite && (rd_addr != 5'd0))
            rf[rd_addr] <= rd_in;
            rf[0] <= 32'b0;
        end
    //read synchronously
        assign rs1 = (rs1_addr == 5'd0) ? 32'b0 : rf[rs1_addr];
        assign rs2 = (rs2_addr == 5'd0) ? 32'b0 : rf[rs2_addr];
endmodule