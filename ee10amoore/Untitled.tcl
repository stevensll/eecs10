
########## Tcl recorder starts at 01/21/19 19:24:23 ##########

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

########## Tcl recorder end at 01/21/19 19:24:23 ###########


########## Tcl recorder starts at 01/21/19 19:24:26 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:24:26 ###########


########## Tcl recorder starts at 01/21/19 19:31:54 ##########

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

########## Tcl recorder end at 01/21/19 19:31:54 ###########


########## Tcl recorder starts at 01/21/19 19:31:57 ##########

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

########## Tcl recorder end at 01/21/19 19:31:57 ###########


########## Tcl recorder starts at 01/21/19 19:32:11 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:32:11 ###########


########## Tcl recorder starts at 01/21/19 19:37:40 ##########

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

########## Tcl recorder end at 01/21/19 19:37:40 ###########


########## Tcl recorder starts at 01/21/19 19:42:31 ##########

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

########## Tcl recorder end at 01/21/19 19:42:31 ###########


########## Tcl recorder starts at 01/21/19 19:42:33 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:42:33 ###########


########## Tcl recorder starts at 01/21/19 19:45:24 ##########

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

########## Tcl recorder end at 01/21/19 19:45:24 ###########


########## Tcl recorder starts at 01/21/19 19:45:27 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:45:27 ###########


########## Tcl recorder starts at 01/21/19 19:46:14 ##########

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

########## Tcl recorder end at 01/21/19 19:46:14 ###########


########## Tcl recorder starts at 01/21/19 19:46:17 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:46:17 ###########


########## Tcl recorder starts at 01/21/19 19:50:51 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:50:51 ###########


########## Tcl recorder starts at 01/21/19 19:52:25 ##########

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

########## Tcl recorder end at 01/21/19 19:52:25 ###########


########## Tcl recorder starts at 01/21/19 19:52:28 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:52:28 ###########


########## Tcl recorder starts at 01/21/19 19:52:52 ##########

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

########## Tcl recorder end at 01/21/19 19:52:52 ###########


########## Tcl recorder starts at 01/21/19 19:58:34 ##########

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

########## Tcl recorder end at 01/21/19 19:58:34 ###########


########## Tcl recorder starts at 01/21/19 19:58:34 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:58:35 ###########


########## Tcl recorder starts at 01/21/19 19:58:59 ##########

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

########## Tcl recorder end at 01/21/19 19:58:59 ###########


########## Tcl recorder starts at 01/21/19 19:59:00 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:59:00 ###########


########## Tcl recorder starts at 01/21/19 19:59:23 ##########

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

########## Tcl recorder end at 01/21/19 19:59:23 ###########


########## Tcl recorder starts at 01/21/19 19:59:23 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 19:59:23 ###########


########## Tcl recorder starts at 01/21/19 20:06:22 ##########

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

########## Tcl recorder end at 01/21/19 20:06:22 ###########


########## Tcl recorder starts at 01/21/19 20:06:23 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 20:06:23 ###########


########## Tcl recorder starts at 01/21/19 20:11:27 ##########

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

########## Tcl recorder end at 01/21/19 20:11:27 ###########


########## Tcl recorder starts at 01/21/19 20:11:28 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 20:11:28 ###########


########## Tcl recorder starts at 01/21/19 20:14:31 ##########

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

########## Tcl recorder end at 01/21/19 20:14:31 ###########


########## Tcl recorder starts at 01/21/19 20:14:31 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 20:14:31 ###########


########## Tcl recorder starts at 01/21/19 20:15:47 ##########

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

########## Tcl recorder end at 01/21/19 20:15:47 ###########


########## Tcl recorder starts at 01/21/19 20:15:47 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 20:15:47 ###########


########## Tcl recorder starts at 01/21/19 20:20:31 ##########

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

########## Tcl recorder end at 01/21/19 20:20:31 ###########


########## Tcl recorder starts at 01/21/19 20:20:32 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 20:20:32 ###########


########## Tcl recorder starts at 01/21/19 20:22:22 ##########

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

########## Tcl recorder end at 01/21/19 20:22:22 ###########


########## Tcl recorder starts at 01/21/19 20:22:23 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 20:22:23 ###########


########## Tcl recorder starts at 01/21/19 20:25:38 ##########

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

########## Tcl recorder end at 01/21/19 20:25:38 ###########


########## Tcl recorder starts at 01/21/19 20:25:39 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 20:25:39 ###########


########## Tcl recorder starts at 01/21/19 20:26:00 ##########

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

########## Tcl recorder end at 01/21/19 20:26:00 ###########


########## Tcl recorder starts at 01/21/19 20:26:01 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 20:26:01 ###########


########## Tcl recorder starts at 01/21/19 20:27:52 ##########

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

########## Tcl recorder end at 01/21/19 20:27:52 ###########


########## Tcl recorder starts at 01/21/19 20:27:53 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/21/19 20:27:53 ###########


########## Tcl recorder starts at 01/22/19 15:40:41 ##########

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

