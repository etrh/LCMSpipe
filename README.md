# README #

## HOW TO CONNECT RSTUDIO TO BITBUCKET FOR THE FIRST TIME ##
1. Install the latest version of Git for Windows: https://git-for-windows.github.io/

2. Run "Git Bash" and type the following:

	$ git config --global user.name 'user.name'
	$ git config --global user.email 'email@address'
	$ git clone https://YOUR_USERNAME_@bitbucket.org/ccpbioinfo/xcms.git

3. In RStudio, create a new project (Version Control > Git).

4. For 'Repository URL', use the URL of the project as written on the BitBucket page of the project itself. This should naturally be: https://YOUR_USERNAME@bitbucket.org/ccpbioinfo/xcms.git

More help can be found here: http://cinf401.artifice.cc/notes/rstudio-workflow.html