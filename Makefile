# Make Dotfiles
#
# Simon H Moore <simon@simonhugh.xyz>
#
# https://github.com/simonhughxyz/dotfiles

CONFIG := "$(HOME)/.config"
DOTDIRS := $(shell find . -mindepth 1 -maxdepth 1 -type d -not -path "*/.*" -printf "%P ")
DOTFILES := $(addprefix $(CONFIG)/,$(DOTDIRS))

.PHONEY: link unlink

link: | $(DOTFILES)


.PHONEY: $(DOTDIRS)
$(DOTDIRS): %: $(addprefix $(CONFIG)/,%)

$(DOTFILES):
	@if [ -f "$(PWD)/$(notdir $@)/Makefile" ]; then \
		echo "Run Nested Makefile"; \
		else \
		ln -sv "$(PWD)/$(notdir $@)" $@; fi

unlink:
	@for f in $(DOTFILES); do if [ -h $$f ]; then rm $$f; fi ; done

conflict:
	@for f in $(DOTFILES); do echo $$f ; done


print:
	@echo "$(DOTDIRS)"
	@echo "$(DOTFILES)"
