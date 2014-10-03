#projects.revolutionanalytics.com
#Chris Mosetick
#last update    2014-09-25

server {
        #listen on IPv4 and IPv6 addresses at the same time
        listen 80;
        listen [::]:80;

        #directory in the file system to serve web pages from
        root /home/mran-user/src/OSS-site/dist;
        index index.html index.htm;

        # public facing domain name for this vhost
        server_name projects.revolutionanalytics.com;

        access_log /var/log/nginx/projects.revolutionanalytics.com.log;
        error_log /var/log/nginx/error-projects.revolutionanalytics.com.log;



}
#this last bracket is needed to close this vhost
