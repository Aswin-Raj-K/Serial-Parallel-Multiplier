`timescale		    1ns/1ps
module spm #(parameter SIZE = 32)(
    input wire              clk, 
    input wire              rst,
    input wire              y,
    input wire [SIZE-1:0]   x,
    output wire             p
);
    wire [SIZE-1:1]     pp;

    genvar i;

    csa csa0 (.clk(clk), .rst(rst), .x(x[0]&y), .y(pp[1]), .sum(p));
    
    generate 
        for(i=1; i<SIZE-1; i=i+1) begin
            csa csa_a (.clk(clk), .rst(rst), .x(x[i]&y), .y(pp[i+1]), .sum(pp[i]));
        end 
    endgenerate
    
    csa tmp (.clk(clk), .rst(rst), .x(x[SIZE-1]&y), .y(1'b0), .sum(pp[SIZE-1]));

endmodule

