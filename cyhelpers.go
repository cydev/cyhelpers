package main

import (
	"fmt"
	"os"
	"path/filepath"
)

func main() {
	gopath, exists := os.LookupEnv("GOPATH")
	if !exists {
		gopath = "/go"
	}
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "Project name not provided")
		os.Exit(-1)
	}
	project := os.Args[1] // cydev/project, ernado/project or just project
	prefix := filepath.Join(gopath, "src", "github.com")
	candidates := []string{
		project,
		filepath.Join("cydev", project),
		filepath.Join("ernado", project),
	}
	var path string
	for _, candidate := range candidates {
		pathCandidate := filepath.Join(prefix, candidate)
		if _, err := os.Stat(pathCandidate); err == nil {
			path = pathCandidate
			break
		}
	}
	if len(path) == 0 {
		fmt.Fprintln(os.Stderr, "Candidate not found")
		os.Exit(-2)
	}
	fmt.Print(path)
}
