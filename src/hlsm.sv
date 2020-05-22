`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2020 12:40:48 AM
// Design Name: 
// Module Name: hlsm
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


module hlsm(input logic clk, reset,
            input logic next, prev, compute, counter, enter, [3:0] addr,[7:0] data,
            output logic [3:0]rAddr, we,
            output logic [1:0] mode,
            output logic [7:0] out,
            output logic [3:0] i
    );
                     
    typedef enum logic [2:0] {init, waitInp, enterD, cSum, cSumFin, dSum, dCounter, clearCounter} statetype;
    statetype [2:0] state, nextstate;
    
    logic trig;
    logic [7:0] cntr, sum;
    logic [3:0] addrReg;
    logic [7:0] t, nextT;
    logic [3:0] index, nextIndex;
    logic enSum, fin, clr_cntr, clr_sum;
    logic addr_0, addr_1, addr_2, addr_3 ;

    // State Register
    always_ff @(posedge clk, posedge reset)
    if (reset)
        begin 
        state <= init;
        t <= 0;
        index <= 0;
        end
    else 
        begin
        state <= nextstate;
        t <= nextT;
        index <= nextIndex;
        end
    
    //Sum register
    always_ff @(posedge clk, posedge reset)
    if(reset || clr_sum)
        sum <= 0;
    else if (enSum)
        sum <= sum + data;
    else if(fin)
        sum <= ~sum + 1;
    else 
        sum <= sum;
    
    //Address kept in logic in order to understrand if it is changed or not
    always_ff @(posedge clk)
    begin
        addr_0 = addr[0];
        addr_1 = addr[1];
        addr_2 = addr[2];
        addr_3 = addr[3];
    end
    
    always_ff @(clk, next, prev, addr[0], addr[1], addr[2], addr[3])
    if(addr_0 != addr[0] || addr_1 != addr[1] || addr_2 != addr[2] || addr_3 != addr[3])
        trig = 1'b1;
    else
        trig = 1'b0;
        
    //Address Register 
    //This register deals with display next and previous
    always_ff @(posedge clk, posedge reset)
    begin
        if(reset)
            addrReg <= 0;
        else if (next)
            begin
            if(addrReg != 15)
                addrReg = addrReg + 1;
            else
                addrReg = 0;
            end
        else if(prev)
            begin
            if(addrReg != 0)
                addrReg = addrReg - 1;
            else
                addrReg = 15;
            end
        else if(trig)
            addrReg <= addr;
        else
            addrReg <= addrReg;
    end
    
    
    //counter register
    always_ff @(posedge clk, posedge reset)
    if(reset || clr_cntr)
        cntr <= 0;
    else if (enSum) //if enSum = 1 it will be counting
        cntr <= cntr + 1;
    else 
        cntr <= cntr;

        
    // Next State Logic
    always_comb
    case (state)
        init: 
            begin//clear all
            nextIndex <= 0;
            nextT <= 0;
            nextstate = waitInp;
            end
        waitInp: 
            begin
            nextIndex <= 0; //clear index
            i <= 0; 
            nextT <= 0; //clear timer
            if(compute)
                nextstate = clearCounter;
            else if(enter)
                nextstate = enterD; 
            else if(counter)
                nextstate = dCounter; 
            else
                nextstate = waitInp;         
            end
        enterD: 
            begin
            nextstate = waitInp;
            end
        clearCounter: 
            begin
            nextstate = cSum;
            end
        cSum: 
            begin
            i <= index; // 
            nextIndex <= index + 1; //incerement index
            if (index < 15) 
                nextstate = cSum;
            else 
                nextstate = cSumFin;
            end
        cSumFin: 
            begin
            nextstate = dSum;
            end
        dSum: 
            begin
            nextT <= t + 1;
            out <= sum; //output the sum
            if (t == 30) //stay 10 sec
                nextstate = waitInp;
            else 
                nextstate = dSum;
            end
        dCounter: 
            begin
            nextT <= t + 1;
            out <= cntr; //output the counter
            if (t == 30) //stay 10 sec
                nextstate = waitInp;
            else 
                nextstate = dCounter;
            end
        
    endcase
    
    // Output Logic
    always_comb
    case (state)
        init: 
            begin 
                fin = 1'b0;
                clr_cntr = 1'b0;
                enSum = 1'b0;
                we = 1'b0;
                mode = 2'b11;
                clr_sum = 1'b1;
            end
        waitInp: 
            begin
                fin = 1'b0;
                clr_cntr = 1'b0;
                clr_sum = 1'b1;
                enSum = 1'b0;
                we = 1'b0;
                mode = 2'b00; //memory display
            end 
        enterD: 
            begin 
                enSum = 1'b0;
                we = 1'b1;
                mode = 2'b00;
                clr_cntr = 1'b0;
            end
        cSum: 
            begin
                clr_cntr = 1'b0;
                clr_sum = 1'b0;
                enSum = 1'b1;   
                mode = 2'b11; //waiting display
            end
        cSumFin: 
            begin
                fin = 1'b1;
                clr_sum = 1'b0;
                clr_cntr = 1'b0;
                enSum = 1'b0; 
                mode = 2'b11; //waiting display
            end
        dSum: 
            begin 
                fin = 1'b0;
                clr_sum = 1'b0;
                clr_cntr = 1'b0;
                enSum = 1'b0;
                mode = 2'b01; // csum display
            end
        dCounter: 
            begin 
                clr_cntr = 1'b0;
                mode = 2'b10; //counter display
            end
        clearCounter: 
            begin
                clr_cntr = 1'b1;
                mode = 2'b00;
            end
    endcase
    
    assign rAddr = addrReg;
    
endmodule

