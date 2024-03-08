#!/usr/bin/env bash

XSDB=/opt/Xilinx/Vivado/2018.3/bin/xsdb

HW_PLATFORM_PATH=sample_project.sdk/system_hw_platform_0

MEM_FILE=image.mfs

ELF=sample_project.sdk/sample_project/Debug/sample_project.elf

BITSTREAM=template_top.bit

$XSDB configure.tcl 1 $HW_PLATFORM_PATH $ELF $BITSTREAM $MEM_FILE
$XSDB configure.tcl 2 $HW_PLATFORM_PATH $ELF $BITSTREAM $MEM_FILE
$XSDB configure.tcl 3 $HW_PLATFORM_PATH $ELF $BITSTREAM $MEM_FILE
echo SUCCESS

