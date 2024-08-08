`timescale 1ns/1ps 
module pm_TB#(parameter SIZE = 32)();

//Period set to 20ns
localparam half_period = 1;

reg clk = 1, rst;
reg [SIZE-1:0] mc,mp;
reg start;
wire [SIZE*2-1:0] p;
wire done;

//Instantiating the module
pm32 DUT
   (.clk(clk),
    .start(start),
    .rst(rst),
    .mc(mc),
    .mp(mp),
    .p(p),
    .done(done)
    );

//For clock, with period 20ns
always
   #half_period clk = ~clk;

//Validating the design using test cases
initial
    begin
        repeat(4)#half_period
        
        rst = 1;
        start = 0;
        mp = 101;
        mc = 56;
        
        #half_period
        #half_period
        
        start = 1;
        rst = 0;
        #half_period
        #half_period
        start = 0;
        
        $display("==================RESULT===================");
        while(done != 1)//waiting for the result
        begin
            #half_period;
            #half_period;
        end
        $display("Product is: %d", p);
        $display("===========================================");
        $finish;
    end

endmodule