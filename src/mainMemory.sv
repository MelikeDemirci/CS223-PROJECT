`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2020 12:42:52 AM
// Design Name: 
// Module Name: mainMemory
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


module mainMemory(input logic clk, reset, we,
                  input logic [3:0] wAddr, //write address
                  input logic [3:0] rAddr, //read address
                  input logic [3:0] rAddr2,
                  input logic [7:0] data,
                  output logic [7:0] out,
                  output logic [7:0] out2
    );
    
    logic [7:0] RAM[15:0];
    
    assign out = RAM[rAddr];
    assign out2 = RAM[rAddr2];
    always@(posedge clk, posedge reset)
        if(reset)
        begin
            RAM['d0] <= 8'b0000_0000;
            RAM['d1] <= 8'b0000_0001;
            RAM['d2] <= 8'b0000_0010;
            RAM['d3] <= 8'b0000_0011;
            RAM['d4] <= 8'b0000_0100;
            RAM['d5] <= 8'b0000_0101;
            RAM['d6] <= 8'b0000_0110;
            RAM['d7] <= 8'b0000_0111;
            RAM['d8] <= 8'b0000_1000;
            RAM['d9] <= 8'b0000_1001;
            RAM['d10] <= 8'b0000_1010;
            RAM['d11] <= 8'b0000_1011;
            RAM['d12] <= 8'b0000_1100;
            RAM['d13] <= 8'b0000_1101;
            RAM['d14] <= 8'b0000_1110;
            RAM['d15] <= 8'b0000_1111;
                 
        end
        else
        begin
            if(we)
            RAM[wAddr] <= data;
        end
        
 
endmodule
