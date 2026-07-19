`timescale 1ns / 1ps



module axi_lite_master (

    // Global signals

    input wire clk, rstn,



    // --- User Logic Control Interface ---

    // Write Control

    input wire start_write,

    input wire [31:0] write_addr,

    input wire [31:0] write_data,

    output reg write_done, 

    // Read Control

    input wire start_read,

    input wire [31:0] read_addr,

    output reg [31:0] read_data_out,

    output reg read_done,



    // --- AXI-Lite Master Interface ---

    // Write Address Channel (AW)

    output reg [31:0] m_axi_awaddr,

    output reg m_axi_awvalid,

    input wire m_axi_awready,



    // Write Data Channel (W)

    output reg [31:0] m_axi_wdata,

    output reg [3:0] m_axi_wstrb,

    output reg m_axi_wvalid,

    input wire m_axi_wready,



    // Write Response Channel (B)

    input wire [1:0] m_axi_bresp,

    input wire m_axi_bvalid,

    output reg m_axi_bready,



    // Read Address Channel (AR)

    output reg [31:0] m_axi_araddr,

    output reg m_axi_arvalid,

    input wire m_axi_arready,



    // Read Data Channel (R)

    input wire [31:0] m_axi_rdata,

    input wire [1:0] m_axi_rresp,

    input wire m_axi_rvalid,

    output reg m_axi_rready

);



    // --- Write FSM Parameters & Regs ---

    parameter W_IDLE       = 2'b00;

    parameter W_SEND_ADDR  = 2'b01;

    parameter W_SEND_DATA  = 2'b10;

    parameter W_GET_RESP   = 2'b11;

    reg [1:0] w_state;



    // --- Read FSM Parameters & Regs ---

    parameter R_IDLE       = 2'b00;

    parameter R_SEND_ADDR  = 2'b01;

    parameter R_GET_DATA   = 2'b10;

    reg [1:0] r_state;



    

    always @(posedge clk or negedge rstn) begin

        if (!rstn) begin

            w_state        <= W_IDLE;

            m_axi_awaddr   <= 32'h0;

            m_axi_awvalid  <= 1'b0;

            m_axi_wdata    <= 32'h0;

            m_axi_wstrb    <= 4'b0;

            m_axi_wvalid   <= 1'b0;

            m_axi_bready   <= 1'b0;

            write_done     <= 1'b0;

        end else begin

            case (w_state)

                W_IDLE: begin

                    write_done <= 1'b0;

                    if (start_write) begin

                        m_axi_awaddr  <= write_addr;

                        m_axi_wdata   <= write_data;

                        m_axi_wstrb   <= 4'b1111;

                        m_axi_awvalid <= 1'b1;

                        w_state       <= W_SEND_ADDR;

                    end

                end

                W_SEND_ADDR: begin

                    if (m_axi_awvalid && m_axi_awready) begin

                        m_axi_awvalid <= 1'b0;

                        m_axi_wvalid  <= 1'b1;

                        w_state       <= W_SEND_DATA;

                    end

                end

                W_SEND_DATA: begin

                    if (m_axi_wvalid && m_axi_wready) begin

                        m_axi_wvalid <= 1'b0;

                        m_axi_bready <= 1'b1;

                        w_state      <= W_GET_RESP;

                    end

                end

                W_GET_RESP: begin

                    if (m_axi_bvalid && m_axi_bready) begin

                        m_axi_bready <= 1'b0;

                        write_done   <= 1'b1;

                        w_state      <= W_IDLE;

                    end

                end

                default: w_state <= W_IDLE;

            endcase

        end

    end



  

    always @(posedge clk or negedge rstn) begin

        if (!rstn) begin

            r_state        <= R_IDLE;

            m_axi_araddr   <= 32'h0;

            m_axi_arvalid  <= 1'b0;

            m_axi_rready   <= 1'b0;

            read_data_out  <= 32'h0;

            read_done      <= 1'b0;

        end else begin

            case (r_state)

                R_IDLE: begin

                    read_done <= 1'b0;

                    if (start_read) begin

                        m_axi_araddr  <= read_addr;

                        m_axi_arvalid <= 1'b1;

                        r_state       <= R_SEND_ADDR;

                    end

                end

                R_SEND_ADDR: begin

                    if (m_axi_arvalid && m_axi_arready) begin

                        m_axi_arvalid <= 1'b0;

                        m_axi_rready  <= 1'b1;

                        r_state       <= R_GET_DATA;

                    end

                end

                R_GET_DATA: begin

                    if (m_axi_rvalid && m_axi_rready) begin

                        m_axi_rready  <= 1'b0;

                        read_data_out <= m_axi_rdata;

                        read_done     <= 1'b1;

                        r_state       <= R_IDLE;

                    end

                end

                default: r_state <= R_IDLE;

            endcase

        end

    end



endmodule

