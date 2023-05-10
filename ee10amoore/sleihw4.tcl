
########## Tcl recorder starts at 02/04/12 00:10:38 ##########

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
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/12 00:10:38 ###########


########## Tcl recorder starts at 02/04/12 00:15:00 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/12 00:15:00 ###########


########## Tcl recorder starts at 02/04/12 00:15:11 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/12 00:15:11 ###########


########## Tcl recorder starts at 02/04/12 00:15:38 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/12 00:15:38 ###########


########## Tcl recorder starts at 02/04/12 00:15:41 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/12 00:15:41 ###########


########## Tcl recorder starts at 02/04/12 00:16:28 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/12 00:16:28 ###########


########## Tcl recorder starts at 02/04/12 00:16:30 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/12 00:16:30 ###########


########## Tcl recorder starts at 02/04/12 00:17:49 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/mblifopt\" addsub.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/12 00:17:49 ###########


########## Tcl recorder starts at 02/04/12 00:19:52 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/12 00:19:52 ###########


########## Tcl recorder starts at 02/04/12 00:21:06 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/12 00:21:06 ###########


########## Tcl recorder starts at 02/04/12 00:21:06 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/12 00:21:06 ###########


########## Tcl recorder starts at 02/04/12 00:28:32 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/12 00:28:32 ###########


########## Tcl recorder starts at 02/04/12 00:28:33 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/12 00:28:33 ###########


########## Tcl recorder starts at 02/04/12 00:29:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/12 00:29:13 ###########


########## Tcl recorder starts at 02/04/12 00:29:14 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/12 00:29:14 ###########


########## Tcl recorder starts at 02/04/12 00:33:10 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/12 00:33:10 ###########


########## Tcl recorder starts at 02/04/12 00:33:11 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/12 00:33:11 ###########


########## Tcl recorder starts at 02/04/12 00:43:50 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/12 00:43:50 ###########


########## Tcl recorder starts at 02/04/12 00:43:50 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/12 00:43:50 ###########


########## Tcl recorder starts at 02/04/14 00:53:55 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/14 00:53:55 ###########


########## Tcl recorder starts at 02/04/14 00:55:11 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/14 00:55:11 ###########


########## Tcl recorder starts at 02/04/14 00:55:11 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/14 00:55:11 ###########


########## Tcl recorder starts at 02/04/14 01:00:15 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/14 01:00:15 ###########


########## Tcl recorder starts at 02/04/14 01:00:15 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/14 01:00:15 ###########


########## Tcl recorder starts at 02/04/14 01:05:15 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/14 01:05:15 ###########


########## Tcl recorder starts at 02/04/14 01:05:16 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/14 01:05:16 ###########


########## Tcl recorder starts at 02/04/14 01:20:37 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/14 01:20:37 ###########


########## Tcl recorder starts at 02/04/14 01:20:38 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/14 01:20:38 ###########


########## Tcl recorder starts at 02/04/23 01:55:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/23 01:55:13 ###########


########## Tcl recorder starts at 02/04/23 01:55:14 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/23 01:55:14 ###########


########## Tcl recorder starts at 02/04/13 01:55:51 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/13 01:55:51 ###########


########## Tcl recorder starts at 02/04/12 15:10:54 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/12 15:10:54 ###########


########## Tcl recorder starts at 01/04/23 05:34:32 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/04/23 05:34:32 ###########


########## Tcl recorder starts at 02/04/10 12:56:33 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 12:56:33 ###########


########## Tcl recorder starts at 02/04/10 13:02:27 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 13:02:27 ###########


########## Tcl recorder starts at 02/04/10 13:02:33 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 13:02:33 ###########


########## Tcl recorder starts at 02/04/10 13:02:39 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 13:02:39 ###########


########## Tcl recorder starts at 02/04/10 13:02:41 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/mblifopt\" addsub.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 13:02:41 ###########


########## Tcl recorder starts at 02/04/10 13:12:15 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 13:12:15 ###########


########## Tcl recorder starts at 02/04/10 13:12:24 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 13:12:24 ###########


