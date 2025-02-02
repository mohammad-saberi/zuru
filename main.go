// Package main defines the entry point of the Go application
package main

// Import necessary standard library packages
import (
	"log"      // Provides logging capabilities
	"net/http" // Provides HTTP client and server implementations
)

// healthHandler handles HTTP requests to the "/health" endpoint
func healthHandler(w http.ResponseWriter, r *http.Request) {
	// Set the HTTP status code to 200 OK
	w.WriteHeader(http.StatusOK)
	// Write the response body with a message
	_, err := w.Write([]byte("200 - OK"))
	if err != nil {
		// Log any error encountered while writing the response
		log.Println("Error writing response:", err)
	}
}

// main is the entry point of the application
func main() {
	// Register the healthHandler function to handle requests at "/health"
	http.HandleFunc("/health", healthHandler)

	// Log that the server is starting
	log.Println("Server is starting on port 8080...")

	// Start the HTTP server on port 8080
	// ListenAndServe will block and run until the program is terminated
	// log.Fatal logs the error if ListenAndServe returns an error and then exits the program
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal("Server failed to start:", err)
	}
}
