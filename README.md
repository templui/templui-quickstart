# ⚠️ DEPRECATED

This repository is deprecated. Use the templUI CLI instead:

See https://templui.io for more information.

---

# templUI Quickstart

Get started with templUI components for Go + templ.

## Prerequisites

- Go 1.25 or higher
- Node.js (for Tailwind CSS)
- [Task](https://taskfile.dev) - Cross-platform task runner

## Quick Start

```bash
git clone https://github.com/templui/templui-quickstart.git my-app
cd my-app

# Install Task (one-time setup)
go install github.com/go-task/task/v3/cmd/task@latest

# Start development server
task dev
```

Your app is now running at [http://localhost:7331](http://localhost:7331)

## Commands

```bash
task dev          # Start development server with hot reload
task templ        # Watch templ files and run server
task --list       # Show all available tasks
```

## Production

```bash
docker build -t my-app .
docker run -p 8090:8090 my-app
```

## Documentation

Visit [templui.io/docs](https://templui.io/docs) for component documentation.

## License

MIT
