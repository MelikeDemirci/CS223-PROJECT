`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2020 12:43:34 AM
// Design Name: 
// Module Name: pushButton
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


module pushButton(input logic clk, pb,
                  output logic pb_out);

logic Q1,Q2,Q2_bar;

always @ (posedge clk) 
begin
       Q1 <= pb ;
       Q2 <= Q1;
end

assign Q2_bar = ~Q2;
assign pb_out = Q1 & Q2_bar;

endmodule
