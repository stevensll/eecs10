
########## Tcl recorder starts at 02/22/20 13:02:06 ##########

set version "2.0"
set proj_dir "U:/slei/hw6"
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
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 13:02:06 ###########


########## Tcl recorder starts at 02/22/20 13:02:48 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 13:02:48 ###########


########## Tcl recorder starts at 02/22/20 15:30:03 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:30:03 ###########


########## Tcl recorder starts at 02/22/20 15:30:05 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:30:05 ###########


########## Tcl recorder starts at 02/22/20 15:31:23 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:31:23 ###########


########## Tcl recorder starts at 02/22/20 15:31:30 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:31:30 ###########


########## Tcl recorder starts at 02/22/20 15:31:38 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:31:38 ###########


########## Tcl recorder starts at 02/22/20 15:31:58 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:31:58 ###########


########## Tcl recorder starts at 02/22/20 15:31:59 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:31:59 ###########


########## Tcl recorder starts at 02/22/20 15:32:50 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:32:50 ###########


########## Tcl recorder starts at 02/22/20 15:32:50 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:32:50 ###########


########## Tcl recorder starts at 02/22/20 15:36:41 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:36:41 ###########


########## Tcl recorder starts at 02/22/20 15:36:41 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:36:41 ###########


########## Tcl recorder starts at 02/22/20 15:39:41 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:39:41 ###########


########## Tcl recorder starts at 02/22/20 15:39:41 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:39:41 ###########


########## Tcl recorder starts at 02/22/20 15:41:26 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:41:26 ###########


########## Tcl recorder starts at 02/22/20 15:41:27 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:41:27 ###########


########## Tcl recorder starts at 02/22/20 15:41:31 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:41:31 ###########


########## Tcl recorder starts at 02/22/20 15:41:47 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:41:47 ###########


########## Tcl recorder starts at 02/22/20 15:41:49 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:41:49 ###########


########## Tcl recorder starts at 02/22/20 15:47:34 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:47:34 ###########


########## Tcl recorder starts at 02/22/20 15:47:36 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:47:36 ###########


########## Tcl recorder starts at 02/22/20 15:52:05 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:52:05 ###########


########## Tcl recorder starts at 02/22/20 15:52:06 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:52:06 ###########


########## Tcl recorder starts at 02/22/20 15:55:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:55:01 ###########


########## Tcl recorder starts at 02/22/20 15:55:02 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 15:55:02 ###########


########## Tcl recorder starts at 02/22/20 16:29:44 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:29:44 ###########


########## Tcl recorder starts at 02/22/20 16:29:45 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:29:45 ###########


########## Tcl recorder starts at 02/22/20 16:30:15 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:30:15 ###########


########## Tcl recorder starts at 02/22/20 16:30:16 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:30:16 ###########


########## Tcl recorder starts at 02/22/20 16:30:33 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:30:33 ###########


########## Tcl recorder starts at 02/22/20 16:30:34 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:30:34 ###########


########## Tcl recorder starts at 02/22/20 16:30:44 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:30:44 ###########


########## Tcl recorder starts at 02/22/20 16:32:16 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:32:16 ###########


########## Tcl recorder starts at 02/22/20 16:32:17 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:32:17 ###########


########## Tcl recorder starts at 02/22/20 16:33:58 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:33:58 ###########


########## Tcl recorder starts at 02/22/20 16:34:00 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:34:00 ###########


########## Tcl recorder starts at 02/22/20 16:34:50 ##########

# Commands to make the Process: 
# Check Syntax
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -syn  -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:34:50 ###########


########## Tcl recorder starts at 02/22/20 16:36:18 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:36:18 ###########


########## Tcl recorder starts at 02/22/20 16:36:20 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:36:20 ###########


########## Tcl recorder starts at 02/22/20 16:39:48 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:39:48 ###########


########## Tcl recorder starts at 02/22/20 16:39:49 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:39:49 ###########


########## Tcl recorder starts at 02/22/20 16:40:45 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:40:45 ###########


########## Tcl recorder starts at 02/22/20 16:40:47 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:40:47 ###########


########## Tcl recorder starts at 02/22/20 16:45:19 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:45:19 ###########


########## Tcl recorder starts at 02/22/20 16:45:21 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:45:21 ###########


########## Tcl recorder starts at 02/22/20 16:48:00 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:48:00 ###########


########## Tcl recorder starts at 02/22/20 16:48:01 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:48:01 ###########


########## Tcl recorder starts at 02/22/20 16:48:51 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:48:51 ###########


########## Tcl recorder starts at 02/22/20 16:48:52 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 16:48:53 ###########


########## Tcl recorder starts at 02/22/20 17:12:32 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:12:32 ###########


########## Tcl recorder starts at 02/22/20 17:12:33 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:12:33 ###########


########## Tcl recorder starts at 02/22/20 17:12:47 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:12:47 ###########


########## Tcl recorder starts at 02/22/20 17:12:49 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:12:49 ###########


########## Tcl recorder starts at 02/22/20 17:15:34 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:15:34 ###########


########## Tcl recorder starts at 02/22/20 17:15:35 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:15:36 ###########


