module decoder_therm(i_argA, o_result);
    parameter LEN = 2;
    localparam BITS = $clog2(LEN);
    input logic  [LEN-1:0] i_argA;
    output logic [LEN-1:0] o_result;
    
    integer i;
    always @(*)
    begin
        o_result = '0;
        for ( i=0; i < LEN; i=i+1)
            if (i_argA[i] == 1'b1)
                o_result = i;
        
    end
endmodule
