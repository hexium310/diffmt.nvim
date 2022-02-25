.DEFAULT_GOAL := test

dependencies_root := tests/dependencies
plenary := https://github.com/nvim-lua/plenary.nvim
plenary_root := $(dependencies_root)/plenary.nvim

define run
	@nvim \
		--headless \
		-u ./tests/init.lua \
		-c "lua require('plenary.test_harness').test_directory('./tests/tests/$1', { minimal_init = './tests/init.lua' })" \
		-c "qa!"
endef

clone_dependencies:
	@if [ ! -d "$(plenary_root)" ]; then \
		echo "Cloning $(plenary)"; \
		git clone --quiet $(plenary) $(plenary_root); \
	fi


.PHONY: test
test: clone_dependencies
	$(call run)

# vim:noexpandtab
