module loadselect_rv32i (
    input wire [31:0]  dmem_out,
    input wire [2:0]   cu_loadtype,
    output wire [31:0] load_out
);

assign load_out = (cu_loadtype == 3'b000) ? {{24{dmem_out[7]}}, dmem_out[7:0]} :      // LB
                  (cu_loadtype == 3'b001) ? {{16{dmem_out[15]}}, dmem_out[15:0]} :    // LH
                  (cu_loadtype == 3'b010) ? dmem_out :                                // LW
                  (cu_loadtype == 3'b011) ? {24'b0, dmem_out[7:0]} :                  // LBU
                  (cu_loadtype == 3'b100) ? {16'b0, dmem_out[15:0]} :                 // LHU
                  32'b0;                                                              // Default

endmodule