########## Tcl recorder starts at 02/04/10 13:27:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 13:27:13 ###########


########## Tcl recorder starts at 02/04/10 13:27:53 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 13:27:53 ###########


########## Tcl recorder starts at 02/04/10 13:28:31 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 13:28:31 ###########


########## Tcl recorder starts at 02/04/10 13:28:40 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 13:28:40 ###########


########## Tcl recorder starts at 02/04/10 13:33:42 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 13:33:42 ###########


########## Tcl recorder starts at 02/04/10 13:35:51 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 13:35:51 ###########


########## Tcl recorder starts at 02/04/10 13:37:47 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 13:37:47 ###########


########## Tcl recorder starts at 02/04/10 13:38:49 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 13:38:49 ###########


########## Tcl recorder starts at 02/04/10 13:41:08 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 13:41:08 ###########


########## Tcl recorder starts at 02/04/10 13:41:12 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 13:41:12 ###########


########## Tcl recorder starts at 02/04/10 13:42:02 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 13:42:02 ###########


########## Tcl recorder starts at 02/04/10 13:42:10 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 13:42:10 ###########


########## Tcl recorder starts at 02/04/10 13:50:04 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 13:50:04 ###########


########## Tcl recorder starts at 02/04/10 13:50:09 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 13:50:09 ###########


########## Tcl recorder starts at 02/04/10 13:56:03 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 13:56:03 ###########


########## Tcl recorder starts at 02/04/10 14:01:33 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 14:01:33 ###########


########## Tcl recorder starts at 02/04/10 14:30:15 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 14:30:15 ###########


########## Tcl recorder starts at 02/04/10 14:30:23 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 14:30:23 ###########


########## Tcl recorder starts at 02/04/10 14:42:18 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 14:42:18 ###########


########## Tcl recorder starts at 02/04/10 14:42:23 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 14:42:23 ###########


########## Tcl recorder starts at 02/04/10 14:42:38 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 14:42:38 ###########


########## Tcl recorder starts at 02/04/10 14:42:40 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 14:42:40 ###########


########## Tcl recorder starts at 02/04/10 14:42:58 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 14:42:58 ###########


########## Tcl recorder starts at 02/04/10 14:43:02 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 14:43:02 ###########


########## Tcl recorder starts at 02/04/10 14:44:39 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 14:44:39 ###########


########## Tcl recorder starts at 02/04/10 14:45:12 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 02/04/10 14:45:12 ###########


########## Tcl recorder starts at 01/07/21 17:24:06 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" addsub.abl -mod addsub -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"addsub.bl1\" -o \"sleihw4.bl2\" -omod \"sleihw4\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj sleihw4 -lci sleihw4.lct -log sleihw4.imp -err automake.err -tti sleihw4.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -blifopt sleihw4.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" sleihw4.bl2 -sweep -mergefb -err automake.err -o sleihw4.bl3 @sleihw4.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -diofft sleihw4.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" sleihw4.bl3 -family AMDMACH -idev van -o sleihw4.bl4 -oxrf sleihw4.xrf -err automake.err @sleihw4.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci sleihw4.lct -dev lc4k -prefit sleihw4.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp sleihw4.bl4 -out sleihw4.bl5 -err automake.err -log sleihw4.log -mod addsub @sleihw4.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open sleihw4.rs1 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs1: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -nojed -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open sleihw4.rs2 w} rspFile] {
	puts stderr "Cannot create response file sleihw4.rs2: $rspFile"
} else {
	puts $rspFile "-i sleihw4.bl5 -lci sleihw4.lct -d m4s_32_30 -lco sleihw4.lco -html_rpt -fti sleihw4.fti -fmt PLA -tto sleihw4.tt4 -eqn sleihw4.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@sleihw4.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete sleihw4.rs1
file delete sleihw4.rs2
if [runCmd "\"$cpld_bin/tda\" -i sleihw4.bl5 -o sleihw4.tda -lci sleihw4.lct -dev m4s_32_30 -family lc4k -mod addsub -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj sleihw4 -if sleihw4.jed -j2s -log sleihw4.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/07/21 17:24:06 ###########

