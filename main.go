package main

import (
	"fmt"
	"net/http"
	"os"

	"myapp/assets"
	"myapp/ui/pages"

	"github.com/a-h/templ"
	"github.com/joho/godotenv"
	"github.com/templui/templui/utils"
)

func main() {
	initDotEnv()

	mux := http.NewServeMux()
	setupAssetsRoutes(mux)
	mux.Handle("GET /", templ.Handler(pages.Landing()))

	fmt.Println("Server is running on http://localhost:8090")
	err := http.ListenAndServe(":8090", mux)
	if err != nil {
		panic(err)
	}
}

func initDotEnv() {
	err := godotenv.Load()
	if err != nil {
		fmt.Println("Error loading .env file")
	}
}

func setupAssetsRoutes(mux *http.ServeMux) {
	isDevelopment := os.Getenv("GO_ENV") != "production"

	// Your app assets (CSS, fonts, images, ...)
	assetHandler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if isDevelopment {
			w.Header().Set("Cache-Control", "no-store")
		} else {
			w.Header().Set("Cache-Control", "public, max-age=31536000")
		}

		var fs http.Handler
		if isDevelopment {
			fs = http.FileServer(http.Dir("./assets"))
		} else {
			fs = http.FileServer(http.FS(assets.Assets))
		}

		fs.ServeHTTP(w, r)
	})

	mux.Handle("GET /assets/", http.StripPrefix("/assets/", assetHandler))

	// templUI embedded component scripts
	utils.SetupScriptRoutes(mux, isDevelopment)
}
