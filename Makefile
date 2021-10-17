# Change these 2 variables to your liking
ARCHIVE=rawtherapee.tar.gz
INSTALL_DIR=$(HOME)/.local

IMAGE=rawtherapee_builder
UID=$(shell id -u)
GID=$(shell id -g)

help:
	@echo "Supported targets:"
	@echo "\tbuild\t\tbuilds the container image"
	@echo "\tarchive\t\tbuilds the RawTherapee ARCHIVE in the current directory"
	@echo "\tinspect\t\truns a shell in the build container and inspects the source contents"
	@echo "\tinstall\t\tinstalls ARCHIVE to INSTALL_DIR"
	@echo "\tclean\t\tdelete ARCHIVE"
	@echo "\tmrproper\tdelete ARCHIVE and delete the container image"
	@echo "\nWhere:"
	@echo "\tARCHIVE is the env. variable that specifies the name of the archive"
	@echo "\tINSTALL_DIR is the env. variable that specifies the installation directory"
	@echo "\nUsage example:"
	@echo "The command below builds RawTherapee as the rt.tgz archive, then it installs it into ~/.local:"
	@echo "make ARCHIVE=rt.tgz INSTALL_DIR=~/.local install"

build:
	docker build . -t $(IMAGE)

archive: build
	docker run -e ARCHIVE=$(ARCHIVE) --user $(UID):$(GID) --rm --mount type=bind,src=$(PWD),dst=/shared $(IMAGE)

inspect: build
	docker run -e ARCHIVE=$(ARCHIVE) --user $(UID):$(GID) -it --rm --mount type=bind,src=$(PWD),dst=/shared $(IMAGE) bash

install: $(ARCHIVE)
	tar fxz $< -C $(INSTALL_DIR)

clean:
	-rm -f $(ARCHIVE)

mrproper: clean
	-docker rmi $(IMAGE)
