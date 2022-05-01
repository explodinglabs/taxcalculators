<img
    alt="My App"
    style="margin: 0 auto;"
    src="https://github.com/explodinglabs/taxcalculators/blob/main/logo.png?raw=true"
/>

We use a custom nginx container to serve the static files built by Elm.

For development, start the container (which starts nginx, due to the base image
being nginx). For development we use a different nginx.conf which *doesn't* use
SSL certificates or redirect port 80 to 443.
```sh
mkdir docs  # Output files are written here
docker run --rm --name taxcalculators --network explodinglabs --publish 80:80 -v ${PWD}/docs:/usr/share/nginx/html:rw -v ${PWD}/nginx-dev.conf:/etc/nginx/nginx.conf -v ${PWD}/static:/usr/share/nginx/html ghcr.io/explodinglabs/taxcalculators  |grep -v '"HEAD '
```

Visit [http://localhost/](http://localhost/).

## Production

For Github Pages, simply push to production.

For Dockerised production, mount the LetsEncrypt keys into the container, and
expose port 443:
```sh
docker run -d --name taxcalculators --network explodinglabs --publish 80:80 --publish 443:443 -v /etc/letsencrypt/live/mydomain.com/fullchain.pem:/certs/fullchain.pem -v /etc/letsencrypt/live/mydomain.com/privkey.pem:/certs/privkey.pem ghcr.io/explodinglabs/taxcalculators
```

To build the image:
```sh
docker build -t ghcr.io/explodinglabs/taxcalculators .
```
