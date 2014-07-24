* [What is MRAN?](#whatismran)
* [MRAN](#indetail)
* [Structure](#structure)
* [How are snapshots created?](#snapshots)
* [Important note regarding dates](#dates)
* [Difference between snapshots of MRAN](#diffsnaps)
* [Metadata and RRT integration](#metadatarrt)

### <a href="#whatismran" name="whatismran">#</a> What is MRAN?
MRAN is a server side component with snapshot capabilities that works hand-in-hand
with the client side [RRT package](http://revolutionanalytics.github.io/RRT).  

Some of the main goals of MRAN:
* Better organize the various places that R packages live on CRAN.
* Add point-in-time capabilities via snapshots allowing more precision for reproducibility.
* Separate data from metadata (data describing data)
* Default repository for Marmoset distribution.
* Optional drop-in replacement for standard CRAN mirror. (with snapshots)

### <a href="#indetail" name="indetail">#</a> In detail - MRAN (Modern R Archive Network)
MRAN is downstream snapshot of CRAN. One of the main differentiations of MRAN to CRAN
is that MRAN consists of a series of snapshots that are taken once a day using a
script that points to the master CRAN server hosted at [Universität Wien](http://www.univie.ac.at/en)
on behalf of the R Project.

MRAN also organizes packages on the server in a different manner than CRAN, partially
due to the snapshot system, and partially for an effort to modernize the structure.

Authors of R packages that are hosted on CRAN are likely to update their packages at any point in time.
That is great as it keeps the ecosystem fresh and ensures that bug fixes are available almost
immediately.

However, that also creates a volatile environment where package versions can change
on any given day. Current CRAN and R standards do not allow a user to track specific
versions of packages indefinitely.

The core features of the [RRT](http://revolutionanalytics.github.io/RRT) package
combined with the MRAN server backend frees a user from having to keep track of
package versions and R versions if they want others to be able to reproduce their work.

By focusing on a MRAN snapshot date, rather than version numbers of any number
of packages and R versions, a user is given the freedom to work on their project
without fear that their hard work will be rendered irreproducible by updates to
R or packages by authors.

MRAN combined with the RRT front end are in essence a trace back mechanism
so users will have a way to go back to the version of a package that they were
working on at a point in time.

Additionally by using these tools, a user can work on multiple projects at the
same time, with each project pointing to different MRAN snapshots. A user can
refresh their client side RRT project directory to a newer snapshot whenever they
choose, or optionally freeze time and keep working off a older snapshot indefinitely.


### <a href="#structure">#</a> Structure

Each MRAN snapshot holds all source versions of a package in the same
per-package directory on the MRAN server.  
i.e. [http://mran.revolutionanalytics.com/snapshots/src/2014-06-20_0500/zoo/](http://mran.revolutionanalytics.com/snapshots/src/2014-06-20_0500/zoo/)

Binary package snapshots are stored on a per platform basis, as they would be on CRAN.
Note that for binary packages MRAN is only taking snapshots of R-release (current stable).
i.e. The zoo package on 23 July 2014 is compiled using R-release 3.1.  

[http://mran.revolutionanalytics.com/snapshots/bin/macosx/2014-07-23_0500/zoo_1.7-11.tgz](http://mran.revolutionanalytics.com/snapshots/bin/macosx/2014-07-23_0500/zoo_1.7-11.tgz)


### <a href="#snapshots" name="snapshots">#</a> How are snapshots created?
Snapshots are created using [ZFS](http://open-zfs.org/wiki/Main_Page).
The MRAN server is specifically using the native Linux kernel port, [ZFS-on-Linux](http://zfsonlinux.org/).
The ZFS-on-Linux project was started at [Lawrence Livermore National Laboratory](https://www.llnl.gov/).
[Open-ZFS](http://open-zfs.org/wiki/Main_Page) is an open source community project that
has a wide range of contributors and sponsors that comprise its ecosystem.

ZFS was chosen as the server side snapshot method for MRAN as it works on the block level,
not the file level like many other tools. It is efficient for storing compressed binary
files like .tar.gz or .zip, unlike SCM tools such as git, mercurial or subversion.

ZFS is very space efficient: ZFS snapshots are immutable objects that only take up the amount of
space that has changed between the snapshot and the 'live' file system. i.e.
very small when looking at the daily churn of updates to R packages, but great space
savings when looking at the ecosystem of packages hosted on CRAN as a whole
over the course of a year.  

Note that backend processes work on the "live" file system, so for reproducibility MRAN always
serves up snapshots. A [RRT](http://revolutionanalytics.github.io/RRT) user pointing to MRAN never
see's the "live" file system.

A current overview of space usage on the current MRAN server can be found at:  
<br/>
[http://mran.revolutionanalytics.com/accounting/](http://mran.revolutionanalytics.com/accounting/)  
<br/>
All MRAN snapshots are exposed at:  
[http://mran.revolutionanalytics.com/snapshots/](http://mran.revolutionanalytics.com/snapshots/)


### <a href="#dates" name="dates">#</a> Important note regarding dates
MRAN snapshots are taken using the UTC time zone as the basis for dates.


### <a href="#diffsnaps" name="diffsnaps">#</a> Differences between snapshots of MRAN

The `zfs diff` command is the method that diffs are created with.
Diffs are taken between the most recent snapshot and the previous
snapshot so that RRT or a user can compare differences between them
at any point in time.

The output of the diffs are exposed at:  
[http://mran.revolutionanalytics.com/diffs/](http://mran.revolutionanalytics.com/diffs/)

### <a href="#metadatarrt" name="metadatarrt">#</a> Metadata and RRT integration

`mran_metadata.R` creates metadata from each snapshot of source packages.
A variety of metadata above and beyond what a CRAN package description file contains is stored for each R package.  
All metadata is exposed at:  
[http://mran.revolutionanalytics.com/metadata/](http://mran.revolutionanalytics.com/metadata/)
