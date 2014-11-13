#masterstaging.mran.io
#Chris Mosetick 2014-06-12
#last update    2014-11-11

server {
        #listen on IPv4 and IPv6 addresses at the same time
        listen 80;
        listen [::]:80;

        #directory in the file system to serve web pages and packages from
        root /home/devstaging-user/jenkins/workspace/masterbranch-build/dist;
        index index.html index.htm;

        # public facing domain name for this vhost
        server_name masterstaging.mran.io master-staging.mran.io staging.mran.io;

	access_log /var/log/nginx/masterstaging.mran.io.log;
	error_log /var/log/nginx/error-masterstaging.mran.io.log;

	#define error page parameters here
        error_page 404 /404/index.html;
        #prevent loading error pages directly
        location  /404/index.html { internal; }

	#send blogs that link to old location to current location
        rewrite ^/documents/rro/open$ http://masterstaging.mran.io/open permanent;

	location /packagedata {
                alias /home/devstaging-user/jenkins/workspace/master-gen-pkg-data/packagedata;
                allow all;
        }

        location /snapshot {
		#snapshots is directory containing symlinks to various .zfs/snapshot dirs
                try_files $uri $uri/ =404;
                #autoindex is needed since we are not serving up any html or php pages
                autoindex  on;
		autoindex_localtime off;
        }

	location /src/contrib/Archive {
                try_files $uri $uri/ =404;
                #autoindex is needed since we are not serving up any html or php pages
                autoindex  on;
                autoindex_localtime off;
        }

        location /metadata {
                try_files $uri $uri/ =404;
                autoindex on;

        }

        location /diffs {
                try_files $uri $uri/ =404;
                autoindex on;
        }

        location /accounting {
                try_files $uri $uri/ =404;
                autoindex on;
        }

        location /history {
		try_files $uri $uri/ =404;
                autoindex on;
                #history is symlink pointing to snapshots of the /MRAN/www FS itself
                #this URL is hidden right now, not on index.html
        }

        location /exports {
		try_files $uri $uri/ =404;
        	autoindex on;
		#exports is symlink to zpool named exports
	      }

}
#this last bracket is needed to close this vhost
