/* Generated by Yosys 0.10.0 (git sha1 UNKNOWN, clang 12.0.0 -fPIC -Os) */

module crc4_check(i_data, i_poly, o_crc);
  wire [7:0] crc_tmp;
  wire [31:0] i;
  input [3:0] i_data;
  input [1:0] i_poly;
  output [3:0] o_crc;
  wire [7:0] poly_tmp;
  wire [3:0] s_crc;
  wire [4:0] s_poly;
  assign crc_tmp = { i_data, 2'hx, i_poly };
  assign i = 32'd4294967295;
  assign o_crc = { 2'hx, i_poly };
  assign poly_tmp = 8'h0x;
  assign s_crc = { 2'hx, i_poly };
  assign s_poly = 5'hxx;
endmodule

module crc_4(i_data, i_poly, i_crc, o_crc);
  wire _0_;
  wire _1_;
  wire _2_;
  wire _3_;
  wire [7:0] crc_tmp;
  wire [31:0] i;
  input [1:0] i_crc;
  input [4:0] i_data;
  input [3:0] i_poly;
  output [1:0] o_crc;
  wire [2:0] poly_tmp;
  assign _0_ = i_poly[0] ^ i_crc[0];
  assign o_crc[0] = i_data[0] ? _0_ : i_crc[0];
  assign _1_ = i_poly[0] ^ i_crc[1];
  assign _2_ = i_data[1] ? _1_ : i_crc[1];
  assign _3_ = _2_ ^ i_poly[1];
  assign o_crc[1] = i_data[0] ? _3_ : _2_;
  assign crc_tmp = { 6'hxx, o_crc };
  assign i = 32'd4294967295;
  assign poly_tmp = i_poly[3:1];
endmodule

module u1intou2(i_argA, o_result);
  input [1:0] i_argA;
  output [1:0] o_result;
  assign o_result[0] = i_argA[1] | i_argA[0];
  assign o_result[1] = 1'h0;
endmodule
