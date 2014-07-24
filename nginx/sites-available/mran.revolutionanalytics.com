#mran.revolutionanalytics.com
#Chris Mosetick 2014-06-12
#last update    2014-07-19

server {
        #listen on IPv4 and IPv6 addresses at the same time
        listen 80;
        listen [::]:80;

        #directory in the file system to serve web pages and packages from
        #this is a detachable block disk formatted with ZFS that can be easily moved to another server
	#www dir is for landing page stuff
        root /MRAN/www;
        index index.html index.htm;

        # public facing domain name for this vhost
        server_name marmoset.revolutionanalytics.com;


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
                #history is symlink poiniting to snapshots of the /MRAN/www FS itself
                #this URL is hidden right now, not on index.html
        }

        location /exports {
		            try_files $uri $uri/ =404;
        	      autoindex on;
        	      # Uncomment to enable naxsi on this location
        	      # include /etc/nginx/naxsi.rules
                #exports is symlink pointing to zpool named "exports"
	}

}
#this last bracket is needed to close this vhost
