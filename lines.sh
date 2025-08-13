#!/bin/bash

find . -name "*.go" -not -path "./vendor/*" | xargs wc -l