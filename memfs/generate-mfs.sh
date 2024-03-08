#!/usr/bin/env bash
mfsgen -cvbf ../image.mfs 3000 *

# NOTE
# I removed the -s flag in the mfsgen command
# It was causing issues and the FS was not recognized!!!
