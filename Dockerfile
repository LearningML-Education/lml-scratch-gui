FROM node:20.11.0 AS lml-scratch
ENV NODE_OPTIONS=--openssl-legacy-provider
COPY . /app/lml-scratch-gui
WORKDIR /app 
RUN git clone https://gitlab.com/lml-corp/lml-scratch-l10n && \
    cd /app/lml-scratch-l10n && git checkout main && cd /app && \
    git clone https://gitlab.com/lml-corp/lml-scratch-vm && \
    cd /app/lml-scratch-vm && git checkout main && \
    cd /app/lml-scratch-l10n && npm install && npm run build && npm link && \
    cd /app/lml-scratch-vm && npm install && npm link && npm link scratch-l10n && \
    cd /app/lml-scratch-gui && npm install && npm link scratch-vm scratch-l10n && \
    npm run build


FROM nginx:1.27.1
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY --from=lml-scratch /app/lml-scratch-gui/build /usr/share/nginx/html/scratch
COPY ./index.html /usr/share/nginx/html/scratch/index.html
COPY ./lml.png /usr/share/nginx/html/scratch/lml.png
