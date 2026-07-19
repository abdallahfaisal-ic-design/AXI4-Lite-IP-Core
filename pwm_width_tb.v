
`timescale 1ns / 1ps



module pwm_width_tb;

    reg clk, rst;

    reg [7:0] duty;

    wire pwm_out;


    pwm_width #(.WIDTH(8), .PRESCALE_MAX(5)) uut (

        .clk(clk), .rst(rst), .duty(duty), .pwm_out(pwm_out)

    );



    always #5 clk = ~clk;



    initial begin

        clk = 0; rst = 1; duty = 0;

        #15 rst = 0;

        


        duty = 8'd64; 

        $display("[TB] Setting PWM Duty Cycle to 25%%");

        #3000;

        

      

        duty = 8'd192; 

        $display("[TB] Setting PWM Duty Cycle to 75%%");

        #3000;

        

        $finish;

    end

endmodule

