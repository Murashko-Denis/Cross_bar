module cross_bar
#(parameter N=31)//size bus address/data (N+1)
(
	input clk, 
	input reset,

	//master 0
	input req0, 
	input [N:0] addr0,
	input cmd0,
	input [N:0] wdata0,

	//master 1
	input req1,
	input [N:0] addr1,
	input cmd1,
	input [N:0] wdata1,

	//from slave0
	input slv0_ack,
	input [N:0] slv0_rdata,

	//from slave1
	input slv1_ack,
	input [N:0] slv1_rdata,

	//req to slave0
	output reg slv0_req,
	output reg [N:0] slv0_addr,
	output reg slv0_cmd,
	output reg [N:0] slv0_wdata,
	
	//req to slave1
	output reg slv1_req,
	output reg[N:0] slv1_addr,
	output reg slv1_cmd,
	output reg [N:0] slv1_wdata,

	//to master0
	output reg ack0,
	output reg [N:0] rdata0, 
	
	//to master1
	output reg ack1,
	output reg [N:0] rdata1
);

wire [1:0] arb_num_master0, arb_num_master1;

//arbiter for slave 0
arbiter #(1'b0)
	a0(clk,(reset),(req0 & (~addr0[N])), (req1 & (~addr1[N])), slv0_ack, arb_num_master0); //addr[31]=0
//arbiter for slave 1
arbiter #(1'b1)
	a1(clk,(reset),(req0 & (addr0[N])), (req1 & (addr1[N])), slv1_ack, arb_num_master1); //addr[31]=1

//saving req from masters0 and master1 - D trigger
reg req0_tr;
reg [N:0] addr0_tr;
reg cmd0_tr;
reg [N:0] wdata0_tr;
reg req1_tr;
reg [N:0] addr1_tr;
reg cmd1_tr;
reg [N:0] wdata1_tr;
always@(posedge clk,posedge reset)
begin
if (reset) begin
	req0_tr<=1'b0;
	addr0_tr<={(N+1){1'b0}};
	cmd0_tr<=1'b0;
	wdata0_tr<={(N+1){1'b0}};
	req1_tr<=1'b0;
	addr1_tr<={(N+1){1'b0}};
	cmd1_tr<=1'b0;
	wdata1_tr<={(N+1){1'b0}};
end
else begin
	req0_tr<=req0;
	addr0_tr<=addr0;
	cmd0_tr<=cmd0;
	wdata0_tr<=wdata0;
	req1_tr<=req1;
	addr1_tr<=addr1;
	cmd1_tr<=cmd1;
	wdata1_tr<=wdata1;
end
end

//choose which req's master slave have to process

always@(posedge clk, posedge reset)
begin
if (reset) begin
	//req to slave0
	slv0_req <= 1'b0;
	slv0_addr <= {(N+1){1'b0}};
	slv0_cmd <= 1'b0;
	slv0_wdata <= {(N+1){1'b0}};
	//req to slave1
	slv1_req<=1'b0;
	slv1_addr <= {(N+1){1'b0}};
	slv1_cmd <= 1'b0;
	slv1_wdata <= {(N+1){1'b0}};
	end
else begin
	//req to slave0
	slv0_req <= (arb_num_master0 == 2'b01) ? req0_tr : ((arb_num_master0 == 2'b10) ? req1_tr : 1'b0); //1'b0 - no req
	slv0_addr <= (arb_num_master0 == 2'b01) ? addr0_tr : ((arb_num_master0 == 2'b10) ? addr1_tr : slv0_addr);
	slv0_cmd <= (arb_num_master0 == 2'b01) ? cmd0_tr : ((arb_num_master0 == 2'b10) ? cmd1_tr : slv0_cmd);
	slv0_wdata <= (arb_num_master0 == 2'b01) ? wdata0_tr : ((arb_num_master0 == 2'b10) ? wdata1_tr : slv0_wdata);
	//data to slave1
	slv1_req <= (arb_num_master1 == 2'b01) ? req0_tr : ((arb_num_master1 == 2'b10) ? req1_tr : 1'b0); //1'b0 - no req
	slv1_addr <= (arb_num_master1 == 2'b01) ? addr0_tr : ((arb_num_master1 == 2'b10) ? addr1_tr : slv1_addr);
	slv1_cmd <= (arb_num_master1 == 2'b01) ? cmd0_tr : ((arb_num_master1 == 2'b10) ? cmd1_tr : slv1_cmd);
	slv1_wdata <= (arb_num_master1 == 2'b01) ? wdata0_tr : ((arb_num_master1 == 2'b10) ? wdata1_tr : slv1_wdata);
	end
end

//D trigger for save decision arbiter	(3 triggers - 1 for arbiter, 2 - ack, 3 - rdata)
reg [1:0] arb_num_master0_tr;	
reg [1:0] arb_num_master1_tr;
always@(posedge clk,posedge reset)
begin
if (reset) begin
	arb_num_master0_tr <= 2'b0;
	arb_num_master1_tr <= 2'b0;
	end
else begin
	arb_num_master0_tr<=arb_num_master0;	
	arb_num_master1_tr<=arb_num_master1;
end
end
//2nd trigger
reg [1:0] arb_num_master0_tr2;	
reg [1:0] arb_num_master1_tr2;
always@(posedge clk,posedge reset)
begin
if (reset) begin
	arb_num_master0_tr2 <= 2'b0;
	arb_num_master1_tr2 <= 2'b0;
	end
else begin
arb_num_master0_tr2<=arb_num_master0_tr;	
arb_num_master1_tr2<=arb_num_master1_tr;
end
end
//3rd trigger
reg [1:0] arb_num_master0_tr3;	
reg [1:0] arb_num_master1_tr3;
always@(posedge clk,posedge reset)
begin
if (reset) begin
	arb_num_master0_tr3 <= 2'b0;
	arb_num_master1_tr3 <= 2'b0;
	end
else begin
arb_num_master0_tr3<=arb_num_master0_tr2;	
arb_num_master1_tr3<=arb_num_master1_tr2;
end
end


//choose which slave work for which master 
//for ack
always@(posedge clk,posedge reset)
begin
if (reset) begin
	ack0 <= 1'b0;
	ack1 <= 1'b0;
	end
else begin
	ack0 <= (arb_num_master0_tr2 == 2'b01) ? slv0_ack : ((arb_num_master1_tr2 == 2'b01) ? slv1_ack : 1'b0);
	ack1 <= (arb_num_master0_tr2 == 2'b10) ? slv0_ack : ((arb_num_master1_tr2 == 2'b10) ? slv1_ack : 1'b0);
end
end

//for rdata
always@(posedge clk,posedge reset)
begin
if (reset) begin
	rdata0 <= {(N+1){1'b0}};
	rdata1 <= {(N+1){1'b0}};
	end
else begin
	rdata0 <= (arb_num_master0_tr3  == 2'b01) ? slv0_rdata : ((arb_num_master1_tr3  == 2'b01) ? slv1_rdata : rdata0);
	rdata1 <= (arb_num_master0_tr3 == 2'b10) ? slv0_rdata : ((arb_num_master1_tr3 == 2'b10) ? slv1_rdata : rdata1);
end
end
endmodule