########## Tcl recorder end at 01/22/19 15:40:41 ###########


########## Tcl recorder starts at 01/22/19 15:40:41 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 15:40:41 ###########


########## Tcl recorder starts at 01/22/19 15:41:03 ##########

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

########## Tcl recorder end at 01/22/19 15:41:03 ###########


########## Tcl recorder starts at 01/22/19 15:41:04 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 15:41:04 ###########


########## Tcl recorder starts at 01/22/19 15:51:49 ##########

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

########## Tcl recorder end at 01/22/19 15:51:49 ###########


########## Tcl recorder starts at 01/22/19 15:51:49 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 15:51:49 ###########


########## Tcl recorder starts at 01/22/19 15:52:06 ##########

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

########## Tcl recorder end at 01/22/19 15:52:06 ###########


########## Tcl recorder starts at 01/22/19 15:52:06 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 15:52:06 ###########


########## Tcl recorder starts at 01/22/19 16:00:13 ##########

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

########## Tcl recorder end at 01/22/19 16:00:13 ###########


########## Tcl recorder starts at 01/22/19 16:00:14 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 16:00:14 ###########


########## Tcl recorder starts at 01/22/19 16:04:15 ##########

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

########## Tcl recorder end at 01/22/19 16:04:15 ###########


########## Tcl recorder starts at 01/22/19 16:04:16 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 16:04:16 ###########


########## Tcl recorder starts at 01/22/19 16:09:26 ##########

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

########## Tcl recorder end at 01/22/19 16:09:26 ###########


########## Tcl recorder starts at 01/22/19 16:09:26 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 16:09:26 ###########


########## Tcl recorder starts at 01/22/19 16:12:42 ##########

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

########## Tcl recorder end at 01/22/19 16:12:42 ###########


########## Tcl recorder starts at 01/22/19 16:12:42 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 16:12:42 ###########


########## Tcl recorder starts at 01/22/19 16:24:43 ##########

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

########## Tcl recorder end at 01/22/19 16:24:43 ###########


########## Tcl recorder starts at 01/22/19 16:24:44 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 16:24:44 ###########


########## Tcl recorder starts at 01/22/19 16:29:39 ##########

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

########## Tcl recorder end at 01/22/19 16:29:39 ###########


########## Tcl recorder starts at 01/22/19 16:29:40 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 16:29:40 ###########


########## Tcl recorder starts at 01/22/19 16:54:15 ##########

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

########## Tcl recorder end at 01/22/19 16:54:15 ###########


########## Tcl recorder starts at 01/22/19 16:54:15 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 16:54:15 ###########


########## Tcl recorder starts at 01/22/19 16:56:19 ##########

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

########## Tcl recorder end at 01/22/19 16:56:19 ###########


########## Tcl recorder starts at 01/22/19 16:56:20 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 16:56:20 ###########


########## Tcl recorder starts at 01/22/19 16:57:50 ##########

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

########## Tcl recorder end at 01/22/19 16:57:50 ###########


########## Tcl recorder starts at 01/22/19 16:57:51 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 16:57:51 ###########


########## Tcl recorder starts at 01/22/19 17:01:45 ##########

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

########## Tcl recorder end at 01/22/19 17:01:45 ###########


########## Tcl recorder starts at 01/22/19 17:01:45 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 17:01:45 ###########


########## Tcl recorder starts at 01/22/19 17:41:18 ##########

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

########## Tcl recorder end at 01/22/19 17:41:18 ###########


########## Tcl recorder starts at 01/22/19 17:41:19 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 17:41:19 ###########


########## Tcl recorder starts at 01/22/19 17:48:03 ##########

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

########## Tcl recorder end at 01/22/19 17:48:03 ###########


########## Tcl recorder starts at 01/22/19 17:48:03 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 17:48:03 ###########


########## Tcl recorder starts at 01/22/19 17:54:41 ##########

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

########## Tcl recorder end at 01/22/19 17:54:41 ###########


########## Tcl recorder starts at 01/22/19 17:54:42 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 17:54:42 ###########


########## Tcl recorder starts at 01/22/19 17:57:32 ##########

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

########## Tcl recorder end at 01/22/19 17:57:32 ###########


########## Tcl recorder starts at 01/22/19 17:57:32 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 17:57:32 ###########


########## Tcl recorder starts at 01/22/19 18:00:00 ##########

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

########## Tcl recorder end at 01/22/19 18:00:00 ###########


########## Tcl recorder starts at 01/22/19 18:00:00 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:00:00 ###########


########## Tcl recorder starts at 01/22/19 18:02:40 ##########

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

########## Tcl recorder end at 01/22/19 18:02:40 ###########


########## Tcl recorder starts at 01/22/19 18:02:41 ##########

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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:02:41 ###########


########## Tcl recorder starts at 01/22/19 18:11:52 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:11:52 ###########


########## Tcl recorder starts at 01/22/19 18:12:18 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:12:18 ###########


########## Tcl recorder starts at 01/22/19 18:12:18 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:12:18 ###########


