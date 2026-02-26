PYTHON ?= python3

.PHONY: help validate validate-quick test lint pycheck placeholder-scan tree

help:
	@printf "Targets:\n"
	@printf "  make validate        Run full repository validation\n"
	@printf "  make validate-quick  Run quick repository validation\n"
	@printf "  make test            Run unit tests\n"
	@printf "  make lint            Run shell/python syntax checks\n"
	@printf "  make pycheck         Compile Python helpers/tests\n"
	@printf "  make placeholder-scan  Scan for TODO/template markers\n"
	@printf "  make tree            Print repo directory tree (fallback if tree missing)\n"

validate:
	./validate_repo.sh

validate-quick:
	./validate_repo.sh --quick

test:
	$(PYTHON) -m unittest discover -s tests -p 'test_*.py' -v

lint:
	bash -n validate_repo.sh
	find scripts labs -type f -name '*.sh' -exec bash -n {} \;
	$(MAKE) pycheck

pycheck:
	$(PYTHON) -m py_compile scripts/triage_eve_sample.py tests/test_triage_eve_sample.py

placeholder-scan:
	@if command -v rg >/dev/null 2>&1; then \
		rg -n "TODO|TBD|FIXME|PLACEHOLDER|REPLACE_WITH_|lorem ipsum" . \
			--glob '!**/.git/**' \
			--glob '!validate_repo.sh' \
			--glob '!.github/workflows/**'; \
	else \
		echo "rg not installed"; \
	fi

tree:
	@if command -v tree >/dev/null 2>&1; then tree -a -I '.git'; else find . -path './.git' -prune -o -print | sort; fi
