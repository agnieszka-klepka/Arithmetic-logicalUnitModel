module crc4check (i_data, i_poly, o_crc);
    parameter WCODE = 4;
    input logic [WCODE-1:0] i_data;
    input logic [1:0] i_poly;
    output logic [3:0] o_crc;

    logic [4:0] s_poly;
    logic [3:0] s_crc;

    localparam LEN = WCODE+4;

    logic [LEN-1:0] crc_tmp;
    logic [LEN-1:0] poly_tmp;
    integer i;
    always_comb
    begin
        s_poly = i_poly[8:4];
        s_crc = i_poly[3:0];

        {o_crc, crc_tmp, poly_tmp} = '0;

        crc_tmp = {i_data, s_crc};
        poly_tmp = {s_poly, {(WCODE-1){1'b0}}};

        for(i=WCODE-1; i >= 0; i--)
        begin
            if (i_data[i] == 1'b1)
            begin 
                crc_tmp = crc_tmp ^ poly_tmp;
            end
        poly_tmp = poly_tmp >> 1;
        end
        o_crc = {{(WCODE-5){1'b0}}, crc_tmp[3:0]};
    end
endmodule