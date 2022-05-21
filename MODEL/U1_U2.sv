module u1intou2 (i_argA,
                o_result);

parameter BITS = 2;
input logic signed [BITS-1:0] i_argA;
output logic signed [BITS-1:0] o_result;

always @(*)
    begin 
        if(i_argA[BITS-1] == 0)
        begin
            o_result = i_argA;
        end
        else   
        begin
            o_result = (i_argA >> 1);
        end
    end
endmodule
