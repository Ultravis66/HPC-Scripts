# HPC-Scripts
This is a repository to help people who need scripting to submit Star CCM jobs:

If you have star CCM+ jobs that you would like to sumbit to an HPC with a java file, these scripts will do just that.

You place your jobs into a folder called simFiles

change the account name in the submission line to your account

add the correct path to simFiles

Ensure that both the sim file and java file have the same names:
Example.sim
Example.java

run the script:
bash queueStarsM.sh
