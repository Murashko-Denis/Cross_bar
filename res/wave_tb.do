onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_cross_bar/clk
add wave -noupdate -radix hexadecimal /tb_cross_bar/reset
add wave -noupdate -radix hexadecimal /tb_cross_bar/addr0
add wave -noupdate -color {Orange Red} -radix hexadecimal /tb_cross_bar/addr1
add wave -noupdate -radix hexadecimal /tb_cross_bar/cmd0
add wave -noupdate -color {Orange Red} -radix hexadecimal /tb_cross_bar/cmd1
add wave -noupdate -radix hexadecimal /tb_cross_bar/req0
add wave -noupdate -color {Orange Red} -radix hexadecimal /tb_cross_bar/req1
add wave -noupdate -radix hexadecimal /tb_cross_bar/ack0
add wave -noupdate -color {Orange Red} -radix hexadecimal /tb_cross_bar/ack1
add wave -noupdate -color Green -radix hexadecimal /tb_cross_bar/rdata0
add wave -noupdate -color {Orange Red} -radix hexadecimal /tb_cross_bar/rdata1
add wave -noupdate -color Green -radix hexadecimal /tb_cross_bar/wdata0
add wave -noupdate -color Coral -radix hexadecimal /tb_cross_bar/wdata1
add wave -noupdate -color Aquamarine -radix hexadecimal /tb_cross_bar/slv0_addr
add wave -noupdate -color Aquamarine -radix hexadecimal /tb_cross_bar/slv0_cmd
add wave -noupdate -color Aquamarine -radix hexadecimal /tb_cross_bar/slv0_req
add wave -noupdate -color Aquamarine -radix hexadecimal /tb_cross_bar/slv0_wdata
add wave -noupdate -color Aquamarine -radix hexadecimal /tb_cross_bar/slv0_ack
add wave -noupdate -color Aquamarine -radix hexadecimal /tb_cross_bar/slv0_rdata
add wave -noupdate -color Gold -radix hexadecimal /tb_cross_bar/slv1_addr
add wave -noupdate -color Gold -radix hexadecimal /tb_cross_bar/slv1_cmd
add wave -noupdate -color Gold -radix hexadecimal /tb_cross_bar/slv1_req
add wave -noupdate -color Gold -radix hexadecimal /tb_cross_bar/slv1_wdata
add wave -noupdate -color Gold -radix hexadecimal /tb_cross_bar/slv1_ack
add wave -noupdate -color Gold -radix hexadecimal /tb_cross_bar/slv1_rdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {531 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 173
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {419 ns}