########## Tcl recorder starts at 01/22/19 18:23:25 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:23:25 ###########


########## Tcl recorder starts at 01/22/19 18:23:25 ##########

# Commands to make the Process: 
# Compile Logic
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:23:25 ###########


########## Tcl recorder starts at 01/22/19 18:24:09 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:24:09 ###########


########## Tcl recorder starts at 01/22/19 18:24:09 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:24:09 ###########


########## Tcl recorder starts at 01/22/19 18:24:31 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:24:31 ###########


########## Tcl recorder starts at 01/22/19 18:24:32 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:24:32 ###########


########## Tcl recorder starts at 01/22/19 18:25:24 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:25:24 ###########


########## Tcl recorder starts at 01/22/19 18:25:25 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:25:25 ###########


########## Tcl recorder starts at 01/22/19 18:26:08 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:26:08 ###########


########## Tcl recorder starts at 01/22/19 18:26:08 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:26:08 ###########


########## Tcl recorder starts at 01/22/19 18:32:21 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:32:21 ###########


########## Tcl recorder starts at 01/22/19 18:32:21 ##########

# Commands to make the Process: 
# Constraint Editor
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/blifstat\" -i untitled.bl5 -o untitled.sif"] {
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
	puts $rspFile "-nodal -src untitled.bl5 -type BLIF -presrc untitled.bl3 -crf untitled.crf -sif untitled.sif -devfile \"$install_dir/ispcpld/dat/lc4k/m4s_32_30.dev\" -lci untitled.lct
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

########## Tcl recorder end at 01/22/19 18:32:21 ###########


########## Tcl recorder starts at 01/22/19 18:32:29 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:32:29 ###########


########## Tcl recorder starts at 01/22/19 18:32:43 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:32:43 ###########


########## Tcl recorder starts at 01/22/19 18:32:44 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:32:44 ###########


########## Tcl recorder starts at 01/22/19 18:35:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:35:13 ###########


########## Tcl recorder starts at 01/22/19 18:35:14 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:35:14 ###########


########## Tcl recorder starts at 01/22/19 18:37:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:37:13 ###########


########## Tcl recorder starts at 01/22/19 18:37:14 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:37:14 ###########


########## Tcl recorder starts at 01/22/19 18:39:25 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:39:25 ###########


########## Tcl recorder starts at 01/22/19 18:39:26 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:39:26 ###########


########## Tcl recorder starts at 01/22/19 18:40:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:40:14 ###########


########## Tcl recorder starts at 01/22/19 18:40:14 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:40:14 ###########


########## Tcl recorder starts at 01/22/19 18:41:25 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:41:25 ###########


########## Tcl recorder starts at 01/22/19 18:41:25 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:41:25 ###########


########## Tcl recorder starts at 01/22/19 18:48:12 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:48:12 ###########


########## Tcl recorder starts at 01/22/19 18:48:13 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:48:13 ###########


########## Tcl recorder starts at 01/22/19 18:58:22 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:58:22 ###########


########## Tcl recorder starts at 01/22/19 18:58:23 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:58:23 ###########


########## Tcl recorder starts at 01/22/19 18:59:09 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -ojhd only -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:59:09 ###########


########## Tcl recorder starts at 01/22/19 18:59:09 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/22/19 18:59:09 ###########


########## Tcl recorder starts at 01/24/17 16:05:15 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/ahdl2blf\" deccntr.abl -mod deccntr -ojhd compile -ret -def _AMDMACH_ _MACH_ _LSI5K_ _LATTICE_ _PLSI_ _MACH4ZE_  -err automake.err "] {
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
if [runCmd "\"$cpld_bin/mblflink\" \"deccntr.bl1\" -o \"untitled.bl2\" -omod \"untitled\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj untitled -lci untitled.lct -log untitled.imp -err automake.err -tti untitled.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -blifopt untitled.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" untitled.bl2 -sweep -mergefb -err automake.err -o untitled.bl3 @untitled.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -diofft untitled.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" untitled.bl3 -family AMDMACH -idev van -o untitled.bl4 -oxrf untitled.xrf -err automake.err @untitled.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci untitled.lct -dev lc4k -prefit untitled.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp untitled.bl4 -out untitled.bl5 -err automake.err -log untitled.log -mod deccntr @untitled.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open untitled.rs1 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs1: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -nojed -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open untitled.rs2 w} rspFile] {
	puts stderr "Cannot create response file untitled.rs2: $rspFile"
} else {
	puts $rspFile "-i untitled.bl5 -lci untitled.lct -d m4s_32_30 -lco untitled.lco -html_rpt -fti untitled.fti -fmt PLA -tto untitled.tt4 -eqn untitled.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@untitled.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete untitled.rs1
file delete untitled.rs2
if [runCmd "\"$cpld_bin/tda\" -i untitled.bl5 -o untitled.tda -lci untitled.lct -dev m4s_32_30 -family lc4k -mod deccntr -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj untitled -if untitled.jed -j2s -log untitled.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/24/17 16:05:15 ###########

