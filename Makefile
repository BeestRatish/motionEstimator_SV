# Makefile for SystemVerilog Project

RTL = ./top.sv ./accumulator.sv
SVTB = ./top_tb.sv
INTERFACE = ./top_interface.sv
DRIVER = ./driver.sv
ENVIRONMENT = ./environment.sv
GENERATOR = ./generator.sv
MONITOR = ./monitor.sv
SCOREBOARD = ./scoreboard.sv
SEED = 1

default: test 

test: compile run

run:
	./simv -l simv.log +ntb_random_seed=$(SEED)

compile:
	vcs -l vcs.log -sverilog -debug_all -full64 \
	$(SVTB) $(RTL) $(INTERFACE) $(DRIVER) $(ENVIRONMENT) $(GENERATOR) $(MONITOR) $(SCOREBOARD)

dve:
	dve -vpd vcdplus.vpd &

debug:
	./simv -l simv.log -gui -tbug +ntb_random_seed=$(SEED)

solution: clean
	cp ../../solutions/project/*.sv .

clean:
	rm -rf simv* csrc* *.tmp *.vpd *.key *.log *hdrs.h

nuke: clean
	rm -rf *.v* *.sv include .*.lock .*.old DVE* *.tcl *.h
	cp .orig/* .

help:
	@echo ==========================================================================
	@echo  " 								       "
	@echo  " USAGE: make target <SEED=xxx>                                         "
	@echo  " 								       "
	@echo  " ------------------------- Test TARGETS ------------------------------ "
	@echo  " test       => Compile TB and DUT files, runs the simulation.          "
	@echo  " compile    => Compile the TB, DUT, and interface.                     "
	@echo  " run        => Run the simulation.                                     "
	@echo  " dve        => Run dve in post-processing mode                         "
	@echo  " debug      => Runs simulation interactively with dve                  "
	@echo  " clean      => Remove all intermediate simv and log files.             "
	@echo  "                                                                       "
	@echo  " -------------------- ADMINISTRATIVE TARGETS ------------------------- "
	@echo  " help       => Displays this message.                                  "
	@echo  " solution   => Copies all files from solutions directory               "
	@echo  " nuke       => Erase all changes. Put all files back to original state "
	@echo  "								       "
	@echo ==========================================================================
