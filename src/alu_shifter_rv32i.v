module alu_shifter_rv32i (
    input wire [31:0] in,     
    input wire [31:0] shamt,  
    input wire [1:0]  type,   
    output reg [31:0] out     
);
    always @(*) begin
        case (type)
            2'b00: begin 
                out = in << shamt[4:0]; //shift left logical
            end
            2'b01: begin 
                out = in >> shamt[4:0]; //shift right logical
            end
            2'b10: begin 
                out = $signed(in) >>> shamt[4:0]; //shift right arithmatic
            end
            default: out = 32'b0;
        endcase
    end
endmodule