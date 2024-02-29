#!/bin/bash

go test ./... -p 1 -coverprofile cover.out

go tool cover -html=cover.out