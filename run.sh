#!/usr/bin/env bash

docker run --rm -it \
	-v "./init.lua:/home/$(id -un)/.config/nvim/init.lua" \
	-v "./lazy:/home/$(id -un)/.local/share/nvim/lazy" \
	-w "/home/$(id -un)/workspace/grpc-go" \
	nvim-cmp-repro \
	nvim call.go
