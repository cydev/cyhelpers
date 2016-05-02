package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strings"
)

var names = [...]string{
	"cydev",
	"ernado",
}

func completion(prefix string) string {
	candidates := []string{}
	exists := make(map[string]bool)
	for _, name := range names {
		dir := filepath.Join(prefix, name)
		dirs, err := ioutil.ReadDir(dir)
		if err != nil {
			log.Fatal(err)
		}
		for _, d := range dirs {
			if !d.IsDir() {
				continue
			}
			candidate := d.Name()
			if exists[candidate] {
				candidate = filepath.Join(name, candidate)
			}
			exists[candidate] = true
			candidates = append(candidates, candidate)
		}
	}
	return strings.Join(candidates, " ")
}

func main() {
	gopath, exists := os.LookupEnv("GOPATH")
	if !exists {
		gopath = "/go"
	}
	prefix := filepath.Join(gopath, "src", "github.com")
	if len(os.Args) < 2 {
		// returning completion list
		fmt.Print(completion(prefix))
		os.Exit(1)
	}
	project := os.Args[1] // cydev/project, ernado/project or just project
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
		log.Fatal("project", project, "not found")
	}
	fmt.Print(path)
}
