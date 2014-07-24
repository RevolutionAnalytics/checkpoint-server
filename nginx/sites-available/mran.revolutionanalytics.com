#mran.revolutionanalytics.com
#Chris Mosetick 2014-06-12
#last update    2014-07-24

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
        }

	location /exports {
		try_files $uri $uri/ =404;
        	autoindex on;
        	# Uncomment to enable naxsi on this location
        	# include /etc/nginx/naxsi.rules
	}

}
#this last bracket is needed to close this vhost
