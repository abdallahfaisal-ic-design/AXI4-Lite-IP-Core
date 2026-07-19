
`timescale 1ns / 1ps



module pwm_width #(

    parameter WIDTH = 8,

    parameter PRESCALE_MAX = 100

) (

    input wire clk, rst,

    input wire [WIDTH-1:0] duty,

    output reg pwm_out

);



    reg [31:0] prescale_counter;

    reg [WIDTH-1:0] pwm_counter;



    always @(posedge clk or posedge rst) begin

        if (rst) begin

            prescale_counter <= 0;

            pwm_counter      <= 0;

            pwm_out          <= 1'b0;

        end else begin

           

            if (prescale_counter >= PRESCALE_MAX - 1) begin

                prescale_counter <= 0;

                pwm_counter      <= pwm_counter + 1;

            end else begin

                prescale_counter <= prescale_counter + 1;

            end



         

            if (pwm_counter < duty) begin

                pwm_out <= 1'b1;

            end else begin

                pwm_out <= 1'b0;

            end

        end

    end



endmodule

