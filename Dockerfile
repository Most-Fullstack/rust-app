# Use the official Rust image as the base
FROM rust:1.82-slim AS builder

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the project files to the container
COPY . .

# Build the application in release mode
RUN cargo build --release

# Create a new lightweight image for running the binary
FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y libc6

# Set the working directory in the new image
WORKDIR /usr/src/app

# Copy the compiled binary from the builder stage
COPY --from=builder /usr/src/app/target/release/rust-app .

# Expose the port your app runs on (optional)
EXPOSE 8080

# Set the command to run the binary
CMD ["./rust-app"]
