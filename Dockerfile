# Builder image
FROM --platform=linux/amd64 golang:1.22 as builder

WORKDIR /go/src/testergit

COPY . /go/src/testergit

ENV GO111MODULE=on \
    GOOS=linux \
    GOARCH=amd64 \
    CGO_ENABLED=0

# RUN go mod download && \
#     go build -o testergit -ldflags "-X 'github.com/sfarosu/testergit/cmd/version.BuildDate=$(date '+%Y-%m-%d %H:%M:%S')'-X 'github.com/sfarosu/testergit/cmd/version.GitShortHash=$(git rev-parse --short HEAD)'"

# Run image
FROM --platform=linux/amd64 alpine:3.19

RUN apk update && apk add --no-cache --upgrade openssh-client openssl tzdata

WORKDIR /app

COPY ./scripts/ ./scripts
COPY --from=builder /go/src/testergit/testergit .

RUN chown -R 10001:root /app && \
    chgrp -R 0 /app && \
    chmod -R g=u /app /etc/passwd && \
    chmod -R a+x-w /app/scripts && \
    chmod a+x-w /app/testergit

EXPOSE 8080

ENTRYPOINT [ "./scripts/uid_entrypoint.sh" ]

USER 10001

CMD [ "./testergit" ]
