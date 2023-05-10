
########## Tcl recorder starts at 02/27/20 21:14:22 ##########

set version "2.0"
set proj_dir "U:/slei/hw7"
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
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:14:22 ###########


########## Tcl recorder starts at 02/27/20 21:15:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:15:01 ###########


########## Tcl recorder starts at 02/27/20 21:17:31 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:17:31 ###########


########## Tcl recorder starts at 02/27/20 21:17:32 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -mod ALUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:17:32 ###########


########## Tcl recorder starts at 02/27/20 21:18:36 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:18:36 ###########


########## Tcl recorder starts at 02/27/20 21:18:41 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:18:41 ###########


########## Tcl recorder starts at 02/27/20 21:19:22 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:19:22 ###########


########## Tcl recorder starts at 02/27/20 21:19:22 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:19:22 ###########


########## Tcl recorder starts at 02/27/20 21:19:54 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:19:54 ###########


########## Tcl recorder starts at 02/27/20 21:19:54 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:19:54 ###########


########## Tcl recorder starts at 02/27/20 21:20:12 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:20:12 ###########


########## Tcl recorder starts at 02/27/20 21:20:13 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:20:13 ###########


########## Tcl recorder starts at 02/27/20 21:21:25 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:21:25 ###########


########## Tcl recorder starts at 02/27/20 21:21:26 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:21:26 ###########


########## Tcl recorder starts at 02/27/20 21:23:56 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:23:56 ###########


########## Tcl recorder starts at 02/27/20 21:23:57 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:23:57 ###########


########## Tcl recorder starts at 02/27/20 21:24:25 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:24:25 ###########


########## Tcl recorder starts at 02/27/20 21:24:26 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:24:26 ###########


########## Tcl recorder starts at 02/27/20 21:25:04 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:25:04 ###########


########## Tcl recorder starts at 02/27/20 21:25:04 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:25:05 ###########


########## Tcl recorder starts at 02/27/20 21:26:02 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:26:02 ###########


########## Tcl recorder starts at 02/27/20 21:26:03 ##########

# Commands to make the Process: 
# Pre-Fit Equations
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -mod ALUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/blif2eqn\" hw7.bl5 -o hw7.eq2 -use_short -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:26:03 ###########


########## Tcl recorder starts at 02/27/20 21:26:10 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:26:10 ###########


########## Tcl recorder starts at 02/27/20 21:29:04 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:29:04 ###########


########## Tcl recorder starts at 02/27/20 21:29:05 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:29:05 ###########


########## Tcl recorder starts at 02/27/20 21:29:46 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw7.lct -touch hw7.imp
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/optedit\" @opt_cmd.rs2"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:29:46 ###########


########## Tcl recorder starts at 02/27/20 21:29:55 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:29:55 ###########


########## Tcl recorder starts at 02/27/20 21:37:55 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:37:55 ###########


########## Tcl recorder starts at 02/27/20 21:37:56 ##########

