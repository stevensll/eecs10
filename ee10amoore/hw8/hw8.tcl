
########## Tcl recorder starts at 03/04/95 14:13:42 ##########

set version "2.0"
set proj_dir "U:/slei/hw8"
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
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" DAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:13:42 ###########


########## Tcl recorder starts at 03/04/95 14:14:07 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" DAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:14:07 ###########


########## Tcl recorder starts at 03/04/95 14:17:59 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" DAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:17:59 ###########


########## Tcl recorder starts at 03/04/95 14:18:06 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" DAUDemo.abl -mod DAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:18:06 ###########


########## Tcl recorder starts at 03/04/95 14:18:09 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:18:09 ###########


########## Tcl recorder starts at 03/04/95 14:19:24 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:19:24 ###########


########## Tcl recorder starts at 03/04/95 14:19:24 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:19:24 ###########


########## Tcl recorder starts at 03/04/95 14:20:18 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:20:18 ###########


########## Tcl recorder starts at 03/04/95 14:20:18 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:20:18 ###########


########## Tcl recorder starts at 03/04/95 14:21:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:21:13 ###########


########## Tcl recorder starts at 03/04/95 14:21:13 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:21:13 ###########


########## Tcl recorder starts at 03/04/95 14:22:36 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:22:36 ###########


########## Tcl recorder starts at 03/04/95 14:22:36 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:22:37 ###########


########## Tcl recorder starts at 03/04/95 14:22:51 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:22:51 ###########


########## Tcl recorder starts at 03/04/95 14:22:52 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:22:52 ###########


########## Tcl recorder starts at 03/04/95 14:23:23 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:23:23 ###########


########## Tcl recorder starts at 03/04/95 14:23:23 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:23:23 ###########


########## Tcl recorder starts at 03/04/95 14:23:41 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:23:41 ###########


########## Tcl recorder starts at 03/04/95 14:23:42 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:23:42 ###########


########## Tcl recorder starts at 03/04/95 14:23:47 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/mblifopt\" DAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:23:47 ###########


########## Tcl recorder starts at 03/04/95 14:24:32 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw8.lct -touch hw8.imp
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

########## Tcl recorder end at 03/04/95 14:24:32 ###########


########## Tcl recorder starts at 03/04/95 14:24:39 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:24:39 ###########


########## Tcl recorder starts at 03/04/95 14:26:35 ##########

# Commands to make the Process: 
# Optimization Constraint
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw8.lct -touch hw8.imp
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

########## Tcl recorder end at 03/04/95 14:26:35 ###########


########## Tcl recorder starts at 03/04/95 14:26:46 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:26:46 ###########


########## Tcl recorder starts at 03/04/95 14:30:39 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:30:39 ###########


########## Tcl recorder starts at 03/04/95 14:30:41 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:30:41 ###########


########## Tcl recorder starts at 03/04/95 14:32:45 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:32:45 ###########


########## Tcl recorder starts at 03/04/95 14:32:46 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:32:46 ###########


########## Tcl recorder starts at 03/04/95 14:34:37 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:34:37 ###########


########## Tcl recorder starts at 03/04/95 14:34:39 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:34:39 ###########


########## Tcl recorder starts at 03/04/95 14:39:47 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:39:47 ###########


########## Tcl recorder starts at 03/04/95 14:39:48 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:39:48 ###########


########## Tcl recorder starts at 03/04/95 14:41:33 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" DAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:41:33 ###########


########## Tcl recorder starts at 03/04/95 14:41:36 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DAUDemo.abl -mod DAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:41:36 ###########


########## Tcl recorder starts at 03/04/95 14:41:55 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:41:55 ###########


########## Tcl recorder starts at 03/04/95 14:41:57 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:41:57 ###########


########## Tcl recorder starts at 03/04/95 14:44:54 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:44:54 ###########


########## Tcl recorder starts at 03/04/95 14:44:55 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:44:55 ###########


########## Tcl recorder starts at 03/04/95 14:46:19 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:46:19 ###########


########## Tcl recorder starts at 03/04/95 14:46:20 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:46:21 ###########


########## Tcl recorder starts at 03/04/95 14:48:09 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:48:09 ###########


########## Tcl recorder starts at 03/04/95 14:48:10 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:48:10 ###########


########## Tcl recorder starts at 03/04/95 14:49:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:49:13 ###########


########## Tcl recorder starts at 03/04/95 14:49:14 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:49:14 ###########


