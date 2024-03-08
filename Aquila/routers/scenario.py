from fastapi import APIRouter, UploadFile, File, HTTPException
import subprocess
from subprocess import PIPE

baseUrl = "."

router = APIRouter(tags=["Scenario"])


@router.post("/upload_scenario")
async def upload_scenario(
    # system_type,
    nodes,
    compute_file: UploadFile = File(...),
    config_file: UploadFile = File(...)
):
    if config_file.filename.split(".")[-1] != "h":
        raise HTTPException(status_code=400, detail="Config file must be of format *.h")
    
    if compute_file.filename.split(".")[-1] != "c":
        raise HTTPException(status_code=400, detail="Config file must be of format *.c")

    config_contents = config_file.file.read()
    compute_contents = compute_file.file.read()

    # Write config to src
    with open(f"{baseUrl}/src/config_apps.h", 'wb') as f:
        f.write(config_contents)
        f.close()

    # Write compute to src
    with open(f"{baseUrl}/src/compute.c", 'wb') as f:
        f.write(compute_contents)
        f.close()
    
    # Modify run_app based on nodes
    with open(f"{baseUrl}/run_app.sh", 'w') as f:
        f.write("#!/usr/bin/env bash\n\n")
        f.write("XSDB=/opt/Xilinx/Vivado/2018.3/bin/xsdb\n\n")
        f.write("HW_PLATFORM_PATH=sample_project.sdk/system_hw_platform_0\n\n")
        f.write("MEM_FILE=image.mfs\n\n")
        f.write("ELF=sample_project.sdk/sample_project/Debug/sample_project.elf\n\n")
        f.write("BITSTREAM=template_top.bit\n\n")

        max_nodes = int(nodes)
        if max_nodes >=40:
            max_nodes = 38
        
        for i in range(max_nodes+2):
            if(i+1 not in [4,5]):
                f.write(f"$XSDB configure.tcl {i+1} $HW_PLATFORM_PATH $ELF $BITSTREAM $MEM_FILE\n")

        f.close()
    
    # run make_all
    make_command = ["make", "all"]
    # make_command = ["make", "all", "-C", baseUrl]
    make_result = subprocess.run(make_command, stdout=PIPE, stderr=PIPE)
        
    print("##############################################################")
    print(make_result.stdout)
    print(make_result.stderr)
    print("##############################################################")

    # if make_result.stderr:
        # raise HTTPException(status_code=400, detail="Success")
    
    shell_command = [f"{baseUrl}/run_app.sh"]
    shell_result = subprocess.run(shell_command, stdout=PIPE, stderr=PIPE)

    print("##############################################################")
    print(shell_result.stdout)
    print(shell_result.stderr)
    print("##############################################################")

    # if shell_result.stderr:
        # raise HTTPException(status_code=400, detail="Success")

    if not shell_result.stderr and not make_result.stderr:
        raise HTTPException(status_code=200, detail="Success")

        