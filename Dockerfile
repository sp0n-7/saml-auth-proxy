FROM golang:1.14.3 as BUILD_IMAGE

WORKDIR /go/src/citizen
COPY . .
RUN GO111MODULE=on CGO_ENABLED=0 GOOS=linux go build -v -installsuffix cgo .

FROM alpine:3.9

RUN apk add --no-cache -U \
  ca-certificates
COPY --from=BUILD_IMAGE /go/src/citizen/saml-auth-proxy /usr/bin

ENTRYPOINT ["/usr/bin/saml-auth-proxy"]
