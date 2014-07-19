MRAN
====

Modern R Archive Network

#### Downstream [CRAN](http://cran.r-project.org/) server with snapshot capabilities + advanced metadata from [RRT](http://revolutionanalytics.github.io/RRT)

* To get started creating a MRAN server, clone this repository to your server
candidate.

* Ubuntu 14.04 is the current reference platform for MRAN, though it should
work on any platform that support ZFS.

* Make sure that you have read file **MRAN-server-overview.md** in the docs
directory. It will brief you on the structure and concepts of a MRAN server.

* You should be able to commit at least 100GB of disk space to a MRAN server to
get started. You can grow your MRAN pool over time as disk space is needed.  

* **Migration and backup:** The `zfs send` command can be used to safely
migrate a MRAN server zpool or FS from one disk(s) to another larger set maintaining
all snapshots and live data throughout the process.  

* See **packages-import.bsh** for how to use the `zfs recv` command to import
from another server or another zpool on an existing system.

* Review **host-setup.bsh**  
Change the line starting with CHANGE ME to the correct device, then run the
script to get started building your MRAN server.

* Issues, improvements, ideas? Please use the [MRAN issue tracker](https://github.com/RevolutionAnalytics/MRAN/issues)
to file any bug reports or leave feedback about MRAN.
