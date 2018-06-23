#!/bin/bash
sudo apt-get install -y nginx

cat > kubernetes.default.svc.cluster.local <<EOF
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	root /var/www/html;

	# Add index.php to the list if you are using PHP
	index index.html index.htm index.nginx-debian.html;

	server_name _;
        location /healthz {
	 proxy_pass                    https://127.0.0.1:6443/healthz;
         proxy_ssl_trusted_certificate /var/lib/kubernetes/ca.pem;
        }

	location / {
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files $uri $uri/ =404;
	}
}

EOF

sudo mv kubernetes.default.svc.cluster.local \
 /etc/nginx/sites-enabled/default

sudo systemctl restart nginx
sudo systemctl enable nginx
