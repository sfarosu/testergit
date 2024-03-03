package cmd

import (
	"fmt"
	"runtime"

	"github.com/sfarosu/testergit/cmd/version"
)

func Run() {
	fmt.Println("RUN called")
	fmt.Printf("Version '%v', BuildDate '%v', GitShortHash '%v', GoVersion '%v'\n", version.Version, version.BuildDate, version.GitShortHash, runtime.Version())
}
