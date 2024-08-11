`timescale 1ns/1ps 
module pm_TB_V2#(parameter SIZE = 32, TEST_DATA_COUNT = 40)();

//Period set to 20ns
localparam half_period = 1;

reg clk = 1, rst;
reg [SIZE-1:0] mc,mp;
reg start;
wire [SIZE*2-1:0] p;
wire done;
reg [31:0] memory_array [0:TEST_DATA_COUNT-1];

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
 
 
integer i;
integer file;
integer scan_result;
integer j;
//Validating the design using test cases
initial
    begin
        file = $fopen("dataIn.mem","r");
        if(file) begin
            for(i = 0; i < TEST_DATA_COUNT; i = i + 1)
                scan_result = $fscanf(file, "%d\n", memory_array[i]);
            $fclose(file);
        end else begin
            $display("Failed to open file.");
        end
        
        for(j = 0; j < TEST_DATA_COUNT-1; j = j + 1)
        begin
            repeat(2)#half_period
            
            rst = 1;
            start = 0;
            mp = memory_array[j];
            mc = memory_array[j+1];
            
            repeat(2)#half_period
            
            start = 1;
            rst = 0;
            
            repeat(2)#half_period
            
            start = 0;
            
            $display("==================Test Case %0d===================",j+1);
            while(done != 1)//waiting for the result
            begin
                repeat(2)#half_period;
            end
            $display("Result of spm (%0d x %0d): %0d", mp,mc,p);
            $display("Expected Result: %0d", mc*mp);
            
            if(!(mc*mp == p))
            begin
               $display("Test Case %0d Failed",j+1);
               $finish;
            end
            
            $display("================================================");
         end
         $display("All Test Cases Passed");
         $display("================================================");
          $finish;

    end

endmodule