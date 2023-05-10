
########## Tcl recorder starts at 01/21/23 23:39:45 ##########

set version "2.0"
set proj_dir "U:/slei"
cd $proj_dir

# Get directory paths
set pver $version
regsub -all {\.} $pver {_} pver
set lscfile "lsc_"
append lscfile $pver ".ini"
set lsvini_dir [lindex [array get env LSC_INI_PATH] 1]
set lsvini_path [file join $lsvini_dir $lscfile]
if {[catch {set fid [open $lsvini_path]} msg]} {
	 puts "File Open Error: $lsvini_path"
	 return false
} else {set data [read $fid]; close $fid }
foreach line [split $data '\n'] { 
	set lline [string tolower $line]
	set lline [string trim $lline]
	if {[string compare $lline "\[paths\]"] == 0} { set path 1; continue}
	if {$path && [regexp {^\[} $lline]} {set path 0; break}
	if {$path && [regexp {^bin} $lline]} {set cpld_bin $line; continue}
	if {$path && [regexp {^fpgapath} $lline]} {set fpga_dir $line; continue}
	if {$path && [regexp {^fpgabinpath} $lline]} {set fpga_bin $line}}

set cpld_bin [string range $cpld_bin [expr [string first "=" $cpld_bin]+1] end]
regsub -all "\"" $cpld_bin "" cpld_bin
set cpld_bin [file join $cpld_bin]
set install_dir [string range $cpld_bin 0 [expr [string first "ispcpld" $cpld_bin]-2]]
regsub -all "\"" $install_dir "" install_dir
set install_dir [file join $install_dir]
set fpga_dir [string range $fpga_dir [expr [string first "=" $fpga_dir]+1] end]
regsub -all "\"" $fpga_dir "" fpga_dir
set fpga_dir [file join $fpga_dir]
set fpga_bin [string range $fpga_bin [expr [string first "=" $fpga_bin]+1] end]
regsub -all "\"" $fpga_bin "" fpga_bin
set fpga_bin [file join $fpga_bin]

if {[string match "*$fpga_bin;*" $env(PATH)] == 0 } {
   set env(PATH) "$fpga_bin;$env(PATH)" }

if {[string match "*$cpld_bin;*" $env(PATH)] == 0 } {
   set env(PATH) "$cpld_bin;$env(PATH)" }

lappend auto_path [file join $install_dir "ispcpld" "tcltk" "lib" "ispwidget" "runproc"]
package require runcmd

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/23 23:39:45 ###########


########## Tcl recorder starts at 01/21/23 23:40:09 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/23 23:40:09 ###########


########## Tcl recorder starts at 01/21/23 23:40:09 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/23 23:40:09 ###########


########## Tcl recorder starts at 01/21/23 23:40:11 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/23 23:40:11 ###########


########## Tcl recorder starts at 01/21/19 15:43:56 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 15:43:56 ###########


########## Tcl recorder starts at 01/21/19 15:43:57 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 15:43:57 ###########


########## Tcl recorder starts at 01/21/19 15:43:58 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 15:43:58 ###########


########## Tcl recorder starts at 01/21/19 15:44:08 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 15:44:08 ###########


########## Tcl recorder starts at 01/21/19 15:44:08 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 15:44:08 ###########


########## Tcl recorder starts at 01/21/19 15:44:09 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 15:44:09 ###########


########## Tcl recorder starts at 01/21/19 15:44:25 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 15:44:25 ###########


########## Tcl recorder starts at 01/21/19 15:44:25 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 15:44:25 ###########


########## Tcl recorder starts at 01/21/19 15:44:27 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 15:44:27 ###########


########## Tcl recorder starts at 01/21/19 15:46:53 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 15:46:53 ###########


########## Tcl recorder starts at 01/21/19 15:47:20 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 15:47:20 ###########


########## Tcl recorder starts at 01/21/19 15:48:28 ##########

# Commands to make the Process: 
# Pre-Fit Equations
if [runCmd "\"$cpld_bin/blif2eqn\" counter.bl5 -o counter.eq2 -use_short -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 15:48:28 ###########


########## Tcl recorder starts at 01/21/19 15:49:22 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 15:49:22 ###########


########## Tcl recorder starts at 01/21/19 15:49:30 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 15:49:30 ###########


########## Tcl recorder starts at 01/21/19 15:55:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 15:55:01 ###########


########## Tcl recorder starts at 01/21/19 15:55:07 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 15:55:07 ###########


########## Tcl recorder starts at 01/21/19 15:59:23 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 15:59:23 ###########


########## Tcl recorder starts at 01/21/19 15:59:35 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 15:59:35 ###########


########## Tcl recorder starts at 01/21/19 15:59:55 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 15:59:55 ###########


########## Tcl recorder starts at 01/21/19 15:59:58 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 15:59:58 ###########


########## Tcl recorder starts at 01/21/19 16:00:29 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 16:00:29 ###########


########## Tcl recorder starts at 01/21/19 16:00:33 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 16:00:33 ###########


########## Tcl recorder starts at 01/21/19 16:05:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 16:05:02 ###########


########## Tcl recorder starts at 01/21/19 16:05:05 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 16:05:05 ###########


########## Tcl recorder starts at 01/21/19 16:06:55 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 16:06:55 ###########


########## Tcl recorder starts at 01/21/19 16:07:04 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 16:07:04 ###########


########## Tcl recorder starts at 01/21/19 16:07:18 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 16:07:18 ###########


########## Tcl recorder starts at 01/21/19 16:07:21 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 16:07:21 ###########


########## Tcl recorder starts at 01/21/19 16:07:23 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 16:07:23 ###########


########## Tcl recorder starts at 01/21/19 16:08:20 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 16:08:20 ###########


########## Tcl recorder starts at 01/21/19 16:08:22 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 16:08:22 ###########


########## Tcl recorder starts at 01/21/19 16:09:19 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 16:09:19 ###########


########## Tcl recorder starts at 01/21/19 16:09:21 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 16:09:21 ###########


########## Tcl recorder starts at 01/21/19 16:10:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 16:10:13 ###########


########## Tcl recorder starts at 01/21/19 16:10:16 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 16:10:16 ###########


########## Tcl recorder starts at 01/21/19 16:11:22 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 16:11:22 ###########


########## Tcl recorder starts at 01/21/19 16:11:34 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 16:11:34 ###########


########## Tcl recorder starts at 01/21/19 17:24:26 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 17:24:26 ###########


########## Tcl recorder starts at 01/21/19 17:24:31 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 17:24:31 ###########


########## Tcl recorder starts at 01/21/19 17:27:09 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 17:27:09 ###########


########## Tcl recorder starts at 01/21/19 17:27:54 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 17:27:54 ###########


########## Tcl recorder starts at 01/21/19 17:30:38 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 17:30:38 ###########


########## Tcl recorder starts at 01/21/19 17:30:54 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 17:30:54 ###########


########## Tcl recorder starts at 01/21/19 17:30:57 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 17:30:57 ###########


########## Tcl recorder starts at 01/21/19 17:31:07 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 17:31:07 ###########


########## Tcl recorder starts at 01/21/19 17:31:13 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 17:31:13 ###########


########## Tcl recorder starts at 01/21/19 18:01:56 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:01:56 ###########


########## Tcl recorder starts at 01/21/19 18:01:59 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:01:59 ###########


########## Tcl recorder starts at 01/21/19 18:03:22 ##########

# Commands to make the Process: 
# Check Syntax
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -syn  -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:03:22 ###########


########## Tcl recorder starts at 01/21/19 18:06:44 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:06:44 ###########


########## Tcl recorder starts at 01/21/19 18:06:46 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:06:46 ###########


########## Tcl recorder starts at 01/21/19 18:15:16 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:15:16 ###########


########## Tcl recorder starts at 01/21/19 18:41:49 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:41:49 ###########


########## Tcl recorder starts at 01/21/19 18:41:53 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:41:53 ###########


########## Tcl recorder starts at 01/21/19 18:42:08 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:42:08 ###########


########## Tcl recorder starts at 01/21/19 18:42:11 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:42:11 ###########


########## Tcl recorder starts at 01/21/19 18:42:13 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:42:13 ###########


########## Tcl recorder starts at 01/21/19 18:44:34 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:44:34 ###########


########## Tcl recorder starts at 01/21/19 18:44:37 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:44:37 ###########


########## Tcl recorder starts at 01/21/19 18:45:12 ##########

# Commands to make the Process: 
# Check Syntax
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -syn  -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:45:12 ###########


########## Tcl recorder starts at 01/21/19 18:45:33 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:45:33 ###########


########## Tcl recorder starts at 01/21/19 18:47:12 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:47:12 ###########


########## Tcl recorder starts at 01/21/19 18:55:20 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:55:20 ###########


########## Tcl recorder starts at 01/21/19 18:55:23 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:55:23 ###########


########## Tcl recorder starts at 01/21/19 18:55:43 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:55:43 ###########


########## Tcl recorder starts at 01/21/19 18:55:47 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:55:47 ###########


########## Tcl recorder starts at 01/21/19 18:55:48 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:55:48 ###########


########## Tcl recorder starts at 01/21/19 18:55:59 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:55:59 ###########


########## Tcl recorder starts at 01/21/19 18:56:01 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 18:56:01 ###########


########## Tcl recorder starts at 01/21/19 19:06:50 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:06:50 ###########


########## Tcl recorder starts at 01/21/19 19:06:53 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:06:53 ###########


########## Tcl recorder starts at 01/21/19 19:08:51 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:08:51 ###########


########## Tcl recorder starts at 01/21/19 19:09:06 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:09:06 ###########


########## Tcl recorder starts at 01/21/19 19:09:09 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:09:09 ###########


########## Tcl recorder starts at 01/21/19 19:10:59 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:10:59 ###########


########## Tcl recorder starts at 01/21/19 19:11:26 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:11:26 ###########


########## Tcl recorder starts at 01/21/19 19:11:43 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:11:43 ###########


########## Tcl recorder starts at 01/21/19 19:13:10 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:13:10 ###########


########## Tcl recorder starts at 01/21/19 19:14:29 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:14:29 ###########


########## Tcl recorder starts at 01/21/19 19:14:32 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:14:32 ###########


########## Tcl recorder starts at 01/21/19 19:17:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:17:01 ###########


########## Tcl recorder starts at 01/21/19 19:17:44 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" hw2.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" deccntr.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod deccntr @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:17:44 ###########


########## Tcl recorder starts at 02/03/12 05:30:21 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" \"../CatherineZhengEE10/Set 3/addsub.abl\" -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/03/12 05:30:21 ###########


########## Tcl recorder starts at 02/03/12 05:30:28 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" \"../CatherineZhengEE10/Set 3/addsub.abl\" -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" addsub.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod addsub @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/03/12 05:30:28 ###########


########## Tcl recorder starts at 02/03/12 05:31:18 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" \"../CatherineZhengEE10/Set 3/addsub.abl\" -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/03/12 05:31:18 ###########


########## Tcl recorder starts at 02/03/12 05:32:15 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" \"../CatherineZhengEE10/Set 3/addsub.abl\" -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/03/12 05:32:15 ###########


########## Tcl recorder starts at 02/03/12 05:32:35 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" \"../CatherineZhengEE10/Set 3/addsub.abl\" -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" addsub.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod addsub @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/03/12 05:32:35 ###########


########## Tcl recorder starts at 02/03/12 05:34:21 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" \"../CatherineZhengEE10/Set 3/addsub.abl\" -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" addsub.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod addsub @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/03/12 05:34:21 ###########


########## Tcl recorder starts at 02/03/12 05:35:10 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/03/12 05:35:10 ###########


########## Tcl recorder starts at 02/03/12 05:36:03 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" \"../CatherineZhengEE10/Set 3/addsub.abl\" -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/03/12 05:36:03 ###########


########## Tcl recorder starts at 02/03/12 05:36:21 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" \"../CatherineZhengEE10/Set 3/addsub.abl\" -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" addsub.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"counter.bl2\" -omod \"counter\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj counter -lci counter.lct -log counter.imp -err automake.err -tti counter.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -blifopt counter.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" counter.bl2 -sweep -mergefb -err automake.err -o counter.bl3 @counter.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -diofft counter.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" counter.bl3 -family AMDMACH -idev van -o counter.bl4 -oxrf counter.xrf -err automake.err @counter.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci counter.lct -dev lc4k -prefit counter.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp counter.bl4 -out counter.bl5 -err automake.err -log counter.log -mod addsub @counter.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open counter.rs1 w} rspFile] {
	puts stderr "Cannot create response file counter.rs1: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -nojed -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open counter.rs2 w} rspFile] {
	puts stderr "Cannot create response file counter.rs2: $rspFile"
} else {
	puts $rspFile "-i counter.bl5 -lci counter.lct -d m4s_32_30 -lco counter.lco -html_rpt -fti counter.fti -fmt PLA -tto counter.tt4 -eqn counter.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@counter.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete counter.rs1
file delete counter.rs2
if [runCmd "\"$cpld_bin/tda\" -i counter.bl5 -o counter.tda -lci counter.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/03/12 05:36:21 ###########


########## Tcl recorder starts at 02/03/12 05:39:38 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj counter -if counter.jed -j2s -log counter.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/03/12 05:39:38 ###########

