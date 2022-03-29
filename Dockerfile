FROM golang:alpine as builder
RUN apk update && apk add git && apk add ca-certificates
COPY *.go go.mod go.sum  $GOPATH/src/mypackage/myapp/
WORKDIR $GOPATH/src/mypackage/myapp/
ENV CGO_ENABLED=0
ENV GOOS=linux
RUN go mod tidy && go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/docker_state_exporter

FROM scratch
COPY --from=builder /go/bin/docker_state_exporter /go/bin/docker_state_exporter
EXPOSE 8080
ENTRYPOINT ["/go/bin/docker_state_exporter"]
CMD ["-listen-address=:8080"]
