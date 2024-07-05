#!/bin/bash

# Variables for PostgreSQL
POSTGRES_URL="postgres://ubuntu:unicode@127.0.0.1/circle_test?sslmode=disable"
AWS_URL="http://sqs.us-east-1.localhost.localstack.cloud:4566"
AWS_ID="test"
AWS_SECRET="test"
AWS_REGION="us-east-1"

# Build the Go application
go build -o bin/sims/sims cmd/sims/*

# Variables for the Go application
SIMS_FILE="bin/sims/sims"

# Create the required SQS queues
echo "Creating SQS queues..."

aws --endpoint-url=$AWS_URL sqs create-queue --queue-name connection-state-change
aws --endpoint-url=$AWS_URL sqs create-queue --queue-name event-state-change
aws --endpoint-url=$AWS_URL sqs create-queue --queue-name object-state-change
aws --endpoint-url=$AWS_URL sqs create-queue --queue-name reaction-state-change
aws --endpoint-url=$AWS_URL sqs create-queue --queue-name endpoint-state-change


# Run the binary
echo "Running the Go application..."
$SIMS_FILE --aws.id=$AWS_ID --aws.region=$AWS_REGION --aws.secret=$AWS_SECRET --aws.url=$AWS_URL --postgres.url=$POSTGRES_URL