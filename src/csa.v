`timescale 1ns / 1ps

// Carry Save Adder
module csa(
    input wire  clk, 
    input wire  rst,
    input wire  x, 
    input wire  y,
    output reg  sum
);

    reg sc;


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sum <= 1'b0;
            sc <= 1'b0;
        end
        else begin
            sum <= x ^ y ^ sc;
            sc <= (y & sc) | (x & sc) | (x & y);
        end
    end
endmodule