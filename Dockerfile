FROM node:20.11.0 AS lml-scratch
ENV NODE_OPTIONS=--openssl-legacy-provider
ENV NODE_ENV=production
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
COPY --from=lml-scratch /app/lml-scratch-gui/build /usr/share/nginx/html/scratch
