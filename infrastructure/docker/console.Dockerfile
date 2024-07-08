# Dockerfile

# Use the official Golang image to build the Go application
FROM golang:1.21-alpine3.17 as builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY ../../go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY ../.. .

# Build the Go app
RUN GOOS=linux GOARCH=amd64 go build -o bin/console/console cmd/console/*.go

# Start a new stage from scratch
FROM alpine:latest

WORKDIR /root/

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/bin/sims/sims .

#Retrieve the environment variables
ARG AWS_REGION
ARG ENV
ARG POSTGRES_URL

RUN chmod +x sims
# Command to run the executable
#Should have the form: --aws.id=$AWS_ID --aws.region=$AWS_REGION --aws.secret=$AWS_SECRET --aws.url=$AWS_URL --postgres.url=$POSTGRES_URL
#taking the values from the environment variables
CMD /bin/sh -c "./sims --region=$AWS_REGION --env=$ENV --postgres.url=$POSTGRES_URL"