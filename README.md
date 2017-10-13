# README #

## HOW TO CONNECT RSTUDIO TO BITBUCKET FOR THE FIRST TIME ##

### FASTER NO-HEADACHE APPROACH ###

1. Run "Git Bash" and type in the following:

	$ git config --global user.name 'user.name'  
	$ git config --global user.email 'email@address'  
	
2. Go to RStudio > Tools > Global Options > Git/SVN > Create RSA Key...
3. Copy your public key from RStudio to Bitbucket > Click on your profile photo > Bitbucket settings > SSH keys > Add key

### HEADACHE GUARANTEED IN THE LONG-RU N###

1. Install the latest version of Git for Windows: https://git-for-windows.github.io/

2. Run "Git Bash" and type the following:

	$ git config --global user.name 'user.name'  
	$ git config --global user.email 'email@address'  
	$ git clone https://YOUR_USERNAME_@bitbucket.org/ccpbioinfo/xcms.git  

3. In RStudio, create a new project (Version Control > Git).

4. For 'Repository URL', use the URL of the project as written on the BitBucket page of the project itself. This should naturally be: https://YOUR_USERNAME@bitbucket.org/ccpbioinfo/xcms.git

More help can be found here: http://cinf401.artifice.cc/notes/rstudio-workflow.html

