FROM nginx

RUN apt-get update
RUN apt-get install -y npm

COPY nginx.conf /etc/nginx/nginx.conf
COPY docs /usr/share/nginx/html
COPY . /app
WORKDIR /app

RUN npm install
RUN npm install elm uglify-js
ENV PATH="/app/node_modules/.bin:${PATH}"
RUN elm make src/Main.elm --optimize --output /usr/share/nginx/html/elm.js && ./node_modules/.bin/uglifyjs /usr/share/nginx/html/elm.js --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output /usr/share/nginx/html/elm.js
