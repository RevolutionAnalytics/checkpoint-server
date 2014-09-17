#projects.revolutionanalytics.com
#Chris Mosetick
#last update    2014-09-10

server {
        #listen on IPv4 and IPv6 addresses at the same time
        listen 80;
        listen [::]:80;

        #directory in the file system to serve web pages from
        root /home/mran-user/src/OSS-site/dist;
        index index.html index.htm;

        # public facing domain name for this vhost
        server_name projects.revolutionanalytics.com;





}
#this last bracket is needed to close this vhost
