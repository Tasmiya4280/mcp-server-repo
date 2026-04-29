now # syntax=docker/dockerfile:1

FROM golang:1.18 AS builder
WORKDIR /app

# Download dependencies first to leverage Docker layer caching.
COPY go.mod go.sum ./
RUN go mod download

COPY . ./
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /main .

FROM gcr.io/distroless/static-debian11
COPY --from=builder /main /main
COPY --from=builder /app/static /static

EXPOSE 8080
ENTRYPOINT ["/main"]
