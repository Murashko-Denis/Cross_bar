//1 arbiter for each slave
module arbiter
#(parameter N=31,NUM=1'b0)//size buffer queue
(
	input clk, 
	input reset,
	//from master 0
	input req0, 
	//from master 1
	input req1,
	input ack,
	
	output reg [1:0] from_num_master //0 - master0, 1 - master1
	//output reg haveReq
);

reg [1:0] state;
parameter Idle=0, Master0=2'b01, Master1=2'b10;
reg [1:0] last_num_master;
always@(posedge clk, posedge reset)
begin
	if(reset) begin
		state<=Idle;
		//haveReq<=1'b0;
	end
	else
		case(state)
			Idle: begin case ({req0,req1})
				2'b00: state <= Idle;
				2'b01: state <= Master1;
				2'b10: state <= Master0; 
				//2'b11: begin state <= Master1; end//haveReq<=1'b1; end
				2'b11: state <= (last_num_master) ? Master0 : Master1;   //change master 
				endcase
				end
				
			Master0: begin case ({req0,req1})
				2'b00: state <= Idle;
				2'b01: state <= Master1;
				2'b10: state <= Master0;
				2'b11: begin if (ack)
						state <= Master1;
						else state <= Master0;//todo
			
						end
				endcase
				end
				
			Master1: begin case ({req0,req1})
				2'b00: state <= Idle;
				2'b01: state <= Master1;
				2'b10: state <= Master0;
				2'b11: begin if (ack)
						state <= Master0;
						else state<=Master1;//todo if in master1 and req 11 - we stay in master1 
						//if from_num_master - use it
						end
				endcase
				end
		endcase
end

always@(state)
begin
	case(state)
		Idle: from_num_master = 2'b0;
		Master0: from_num_master = 2'b01;
		Master1: from_num_master = 2'b10;  
		default: from_num_master = 2'b00;
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
