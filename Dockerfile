FROM node:20.11.0 AS lml-scratch
ENV NODE_OPTIONS=--openssl-legacy-provider
COPY . /app/lml-scratch-gui
WORKDIR /app 
RUN git clone https://gitlab.com/lml-corp/lml-scratch-l10n 
RUN cd /app/lml-scratch-l10n && git checkout devel && cd /app
RUN git clone https://gitlab.com/lml-corp/lml-scratch-vm
RUN cd /app/lml-scratch-vm && git checkout devel 
RUN cd /app/lml-scratch-l10n && npm install && npm run build && npm link
RUN cd /app/lml-scratch-vm && npm install && npm link && npm link scratch-l10n 
RUN cd /app/lml-scratch-gui && npm install && npm link scratch-vm scratch-l10n
RUN npm run build


FROM nginx:1.27.1
COPY --from=lml-scratch /app/lml-scratch-gui/build /usr/share/nginx/html