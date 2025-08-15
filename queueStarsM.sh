#!/bin/bash -x
echo "Lets start submitting these jobs"
echo "Number of CPU's per job: "
echo "Please use multiples of 128"
read cpus
echo "Wall time (XX:XX:XX): "
read wallTime

while true; do
    read -p "Do you wish to submit the jobs in simFiles folder (y/n)?" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Calculate the number of nodes required and cores per node
numSelect=`expr \( $cpus - 1 \) / $BC_STANDARD_NODE_CORES + 1`
numCPUs=`expr \( $cpus / $numSelect \) + \( $cpus % $numSelect \)`

nodeCPUs=$BC_STANDARD_NODE_CORES

for file in /p/PATHTOHOME/simFiles/*.sim  # Only select .sim files
do
  export simFile="$file"
  # Submit the job with only the .sim file (macro handled in the .csh script)
  qsub -A USERACCOUNTHERE -l select=$numSelect:ncpus=$numCPUs:mpiprocs=$numCPUs \
    -l walltime=$wallTime -N `echo $file | cut -d'/' -f6 | cut -d'.' -f1` \
    -q standard -v simFile runAStarM.sh  # Pass only the simFile (macro handled in the .sh script)
done
exit