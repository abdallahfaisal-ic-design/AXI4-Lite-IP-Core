`timescale 1ns / 1ps



module axi_lite_top_system_tb;



    reg clk;

    reg rstn;

    

    reg start_write; reg [31:0] write_addr; reg [31:0] write_data; wire write_done;

    reg start_read;  reg [31:0] read_addr;  wire [31:0] read_data_out; wire read_done;



    wire [31:0] mem_addr_out; wire [31:0] mem_data_out;

    wire mem_write_en; wire mem_read_en;

    reg [31:0] mem_data_in;



    /    reg [31:0] mock_ram [0:255]; 



    axi_lite_top_system uut (

        .clk(clk), .rstn(rstn),

        .start_write(start_write), .write_addr(write_addr), .write_data(write_data), .write_done(write_done),

        .start_read(start_read), .read_addr(read_addr), .read_data_out(read_data_out), .read_done(read_done),

        .mem_addr_out(mem_addr_out), .mem_data_out(mem_data_out),

        .mem_write_en(mem_write_en), .mem_read_en(mem_read_en), .mem_data_in(mem_data_in)

    );



   
    always #5 clk = ~clk;




    always @(posedge clk) begin

        if (mem_write_en) begin

            mock_ram[mem_addr_out[9:2]] <= mem_data_out;

        end

    end



    always @(*) begin

        if (mem_read_en)

            mem_data_in = mock_ram[mem_addr_out[9:2]];

        else

            mem_data_in = 32'h0;

    end



    initial begin

        clk = 0; rstn = 0;

        start_write = 0; write_addr = 32'h0; write_data = 32'h0;

        start_read = 0;  read_addr = 32'h0;

        #20; rstn = 1; #20;



     

        $display("[TB] Writing 32'hAAAA_BBBB to Addr 0x10");

        @(posedge clk);

        start_write = 1; write_addr = 32'h0000_0010; write_data = 32'hAAAA_BBBB;

        @(posedge clk);

        start_write = 0;

        @(posedge write_done);

        #40;



       

        $display("[TB] Reading from Addr 0x10");

        @(posedge clk);

        start_read = 1; read_addr = 32'h0000_0010;

        @(posedge clk);

        start_read = 0;

        @(posedge read_done);



      

        if (read_data_out == 32'hAAAA_BBBB)

            $display("[SUCCESS] Simulation Passed Perfectly! Read Data: %h", read_data_out);

        else

            $display("[ERROR] Critical Mismatch! Expected: 32'hAAAA_BBBB, Got: %h", read_data_out);



        #50;

        $finish;

    end



endmodule


