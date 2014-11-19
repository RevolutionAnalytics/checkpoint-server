#devstaging.raprojects.io
#Chris Mosetick 2014-11-18
#last update    2014-11-18

server {
        #listen on IPv4 and IPv6 addresses at the same time
        listen 80;
        listen [::]:80;

        #directory in the file system to serve web pages and packages from
        root /home/devstaging-user/jenkins/workspace/raprojects-devbranch/dist;
        index index.html index.htm;

        # public facing domain name for this vhost
        server_name devstaging.raprojects.io dev-staging.raprojects.io;

        access_log /var/log/nginx/devstaging.raprojects.io.log;
        error_log /var/log/nginx/error-devstaging.projects.io.log;

        #define error page parameters here
        error_page 404 /404/index.html;
        #prevent loading error pages directly
        location  /404/index.html { internal; }

}
#this last bracket is needed to close this vhost
