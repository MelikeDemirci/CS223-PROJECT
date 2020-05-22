`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2020 12:41:53 AM
// Design Name: 
// Module Name: sevSeg
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


module sevSeg( input logic clk, 
                      input logic [1:0] mode, //00 - memory display | 01 - cSum display | 10 - counter display | 11 - wait
                      input logic [7:0] data, 
                      input logic [3:0] addr,
                      output logic a, b, c, d, e, f, g, dp, 
                      output logic [3:0] an);
    localparam N = 18;
    logic [N-1:0] count = {N{1'b0}};
    
    always_ff@( posedge clk)
        count <= count + 1;
        
    logic [3:0]digit_val;
    logic [3:0] addr_val;
    logic [3:0]digit_en;
    
    always_comb
    begin
        digit_en = 4'b1111;
        digit_val = 4'b1111;
        
        case(count[N-1:N-2]) 
        2'b00 :
        begin
            digit_val = data[3:0];
            digit_en = 4'b1110;
        end
        2'b01:
        begin
            digit_val = data[7:4];
            digit_en = 4'b1101;
        end
        2'b10:
        begin
            digit_en = 4'b1011;
        end
        2'b11:
        begin
            addr_val = addr;
            digit_en = 4'b0111;
        end
        endcase
    end
   
    logic [6:0] sseg_LEDs;
    always_comb
    begin
        if(digit_en == 4'b1011)
        begin
            if(mode == 2'b01)
                sseg_LEDs = 7'b1110110; // = 
            else if(mode == 2'b10)
                sseg_LEDs = 7'b1111111; //all closed if it is counter display or wait
            else 
                sseg_LEDs = 7'b1111110; //-
        end
        else if(digit_en == 4'b0111)
        begin
            if(mode == 2'b01) 
                sseg_LEDs = 7'b0110001; //C
            else if(mode == 2'b10)
                sseg_LEDs = 7'b1111111; //all closed if it is counter display mode
            else if(mode == 2'b11)
                sseg_LEDs = 7'b1111110; // -
            else
            begin
                case(addr_val)
                'd0  : sseg_LEDs = 7'b0000001; //0
                'd1  : sseg_LEDs = 7'b1001111; //1
                'd2  : sseg_LEDs = 7'b0010010; //2
                'd3  : sseg_LEDs = 7'b0000110; //3
                'd4  : sseg_LEDs = 7'b1001100; //4
                'd5  : sseg_LEDs = 7'b0100100; //5
                'd6  : sseg_LEDs = 7'b0100000; //6
                'd7  : sseg_LEDs = 7'b0001111; //7
                'd8  : sseg_LEDs = 7'b0000000; //8
                'd9  : sseg_LEDs = 7'b0000100; //9 
                'd10 : sseg_LEDs = 7'b0001000; //A
                'd11 : sseg_LEDs = 7'b1100000; //B
                'd12 : sseg_LEDs = 7'b0110001; //C
                'd13 : sseg_LEDs = 7'b1000010; //D
                'd14 : sseg_LEDs = 7'b0110000; //E
                'd15 : sseg_LEDs = 7'b0111000; //F
                default : sseg_LEDs = 7'b1111110;
                endcase
            end
        end
        else
        begin
            if(mode == 2'b11)
            sseg_LEDs = 7'b1111110; // -
            else
            begin
                case(digit_val)
                'd0  : sseg_LEDs = 7'b0000001; //0
                'd1  : sseg_LEDs = 7'b1001111; //1
                'd2  : sseg_LEDs = 7'b0010010; //2
                'd3  : sseg_LEDs = 7'b0000110; //3
                'd4  : sseg_LEDs = 7'b1001100; //4
                'd5  : sseg_LEDs = 7'b0100100; //5
                'd6  : sseg_LEDs = 7'b0100000; //6
                'd7  : sseg_LEDs = 7'b0001111; //7
                'd8  : sseg_LEDs = 7'b0000000; //8
                'd9  : sseg_LEDs = 7'b0000100; //9 
                'd10 : sseg_LEDs = 7'b0001000; //A
                'd11 : sseg_LEDs = 7'b1100000; //B
                'd12 : sseg_LEDs = 7'b0110001; //C
                'd13 : sseg_LEDs = 7'b1000010; //D
                'd14 : sseg_LEDs = 7'b0110000; //E
                'd15 : sseg_LEDs = 7'b0111000; //F
                
                
                default : sseg_LEDs = 7'b1111110;
                endcase
            end
         end
    end
    
    assign an = digit_en;
    assign {a, b, c, d, e, f, g} = sseg_LEDs;
    assign dp = 1'b1;
endmodule
