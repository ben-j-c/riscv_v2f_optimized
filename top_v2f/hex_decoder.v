module hex_decoder(
	data,
	en,
	seg_a,
	seg_b,
	seg_c,
	seg_d,
	seg_e,
	seg_f,
	seg_g
);
	input [3:0] data;
	input en;
	output seg_a;
	output seg_b;
	output seg_c;
	output seg_d;
	output seg_e;
	output seg_f;
	output seg_g;

	reg [6:0] seg;

	assign seg_a = seg[6];
	assign seg_b = seg[5];
	assign seg_c = seg[4];
	assign seg_d = seg[3];
	assign seg_e = seg[2];
	assign seg_f = seg[1];
	assign seg_g = seg[0];

	always @(*) begin
		if (en) begin
			case (data)
				4'h0: seg <= 0b1111110;
				4'h1: seg <= 0b0110000;
				4'h2: seg <= 0b1101101;
				4'h3: seg <= 0b1111001;
				4'h4: seg <= 0b0110011;
				4'h5: seg <= 0b1011011;
				4'h6: seg <= 0b1011111;
				4'h7: seg <= 0b1110000;
				4'h8: seg <= 0b1111111;
				4'h9: seg <= 0b1110011;
				4'hA: seg <= 0b1110111;
				4'hb: seg <= 0b0011111;
				4'hc: seg <= 0b0001101;
				4'hd: seg <= 0b0111101;
				4'hE: seg <= 0b1001111;
				4'hF: seg <= 0b1000111;
			endcase
		end else begin
			seg_a <= 0;
			seg_b <= 0;
			seg_c <= 0;
			seg_d <= 0;
			seg_e <= 0;
			seg_f <= 0;
			seg_g <= 0;
		end
	end
endmodule