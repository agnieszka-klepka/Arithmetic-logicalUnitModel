SHELL:= /bin/bash
SYNTH = yosys

rtl: 
	${SYNTH} -s run.ys | tee exe_unit.yosys.log


MODEL_FILES = ../MODEL/*.sv

RTL_FILES   = ../RTL/exe_unit_rtl.sv
TB_FILES    = ../TEST/testbench.sv

sim2: clear
	iverilog  exe_unit.iveri.run tee exe_unit.iveri.log -g2005-sv ${MODEL_FILES} ${RTL_FILES} ${TB_FILES} -o
	./exe_unit.iveri.run
	
sim: clear
	iverilog -g2005-sv ${MODEL_FILES} ${RTL_FILES} ${TB_FILES}  -o exe_unit.iveri.run |& tee exe_unit.iveri.log
	./exe_unit.iveri.run

sim3:
	iverilog -o exe_unit.iveri.run -g2005-sv ${MODEL_FILES} ${RTL_FILES} ${TB_FILES} | ./exe_unit.iveri.run >> exe_unit.iveri.log
	
clear:
	if [ -f exe_unit.iveri.run ] ; then rm exe_unit.iveri.run ; fi

wave:
	gtkwave signals.vcd &
    