# Commands to make the Process: 
# Constraint Editor
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/blifstat\" -i hw7.bl5 -o hw7.sif"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
# Application to view the Process: 
# Constraint Editor
if [catch {open lattice_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file lattice_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-nodal -src hw7.bl5 -type BLIF -presrc hw7.bl3 -crf hw7.crf -sif hw7.sif -devfile \"$install_dir/ispcpld/dat/lc4k/m4s_128_96.dev\" -lci hw7.lct
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lciedit\" @lattice_cmd.rs2"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:37:56 ###########


########## Tcl recorder starts at 02/27/20 21:38:05 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:38:05 ###########


########## Tcl recorder starts at 02/27/20 21:42:15 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:42:15 ###########


########## Tcl recorder starts at 02/27/20 21:42:17 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/20 21:42:17 ###########


########## Tcl recorder starts at 02/27/13 17:43:27 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/13 17:43:27 ###########


########## Tcl recorder starts at 02/27/13 17:43:28 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/13 17:43:28 ###########


########## Tcl recorder starts at 02/27/13 17:46:27 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/13 17:46:27 ###########


########## Tcl recorder starts at 02/27/13 17:46:29 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -mod ALUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/13 17:46:29 ###########


########## Tcl recorder starts at 02/27/13 17:49:15 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/13 17:49:15 ###########


########## Tcl recorder starts at 02/27/13 17:49:16 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/13 17:49:16 ###########


########## Tcl recorder starts at 02/27/13 17:49:58 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/13 17:49:58 ###########


########## Tcl recorder starts at 02/27/13 17:49:59 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/13 17:49:59 ###########


########## Tcl recorder starts at 02/27/07 22:18:20 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:18:20 ###########


########## Tcl recorder starts at 02/27/07 22:18:21 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:18:21 ###########


########## Tcl recorder starts at 02/27/07 22:26:32 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:26:32 ###########


########## Tcl recorder starts at 02/27/07 22:26:33 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:26:33 ###########


########## Tcl recorder starts at 02/27/07 22:28:00 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:28:00 ###########


########## Tcl recorder starts at 02/27/07 22:28:01 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:28:01 ###########


########## Tcl recorder starts at 02/27/07 22:29:55 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:29:55 ###########


########## Tcl recorder starts at 02/27/07 22:29:57 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:29:57 ###########


########## Tcl recorder starts at 02/27/07 22:30:35 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:30:35 ###########


########## Tcl recorder starts at 02/27/07 22:30:36 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:30:36 ###########


########## Tcl recorder starts at 02/27/07 22:33:17 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:33:17 ###########


########## Tcl recorder starts at 02/27/07 22:33:18 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:33:18 ###########


########## Tcl recorder starts at 02/27/07 22:35:32 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:35:32 ###########


########## Tcl recorder starts at 02/27/07 22:35:33 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:35:33 ###########


########## Tcl recorder starts at 02/27/07 22:39:42 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:39:42 ###########


########## Tcl recorder starts at 02/27/07 22:39:43 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:39:43 ###########


########## Tcl recorder starts at 02/27/07 22:41:37 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:41:37 ###########


########## Tcl recorder starts at 02/27/07 22:41:38 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:41:38 ###########


########## Tcl recorder starts at 02/27/07 22:41:58 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:41:58 ###########


########## Tcl recorder starts at 02/27/07 22:42:14 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:42:14 ###########


########## Tcl recorder starts at 02/27/07 22:42:15 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:42:15 ###########


########## Tcl recorder starts at 02/27/07 22:43:03 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:43:03 ###########


########## Tcl recorder starts at 02/27/07 22:43:04 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:43:04 ###########


########## Tcl recorder starts at 02/27/07 22:44:11 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:44:11 ###########


########## Tcl recorder starts at 02/27/07 22:44:13 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:44:13 ###########


########## Tcl recorder starts at 02/27/07 22:46:33 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:46:33 ###########


########## Tcl recorder starts at 02/27/07 22:46:34 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:46:34 ###########


########## Tcl recorder starts at 02/27/07 22:47:29 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:47:29 ###########


########## Tcl recorder starts at 02/27/07 22:47:30 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 22:47:30 ###########


########## Tcl recorder starts at 02/27/07 23:16:35 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 23:16:35 ###########


########## Tcl recorder starts at 02/27/07 23:16:36 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/27/07 23:16:36 ###########


########## Tcl recorder starts at 02/28/07 01:51:38 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 01:51:38 ###########


########## Tcl recorder starts at 02/28/07 01:51:40 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -mod ALUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 01:51:40 ###########


########## Tcl recorder starts at 02/28/07 01:54:04 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 01:54:04 ###########


########## Tcl recorder starts at 02/28/07 01:54:06 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -mod ALUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 01:54:06 ###########


########## Tcl recorder starts at 02/28/07 01:55:22 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 01:55:22 ###########


########## Tcl recorder starts at 02/28/07 01:55:23 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -mod ALUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 01:55:23 ###########


########## Tcl recorder starts at 02/28/07 01:55:45 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 01:55:45 ###########


########## Tcl recorder starts at 02/28/07 01:55:46 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 01:55:46 ###########


########## Tcl recorder starts at 02/28/07 01:56:40 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 01:56:40 ###########


########## Tcl recorder starts at 02/28/07 01:56:41 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 01:56:41 ###########


########## Tcl recorder starts at 02/28/07 01:59:25 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 01:59:25 ###########


########## Tcl recorder starts at 02/28/07 01:59:26 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 01:59:26 ###########


########## Tcl recorder starts at 02/28/07 02:00:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 02:00:01 ###########


########## Tcl recorder starts at 02/28/07 02:00:03 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 02:00:03 ###########


########## Tcl recorder starts at 02/28/07 02:01:30 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 02:01:30 ###########


########## Tcl recorder starts at 02/28/07 02:01:32 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 02:01:32 ###########


########## Tcl recorder starts at 02/28/07 02:02:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 02:02:01 ###########


########## Tcl recorder starts at 02/28/07 02:02:02 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 02:02:02 ###########


########## Tcl recorder starts at 02/28/07 02:02:28 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw7.lct -touch hw7.imp
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/optedit\" @opt_cmd.rs2"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 02:02:28 ###########


########## Tcl recorder starts at 02/28/07 02:02:40 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 02:02:40 ###########


########## Tcl recorder starts at 02/28/07 02:04:29 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 02:04:29 ###########


########## Tcl recorder starts at 02/28/07 02:04:30 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 02:04:30 ###########


########## Tcl recorder starts at 02/28/07 02:05:34 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 02:05:34 ###########


########## Tcl recorder starts at 02/28/07 02:05:35 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -mod ALUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 02:05:35 ###########


########## Tcl recorder starts at 02/28/07 02:08:47 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 02:08:47 ###########


########## Tcl recorder starts at 02/28/07 02:08:48 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 02:08:48 ###########


########## Tcl recorder starts at 02/28/07 23:32:48 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:32:48 ###########


########## Tcl recorder starts at 02/28/07 23:32:57 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:32:57 ###########


########## Tcl recorder starts at 02/28/07 23:33:27 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -mod ALUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:33:27 ###########


########## Tcl recorder starts at 02/28/07 23:34:22 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:34:22 ###########


########## Tcl recorder starts at 02/28/07 23:34:22 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:34:22 ###########


########## Tcl recorder starts at 02/28/07 23:35:48 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:35:48 ###########


########## Tcl recorder starts at 02/28/07 23:35:49 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:35:49 ###########


########## Tcl recorder starts at 02/28/07 23:36:00 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:36:00 ###########


########## Tcl recorder starts at 02/28/07 23:36:00 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:36:00 ###########


########## Tcl recorder starts at 02/28/07 23:36:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:36:13 ###########


########## Tcl recorder starts at 02/28/07 23:36:14 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:36:14 ###########


########## Tcl recorder starts at 02/28/07 23:36:26 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -mod ALUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:36:26 ###########


########## Tcl recorder starts at 02/28/07 23:37:39 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:37:39 ###########


########## Tcl recorder starts at 02/28/07 23:37:41 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:37:41 ###########


########## Tcl recorder starts at 02/28/07 23:39:22 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw7.lct -touch hw7.imp
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/optedit\" @opt_cmd.rs2"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:39:22 ###########


########## Tcl recorder starts at 02/28/07 23:39:31 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:39:31 ###########


########## Tcl recorder starts at 02/28/07 23:46:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:46:13 ###########


########## Tcl recorder starts at 02/28/07 23:46:16 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -mod ALUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:46:16 ###########


########## Tcl recorder starts at 02/28/07 23:46:44 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:46:44 ###########


########## Tcl recorder starts at 02/28/07 23:46:45 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:46:45 ###########


########## Tcl recorder starts at 02/28/07 23:57:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:57:01 ###########


########## Tcl recorder starts at 02/28/07 23:57:04 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:57:04 ###########


########## Tcl recorder starts at 02/28/07 23:57:25 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:57:25 ###########


########## Tcl recorder starts at 02/28/07 23:57:26 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/28/07 23:57:26 ###########


########## Tcl recorder starts at 03/01/07 00:14:43 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:14:43 ###########


########## Tcl recorder starts at 03/01/07 00:14:44 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:14:44 ###########


########## Tcl recorder starts at 03/01/07 00:15:39 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:15:39 ###########


########## Tcl recorder starts at 03/01/07 00:15:40 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:15:40 ###########


########## Tcl recorder starts at 03/01/07 00:16:09 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:16:09 ###########


########## Tcl recorder starts at 03/01/07 00:16:10 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:16:11 ###########


########## Tcl recorder starts at 03/01/07 00:18:32 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:18:32 ###########


########## Tcl recorder starts at 03/01/07 00:18:34 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:18:34 ###########


########## Tcl recorder starts at 03/01/07 00:20:30 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:20:30 ###########


########## Tcl recorder starts at 03/01/07 00:20:31 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:20:31 ###########


########## Tcl recorder starts at 03/01/07 00:27:59 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:27:59 ###########


########## Tcl recorder starts at 03/01/07 00:28:00 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -mod ALUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:28:00 ###########


########## Tcl recorder starts at 03/01/07 00:28:22 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:28:22 ###########


########## Tcl recorder starts at 03/01/07 00:28:24 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -mod ALUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:28:24 ###########


########## Tcl recorder starts at 03/01/07 00:29:06 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:29:06 ###########


########## Tcl recorder starts at 03/01/07 00:29:07 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -mod ALUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:29:07 ###########


########## Tcl recorder starts at 03/01/07 00:35:33 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:35:33 ###########


########## Tcl recorder starts at 03/01/07 00:35:34 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:35:34 ###########


########## Tcl recorder starts at 03/01/07 00:53:14 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:53:14 ###########


########## Tcl recorder starts at 03/01/07 00:53:15 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:53:15 ###########


########## Tcl recorder starts at 03/01/07 00:53:37 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:53:37 ###########


########## Tcl recorder starts at 03/01/07 00:53:38 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 00:53:38 ###########


########## Tcl recorder starts at 03/01/07 01:31:04 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 01:31:04 ###########


########## Tcl recorder starts at 03/01/07 01:31:05 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 01:31:05 ###########


########## Tcl recorder starts at 03/01/07 01:33:46 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 01:33:46 ###########


########## Tcl recorder starts at 03/01/07 01:33:47 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 01:33:47 ###########


########## Tcl recorder starts at 03/01/07 01:39:23 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 01:39:23 ###########


########## Tcl recorder starts at 03/01/07 01:39:25 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 01:39:25 ###########


########## Tcl recorder starts at 03/01/07 01:40:02 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 01:40:03 ###########


########## Tcl recorder starts at 03/01/07 01:40:04 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 01:40:04 ###########


########## Tcl recorder starts at 03/01/07 01:44:17 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 01:44:17 ###########


########## Tcl recorder starts at 03/01/07 01:44:19 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 01:44:19 ###########


########## Tcl recorder starts at 03/01/07 01:53:31 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 01:53:31 ###########


########## Tcl recorder starts at 03/01/07 01:53:32 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 01:53:32 ###########


########## Tcl recorder starts at 03/01/07 01:54:42 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 01:54:42 ###########


########## Tcl recorder starts at 03/01/07 01:54:43 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 01:54:43 ###########


########## Tcl recorder starts at 03/01/07 02:29:51 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 02:29:51 ###########


########## Tcl recorder starts at 03/01/07 02:29:52 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 02:29:52 ###########


########## Tcl recorder starts at 03/01/07 02:30:35 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 02:30:35 ###########


########## Tcl recorder starts at 03/01/07 02:30:37 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 02:30:37 ###########


########## Tcl recorder starts at 03/01/07 03:00:25 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 03:00:25 ###########


########## Tcl recorder starts at 03/01/07 03:00:27 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -mod ALUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 03:00:27 ###########


########## Tcl recorder starts at 03/01/07 03:01:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 03:01:13 ###########


########## Tcl recorder starts at 03/01/07 03:01:14 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -mod ALUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 03:01:14 ###########


########## Tcl recorder starts at 03/01/07 03:01:47 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 03:01:47 ###########


########## Tcl recorder starts at 03/01/07 03:01:49 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 03:01:49 ###########


########## Tcl recorder starts at 03/01/07 03:18:57 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 03:18:57 ###########


########## Tcl recorder starts at 03/01/07 03:18:58 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 03:18:58 ###########


########## Tcl recorder starts at 03/01/07 03:26:45 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 03:26:45 ###########


########## Tcl recorder starts at 03/01/07 03:26:46 ##########

# Commands to make the Process: 
# Constraint Editor
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/blifstat\" -i hw7.bl5 -o hw7.sif"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
# Application to view the Process: 
# Constraint Editor
if [catch {open lattice_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file lattice_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-nodal -src hw7.bl5 -type BLIF -presrc hw7.bl3 -crf hw7.crf -sif hw7.sif -devfile \"$install_dir/ispcpld/dat/lc4k/m4s_128_96.dev\" -lci hw7.lct
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lciedit\" @lattice_cmd.rs2"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 03:26:46 ###########


########## Tcl recorder starts at 03/01/07 03:26:58 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 03:26:59 ###########


########## Tcl recorder starts at 03/01/07 03:45:31 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 03:45:31 ###########


########## Tcl recorder starts at 03/01/07 03:45:33 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 03:45:33 ###########


########## Tcl recorder starts at 03/01/07 03:48:29 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 03:48:29 ###########


########## Tcl recorder starts at 03/01/07 03:48:31 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 03:48:31 ###########


########## Tcl recorder starts at 03/01/07 13:35:35 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 13:35:35 ###########


########## Tcl recorder starts at 03/01/07 13:35:36 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 13:35:36 ###########


########## Tcl recorder starts at 03/01/07 13:37:15 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 13:37:15 ###########


########## Tcl recorder starts at 03/01/07 13:37:16 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 13:37:16 ###########


########## Tcl recorder starts at 03/01/07 14:40:47 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 14:40:47 ###########


########## Tcl recorder starts at 03/01/07 14:41:13 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -mod ALUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 14:41:13 ###########


########## Tcl recorder starts at 03/01/07 14:41:46 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 14:41:46 ###########


########## Tcl recorder starts at 03/01/07 14:41:47 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 14:41:47 ###########


########## Tcl recorder starts at 03/01/07 14:42:14 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 14:42:14 ###########


########## Tcl recorder starts at 03/01/07 14:42:16 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 14:42:16 ###########


########## Tcl recorder starts at 03/01/07 14:56:33 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 14:56:33 ###########


########## Tcl recorder starts at 03/01/07 14:56:35 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -mod ALUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 14:56:35 ###########


########## Tcl recorder starts at 03/01/07 15:00:28 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 15:00:28 ###########


########## Tcl recorder starts at 03/01/07 15:00:29 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -mod ALUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 15:00:29 ###########


########## Tcl recorder starts at 03/01/07 15:00:49 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 15:00:49 ###########


########## Tcl recorder starts at 03/01/07 15:00:50 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -mod ALUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 15:00:50 ###########


########## Tcl recorder starts at 03/01/07 15:36:56 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 15:36:56 ###########


########## Tcl recorder starts at 03/01/07 15:36:58 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -mod ALUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ALUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"ALUDemo.bl1\" -o \"hw7.bl2\" -omod \"hw7\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw7 -lci hw7.lct -log hw7.imp -err automake.err -tti hw7.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -blifopt hw7.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw7.bl2 -sweep -mergefb -err automake.err -o hw7.bl3 @hw7.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -diofft hw7.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw7.bl3 -family AMDMACH -idev van -o hw7.bl4 -oxrf hw7.xrf -err automake.err @hw7.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw7.lct -dev lc4k -prefit hw7.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw7.bl4 -out hw7.bl5 -err automake.err -log hw7.log -mod ALUDemo @hw7.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw7.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs1: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -nojed -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw7.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw7.rs2: $rspFile"
} else {
	puts $rspFile "-i hw7.bl5 -lci hw7.lct -d m4s_128_96 -lco hw7.lco -html_rpt -fti hw7.fti -fmt PLA -tto hw7.tt4 -eqn hw7.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw7.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw7.rs1
file delete hw7.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw7.bl5 -o hw7.tda -lci hw7.lct -dev m4s_128_96 -family lc4k -mod ALUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw7 -if hw7.jed -j2s -log hw7.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/01/07 15:36:58 ###########


########## Tcl recorder starts at 03/12/12 17:49:02 ##########

# Commands to make the Process: 
# Check Syntax
if [runCmd "\"$cpld_bin/ahdl2blf\" ALU.abl -mod ALU -syn  -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/12/12 17:49:02 ###########


########## Tcl recorder starts at 03/12/12 17:49:29 ##########

# Commands to make the Process: 
# Check Syntax
if [runCmd "\"$cpld_bin/ahdl2blf\" ALUDemo.abl -mod ALUDemo -syn  -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/12/12 17:49:29 ###########

