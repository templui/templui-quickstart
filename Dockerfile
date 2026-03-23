# Build stage:
# We install everything we need here, build the CSS, generate templ code,
# and compile the app binary.
FROM golang:1.24 AS build
WORKDIR /app

# Copy Go dependency files first so Docker can cache downloads better.
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the project files.
COPY . .

# Install tools needed during the build.
RUN apt-get update && apt-get install -y wget ca-certificates && rm -rf /var/lib/apt/lists/*

# Download the Tailwind standalone binary for the current CPU architecture.
RUN arch="$(dpkg --print-architecture)" && \
    case "$arch" in \
      amd64) tailwind_arch="x64" ;; \
      arm64) tailwind_arch="arm64" ;; \
      *) echo "unsupported architecture: $arch" && exit 1 ;; \
    esac && \
    wget -O /usr/local/bin/tailwindcss "https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-${tailwind_arch}" && \
    chmod +x /usr/local/bin/tailwindcss

# Build the Tailwind CSS file.
# We also include templUI component templates, so Tailwind sees their classes too.
RUN TEMPLUI_PATH="$(go list -mod=mod -m -f '{{.Dir}}' github.com/templui/templui)" && \
    test -n "$TEMPLUI_PATH" && \
    test -d "$TEMPLUI_PATH/components" && \
    printf '%s\n' \
      '@source "./**/*.templ";' \
      '@source "./**/*.js";' \
      "@source \"$TEMPLUI_PATH/components/**/*.templ\";" \
      "@source \"$TEMPLUI_PATH/components/**/*.js\";" \
      > ./assets/css/sources.generated.css && \
    tailwindcss -i ./assets/css/input.css -o ./assets/css/output.css --minify

# Generate Go files from .templ files.
RUN go tool templ generate

# Build one static Linux binary for the final image.
RUN CGO_ENABLED=0 GOOS=linux go build -o main ./main.go

# Runtime stage:
# This image stays small and only contains the final app binary.
FROM alpine:3.20.2
WORKDIR /app

# Install runtime certificates.
RUN apk add --no-cache ca-certificates

# Run the app in production mode.
ENV GO_ENV=production

# Copy the built binary from the build stage.
COPY --from=build /app/main .

# The app listens on port 8090.
EXPOSE 8090

# Start the app.
CMD ["./main"]
