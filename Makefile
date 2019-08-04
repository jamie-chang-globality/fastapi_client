.DEFAULT_GOAL := default
pkg_src = example
tests_src = tests

isort = isort -rc $(pkg_src) $(tests_src)
black = black $(pkg_src) $(tests_src)
flake8 = flake8 $(pkg_src) $(tests_src)
mypy = mypy $(pkg_src)


.PHONY: format
format:
	$(isort)
	$(black)

.PHONY: check-format
check-format:
	$(isort) --check-only
	$(black) --check
	@echo "No format problems"

.PHONY: lint
lint:
	$(flake8)
	@echo "No flake8 problems"

.PHONY: mypy
mypy:
	$(mypy)
	@echo "No mypy problems"

.PHONY: test
test:
	./scripts/test.sh
	@echo "All tests passed"

.PHONY: testcov
testcov:
	./scripts/testcov.sh
	@echo "opening coverage html in browser"
	@open htmlcov/index.html

.PHONY: default
default: check-format lint mypy test

.PHONY: regenerate
regenerate:
	./scripts/regenerate-example.sh
	@echo "Regeneration succeeded"

.PHONY: clean
clean:
	rm -rf `find . -name __pycache__`
	rm -f `find . -type f -name '*.py[co]' `
	rm -f `find . -type f -name '*~' `
	rm -f `find . -type f -name '.*~' `
	rm -rf `find . -type d -name '*.egg-info' `
	rm -rf `find . -type d -name 'pip-wheel-metadata' `
	rm -rf .cache
	rm -rf .pytest_cache
	rm -rf .mypy_cache
	rm -rf htmlcov
	rm -rf *.egg-info
	rm -f .coverage
	rm -f .coverage.*
	rm -rf generated

.PHONY: lock
lock:
	poetry lock

.PHONY: develop
develop:
	./scripts/develop.sh