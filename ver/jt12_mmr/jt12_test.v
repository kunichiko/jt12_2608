`timescale 1ns / 1ps

module jt12_test;

reg	rst;
reg	clk;
reg flag_A, flag_B;

wire s1_enters, s2_enters, s3_enters, s4_enters;

`include "../common/dump.vh"

initial begin
	clk = 0;
    forever #10 clk=~clk;
end


initial begin
	rst = 0;
	flag_A = 0;
	flag_B = 0;
    #5 rst = 1;
    #20 rst = 0;
 //   #(1000*1000*1000) $finish;
end
/*
always @(posedge clk)
	if( rst ) begin

	end else begin
		//
	end
*/
// PCM
wire		[7:0]	pcm;
wire				pcm_en;
`ifdef TEST_SUPPORT		
// Test
wire			test_eg;
wire			test_op0;
`endif
// REG
wire	[2:0]	block;
wire	[1:0]	rl;
wire	[2:0]	fb;
wire	[2:0]	con;
wire	[10:0]	fnum;
wire	[2:0]	pms;
wire	[1:0]	ams_VII;
wire	[2:0]	dt1_II;
wire	[3:0]	mul_V;
wire	[6:0]	tl_VII;
wire	[1:0]	ks_III;
wire	[4:0]	ar_II;
wire			amsen_VII;
wire	[4:0]	d1r_II;
wire	[4:0]	d2r_II;
wire	[3:0]	d1l;
wire	[3:0]	rr_II;
wire			ssg_en;
wire	[2:0]	ssg_eg_II;
wire			kon;
wire			koff;
//wire	[1:0]	cur_op;
wire			zero;
	
wire 	[2:0]	lfo_freq;
wire	[9:0]	value_A;
wire	[7:0]	value_B;
wire	[2:0]	alg;	

wire	cs_n, wr_n, prog_done;
wire	[7:0]	din;
wire	[1:0]	addr;

wire	[3:0]	s_hot = { s4_enters, s2_enters, s3_enters, s1_enters };

jt12_testdata #(.rand_wait(`RANDWAIT)) u_testdata(
	.rst	( rst		),
	.clk	( clk		),
	.cs_n	( cs_n		),
	.wr_n	( wr_n		),
	.dout	( din		),
	.din	( { busy, 5'd0, flag_B, flag_A } ),
	.addr	( addr		),
	.prog_done(prog_done)
);

initial begin
	$display("DUMP START");
end

always @(posedge clk) begin
	$display("%X,%X,%X,%X,%X,%X,%X,%X,%X,%X,%X,%X,%X", 
    	s_hot, dt1_II, mul_V, tl_VII, ks_III, ar_II,
    	amsen_VII, d1r_II, d2r_II, d1l, rr_II, ssg_en, ssg_eg_II );
end

always @(posedge clk) begin
	if( prog_done ) begin    	
    	#10000 
        $display("DUMP END");
        $finish;
    end
end
		

jt12_mmr u_uut(
	.rst	( rst		),
	.clk	( clk		),				// PM
	
	.din	( din		),
	.write	( ~wr_n		),
	.addr	( addr		),
	.busy	( busy		),

	// LFO
	.lfo_freq(lfo_freq),
	.lfo_en(lfo_en),
	// Timers
	.value_A(value_A),
	.value_B(value_B),
	.load_A(load_A),
	.load_B(load_B),
	.enable_irq_A(enable_irq_A),
	.enable_irq_B(enable_irq_B),
	.clr_flag_A(clr_flag_A),
	.clr_flag_B(clr_flag_B),
	.clr_run_A(clr_run_A),
	.clr_run_B(clr_run_B),
	.set_run_A(set_run_A),
	.set_run_B(set_run_B),
	.flag_A(flag_A),
	// PCM
	.pcm(pcm),
	.pcm_en(pcm_en),

	`ifdef TEST_SUPPORT		
	// Test
	.test_eg(test_eg),
	.test_op0(test_op0),
	`endif
    // Operator
	.use_prevprev1(use_prevprev1),
	.use_internal_x(use_internal_x),
	.use_internal_y(use_internal_y),	
	.use_prev2(use_prev2),
	.use_prev1(use_prev1),    
	// PG
	.fnum(fnum),
	.block( block ),	
	// REG
	.rl(rl),
	.fb(fb),
	.alg(alg),
	.pms(	pms),
	.ams_VII(ams_VII),
	.amsen_VII(amsen_VII),    
	.dt1_II(	dt1_II),
	.mul_V(	mul_V ),
	.tl_VII(	tl_VII ),

	.ar_II(	ar_II ),
	.d1r_II(	d1r_II ),
	.d2r_II(	d2r_II ),
	.rr_II(	rr_II ),
	.d1l(	d1l ),
	.ks_III(	ks_III ),
	// SSG operation
	.ssg_en(ssg_en),
	.ssg_eg_II(ssg_eg_II),
        
	.kon(kon),
	.koff(koff),

//	output	[ 1:0]	cur_op,
	// Operator
	.zero(zero),
	.s1_enters(s1_enters),
	.s2_enters(s2_enters),
	.s3_enters(s3_enters),
	.s4_enters(s4_enters)
);

endmodule