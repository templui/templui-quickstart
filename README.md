# templUI Quickstart

This is a ready-to-run quickstart project for templUI.

## Run

```sh
git clone <repo-url>
cd templui-quickstart
cp .env.example .env
go mod tidy
task dev
```

Open `http://localhost:7331` for templ live preview or `http://localhost:8090` for the app.

If you want your own module path later, run:

```sh
go mod edit -module your/module/path
```

## Docker

```sh
docker build -t templui-quickstart .
docker run --rm -p 8088:8090 templui-quickstart
```

Then open `http://localhost:8088`.
