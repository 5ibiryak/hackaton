FROM golang:1.16-alpine 

USER 0
ENV GO111MODULE=on
RUN apk update && apk add bash go
RUN wget https://dl.google.com/go/go1.12.7.linux-amd64.tar.gz && \
    tar -C /usr/local -xvzf go1.12.7.linux-amd64.tar.gz && \
    rm -rf go1.12.7.linux-amd64.tar.gz && \
    mkdir -p /app


WORKDIR /app
COPY . .
RUN chmod +x ./src/prepare.sh && \ 
    ./src/prepare.sh && \
    go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o server -ldflags="-w -s" .
CMD ['10 15 minutes, 5 10 fifth, 4 5 10 fifth']
EXPOSE 3000
ENTRYPOINT /app/server
USER 1000
