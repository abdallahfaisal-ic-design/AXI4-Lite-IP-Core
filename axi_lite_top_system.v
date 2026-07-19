
`timescale 1ns / 1ps



module axi_lite_top_system (

    input wire clk, rstn,

    

    

    input wire start_write,

    input wire [31:0] write_addr,

    input wire [31:0] write_data,

    output wire write_done, 

    

 

    input wire start_read,

    input wire [31:0] read_addr,

    output wire [31:0] read_data_out,

    output wire read_done,

    

 
    output wire [31:0] mem_addr_out,

    output wire [31:0] mem_data_out,

    output wire mem_write_en,

    output wire mem_read_en,

    input wire [31:0] mem_data_in

);



    

    wire [31:0] axi_awaddr; wire axi_awvalid; wire axi_awready;

    wire [31:0] axi_wdata; wire [3:0] axi_wstrb; wire axi_wvalid; wire axi_wready;

    wire [1:0]  axi_bresp; wire axi_bvalid; wire axi_bready;

    wire [31:0] axi_araddr; wire axi_arvalid; wire axi_arready;

    wire [31:0] axi_rdata; wire [1:0] axi_rresp; wire axi_rvalid; wire axi_rready;




    axi_lite_master master_inst (

        .clk(clk), .rstn(rstn),

        .start_write(start_write), .write_addr(write_addr), .write_data(write_data), .write_done(write_done),

        .start_read(start_read), .read_addr(read_addr), .read_data_out(read_data_out), .read_done(read_done),

        

        .m_axi_awaddr(axi_awaddr), .m_axi_awvalid(axi_awvalid), .m_axi_awready(axi_awready),

        .m_axi_wdata(axi_wdata), .m_axi_wstrb(axi_wstrb), .m_axi_wvalid(axi_wvalid), .m_axi_wready(axi_wready),

        .m_axi_bresp(axi_bresp), .m_axi_bvalid(axi_bvalid), .m_axi_bready(axi_bready),

        .m_axi_araddr(axi_araddr), .m_axi_arvalid(axi_arvalid), .m_axi_arready(axi_arready),

        .m_axi_rdata(axi_rdata), .m_axi_rresp(axi_rresp), .m_axi_rvalid(axi_rvalid), .m_axi_rready(axi_rready)

    );



  
    axi_lite_full_slave slave_inst (

        .clk(clk), .rstn(rstn),

        .s_axi_awaddr(axi_awaddr), .s_axi_awvalid(axi_awvalid), .s_axi_awready(axi_awready),

        .s_axi_wdata(axi_wdata), .s_axi_wstrb(axi_wstrb), .s_axi_wvalid(axi_wvalid), .s_axi_wready(axi_wready),

        .s_axi_bresp(axi_bresp), .s_axi_bvalid(axi_bvalid), .s_axi_bready(axi_bready),

        .s_axi_araddr(axi_araddr), .s_axi_arvalid(axi_arvalid), .s_axi_arready(axi_arready),

        .s_axi_rdata(axi_rdata), .s_axi_rresp(axi_rresp), .s_axi_rvalid(axi_rvalid), .s_axi_rready(axi_rready),

        

        .mem_addr_out(mem_addr_out), .mem_data_out(mem_data_out),

        .mem_write_en(mem_write_en), .mem_read_en(mem_read_en), .mem_data_in(mem_data_in)

    );



endmodule

