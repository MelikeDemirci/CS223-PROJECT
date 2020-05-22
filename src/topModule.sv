`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2020 12:44:57 AM
// Design Name: 
// Module Name: topModule
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module topModule(input logic clk, reset, 
                 input logic [3:0] wAddr, [7:0] data, //from switches
                 input logic next, prev, compute, counter, enter, //buttons
                 output logic a, b, c, d, e, f, g, dp, [3:0] an, //to sevenSeg
                 output logic [7:0] lData, [3:0] lAddr, 
                 output logic lReset

    );
    

logic clk2;
logic nextB, prevB, computeB, counterB, enterB; 
logic we;
logic [3:0] rAddr, rAddr2;
logic [1:0] mode;
logic [7:0] out2, out, outCntrl, dataSSeg;

//mux
always_comb
begin
if(mode == 2'b00)
    dataSSeg <= out;
else 
    dataSSeg <= outCntrl;
end

clockDiv cd(clk, clk2);
pushButton n(clk2, next, nextB);    
pushButton p(clk2, prev, prevB);  
pushButton cmp(clk2, compute, computeB);  
pushButton cnt(clk2, counter, counterB);  
pushButton ent(clk2, enter, enterB);  

hlsm HighLevelSM(clk2, reset,nextB, prevB, computeB, counterB, enterB, wAddr, out2,
                rAddr, //goes to memory and sevSeg
                we, //goes to memory
                mode, //goes to sevSeg
                outCntrl, //goes to sevSeg
                rAddr2 //goes to memory
    );
    
mainMemory memory(clk2, reset, 
            we, //write enable
            wAddr, //write address
            rAddr, //comes from hlsm
            rAddr2, //comes from hlsm
            data, //input data
            out, //data readed from rAddr
            out2 //data readed from rAddr2
    );
    
sevSeg sevenSegment( clk, mode, dataSSeg, rAddr, //rAddr comes from hlsm
        a, b, c, d, e, f, g, dp, an);
    
assign lData = data;
assign lAddr = wAddr;
assign lReset = reset;

endmodule
