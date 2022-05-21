module dekoder_priorytetowy (i_argA, o_result);

  parameter BITS=8;
  input logic[BITS-1:0] i_argA;
  output logic [BITS-1:0] o_result;

  integer i;
  logic s;
  always@(*)
  begin
      s=0;
      o_result='0;
      for(i=0;i<=BITS-1;i=i+1)
      begin
        if(i_argA[i]==1'b1 & s==0)
        begin
          o_result=BITS-i;
          s=1;
        end
      end
  end
endmodule
            
