#!/usr/bin/env tclsh


proc print_usage {} {
  puts "./configure board_number hw_platform_path elf"
  puts "Do not end directory path arguments with '/'"
}

# Map FPGA board number to Digilent JTAG cable name
proc jtag_cable_lookup {board_number} {
  switch $board_number {
    1  {set jtag_cable_number "210248A49862"}
    2  {set jtag_cable_number "210248A4995D"}
    3  {set jtag_cable_number "210248A49B13"}
    4  {set jtag_cable_number "210248A49B10"}
    5  {set jtag_cable_number "210248A49A79"}
    6  {set jtag_cable_number "210248707372"}
    7  {set jtag_cable_number "210248707367"}
    8  {set jtag_cable_number "210248707371"}
    9  {set jtag_cable_number "210248690208"}
    10 {set jtag_cable_number "210248707374"}
    11 {set jtag_cable_number "210248A49841"}
    12 {set jtag_cable_number "210248A49886"}
    13 {set jtag_cable_number "210248A49920"}
    14 {set jtag_cable_number "210248A4990A"}
    15 {set jtag_cable_number "210248A4991E"}
    16 {set jtag_cable_number "210248A49906"}
    17 {set jtag_cable_number "210248A4991B"}
    18 {set jtag_cable_number "210248A49915"}
    19 {set jtag_cable_number "210248A4988D"}
    20 {set jtag_cable_number "210248A49C34"}
    21 {set jtag_cable_number "210248AA59AC"}
    22 {set jtag_cable_number "210248AA5879"}
    23 {set jtag_cable_number "210248AA5A37"}
    24 {set jtag_cable_number "210248AA57B3"}
    25 {set jtag_cable_number "210248AA5921"}
    26 {set jtag_cable_number "210248AA58C2"}
    27 {set jtag_cable_number "210248AA5A43"}
    28 {set jtag_cable_number "210248AA590E"}
    29 {set jtag_cable_number "210248AA5924"}
    30 {set jtag_cable_number "210248AA59B0"}
    31 {set jtag_cable_number "210248AA58BF"}
    32 {set jtag_cable_number "210248AA5709"}
    33 {set jtag_cable_number "210248AA5686"}
    34 {set jtag_cable_number "210248AA5913"}
    35 {set jtag_cable_number "210248AA591C"}
    36 {set jtag_cable_number "210248AA591F"}
    37 {set jtag_cable_number "210248AA59A6"}
    38 {set jtag_cable_number "210248AA59B1"}
    39 {set jtag_cable_number "210248AA590D"}
    40 {set jtag_cable_number "210248AA5914"}
    default { puts "Error! Invalid board number: $board_number"
              print_usage
              exit
            }
    }
}

set nargs 5
if {$argc != $nargs} {
  puts "Error! Expecting ${nargs} arguments"
  print_usage
  exit
}

set board_number [lindex $argv 0]
set hw_platform_path [lindex $argv 1]
set elf [lindex $argv 2]
set bitstream [lindex $argv 3]
set memfile [lindex $argv 4]

puts "Configuring FPGA ${board_number}\n"
puts "Hadwarre Platform: ${hw_platform_path}\n"
puts "ELF File: ${elf}\n"
puts "Bitstream File: ${hw_platform_path}/${bitstream}\n"

set jtag_cable_number [jtag_cable_lookup $board_number]
puts "JTAG Cable: ${jtag_cable_number}\n"


puts "
-------------------------------------------------------------------------------
 Starting FPGA ${board_number} Configuration
-------------------------------------------------------------------------------
"


connect -url tcp:127.0.0.1:3121
source ${hw_platform_path}/ps7_init.tcl
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed ${jtag_cable_number}"} -index 0
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent Zed ${jtag_cable_number}" && level==0} -index 1
fpga -file ${hw_platform_path}/${bitstream}
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed ${jtag_cable_number}"} -index 0
loadhw -hw ${hw_platform_path}/system.hdf -mem-ranges [list {0x40000000 0xbfffffff}]
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed ${jtag_cable_number}"} -index 0
ps7_init
ps7_post_config

targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zed ${jtag_cable_number}"} -index 0
dow -data ${memfile} 0x3200000
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zed ${jtag_cable_number}"} -index 0
dow ${elf}
configparams force-mem-access 0

targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zed ${jtag_cable_number}"} -index 0
con
#0x7200000
puts "
-------------------------------------------------------------------------------
"


exit