########## Tcl recorder starts at 03/04/95 14:49:38 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:49:38 ###########


########## Tcl recorder starts at 03/04/95 14:49:39 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:49:39 ###########


########## Tcl recorder starts at 03/04/95 14:51:25 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:51:25 ###########


########## Tcl recorder starts at 03/04/95 14:51:26 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:51:26 ###########


########## Tcl recorder starts at 03/04/95 14:52:23 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:52:23 ###########


########## Tcl recorder starts at 03/04/95 14:52:26 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:52:26 ###########


########## Tcl recorder starts at 03/04/95 14:59:05 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:59:05 ###########


########## Tcl recorder starts at 03/04/95 14:59:06 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:59:06 ###########


########## Tcl recorder starts at 03/04/95 14:59:17 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:59:17 ###########


########## Tcl recorder starts at 03/04/95 14:59:19 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 14:59:19 ###########


########## Tcl recorder starts at 03/04/95 15:00:37 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:00:37 ###########


########## Tcl recorder starts at 03/04/95 15:00:38 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:00:38 ###########


########## Tcl recorder starts at 03/04/95 15:04:49 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:04:49 ###########


########## Tcl recorder starts at 03/04/95 15:04:51 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:04:51 ###########


########## Tcl recorder starts at 03/04/95 15:06:04 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:06:04 ###########


########## Tcl recorder starts at 03/04/95 15:06:06 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:06:06 ###########


########## Tcl recorder starts at 03/04/95 15:09:04 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:09:04 ###########


########## Tcl recorder starts at 03/04/95 15:09:05 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:09:06 ###########


########## Tcl recorder starts at 03/04/95 15:12:28 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:12:28 ###########


########## Tcl recorder starts at 03/04/95 15:12:30 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:12:30 ###########


########## Tcl recorder starts at 03/04/95 15:35:35 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:35:35 ###########


########## Tcl recorder starts at 03/04/95 15:35:36 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:35:36 ###########


########## Tcl recorder starts at 03/04/95 15:44:25 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" DAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:44:25 ###########


########## Tcl recorder starts at 03/04/95 15:44:27 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DAUDemo.abl -mod DAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:44:27 ###########


########## Tcl recorder starts at 03/04/95 15:44:51 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:44:51 ###########


########## Tcl recorder starts at 03/04/95 15:44:53 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DAUDemo.abl -mod DAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:44:53 ###########


########## Tcl recorder starts at 03/04/95 15:51:20 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:51:20 ###########


########## Tcl recorder starts at 03/04/95 15:51:22 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:51:22 ###########


########## Tcl recorder starts at 03/04/95 15:52:43 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:52:43 ###########


########## Tcl recorder starts at 03/04/95 15:52:44 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:52:44 ###########


########## Tcl recorder starts at 03/04/95 15:54:05 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:54:05 ###########


########## Tcl recorder starts at 03/04/95 15:54:07 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:54:07 ###########


########## Tcl recorder starts at 03/04/95 15:54:19 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:54:19 ###########


########## Tcl recorder starts at 03/04/95 15:54:20 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 15:54:20 ###########


########## Tcl recorder starts at 03/04/95 16:03:50 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 16:03:50 ###########


########## Tcl recorder starts at 03/04/95 16:03:51 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" DataAccess.abl -mod DataAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" DataAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"DAUDemo.bl1\" -o \"hw8.bl2\" -omod \"hw8\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw8 -lci hw8.lct -log hw8.imp -err automake.err -tti hw8.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -blifopt hw8.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw8.bl2 -sweep -mergefb -err automake.err -o hw8.bl3 @hw8.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -diofft hw8.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw8.bl3 -family AMDMACH -idev van -o hw8.bl4 -oxrf hw8.xrf -err automake.err @hw8.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw8.lct -dev lc4k -prefit hw8.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw8.bl4 -out hw8.bl5 -err automake.err -log hw8.log -mod DAUDemo @hw8.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw8.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs1: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -nojed -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw8.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw8.rs2: $rspFile"
} else {
	puts $rspFile "-i hw8.bl5 -lci hw8.lct -d m4s_128_96 -lco hw8.lco -html_rpt -fti hw8.fti -fmt PLA -tto hw8.tt4 -eqn hw8.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw8.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw8.rs1
file delete hw8.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw8.bl5 -o hw8.tda -lci hw8.lct -dev m4s_128_96 -family lc4k -mod DAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw8 -if hw8.jed -j2s -log hw8.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 03/04/95 16:03:51 ###########

