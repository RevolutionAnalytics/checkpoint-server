* [What is checkpoint-server?](#whatischeckpoint-server)
* [In Detail](#indetail)
* [Structure](#structure)
* [Timing](#timing)
* [How are snapshots created?](#snapshots)
* [Important note regarding dates](#dates)


### <a href="#whatischeckpoint-server" name="whatismran">#</a> What is checkpoint-server?

`checkpoint-server` is a server side component with snapshot capabilities that works hand-in-hand
with the client side [checkpoint package](https://github.com/revolutionanalytics/checkpoint).  

Some of the main goals of checkpoint-server:
* Add point-in-time capabilities via snapshots allowing more precision for reproducible work.
* Default repository for [Revolution R Open](http://mran.revolutionanalytics.com/open/) distribution of R.
* Drop-in replacement for standard CRAN mirror. (with snapshots)


### <a href="#indetail" name="indetail">#</a> In detail - checkpoint-server & Managed R Archive Network

`checkpoint-server` is a backend component of [MRAN](http://mran.revolutionanalytics.com)
that is downstream snapshot of CRAN. One of the main differentiations of checkpoint-server
to CRAN is that there consists a series of snapshots that are taken once a day using
a script that points to the master CRAN server hosted at
[Universität Wien](http://www.univie.ac.at/en) on behalf of the [R Project](http://www.r-project.org/).
CRAN versions R packages but does not have a snapshot capable system in place for end users to point to.

Authors of R packages that are hosted on CRAN are likely to update their packages at any point in time.
That is great as it keeps the ecosystem fresh and ensures that bug fixes are available almost
immediately.

However, that also creates a volatile environment where package versions can change
on any given day. Current CRAN and R standards do not allow a user to track specific
versions of packages indefinitely.

The core features of the [`checkpoint`](https://github.com/revolutionanalytics/checkpoint) package
combined with the MRAN server backend frees a user from having to keep track of
package versions and R versions if they want others to be able to reproduce their work.

By focusing on a snapshot date, rather than version numbers of any number
of packages and R versions, a user is given the freedom to work on their project
without fear that their hard work will be rendered irreproducible by updates to
R or packages by authors.

checkpoint-server combined with the `checkpoint` front end R package are in essence
a trace back mechanism so users will have a way to go back to the version of a CRAN
R package that they were working on at a point in time.

Additionally by using these tools, a user can work on multiple projects at the
same time, with each project pointing to different checkpoint-server snapshots. A user can
refresh their client side project workspace to a newer snapshot whenever they
choose, or optionally freeze time and keep working off a older snapshot indefinitely.

Limitations:  
Currently checkpoint-server only takes snapshots of what is publicly available on [CRAN](http://cran.r-project.org).


### <a href="#structure">#</a> Structure

Each checkpoint-server snapshot holds an entire copy of CRAN as it existed at the time of the snapshot.


### <a href="#timing">#</a> Timing
1. cran.revolutionanalytics.com is a standard CRAN mirror that is updated daily via rsync job.
2. A snapshot is then created of the standard CRAN mirror.
3. checkpoint-server is then populated with a new snapshot:  
mran.revolutionanalytics.com/snapshot/<date> is populated each day from the same rsync job.  
Note that this avoids having to run multiple rsync jobs and also avoids redundent content
on the checkpoint-server.


### <a href="#snapshots" name="snapshots">#</a> How are snapshots created?

Snapshots are created using [ZFS](http://open-zfs.org/wiki/Main_Page).
The checkpoint-server is specifically using the native Linux kernel port, [ZFS-on-Linux](http://zfsonlinux.org/).
The ZFS-on-Linux project was started at [Lawrence Livermore National Laboratory](https://www.llnl.gov/).
[Open-ZFS](http://open-zfs.org/wiki/Main_Page) is an open source community project that
has a wide range of contributors and sponsors that comprise its ecosystem.

ZFS was chosen as the server side snapshot method for checkpoint-server as it works on the block level,
not the file level like many other tools. It is efficient for storing compressed binary
files like .tar.gz or .zip, unlike SCM tools such as git, mercurial or subversion.

ZFS is very space efficient: ZFS snapshots are immutable objects that only take up the amount of
space that has changed between the snapshot and the 'live' file system. i.e.
very small when looking at the daily churn of updates to R packages, but great space
savings when looking at the ecosystem of packages hosted on CRAN as a whole
over the course of a year.  

Note that backend processes work on the "live" file system, so for reproducibility checkpoint-server always
serves up snapshots. A [checkpoint](https://github.com/RevolutionAnalytics/checkpoint)
user pointing to checkpoint-server (MRAN) never see's the "live" file system.

All checkpoint-server snapshots are exposed at:  
[http://mran.revolutionanalytics.com/snapshot/](http://mran.revolutionanalytics.com/snapshot/)


### <a href="#dates" name="dates">#</a> Important note regarding dates

checkpoint-server snapshots are taken using the UTC time zone as the basis for dates.
Thus CRAN package authors might notice a delay of 1-3 days between when they update their package,
see the new version hosted on CRAN, and when it appears in a checkpoint-server snapshot.
