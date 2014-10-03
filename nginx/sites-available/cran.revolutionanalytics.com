#cran.revolutionanalytics.com
#Chris Mosetick 2014-08-15
#last update    2014-08-18

server {
        #listen on IPv4 and IPv6 addresses at the same time
        listen 80;
        listen [::]:80;

        #directory in the file system to serve web pages and packages from
        #this is a detachable block disk formatted with ZFS that can be easily moved to another server

        root /cran;
        index index.html index.htm;
        autoindex  on;

        # public facing domain name for this vhost
        server_name cran.revolutionanalytics.com;

        access_log /var/log/nginx/cran.revolutionanalytics.com.log;
        error_log /var/log/nginx/error-cran.revolutionanalytics.com.log;

        #enable redirection to package web pages and tasks views
        rewrite ^/package=(.+) /web/packages/$1/index.html redirect;
        rewrite ^/view=(.+) /web/views/$1.html redirect;

}
#this last bracket is needed to close this vhost
