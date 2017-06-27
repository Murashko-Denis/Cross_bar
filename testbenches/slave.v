module slave
(
	input clk, 
	input reset,
	
	input req,
	input [31:0] addr,
	input cmd,
	input [31:0] wdata,
	
	output reg ack,
	output reg [31:0] rdata_tr
);
reg [31:0] data;
reg [31:0] rdata;
reg [31:0] addr_;

//generator front for ack (we cant if (req) -> ack <= 1'b1)
/*reg req_tr;
always@(posedge clk, posedge reset)
begin
if (reset) begin
	req_tr <= 1'b0;
	ack <= 1'b0;
end
else begin  
req_tr <= req;
ack <= req_tr & !req;
end
end*/

always@(posedge clk, posedge reset)
begin
	if(reset) begin
		rdata <= 32'b0;
		data <= 32'b0;
		addr_ <= 32'b0;
		ack <= 1'b0;
		end
	else if (req) 
		if (addr !== addr_) begin
			addr_<=addr;
			if (cmd) begin	
				ack <= 1'b1;
				data <= wdata;
				end
			else begin
				ack <= 1'b1;
				rdata <= data;
				end
			end
		else ack <= 1'b0;
	else ack <= 1'b0;
end

//delay 1 clk rdata
always@(posedge clk, posedge reset)
begin
if (reset)
	rdata_tr<=1'b0;
else 
	rdata_tr <= rdata;
end

endmodule

