# Make Dotfiles
#
# Simon H Moore <simon@simonhugh.xyz>
#
# https://github.com/simonhughxyz/dotfiles

CONFIG := "$(HOME)/.config"
HOMEDIRS := $(shell find ./HOME/ -mindepth 1 -maxdepth 1 -type d -printf "%P ")
CONFIGDIRS := $(shell find . -mindepth 1 -maxdepth 1 -type d -not -name "HOME" -not -path "*/.*" -printf "%P ")
CONFIGFILES := $(addprefix $(CONFIG)/,$(CONFIGDIRS))
HOMEFILES := $(addprefix $(HOME)/,$(HOMEDIRS))

.PHONEY: link unlink

link: | $(HOMEFILES) $(CONFIGFILES)


.PHONEY: $(DOTDIRS)
$(DOTDIRS): %: $(addprefix $(CONFIG)/,%)

$(CONFIGFILES):
	@if [ -f "$(PWD)/$(notdir $@)/Makefile" ]; then \
		echo "Run Nested Makefile"; \
		else \
		ln -sv "$(PWD)/$(notdir $@)" $@; fi

$(HOMEFILES):
	@if [ -f "$(PWD)/HOME/$(notdir $@)/Makefile" ]; then \
		echo "Run Nested Makefile"; \
		else \
		ln -sv "$(PWD)/HOME/$(notdir $@)" $@; fi

unlink:
	@for f in $(CONFIGFILES); do if [ -h $$f ]; then rm $$f; fi ; done
	@for f in $(HOMEFILES); do if [ -h $$f ]; then rm $$f; fi ; done

conflict:
	@for f in $(DOTFILES); do echo $$f ; done


print:
	@echo "$(HOMEDIRS)"
	@echo "$(HOMEFILES)"
	@echo "$(CONFIGDIRS)"
	@echo "$(CONFIGFILES)"
