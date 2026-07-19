
`timescale 1ns / 1ps



module axi_lite_full_slave (

    input wire clk, rstn,



    // (AW) Write Address Channel

    input wire [31:0] s_axi_awaddr,

    input wire s_axi_awvalid,

    output reg s_axi_awready,



    // (W) Write Data Channel

    input wire [31:0] s_axi_wdata,

    input wire [3:0] s_axi_wstrb,

    input wire s_axi_wvalid,

    output reg s_axi_wready,



    // (B) Write Response Channel

    output reg [1:0] s_axi_bresp,

    output reg s_axi_bvalid,

    input wire s_axi_bready,



    // (AR) Read Address Channel

    input wire [31:0] s_axi_araddr,

    input wire s_axi_arvalid,

    output reg s_axi_arready,



    // (R) Read Data Channel

    output reg [31:0] s_axi_rdata,

    output reg [1:0] s_axi_rresp,

    output reg s_axi_rvalid,

    input wire s_axi_rready,



   

    output reg [31:0] mem_addr_out,

    output reg [31:0] mem_data_out,

    output reg mem_write_en,

    output reg mem_read_en,

    input wire [31:0] mem_data_in

);



    parameter W_IDLE       = 2'b00;

    parameter W_RX_DATA    = 2'b01;

    parameter W_WRITE_MEM  = 2'b10;

    parameter W_SEND_RESP  = 2'b11;



    parameter R_IDLE       = 2'b00;

    parameter R_READ_MEM   = 2'b01;

    parameter R_SEND_DATA  = 2'b10;



    reg [1:0] w_state;

    reg [1:0] r_state;

    reg [31:0] reg_awaddr;

    reg [31:0] reg_araddr;

    reg [31:0] reg_wdata;



    // --- Write FSM Engine ---

    always @(posedge clk or negedge rstn) begin

        if (!rstn) begin

            w_state        <= W_IDLE;

            s_axi_awready  <= 1'b0;

            s_axi_wready   <= 1'b0;

            s_axi_bvalid   <= 1'b0;

            s_axi_bresp    <= 2'b00;

            mem_write_en   <= 1'b0;

            mem_addr_out   <= 32'h0;

            mem_data_out   <= 32'h0;

            reg_awaddr     <= 32'h0;

            reg_wdata      <= 32'h0;

        end else begin

            case (w_state)

                W_IDLE: begin

                    mem_write_en  <= 1'b0;

                    s_axi_awready <= 1'b1;

                    if (s_axi_awvalid && s_axi_awready) begin

                        reg_awaddr    <= s_axi_awaddr;

                        s_axi_awready <= 1'b0;

                        s_axi_wready  <= 1'b1;

                        w_state       <= W_RX_DATA;

                    end

                end

                W_RX_DATA: begin

                    if (s_axi_wvalid && s_axi_wready) begin

                        reg_wdata    <= s_axi_wdata;

                        s_axi_wready <= 1'b0;

                        w_state      <= W_WRITE_MEM;

                    end

                end

                W_WRITE_MEM: begin

                    mem_addr_out <= reg_awaddr; 

                    mem_data_out <= reg_wdata;

                    mem_write_en <= 1'b1;

                    s_axi_bvalid <= 1'b1;

                    s_axi_bresp  <= 2'b00; 

                    w_state      <= W_SEND_RESP;

                end

                W_SEND_RESP: begin

                   

                    if (s_axi_bvalid && s_axi_bready) begin

                        mem_write_en <= 1'b0;

                        s_axi_bvalid <= 1'b0;

                        w_state      <= W_IDLE;

                    end

                end

                default: w_state <= W_IDLE;

            endcase

        end

    end



    // --- Read FSM Engine ---

    always @(posedge clk or negedge rstn) begin

        if (!rstn) begin

            r_state       <= R_IDLE;

            s_axi_arready <= 1'b0;

            s_axi_rresp   <= 2'b00;

            s_axi_rvalid  <= 1'b0;

            mem_read_en   <= 1'b0;

            reg_araddr    <= 32'h0;

            s_axi_rdata   <= 32'h0;

        end else begin

            case (r_state)

                R_IDLE: begin

                    mem_read_en   <= 1'b0;

                    s_axi_arready <= 1'b1;

                    if (s_axi_arvalid && s_axi_arready) begin

                        reg_araddr    <= s_axi_araddr;

                        s_axi_arready <= 1'b0;

                        mem_addr_out  <= s_axi_araddr; 

                        mem_read_en   <= 1'b1;

                        r_state       <= R_READ_MEM;

                    end

                end

                R_READ_MEM: begin

                    s_axi_rdata  <= mem_data_in;

                    s_axi_rvalid <= 1'b1;

                    r_state      <= R_SEND_DATA;

                end

                R_SEND_DATA: begin

                    if (s_axi_rvalid && s_axi_rready) begin

                        mem_read_en  <= 1'b0;

                        s_axi_rvalid <= 1'b0;

                        r_state      <= R_IDLE;

                    end

                end

                default: r_state <= R_IDLE;

            endcase

        end

    end



endmodule

