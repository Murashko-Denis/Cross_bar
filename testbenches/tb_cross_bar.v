`timescale 1 ns/ 100 ps
module tb_cross_bar();
reg [31:0] addr0;
reg [31:0] addr1;
reg clk;
reg cmd0;
reg cmd1;
reg req0;
reg req1;
reg reset;
wire slv0_ack;
wire [31:0] slv0_rdata;
wire slv1_ack;
wire [31:0] slv1_rdata;
reg [31:0] wdata0;
reg [31:0] wdata1;
// wires                                               
wire ack0;
wire ack1;
wire [31:0] rdata0;
wire [31:0] rdata1;
wire [31:0] slv0_addr;
wire slv0_cmd;
wire slv0_req;
wire [31:0]  slv0_wdata;
wire [31:0]  slv1_addr;
wire slv1_cmd;
wire slv1_req;
wire [31:0]  slv1_wdata;
                
cross_bar i1 (
// port map - connection between master ports and signals/registers   
	.ack0(ack0),
	.ack1(ack1),
	.addr0(addr0),
	.addr1(addr1),
	.clk(clk),
	.cmd0(cmd0),
	.cmd1(cmd1),
	.rdata0(rdata0),
	.rdata1(rdata1),
	.req0(req0),
	.req1(req1),
	.reset(reset),
	.slv0_ack(slv0_ack),
	.slv0_addr(slv0_addr),
	.slv0_cmd(slv0_cmd),
	.slv0_rdata(slv0_rdata),
	.slv0_req(slv0_req),
	.slv0_wdata(slv0_wdata),
	.slv1_ack(slv1_ack),
	.slv1_addr(slv1_addr),
	.slv1_cmd(slv1_cmd),
	.slv1_rdata(slv1_rdata),
	.slv1_req(slv1_req),
	.slv1_wdata(slv1_wdata),
	.wdata0(wdata0),
	.wdata1(wdata1)
);	

slave slave0(
	.clk(clk),
	.reset(reset),
	.req(slv0_req),
	.addr(slv0_addr),
	.cmd(slv0_cmd),
	.wdata(slv0_wdata),
	.ack(slv0_ack),
	.rdata_tr(slv0_rdata)
);
slave slave1(
	.clk(clk),
	.reset(reset),
	.req(slv1_req),
	.addr(slv1_addr),
	.cmd(slv1_cmd),
	.wdata(slv1_wdata),
	.ack(slv1_ack),
	.rdata_tr(slv1_rdata)
);
initial begin  
$display("Running testbench");                                                
clk=1'b0;
cmd0=1'b1;
cmd1=1'b1;
req0=1'b1;
req1=1'b1;
addr0=32'h00001000;
addr1=32'hA0000000;
wdata0=32'h11111111;
wdata1=32'h22222222;
reset=1'b1;

forever #5 clk=!clk; 
end  
                                                        
/*initial begin                                                                                                 
forever #120 addr0=~addr0;
end
initial begin                                                                                                 
forever #120 addr1=~addr1;
end
initial begin
forever #30 cmd0=!cmd0;
end
initial begin
forever #60 cmd1=!cmd1;
end
initial begin
forever #10 req0=!req0;
end
initial begin
forever #20 req1=!req1; 
end*/
//master0
always@(posedge clk,posedge reset)
begin
if (reset) begin
	req0 <= 1'b1;
	addr0 <=32'hA0001000;
	cmd0 <= 1'b0;
	wdata0 <= 32'h11111111;
	
end
else if (ack0) begin
	req0 <= 1'b1;
	cmd0 <= !cmd0;
	addr0 <= addr0+32'h80000001;
	if (!cmd0)
		wdata0 <= wdata0+32'h00000001;
	end
else begin
	req0 <= 1'b1;
	addr0 <= addr0;
	cmd0 <= cmd0;
	wdata0 <= wdata0;
	end
end

//master1
always@(posedge clk,posedge reset)
begin
if (reset) begin
	req1 <= 1'b1;
	cmd1 <= 1'b1;
	addr1 <= 32'h00000100;
	wdata1 <= 32'h22222222;
end
else if (ack1) begin
	req1 <= 1'b1;
	addr1 <= addr1+32'hA0000001;
	cmd1 <= !cmd1;
	if (!cmd1)
		wdata1 <= wdata1+32'h00000001;

	end
else begin
	req1 <= 1'b1;
	addr1 <= addr1;
	cmd1<= cmd1;
	wdata1 <= wdata1;
	end
end



initial begin
#10; reset = 1'b0;
#500; 
$display("Simulation ended succesfully");
$stop;                                                   
end                                                    
endmodule

