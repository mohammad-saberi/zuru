# Start from the official Golang base image
FROM golang:1.23.5-alpine

# Set the current working directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go application
RUN go build -o main .

# Expose port 8080
EXPOSE 8080

# Running as a non-root user
RUN adduser -D zuru-tech
USER zuru-tech

# Command to run the executable
CMD ["./main"]