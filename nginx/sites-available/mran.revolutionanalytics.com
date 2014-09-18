#mran.revolutionanalytics.com
#Chris Mosetick 2014-06-12
#last update    2014-09-10

server {
        #listen on IPv4 and IPv6 addresses at the same time
        listen 80;
        listen [::]:80;

        #directory in the file system to serve web pages and packages from
        #this is a detachable block disk formatted with ZFS that can be easily moved to another server
        #www dir is for landing page stuff
        #root /MRAN/www;
        root /home/mran-user/src/MRAN-site/dist;
        index index.html index.htm;

        # public facing domain name for this vhost
        server_name mran.revolutionanalytics.com;

        #define the location of the Nodejs instance running on this system
        #location / {
        #proxy_pass http://localhost:7300/;
        #proxy_set_header Host $host;
        #proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        #}


        location /snapshots {
                try_files $uri $uri/ =404;
                #autoindex is needed since we are not serving up any html or php pages
                autoindex  on;
                # Uncomment to enable naxsi on this location
                # include /etc/nginx/naxsi.rules
                #snapshots is directory containing symlinks to various .zfs/snapshot dirs
        }


        location /metadata {
                try_files $uri $uri/ =404;
                autoindex on;
		            # Uncomment to enable naxsi on this location
                # include /etc/nginx/naxsi.rules

        }

        location /diffs {
                try_files $uri $uri/ =404;
                autoindex on;
                # Uncomment to enable naxsi on this location
                # include /etc/nginx/naxsi.rules
        }

        location /accounting {
                try_files $uri $uri/ =404;
                autoindex on;
                # Uncomment to enable naxsi on this location
                # include /etc/nginx/naxsi.rules
        }

        location /history {
		            try_files $uri $uri/ =404;
                autoindex on;
                # Uncomment to enable naxsi on this location
                # include /etc/nginx/naxsi.rules
                #history is symlink pointing to snapshots of the /MRAN/www FS itself
                #this URL is hidden right now, not on index.html
        }

        location /exports {
		            try_files $uri $uri/ =404;
        	      autoindex on;
        	      # Uncomment to enable naxsi on this location
        	      # include /etc/nginx/naxsi.rules
		            #exports is symlink to zpool named exports
	      }

}
#this last bracket is needed to close this vhost
