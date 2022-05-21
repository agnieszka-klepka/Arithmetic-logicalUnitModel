module exe_unit(i_argA, 
                i_argB, 
                i_oper, 
                o_PF, 
                o_NF,
                o_BF0,
                o_BF1, 
                o_result);
   
    parameter M = 8;
    parameter N = 4;

    input logic signed [M-1:0] i_argA;
    input logic signed [M-1:0] i_argB;
    input logic [N-1:0]        i_oper;
    output logic [M-1:0]       o_result;
    output logic               o_PF, o_NF, o_BF1, o_BF0;

    logic [M-1:0] s_u1intou2, s_dekoder_term, s_counting1, s_crc4_check, s_crc4, s_dekoder_prioryt;


    
    u1intou2# (.BITS(M)) u1intou2(.i_argA(i_argA), .o_result(s_u1intou2));
    decoder_therm# (.LEN(M)) decoder_therm(.i_argA(i_argA), .o_result(s_dekoder_term));
    zliczanie1# (.BITS(M)) zliczanie1(.i_argA(i_argA), .i_argB(i_argB) ,.o_result(s_counting1));
    crc4check# (.WCODE(M)) crc4check(.i_data({i_argB[4], i_argB[3], i_argB[2], i_argB[1], i_argB[0]}), .i_poly(i_argA), .o_crc(s_crc4_check));
    crc_eval# (.WCODE(M), .WPOLY(N)) crc_4(.i_data(i_argA), .i_poly({i_argB[4], i_argB[3], i_argB[2], i_argB[1], i_argB[0]}), .i_crc({i_argB[4], i_argB[3], i_argB[2], i_argB[1], i_argB[0]}), .o_crc(s_crc4));
    dekoder_priorytetowy# (.BITS(M)) dekoder_priorytetowy(.i_argA(i_argA), .o_result(s_dekoder_prioryt));
    

    integer ones;
    integer zeros;
    integer i = 0;

    always @(*) begin: main
        o_PF=0;
        o_NF=0;
        o_BF1=0; 
        o_BF0=0;

        case(i_oper)
            4'b0000: o_result = i_argA + i_argB;        
            4'b0001: o_result = (i_argA | i_argB);
            4'b0010: o_result = ~ (i_argA | i_argB);
            4'b0011: o_result = (i_argA << i_argB);     //logiczne
            4'b0100: o_result = (i_argA <<< i_argB);    //arytmetyczne
            4'b0101: o_result = i_argA ^ (i_argA >> 1);
            4'b0110: o_result = s_u1intou2;
            4'b0111: o_result = s_dekoder_term;
            4'b1000: o_result = s_counting1;
            4'b1001: o_result = s_crc4_check;
            4'b1010: o_result = s_crc4;
            4'b1011: o_result = s_dekoder_prioryt;

            default o_result = '0;
        endcase

        o_PF = ^o_result;   //xoruje o_result -> jezeli jest nieparzysta liczba jedynek -> wynik jest równy 1 -> uzupełnia 1; jezeli jest wynik xor jest 0 -> jest parzysta liczba
        o_NF = ~(^o_result);
    
        
        
        ones = 0;
        //ZNACZNIK BF1
        for (i=1; i<M; i=i+1)
        begin
            if (o_result[i] == 1)
            begin
                ones = ones + 1;
            end
        end
        if(ones == 1)
        begin
            o_BF1 = 1'b1;
        end
        else 
        begin
            o_BF1 = '0; 
        end


        zeros = 0;
        //ZNACZNIK BF0
        for (i=1; i<M; i=i+1)
        begin
            if (o_result[i] == 0)
            begin
                zeros = zeros + 1;
            end
        end
        if(zeros == 1)
        begin
            o_BF0 = 1'b1;
        end
        else 
        begin
            o_BF0 = '0;
        end
    
    end
endmodule
