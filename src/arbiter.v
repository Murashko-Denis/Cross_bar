//1 arbiter for each slave
module arbiter
#(parameter NUM=1'b0)//size buffer queue
(
	input clk, 
	input reset,
	//from master 0
	input req0, 
	//from master 1
	input req1,
	//from slave
	input ack,
	
	output reg [1:0] from_num_master //01 - master0, 10 - master1
);

reg [1:0] state;
parameter Idle=0, Master0=2'b01, Master1=2'b10;
reg [1:0] last_num_master; //to change master if 2 req 

always@(posedge clk, posedge reset)
begin
	if(reset) begin
		state<=Idle;
	end
	else
		case(state)
			Idle: begin case ({req0,req1})
				2'b00: state <= Idle;
				2'b01: state <= Master1;
				2'b10: state <= Master0; 
				2'b11: state <= (last_num_master) ? Master0 : Master1;   //change master 
				endcase
				end
				
			Master0: begin case ({req0,req1})
				2'b00: state <= Idle;
				2'b01: state <= Master1;
				2'b10: state <= Master0;
				2'b11: begin if (ack)
						state <= Master1; //processing 2nd req
						else state <= Master0; //wait ack slave
						end
				endcase
				end
				
			Master1: begin case ({req0,req1})
				2'b00: state <= Idle;
				2'b01: state <= Master1;
				2'b10: state <= Master0;
				2'b11: begin if (ack)
						state <= Master0;//processing 2nd req
						else state<=Master1;//wait ack slave
						end
				endcase
				end
		endcase
end

always@(state)
begin
	case(state)
		Idle: from_num_master = 2'b0;
		Master0: from_num_master = 2'b01; //directing req from master0
		Master1: from_num_master = 2'b10; //directing req from master1
		default: from_num_master = 2'b0;
	endcase
end

//save last state
always@(posedge clk, posedge reset)
begin
if (reset)
	last_num_master <= 2'b0;
else last_num_master <= from_num_master;
end
endmodule
