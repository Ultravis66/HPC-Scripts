#!/bin/bash -x

#PBS -l application=star-ccm+
#PBS -l ccmppower=1
#PBS -l place=scatter:excl

source /etc/profile.d/modules.sh
module load starccm/2410-R8

# Directory setup
TMPDIR="$WORKDIR/$PBS_JOBID"
mkdir -p "$TMPDIR"
cp "$simFile" "$TMPDIR"
cd "$TMPDIR" || exit 1

# Handle nodes and CPU count
nmax=$(wc -l < "$PBS_NODEFILE")
PBS_NNODES=$nmax
PBS_NNODES=$((PBS_NNODES - 1))

tail -n "$PBS_NNODES" "$PBS_NODEFILE" > new_node_file.dat

# Extract base name (leave exactly as you had it)
SIM_FILE=$(echo "$simFile" | cut -d'/' -f6)
BASE_NAME=$(echo "$simFile" | sed 's/\.sim$//')

# The macro file has the same base name but with a .java extension
MACRO_FILE="${BASE_NAME}.java"
cp "$MACRO_FILE" "$TMPDIR"

# Set output directory (same as TMPDIR)
OUTPUT_DIR="$TMPDIR"

# Run STAR-CCM+ with both the macro and the simulation file in batch mode
# Use the copy in TMPDIR by passing basenames
starccm+ -power -pio -np "$PBS_NNODES" -mpidriver openmpi -rsh /usr/bin/ssh \
         -machinefile new_node_file.dat -batch "$(basename "$MACRO_FILE")" "$SIM_FILE" |& \
         grep -v "maparch" > "${OUTPUT_DIR}/${SIM_FILE}.out"