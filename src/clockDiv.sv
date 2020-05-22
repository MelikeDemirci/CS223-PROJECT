`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2020 12:44:07 AM
// Design Name: 
// Module Name: clockDiv
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


module clockDiv(input logic clk,
                    output logic slowerClk

    );
   
logic [26:0] clk_counter;
initial begin
slowerClk = clk;
end

always @(posedge clk)
begin 
    if(clk_counter >= 9999999)
        begin
        clk_counter <= 0;
        slowerClk = ~slowerClk;
        end
    else
        clk_counter <= clk_counter + 1;
end 

endmodule