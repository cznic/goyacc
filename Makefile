# Copyright 2014 The goyacc Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

.PHONY: all clean editor later nuke todo internalError

grep=--include=*.go

all: editor
	go tool vet -printfuncs "Log:0,Logf:1" *.go
	golint .
	make todo

clean:
	go clean
	rm -f *~ y.output y.go tmp.go

editor:
	go fmt
	go test
	go install

internalError:
	egrep -ho '"internal error.*"' *.go | sort | cat -n

later:
	@grep -n $(grep) LATER * || true
	@grep -n $(grep) MAYBE * || true

nuke: clean
	go clean -i

todo:
	@grep -nr $(grep) ^[[:space:]]*_[[:space:]]*=[[:space:]][[:alpha:]][[:alnum:]]* * || true
	@grep -nr $(grep) TODO * || true
	@grep -nr $(grep) BUG * || true
	@grep -nr $(grep) println * || true
