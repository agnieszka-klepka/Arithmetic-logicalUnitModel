SHELL:= /bin/bash
SYNTH = yosys

rtl: 
	${SYNTH} -s run.ys | tee exe_unit.yosys.log


MODEL_FILES = ../MODEL/*.sv
RTL_FILES   = ../RTL/exe_unit_rtl.sv
TB_FILES    = ../TEST/testbench.sv

sim: clear
	iverilog -g2005-sv ${MODEL_FILES} ${RTL_FILES} ${TB_FILES} | tee exe_unit.iveri.log
	./a.out
	
clear:
	if [ -f exe_unit.iveri.run ] ; then rm exe_unit.iveri.run ; fi

wave:
	gtkwave signals.vcd &
    