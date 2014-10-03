#cran-snapshots.revolutionanalytics.com
#Chris Mosetick 2014-08-15
#last update    2014-09-25

server {
        #listen on IPv4 and IPv6 addresses at the same time
        listen 80;
        listen [::]:80;

        #directory in the file system to serve web pages and packages from
        #this is a detachable block disk formatted with ZFS that can be easily moved to another server

        root /cran-www/snapshots;
        autoindex  on;

        # public facing domain names for this vhost
        # use with an 'S' and without an 'S' at the end to help typos
        server_name cran-snapshots.revolutionanalytics.com cran-snapshot.revolutionanalytics.com;

        access_log /var/log/nginx/cran-snapshots.revolutionanalytics.com.log;
        error_log /var/log/nginx/error-cran-snapshots.revolutionanalytics.com.log;

        #enable redirection to package web pages and tasks views
        rewrite package=(.+) web/packages/$1/index.html redirect;
        rewrite view=(.+) web/views/$1.html redirect;

}
#this last bracket is needed to close this vhost
