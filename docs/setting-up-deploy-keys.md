# Setting up deploy keys for multiple Organization repos in Github.com

References:  
[See this gist for original reference](https://gist.github.com/jexchan/2351996)  
or this  
[stackoverflow page](http://stackoverflow.com/questions/7096458/managing-ssh-public-keys-on-github-organizations-repositories)

## Purpose
-The purpose of this document is to describe the steps needed to setup a machine
account for advanced source control management when working with git repos that
are part of a Github.com Organization account.  
-When a local machine account may need to be shared with multiple users, and is
typically used for unattended automation and running scripts from CI, cron, etc.

###This document describes how to do this for 2 repos, but you can have as many as needed.


## Part 1 - Getting Started with the key generation
While logged into the user account that will do the work
"mran-user" in this case.

`ssh-keygen -t ecdsa -b 521 -C "MRAN-site@revolutionanalytics.com"`  
Set the output of the key file to be:  
`$HOME/.ssh/MRAN-site-ecdsa`
note, do not set a passphrase.

`ssh-keygen -t ecdsa -b 521 -C "OSS-site@revolutionanalytics.com"`  
Set the output of the key file to be:  
`$HOME/.ssh/OSS-site-ecdsa`  
note, do not set a passphrase.

`cat ~/.ssh/MRAN-site-ecdsa.pub`  
`cat ~/.ssh/OSS-site-ecdsa.pub`  
Copy the public half of each key to your clipboard, one at a time.

Now open the repo in your web browser, on the right side click on settings.

Click on Deploy keys from the left hand side.

Paste in the key and click on "add key".

## Part 2 - Modifying the git remote origin

Now this is the tricky part.  
2.1 You need to make sure that the user account is configured to use ssh for git operations.  
e.g. the remote URL in the repos .git/config needs to be set for ssh rather than https:  

2.2 You need to add an extra piece of info after the .com in the remote origin URL. (-MRAN-site OR -OSS-site)

Look carefully here, notice the dash and text after the .com:  
`git@github.com-MRAN-site:RA-Internal/MRAN-site.git`

NOTE - Without doing the above modification, this setup will not work correctly.

2.3 `cd` into each repo that needs to work with a deploy key.
Run the git config command to set username and email on a per repo basis.
```
cd ~/src/MRAN-site
git config user.name "MRAN-site"
git config user.email "MRAN-site@revolutionanalytics.com"
```

```
cd ~/src/OSS-site
git config user.name "OSS-site"
git config user.email "OSS-site@revolutionanalytics.com"
```


## Part 3 - Adding a $HOME/.ssh/config file  

You will need to make sure that you have a properly configured personal ssh config file for the mran-user account for this to work correctly.  
Here is what the `$HOME/.ssh/config` should look like for this example:  

`cd $HOME/.ssh`  
`touch config`
#### config contents:

```
#personal ssh config file for mran-user account
#MRAN-site repo
Host github.com-MRAN-site
    HostName github.com
    User git
    IdentityFile ~/.ssh/MRAN-site-ecsda

#OSS-site repo
Host github.com-OSS-site
    HostName github.com
    User git
    IdentityFile ~/.ssh/OSS-site-ecdsa
```

## Part 4 - testing
Test this all out by manually cd'ing to each repo and running `git pull`  
If things are setup correctly you will not be prompted for any thing.
