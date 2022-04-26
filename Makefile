#################################
# get package version, commit-time, git-version/hash
#################################
GIT_VERSION=$(shell git describe --always --abbrev=7 --match=NeVeRmAtCh)
COMMIT_TIME=$(shell git log -1 --format=%cd)
GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD)

#################################
# from https://github.com/linkernetworks/template-python-project/blob/master/Makefile
#################################
PACKAGE := tensorpuzzles
PYTHON := $$(which python3)
PIP := $(PYTHON) -m pip
SITEPACKAGES := $$($(PYTHON) -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")
#################################
# file control
#################################
PY_DIRS = tests
PY_SCRIPTS := $$(grep -ERIl '^\#!.+python' $(PY_DIRS) | grep -Ev '**/*.py')
PY_FILES := $$(find $(PY_DIRS) -name '*.py' | grep -v '\./\.') $(PY_SCRIPTS) setup.py
PY_DIRS_FILES := $$(find $(PY_DIRS) -name '*.py' | grep -v '\./\.') $(PY_SCRIPTS) setup.py

# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help
help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

.PHONY: version
version: ## show up versions info of package
	@echo "VERSION: $(VERSION)"
	@echo "GIT-VERSION: $(GIT_VERSION)"
	@echo "COMMIT-TIME: $(COMMIT_TIME)"

#################################
# package installation
#################################
.PHONY: install
install: install-dep ## install dependencies

.PHONY: dev
dev: install-dep install-dev ## build dev env
	@$(PYTHON) setup.py develop

.PHONY: install-dep
install-dep: ## install build and core
	@$(PIP) install -r requirements.txt

.PHONY: install-dev
install-dev:  ## install dev related

.PHONY: uninstall
uninstall: ## cleanup all packages
	@$(PYTHON) setup.py develop --uninstall
	@rm -rf $(SITEPACKAGES)/$(PACKAGE)-*.*

#################################
# do tests
#################################

.PHONY: test
test: unit-test ## do all tests

.PHONY: unit-test
unit-test: ## do unit-test
	@echo "Unit Testing..."
	@pytest test_puzzles.py
	@echo "Unit Testing passed\n"
