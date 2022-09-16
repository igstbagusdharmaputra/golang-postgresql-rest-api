FROM golang:1.19.1-alpine3.16 as builder

COPY go.mod go.sum /go/src/github.com/igstbagusdharmaputra/apps/
WORKDIR /go/src/github.com/igstbagusdharmaputra/apps
RUN go mod download
COPY . /go/src/github.com/igstbagusdharmaputra/apps
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o build/apps github.com/igstbagusdharmaputra/apps


FROM alpine

RUN apk add --no-cache ca-certificates && update-ca-certificates
COPY --from=builder /go/src/github.com/igstbagusdharmaputra/apps/build/apps /usr/bin/apps

EXPOSE 8080 8080

ENTRYPOINT ["/usr/bin/apps"]
