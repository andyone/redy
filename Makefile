################################################################################

# This Makefile generated by GoMakeGen 1.2.0 using next command:
# gomakegen --race .
#
# More info: https://kaos.sh/gomakegen

################################################################################

.DEFAULT_GOAL := help
.PHONY = fmt git-config deps-test test gen-fuzz help

################################################################################

git-config: ## Configure git redirects for stable import path services
	git config --global http.https://pkg.re.followRedirects true

deps-test: git-config ## Download dependencies for tests
	go get -d -v pkg.re/check.v1

test: ## Run tests
	go test -race -covermode=atomic .

gen-fuzz: ## Generate archives for fuzz testing
	which go-fuzz-build &>/dev/null || go get -u -v github.com/dvyukov/go-fuzz/go-fuzz-build
	go-fuzz-build -func FuzzInfoParser -o info-parser-fuzz.zip github.com/essentialkaos/redy
	go-fuzz-build -func FuzzConfigParser -o config-parser-fuzz.zip github.com/essentialkaos/redy
	go-fuzz-build -func FuzzRespReader -o resp-reader-fuzz.zip github.com/essentialkaos/redy


fmt: ## Format source code with gofmt
	find . -name "*.go" -exec gofmt -s -w {} \;

help: ## Show this info
	@echo -e '\n\033[1mSupported targets:\033[0m\n'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[33m%-12s\033[0m %s\n", $$1, $$2}'
	@echo -e ''
	@echo -e '\033[90mGenerated by GoMakeGen 1.2.0\033[0m\n'

################################################################################
