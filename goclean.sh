#!/bin/bash
# The script does automatic checking on a Go package and its sub-packages, including:
# 1. gofmt         (http://golang.org/cmd/gofmt/)
# 2. golint        (https://github.com/golang/lint)
# 3. go vet        (http://golang.org/cmd/vet)
# 4. gosimple      (https://github.com/dominikh/go-simple)
# 5. unconvert     (https://github.com/mdempsky/unconvert)
# 6. ineffassign   (https://github.com/gordonklaus/ineffassign)
# 7. race detector (http://blog.golang.org/race-detector)
# 8. test coverage (http://blog.golang.org/cover)

# gometaling (github.com/alecthomas/gometalinter) is used to run each each
# static checker.

set -ex

# run tests
env GORACE="halt_on_error=1" go test -race ./...

# Make sure gometalinter is installed and $GOPATH/bin is in your path.
# $ go get -v github.com/alecthomas/gometalinter"
# $ gometalinter --install"
if [ ! -x "$(type -p gometalinter)" ]; then
  exit 1
fi

# check linters
# linters do not work with modules yet
go mod vendor
unset GO111MODULE

gometalinter --vendor --disable-all --deadline=10m \
  --enable=gofmt \
  --enable=golint \
  --enable=vet \
  --enable=gosimple \
  --enable=unconvert \
  --enable=ineffassign \
  ./...