########## Tcl recorder starts at 02/22/20 17:16:34 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:16:34 ###########


########## Tcl recorder starts at 02/22/20 17:16:36 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:16:36 ###########


########## Tcl recorder starts at 02/22/20 17:18:47 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:18:47 ###########


########## Tcl recorder starts at 02/22/20 17:18:49 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:18:49 ###########


########## Tcl recorder starts at 02/22/20 17:32:25 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:32:25 ###########


########## Tcl recorder starts at 02/22/20 17:32:25 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:32:25 ###########


########## Tcl recorder starts at 02/22/20 17:34:57 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:34:57 ###########


########## Tcl recorder starts at 02/22/20 17:35:00 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:35:00 ###########


########## Tcl recorder starts at 02/22/20 17:37:50 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/22/20 17:37:50 ###########


########## Tcl recorder starts at 02/22/20 17:38:02 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:38:02 ###########


########## Tcl recorder starts at 02/22/20 17:38:47 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/22/20 17:38:47 ###########


########## Tcl recorder starts at 02/22/20 17:39:01 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:39:01 ###########


########## Tcl recorder starts at 02/22/20 17:40:41 ##########

# Commands to make the Process: 
# Constraint Editor
if [runCmd "\"$cpld_bin/blifstat\" -i hw6.bl5 -o hw6.sif"] {
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
	puts $rspFile "-nodal -src hw6.bl5 -type BLIF -presrc hw6.bl3 -crf hw6.crf -sif hw6.sif -devfile \"$install_dir/ispcpld/dat/lc4k/m4s_128_96.dev\" -lci hw6.lct
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

########## Tcl recorder end at 02/22/20 17:40:41 ###########


########## Tcl recorder starts at 02/22/20 17:41:18 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/22/20 17:41:18 ###########


########## Tcl recorder starts at 02/22/20 17:42:29 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:42:29 ###########


########## Tcl recorder starts at 02/22/20 17:42:30 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:42:30 ###########


########## Tcl recorder starts at 02/22/20 17:45:23 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:45:23 ###########


########## Tcl recorder starts at 02/22/20 17:45:24 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:45:24 ###########


########## Tcl recorder starts at 02/22/20 17:46:52 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:46:52 ###########


########## Tcl recorder starts at 02/22/20 17:46:54 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 17:46:54 ###########


########## Tcl recorder starts at 02/22/20 17:47:18 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/22/20 17:47:18 ###########


########## Tcl recorder starts at 02/22/20 18:06:34 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:06:34 ###########


########## Tcl recorder starts at 02/22/20 18:06:36 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:06:36 ###########


########## Tcl recorder starts at 02/22/20 18:06:45 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:06:45 ###########


########## Tcl recorder starts at 02/22/20 18:06:47 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:06:47 ###########


########## Tcl recorder starts at 02/22/20 18:08:23 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:08:23 ###########


########## Tcl recorder starts at 02/22/20 18:08:58 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:08:58 ###########


########## Tcl recorder starts at 02/22/20 18:09:00 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:09:00 ###########


########## Tcl recorder starts at 02/22/20 18:09:23 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:09:23 ###########


########## Tcl recorder starts at 02/22/20 18:09:25 ##########

# Commands to make the Process: 
# Timing Analysis
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
# Application to view the Process: 
# Timing Analysis
if [runCmd "\"$cpld_bin/timing\" -prj \"hw6\" -tti \"hw6.tt4\" -gui -dir \"$proj_dir\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:09:25 ###########


########## Tcl recorder starts at 02/22/20 18:13:03 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:13:03 ###########


########## Tcl recorder starts at 02/22/20 18:13:04 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:13:04 ###########


########## Tcl recorder starts at 02/22/20 18:13:29 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/22/20 18:13:29 ###########


########## Tcl recorder starts at 02/22/20 18:13:37 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:13:37 ###########


########## Tcl recorder starts at 02/22/20 18:15:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:15:13 ###########


########## Tcl recorder starts at 02/22/20 18:15:15 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:15:15 ###########


########## Tcl recorder starts at 02/22/20 18:25:07 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:25:07 ###########


########## Tcl recorder starts at 02/22/20 18:25:08 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:25:08 ###########


########## Tcl recorder starts at 02/22/20 18:26:53 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:26:53 ###########


########## Tcl recorder starts at 02/22/20 18:26:55 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:26:55 ###########


########## Tcl recorder starts at 02/22/20 18:27:27 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/22/20 18:27:27 ###########


########## Tcl recorder starts at 02/22/20 18:27:55 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:27:55 ###########


########## Tcl recorder starts at 02/22/20 18:30:00 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/22/20 18:30:00 ###########


########## Tcl recorder starts at 02/22/20 18:31:37 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:31:37 ###########


########## Tcl recorder starts at 02/22/20 18:31:38 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:31:38 ###########


########## Tcl recorder starts at 02/22/20 18:32:12 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:32:12 ###########


########## Tcl recorder starts at 02/22/20 18:32:14 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:32:14 ###########


########## Tcl recorder starts at 02/22/20 18:33:39 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:33:39 ###########


########## Tcl recorder starts at 02/22/20 18:33:40 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:33:40 ###########


########## Tcl recorder starts at 02/22/20 18:33:57 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:33:57 ###########


########## Tcl recorder starts at 02/22/20 18:33:59 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:33:59 ###########


########## Tcl recorder starts at 02/22/20 18:34:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:34:13 ###########


########## Tcl recorder starts at 02/22/20 18:34:15 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:34:15 ###########


########## Tcl recorder starts at 02/22/20 18:35:26 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:35:26 ###########


########## Tcl recorder starts at 02/22/20 18:35:29 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:35:29 ###########


########## Tcl recorder starts at 02/22/20 18:36:17 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:36:17 ###########


########## Tcl recorder starts at 02/22/20 18:36:19 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:36:19 ###########


########## Tcl recorder starts at 02/22/20 18:39:16 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:39:16 ###########


########## Tcl recorder starts at 02/22/20 18:39:20 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:39:20 ###########


########## Tcl recorder starts at 02/22/20 18:40:42 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/22/20 18:40:42 ###########


########## Tcl recorder starts at 02/22/20 18:40:58 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:40:58 ###########


########## Tcl recorder starts at 02/22/20 18:41:11 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/22/20 18:41:11 ###########


########## Tcl recorder starts at 02/22/20 18:43:03 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:43:03 ###########


########## Tcl recorder starts at 02/22/20 18:43:19 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/22/20 18:43:19 ###########


########## Tcl recorder starts at 02/22/20 18:43:27 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:43:27 ###########


########## Tcl recorder starts at 02/22/20 18:45:50 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:45:50 ###########


########## Tcl recorder starts at 02/22/20 18:45:52 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:45:52 ###########


########## Tcl recorder starts at 02/22/20 18:52:06 ##########

# Commands to make the Process: 
# Optimization Constraint
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
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
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/22/20 18:52:06 ###########


########## Tcl recorder starts at 02/22/20 18:52:16 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:52:16 ###########


########## Tcl recorder starts at 02/22/20 18:53:12 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:53:12 ###########


########## Tcl recorder starts at 02/22/20 18:54:43 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:54:43 ###########


########## Tcl recorder starts at 02/22/20 18:54:45 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:54:45 ###########


########## Tcl recorder starts at 02/22/20 18:56:00 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:56:01 ###########


########## Tcl recorder starts at 02/22/20 18:56:44 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:56:44 ###########


########## Tcl recorder starts at 02/22/20 18:56:46 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:56:46 ###########


########## Tcl recorder starts at 02/22/20 18:58:16 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:58:16 ###########


########## Tcl recorder starts at 02/22/20 18:58:17 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:58:17 ###########


########## Tcl recorder starts at 02/22/20 18:58:37 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:58:37 ###########


########## Tcl recorder starts at 02/22/20 18:58:39 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 18:58:39 ###########


########## Tcl recorder starts at 02/22/20 18:58:52 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/22/20 18:58:52 ###########


########## Tcl recorder starts at 02/22/20 22:25:03 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 22:25:03 ###########


########## Tcl recorder starts at 02/22/20 22:25:04 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 22:25:04 ###########


########## Tcl recorder starts at 02/22/20 22:25:22 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 22:25:22 ###########


########## Tcl recorder starts at 02/22/20 22:25:24 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 22:25:24 ###########


########## Tcl recorder starts at 02/22/20 22:25:47 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 22:25:47 ###########


########## Tcl recorder starts at 02/22/20 22:25:48 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 22:25:48 ###########


########## Tcl recorder starts at 02/22/20 22:26:11 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 22:26:11 ###########


########## Tcl recorder starts at 02/22/20 22:26:12 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 22:26:13 ###########


########## Tcl recorder starts at 02/22/20 22:26:20 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 22:26:20 ###########


########## Tcl recorder starts at 02/22/20 22:26:21 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 22:26:21 ###########


########## Tcl recorder starts at 02/22/20 22:26:35 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/22/20 22:26:35 ###########


########## Tcl recorder starts at 02/22/20 22:26:59 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 22:26:59 ###########


########## Tcl recorder starts at 02/22/20 22:29:11 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 22:29:11 ###########


########## Tcl recorder starts at 02/22/20 22:29:11 ##########

# Commands to make the Process: 
# Optimization Constraint
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
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
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/22/20 22:29:11 ###########


########## Tcl recorder starts at 02/22/20 22:29:23 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 22:29:23 ###########


########## Tcl recorder starts at 02/22/20 22:29:54 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/22/20 22:29:54 ###########


########## Tcl recorder starts at 02/22/20 22:30:06 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 22:30:06 ###########


########## Tcl recorder starts at 02/22/20 22:33:52 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 22:33:52 ###########


########## Tcl recorder starts at 02/22/20 22:33:54 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 22:33:54 ###########


########## Tcl recorder starts at 02/22/20 22:36:34 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/22/20 22:36:34 ###########


########## Tcl recorder starts at 02/22/20 22:38:34 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 22:38:34 ###########


########## Tcl recorder starts at 02/22/20 22:38:35 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 22:38:35 ###########


########## Tcl recorder starts at 02/22/20 22:39:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 22:39:01 ###########


########## Tcl recorder starts at 02/22/20 22:39:02 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 22:39:02 ###########


########## Tcl recorder starts at 02/22/20 23:01:36 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 23:01:36 ###########


########## Tcl recorder starts at 02/22/20 23:01:37 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 23:01:37 ###########


########## Tcl recorder starts at 02/22/20 23:02:35 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 23:02:35 ###########


########## Tcl recorder starts at 02/22/20 23:02:36 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 23:02:37 ###########


########## Tcl recorder starts at 02/22/20 23:03:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 23:03:13 ###########


########## Tcl recorder starts at 02/22/20 23:03:14 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 23:03:14 ###########


########## Tcl recorder starts at 02/22/20 23:08:04 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 23:08:04 ###########


########## Tcl recorder starts at 02/22/20 23:08:05 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 23:08:05 ###########


########## Tcl recorder starts at 02/22/20 23:09:47 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 23:09:47 ###########


########## Tcl recorder starts at 02/22/20 23:09:48 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 23:09:48 ###########


########## Tcl recorder starts at 02/22/20 23:11:29 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 23:11:29 ###########


########## Tcl recorder starts at 02/22/20 23:11:30 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 23:11:30 ###########


########## Tcl recorder starts at 02/22/20 23:59:52 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/22/20 23:59:52 ###########


########## Tcl recorder starts at 02/22/20 23:59:53 ##########

# Commands to make the Process: 
# Constraint Editor
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/blifstat\" -i hw6.bl5 -o hw6.sif"] {
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
	puts $rspFile "-nodal -src hw6.bl5 -type BLIF -presrc hw6.bl3 -crf hw6.crf -sif hw6.sif -devfile \"$install_dir/ispcpld/dat/lc4k/m4s_128_96.dev\" -lci hw6.lct
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

########## Tcl recorder end at 02/22/20 23:59:53 ###########


########## Tcl recorder starts at 02/23/20 00:00:23 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:00:23 ###########


########## Tcl recorder starts at 02/23/20 00:00:24 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:00:24 ###########


########## Tcl recorder starts at 02/23/20 00:00:35 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:00:35 ###########


########## Tcl recorder starts at 02/23/20 00:00:37 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:00:37 ###########


########## Tcl recorder starts at 02/23/20 00:00:57 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:00:57 ###########


########## Tcl recorder starts at 02/23/20 00:00:58 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:00:58 ###########


########## Tcl recorder starts at 02/23/20 00:01:55 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:01:55 ###########


########## Tcl recorder starts at 02/23/20 00:01:56 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:01:56 ###########


########## Tcl recorder starts at 02/23/20 00:02:05 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:02:05 ###########


########## Tcl recorder starts at 02/23/20 00:02:07 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:02:07 ###########


########## Tcl recorder starts at 02/23/20 00:02:19 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/23/20 00:02:19 ###########


########## Tcl recorder starts at 02/23/20 00:02:37 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:02:37 ###########


########## Tcl recorder starts at 02/23/20 00:04:02 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:04:02 ###########


########## Tcl recorder starts at 02/23/20 00:04:03 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:04:03 ###########


########## Tcl recorder starts at 02/23/20 00:04:44 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/23/20 00:04:44 ###########


########## Tcl recorder starts at 02/23/20 00:05:03 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:05:03 ###########


########## Tcl recorder starts at 02/23/20 00:05:13 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:05:13 ###########


########## Tcl recorder starts at 02/23/20 00:05:19 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/23/20 00:05:19 ###########


########## Tcl recorder starts at 02/23/20 00:05:30 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:05:30 ###########


########## Tcl recorder starts at 02/23/20 00:05:56 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:05:56 ###########


########## Tcl recorder starts at 02/23/20 00:05:57 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:05:57 ###########


########## Tcl recorder starts at 02/23/20 00:07:15 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:07:15 ###########


########## Tcl recorder starts at 02/23/20 00:07:16 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:07:16 ###########


########## Tcl recorder starts at 02/23/20 00:07:28 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:07:28 ###########


########## Tcl recorder starts at 02/23/20 00:07:29 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:07:29 ###########


########## Tcl recorder starts at 02/23/20 00:07:41 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:07:41 ###########


########## Tcl recorder starts at 02/23/20 00:07:42 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:07:42 ###########


########## Tcl recorder starts at 02/23/20 00:08:58 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:08:58 ###########


########## Tcl recorder starts at 02/23/20 00:08:59 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:08:59 ###########


########## Tcl recorder starts at 02/23/20 00:10:14 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:10:14 ###########


########## Tcl recorder starts at 02/23/20 00:10:15 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:10:15 ###########


########## Tcl recorder starts at 02/23/20 00:13:36 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:13:36 ###########


########## Tcl recorder starts at 02/23/20 00:13:37 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:13:37 ###########


########## Tcl recorder starts at 02/23/20 00:23:03 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:23:03 ###########


########## Tcl recorder starts at 02/23/20 00:23:04 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:23:04 ###########


########## Tcl recorder starts at 02/23/20 00:23:24 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:23:24 ###########


########## Tcl recorder starts at 02/23/20 00:23:25 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:23:25 ###########


########## Tcl recorder starts at 02/23/20 00:24:55 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:24:55 ###########


########## Tcl recorder starts at 02/23/20 00:24:56 ##########

# Commands to make the Process: 
# Pre-Fit Equations
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/blif2eqn\" hw6.bl5 -o hw6.eq2 -use_short -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:24:56 ###########


########## Tcl recorder starts at 02/23/20 00:26:50 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:26:50 ###########


########## Tcl recorder starts at 02/23/20 00:26:51 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:26:52 ###########


########## Tcl recorder starts at 02/23/20 00:30:02 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:30:02 ###########


########## Tcl recorder starts at 02/23/20 00:30:03 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:30:03 ###########


########## Tcl recorder starts at 02/23/20 00:31:17 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:31:17 ###########


########## Tcl recorder starts at 02/23/20 00:31:18 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:31:18 ###########


########## Tcl recorder starts at 02/23/20 00:33:09 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:33:09 ###########


########## Tcl recorder starts at 02/23/20 00:33:10 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/20 00:33:10 ###########


########## Tcl recorder starts at 02/23/12 19:14:16 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 19:14:16 ###########


########## Tcl recorder starts at 02/23/12 19:14:17 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 19:14:17 ###########


########## Tcl recorder starts at 02/23/12 19:20:19 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 19:20:19 ###########


########## Tcl recorder starts at 02/23/12 19:29:56 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 19:29:56 ###########


########## Tcl recorder starts at 02/23/12 19:30:30 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 19:30:30 ###########


########## Tcl recorder starts at 02/23/12 19:34:52 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 19:34:52 ###########


########## Tcl recorder starts at 02/23/12 19:35:03 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 19:35:03 ###########


########## Tcl recorder starts at 02/23/12 19:35:22 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 19:35:22 ###########


########## Tcl recorder starts at 02/23/12 19:42:47 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 19:42:47 ###########


########## Tcl recorder starts at 02/23/12 19:43:14 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 19:43:14 ###########


########## Tcl recorder starts at 02/23/12 19:47:41 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 19:47:41 ###########


########## Tcl recorder starts at 02/23/12 19:50:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 19:50:01 ###########


########## Tcl recorder starts at 02/23/12 19:50:26 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 19:50:27 ###########


########## Tcl recorder starts at 02/23/12 19:50:36 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 19:50:36 ###########


########## Tcl recorder starts at 02/23/12 19:52:08 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 19:52:08 ###########


########## Tcl recorder starts at 02/23/12 19:52:13 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 19:52:13 ###########


########## Tcl recorder starts at 02/23/12 19:53:59 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 19:53:59 ###########


########## Tcl recorder starts at 02/23/12 19:54:03 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 19:54:03 ###########


########## Tcl recorder starts at 02/23/12 19:55:23 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 19:55:23 ###########


########## Tcl recorder starts at 02/23/12 19:55:26 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 19:55:26 ###########


########## Tcl recorder starts at 02/23/12 20:03:38 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 20:03:38 ###########


########## Tcl recorder starts at 02/23/12 20:04:04 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 20:04:04 ###########


########## Tcl recorder starts at 02/23/12 20:07:42 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 20:07:42 ###########


########## Tcl recorder starts at 02/23/12 20:07:46 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 20:07:46 ###########


########## Tcl recorder starts at 02/23/12 20:11:31 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 20:11:31 ###########


########## Tcl recorder starts at 02/23/12 20:11:34 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 20:11:34 ###########


########## Tcl recorder starts at 02/23/12 20:19:20 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/23/12 20:19:20 ###########


########## Tcl recorder starts at 02/24/11 20:05:00 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:05:00 ###########


########## Tcl recorder starts at 02/24/11 20:06:00 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:06:00 ###########


########## Tcl recorder starts at 02/24/11 20:06:24 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:06:24 ###########


########## Tcl recorder starts at 02/24/11 20:06:29 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:06:29 ###########


########## Tcl recorder starts at 02/24/11 20:06:46 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/24/11 20:06:46 ###########


########## Tcl recorder starts at 02/24/11 20:08:40 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:08:40 ###########


########## Tcl recorder starts at 02/24/11 20:08:44 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:08:44 ###########


########## Tcl recorder starts at 02/24/11 20:11:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:11:01 ###########


########## Tcl recorder starts at 02/24/11 20:11:05 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:11:05 ###########


########## Tcl recorder starts at 02/24/11 20:12:37 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:12:38 ###########


########## Tcl recorder starts at 02/24/11 20:12:43 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:12:43 ###########


########## Tcl recorder starts at 02/24/11 20:12:48 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:12:48 ###########


########## Tcl recorder starts at 02/24/11 20:12:50 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:12:50 ###########


########## Tcl recorder starts at 02/24/11 20:13:33 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:13:33 ###########


########## Tcl recorder starts at 02/24/11 20:13:35 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:13:35 ###########


########## Tcl recorder starts at 02/24/11 20:15:27 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:15:27 ###########


########## Tcl recorder starts at 02/24/11 20:15:30 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:15:30 ###########


########## Tcl recorder starts at 02/24/11 20:15:44 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:15:44 ###########


########## Tcl recorder starts at 02/24/11 20:15:46 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:15:46 ###########


########## Tcl recorder starts at 02/24/11 20:18:46 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:18:46 ###########


########## Tcl recorder starts at 02/24/11 20:19:00 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:19:00 ###########


########## Tcl recorder starts at 02/24/11 20:19:23 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:19:23 ###########


########## Tcl recorder starts at 02/24/11 20:20:35 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:20:35 ###########


########## Tcl recorder starts at 02/24/11 20:20:41 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:20:41 ###########


########## Tcl recorder starts at 02/24/11 20:20:53 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/24/11 20:20:53 ###########


########## Tcl recorder starts at 02/24/11 20:21:21 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:21:21 ###########


########## Tcl recorder starts at 02/24/11 20:22:28 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:22:28 ###########


########## Tcl recorder starts at 02/24/11 20:22:33 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:22:33 ###########


########## Tcl recorder starts at 02/24/11 20:27:56 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:27:56 ###########


########## Tcl recorder starts at 02/24/11 20:28:01 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:28:01 ###########


########## Tcl recorder starts at 02/24/11 20:30:28 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:30:28 ###########


########## Tcl recorder starts at 02/24/11 20:30:45 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:30:45 ###########


########## Tcl recorder starts at 02/24/11 20:30:50 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:30:50 ###########


########## Tcl recorder starts at 02/24/11 20:31:31 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:31:31 ###########


########## Tcl recorder starts at 02/24/11 20:31:50 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:31:50 ###########


########## Tcl recorder starts at 02/24/11 20:31:53 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:31:53 ###########


########## Tcl recorder starts at 02/24/11 20:32:29 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:32:29 ###########


########## Tcl recorder starts at 02/24/11 20:32:52 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:32:52 ###########


########## Tcl recorder starts at 02/24/11 20:32:53 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:32:53 ###########


########## Tcl recorder starts at 02/24/11 20:34:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:34:13 ###########


########## Tcl recorder starts at 02/24/11 20:34:16 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:34:16 ###########


########## Tcl recorder starts at 02/24/11 20:35:26 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:35:26 ###########


########## Tcl recorder starts at 02/24/11 20:35:27 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:35:27 ###########


########## Tcl recorder starts at 02/24/11 20:36:26 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/24/11 20:36:26 ###########


########## Tcl recorder starts at 02/24/11 20:36:45 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:36:45 ###########


########## Tcl recorder starts at 02/24/11 20:37:26 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:37:26 ###########


########## Tcl recorder starts at 02/24/11 20:39:49 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:39:49 ###########


########## Tcl recorder starts at 02/24/11 20:40:10 ##########

# Commands to make the Process: 
# Optimization Constraint
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
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
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/24/11 20:40:10 ###########


########## Tcl recorder starts at 02/24/11 20:40:28 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:40:28 ###########


########## Tcl recorder starts at 02/24/11 20:43:53 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:43:53 ###########


########## Tcl recorder starts at 02/24/11 20:45:23 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:45:23 ###########


########## Tcl recorder starts at 02/24/11 20:45:38 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:45:38 ###########


########## Tcl recorder starts at 02/24/11 20:47:01 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:47:01 ###########


########## Tcl recorder starts at 02/24/11 20:47:04 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:47:04 ###########


########## Tcl recorder starts at 02/24/11 20:47:17 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:47:17 ###########


########## Tcl recorder starts at 02/24/11 20:47:20 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:47:20 ###########


########## Tcl recorder starts at 02/24/11 20:47:26 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:47:26 ###########


########## Tcl recorder starts at 02/24/11 20:47:33 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:47:33 ###########


########## Tcl recorder starts at 02/24/11 20:47:42 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:47:42 ###########


########## Tcl recorder starts at 02/24/11 20:47:45 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:47:45 ###########


########## Tcl recorder starts at 02/24/11 20:50:16 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:50:16 ###########


########## Tcl recorder starts at 02/24/11 20:50:20 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:50:20 ###########


########## Tcl recorder starts at 02/24/11 20:52:11 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:52:11 ###########


########## Tcl recorder starts at 02/24/11 20:52:14 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:52:14 ###########


########## Tcl recorder starts at 02/24/11 20:53:12 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:53:12 ###########


########## Tcl recorder starts at 02/24/11 20:53:19 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:53:19 ###########


########## Tcl recorder starts at 02/24/11 20:53:22 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:53:22 ###########


########## Tcl recorder starts at 02/24/11 20:57:19 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/24/11 20:57:19 ###########


########## Tcl recorder starts at 02/24/11 20:57:40 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:57:40 ###########


########## Tcl recorder starts at 02/24/11 20:57:42 ##########

# Commands to make the Process: 
# Optimization Constraint
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
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
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/24/11 20:57:42 ###########


########## Tcl recorder starts at 02/24/11 20:57:52 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:57:52 ###########


########## Tcl recorder starts at 02/24/11 20:57:59 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:57:59 ###########


########## Tcl recorder starts at 02/24/11 20:58:04 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/24/11 20:58:04 ###########


########## Tcl recorder starts at 02/24/11 20:58:11 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:58:11 ###########


########## Tcl recorder starts at 02/24/11 20:58:17 ##########

# Commands to make the Process: 
# Optimization Constraint
# - none -
# Application to view the Process: 
# Optimization Constraint
if [catch {open opt_cmd.rs2 w} rspFile] {
	puts stderr "Cannot create response file opt_cmd.rs2: $rspFile"
} else {
	puts $rspFile "-global -lci hw6.lct -touch hw6.imp
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

########## Tcl recorder end at 02/24/11 20:58:17 ###########


########## Tcl recorder starts at 02/24/11 20:58:31 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 20:58:31 ###########


########## Tcl recorder starts at 02/24/11 21:06:15 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 21:06:15 ###########


########## Tcl recorder starts at 02/24/11 21:06:36 ##########

# Commands to make the Process: 
# Constraint Editor
if [runCmd "\"$cpld_bin/blifstat\" -i hw6.bl5 -o hw6.sif"] {
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
	puts $rspFile "-nodal -src hw6.bl5 -type BLIF -presrc hw6.bl3 -crf hw6.crf -sif hw6.sif -devfile \"$install_dir/ispcpld/dat/lc4k/m4s_128_96.dev\" -lci hw6.lct
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

########## Tcl recorder end at 02/24/11 21:06:36 ###########


########## Tcl recorder starts at 02/24/11 21:07:23 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 21:07:23 ###########


########## Tcl recorder starts at 02/24/11 21:07:27 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 21:07:27 ###########


########## Tcl recorder starts at 02/24/11 21:07:38 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 21:07:38 ###########


########## Tcl recorder starts at 02/24/11 21:07:41 ##########

# Commands to make the Process: 
# Constraint Editor
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/blifstat\" -i hw6.bl5 -o hw6.sif"] {
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
	puts $rspFile "-nodal -src hw6.bl5 -type BLIF -presrc hw6.bl3 -crf hw6.crf -sif hw6.sif -devfile \"$install_dir/ispcpld/dat/lc4k/m4s_128_96.dev\" -lci hw6.lct
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

########## Tcl recorder end at 02/24/11 21:07:41 ###########


########## Tcl recorder starts at 02/24/11 21:07:48 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 21:07:48 ###########


########## Tcl recorder starts at 02/24/11 21:08:22 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 21:08:22 ###########


########## Tcl recorder starts at 02/24/11 21:08:43 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 21:08:43 ###########


########## Tcl recorder starts at 02/24/11 21:09:06 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 21:09:06 ###########


########## Tcl recorder starts at 02/24/11 21:09:10 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 21:09:10 ###########


########## Tcl recorder starts at 02/24/11 21:09:58 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 21:09:58 ###########


########## Tcl recorder starts at 02/24/11 21:10:52 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 21:10:52 ###########


########## Tcl recorder starts at 02/24/11 21:11:36 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 21:11:36 ###########


########## Tcl recorder starts at 02/24/11 21:11:54 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 21:11:54 ###########


########## Tcl recorder starts at 02/24/11 21:12:20 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 21:12:20 ###########


########## Tcl recorder starts at 02/24/11 21:13:59 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/11 21:13:59 ###########


########## Tcl recorder starts at 02/24/19 21:17:03 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/19 21:17:03 ###########


########## Tcl recorder starts at 02/24/19 21:20:16 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/19 21:20:16 ###########


########## Tcl recorder starts at 02/24/19 21:20:21 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/19 21:20:21 ###########


########## Tcl recorder starts at 02/24/19 21:23:55 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/19 21:23:55 ###########


########## Tcl recorder starts at 02/24/19 21:25:37 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/19 21:25:37 ###########


########## Tcl recorder starts at 02/24/19 21:26:11 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/19 21:26:11 ###########


########## Tcl recorder starts at 02/24/19 21:27:07 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/19 21:27:07 ###########


########## Tcl recorder starts at 02/24/19 21:27:13 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/19 21:27:13 ###########


########## Tcl recorder starts at 02/24/19 21:27:34 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/19 21:27:34 ###########


########## Tcl recorder starts at 02/24/19 21:28:07 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/19 21:28:07 ###########


########## Tcl recorder starts at 02/24/19 21:28:23 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/19 21:28:23 ###########


########## Tcl recorder starts at 02/24/19 21:29:18 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/19 21:29:18 ###########


########## Tcl recorder starts at 02/24/19 21:33:03 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/19 21:33:03 ###########


########## Tcl recorder starts at 02/24/19 21:36:20 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/19 21:36:20 ###########


########## Tcl recorder starts at 02/24/19 21:36:43 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/24/19 21:36:43 ###########


########## Tcl recorder starts at 02/25/13 20:34:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 20:34:13 ###########


########## Tcl recorder starts at 02/25/13 20:34:50 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/ProgramAccess-Jabri.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 20:34:50 ###########


########## Tcl recorder starts at 02/25/13 20:36:08 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 20:36:08 ###########


########## Tcl recorder starts at 02/25/13 20:36:12 ##########

# Commands to make the Process: 
# Check Syntax
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/PAUDemo.abl -mod PAUDemo -syn  -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 20:36:12 ###########


########## Tcl recorder starts at 02/25/13 20:36:16 ##########

# Commands to make the Process: 
# Check Syntax
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/ProgramAccess-Jabri.abl -mod ProgramAccess -syn  -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 20:36:16 ###########


########## Tcl recorder starts at 02/25/13 20:36:24 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/ProgramAccess-Jabri.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 20:36:24 ###########


########## Tcl recorder starts at 02/25/13 20:39:18 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/ProgramAccess-Jabri.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 20:39:19 ###########


########## Tcl recorder starts at 02/25/13 20:39:19 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/ProgramAccess-Jabri.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 20:39:19 ###########


########## Tcl recorder starts at 02/25/13 20:39:39 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/ProgramAccess-Jabri.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 20:39:39 ###########


########## Tcl recorder starts at 02/25/13 20:40:07 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/ProgramAccess-Jabri.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 20:40:07 ###########


########## Tcl recorder starts at 02/25/13 20:40:07 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/ProgramAccess-Jabri.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 20:40:07 ###########


########## Tcl recorder starts at 02/25/13 20:40:57 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/ProgramAccess-Jabri.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 20:40:57 ###########


########## Tcl recorder starts at 02/25/13 20:40:57 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/ProgramAccess-Jabri.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 20:40:57 ###########


########## Tcl recorder starts at 02/25/13 20:41:21 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/ProgramAccess-Jabri.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 20:41:21 ###########


########## Tcl recorder starts at 02/25/13 20:41:22 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/ProgramAccess-Jabri.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 20:41:22 ###########


########## Tcl recorder starts at 02/25/13 20:42:16 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 20:42:17 ###########


########## Tcl recorder starts at 02/25/13 20:50:37 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 20:50:37 ###########


########## Tcl recorder starts at 02/25/13 20:55:53 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 20:55:53 ###########


########## Tcl recorder starts at 02/25/13 20:58:08 ##########

# Commands to make the Process: 
# Check Syntax
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/PAUDemo.abl -mod PAUDemo -syn  -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 20:58:08 ###########


########## Tcl recorder starts at 02/25/13 20:58:13 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 20:58:13 ###########


########## Tcl recorder starts at 02/25/13 21:37:08 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/ProgramAccess-Jabri.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 21:37:08 ###########


########## Tcl recorder starts at 02/25/13 21:37:10 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/ProgramAccess-Jabri.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 21:37:10 ###########


########## Tcl recorder starts at 02/25/13 21:37:27 ##########

# Commands to make the Process: 
# Check Syntax
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/ProgramAccess-Jabri.abl -mod ProgramAccess -syn  -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 21:37:27 ###########


########## Tcl recorder starts at 02/25/13 21:39:03 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/ProgramAccess-Jabri.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 21:39:03 ###########


########## Tcl recorder starts at 02/25/13 21:39:03 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 21:39:03 ###########


########## Tcl recorder starts at 02/25/13 22:14:23 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ../../jabri/hw6/ProgramAccess-Jabri.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 22:14:23 ###########


########## Tcl recorder starts at 02/25/13 22:21:41 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 22:21:41 ###########


########## Tcl recorder starts at 02/25/13 22:21:55 ##########

# Commands to make the Process: 
# JEDEC File
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/25/13 22:21:55 ###########


########## Tcl recorder starts at 02/26/12 00:19:11 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/26/12 00:19:11 ###########


########## Tcl recorder starts at 02/26/12 00:19:17 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" PAUDemo.abl -mod PAUDemo -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" PAUDemo.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/ahdl2blf\" ProgramAccess.abl -mod ProgramAccess -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" ProgramAccess.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"PAUDemo.bl1\" -o \"hw6.bl2\" -omod \"hw6\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj hw6 -lci hw6.lct -log hw6.imp -err automake.err -tti hw6.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -blifopt hw6.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" hw6.bl2 -sweep -mergefb -err automake.err -o hw6.bl3 @hw6.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -diofft hw6.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" hw6.bl3 -family AMDMACH -idev van -o hw6.bl4 -oxrf hw6.xrf -err automake.err @hw6.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci hw6.lct -dev lc4k -prefit hw6.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp hw6.bl4 -out hw6.bl5 -err automake.err -log hw6.log -mod PAUDemo @hw6.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open hw6.rs1 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs1: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -nojed -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open hw6.rs2 w} rspFile] {
	puts stderr "Cannot create response file hw6.rs2: $rspFile"
} else {
	puts $rspFile "-i hw6.bl5 -lci hw6.lct -d m4s_128_96 -lco hw6.lco -html_rpt -fti hw6.fti -fmt PLA -tto hw6.tt4 -eqn hw6.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@hw6.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete hw6.rs1
file delete hw6.rs2
if [runCmd "\"$cpld_bin/tda\" -i hw6.bl5 -o hw6.tda -lci hw6.lct -dev m4s_128_96 -family lc4k -mod PAUDemo -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj hw6 -if hw6.jed -j2s -log hw6.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/26/12 00:19:17 ###########

