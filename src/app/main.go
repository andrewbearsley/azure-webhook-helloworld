package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {
	// Get port from environment variable or default to 8080
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	// Define the handler for the webhook
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Received request from %s", r.RemoteAddr)
		fmt.Fprintf(w, "Hello World from Azure!")
	})

	// Add a health check endpoint
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		fmt.Fprintf(w, "Healthy")
	})

	// Start the server
	log.Printf("Server starting on port %s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatalf("Error starting server: %v", err)
	}
}
