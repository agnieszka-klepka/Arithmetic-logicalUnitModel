// liczba petli losowan danych
`define LICZBA_LOSOWAN  10

// krok czasowy symulacji
`define TIME_STEP       1

module testbench;
    parameter M=4;
    parameter N=4;

    logic [M-1:0] s_argA = '0;
    logic [M-1:0] s_argB = '0;
    logic [N-1:0] s_oper;

    // Sygnaly wyjsciowe wynikow i flag z modelu HDL  
    //   i ukladu po syntezie logicznej
    logic [M-1:0] s_result_model, s_result_synth;
    logic [3:0]   s_flags_model,  s_flags_synth;

    // Liczniki bledow i poprawnych wynikow porownan
    //   wynikow i flag
    integer liczba_bledow_wynikow = 0;
    integer liczba_bledow_flag    = 0;
    integer liczba_poprawnych_wynikow = 0;
    integer liczba_poprawnych_flag    = 0;

    // Sygnal zdarzenia - wyzwala porownywanie wynikow
    event test_results; 

    // Model exe_unit
    exe_unit#(.M(M), .N(N)) exe_unit_model (.i_argA(s_argA), 
                    .i_argB(s_argB),
                    .i_oper(s_oper),
                    .o_result(s_result_model),
                
                // Przypisz sygnal flag do odpowiednich portow
                    .o_BF0(s_flags_model[0]),
                    .o_BF1(s_flags_model[1]),
                    .o_PF(s_flags_model[2]),
                    .o_NF(s_flags_model[3]) 
    );

    // exe_unit po syntezie logicznej
    exe_unit_rtl 
        exe_unit_synth (.i_argA(s_argA),
                    .i_argB(s_argB),
                    .i_oper(s_oper),
                    .o_result(s_result_synth),
                
                // Przypisz sygnal flag do odpowiednich portow
                    .o_BF0(s_flags_synth[0]),
                    .o_BF1(s_flags_synth[1]),
                    .o_PF(s_flags_synth[2]),
                    .o_NF(s_flags_synth[3])
    );

    // blok sprawdzania zgodnosci wynikow
    always @(test_results)
    begin
        if (s_result_model !== s_result_synth)
        begin
            $display("%c[1;31mERROR%c[0m @%0ds: Bladna wartosc wyniku dla oper = %0d, argA = %0d; argB = %0d; model_result = %0d; synth_result = %0d",27,27, $time-`TIME_STEP, s_oper, s_argA, s_argB, s_result_model, s_result_synth);
            liczba_bledow_wynikow = liczba_bledow_wynikow +1;
        end
        else 
        begin
            liczba_poprawnych_wynikow = liczba_poprawnych_wynikow+1;
        end
    end

    // Blok sprawdzania zgodsnosci flag
    always @(test_results)
    begin
        if (s_flags_model !== s_flags_synth) 
        begin
            $display("%c[1;31mERROR%c[0m @%0ds: Bledna wartosc flag   dla oper = %0d, argA = %0d; argB = %0d; model_flags = %4b; synth_flags = %4b",27,27, $time-`TIME_STEP, s_oper, s_argA, s_argB, s_flags_model, s_flags_synth);
            liczba_bledow_flag = liczba_bledow_flag +1;
        end
        else 
        begin
            liczba_poprawnych_flag = liczba_poprawnych_flag +1;
        end
    end

    // Blok generacji sygnalow
    integer seed=0, count=0;
    initial 
    begin
        // Makra systemowe okreslajace gdzie zapisywane sa przebiegi 
        // sygnalolw
        $dumpfile("signals.vcd");   // Plik z sygnalami: gtkwave signals.vcd
        $dumpvars(0,testbench);    
    
        {s_oper, s_argA, s_argB, count} = '0;
        seed = 1;
    
        // Petla generacji sygnalow
        while (count < `LICZBA_LOSOWAN) 
        begin : LOT_LOOP
        
            # `TIME_STEP;     // opoznienie o 1 krok czasowy
        
            count = count + 1;
            //s_oper <= s_oper + 1;
            s_oper <= 4'b1001;                    
            s_argA <= $random(seed);     // argumenty argA i argB
            s_argB <= $random(seed);     //   sa losowo generowane
    
            // wyzwolenie porownywan
            -> test_results;

        end : LOT_LOOP

        // Miejsce na podanie innych wartosci s_oper i argA,argB
        // aby sprawdzic jakies specyficzne przypadki

        // ----------------------------------------
        // # `TIME_STEP;
        // s_oper = 4'b0000;
        // s_argA = 8'b00001000;
        // s_argB = 8'b00000001;
        // -> test_results;
                            
        // ----------------------------------------



        # `TIME_STEP;
        $display("\n---------------------------");
        $display("Koniec generacji sygnalow");
        $display("Liczba blednych wynikow: %c[1;31m  %0d %c[0m ",27, liczba_bledow_wynikow,27);
        $display("Liczba blednych flag:    %c[1;31m  %0d %c[0m ",27, liczba_bledow_flag,27);
        $display("Liczba poprawnych wynikow:%c[1;32m %0d %c[0m ",27, liczba_poprawnych_wynikow,27);
        $display("Liczba poprawnych flag:   %c[1;32m %0d %c[0m ",27, liczba_poprawnych_flag,27);
        $display("---------------------------\n");
    
        # `TIME_STEP;
        $finish; // zakonczenie symulacji

    end

endmodule