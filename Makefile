# Change these 2 variables to your liking
TARBALL=rawtherapee.tar.gz
INSTALL_DIR=$(HOME)/.local

IMAGE=rawtherapee_builder
UID=$(shell id -u)
GID=$(shell id -g)

help:
	@echo "Supported targets:"
	@echo "\tbuild\t\tbuilds an image with RawTherapee's source code and a"
	@echo  "\t\t\ttarball of the installation files"
	@echo "\ttarball\t\tcopies the tarball of the installation files to the"
	@echo "\t\t\tcurrent directory"
	@echo "\tinspect\t\truns a shell in the container to inspects RawTherapee's"
	@echo "\t\t\tsources and tarball"
	@echo "\tinstall\t\tinstalls TARBALL to INSTALL_DIR on the host"
	@echo "\tclean\t\tdelete TARBALL"
	@echo "\tmrproper\tdelete TARBALL and delete the container image"
	@echo "\nWhere:"
	@echo "\tTARBALL is the env. variable that specifies the name of the tarball"
	@echo "\t\t\tarchive"
	@echo "\tCurrent TARBALL value: $(TARBALL)"
	@echo "\tINSTALL_DIR is the env. variable that specifies where RawTherapee"
	@echo "\t\t\tmust be installed"
	@echo "\tCurrent INSTALL_DIR value: $(INSTALL_DIR)"
	@echo "\nUsage examples:"
	@echo "- Creates rawtherapee.tar.gz (default name) from RawTherapee's installation"
	@echo "  files and installs it into ~/.local (default installation dir.) on the host:"
	@echo "  \$$ make install"
	@echo "- Creates rt.tgz from RawTherapee's installation files and installs it into"
	@echo "  /tmp on the host:"
	@echo "  \$$ make TARBALL=rt.tgz INSTALL_DIR=/tmp install"

build:
	docker build --build-arg UID=$(UID) --build-arg GID=$(GID) --build-arg TARBALL=$(TARBALL) --build-arg INSTALL_DIR=$(INSTALL_DIR) . -t $(IMAGE)

tarball: build
	docker run -e TARBALL=$(TARBALL) --user $(UID):$(GID) --rm --mount type=bind,src=$(PWD),dst=/shared $(IMAGE)

inspect: build
	docker run --user $(UID):$(GID) -it --rm --mount type=bind,src=$(PWD),dst=/shared $(IMAGE) bash

install: tarball
	-mkdir -p $(INSTALL_DIR)
	tar fxz $(TARBALL) -C $(INSTALL_DIR)

clean:
	-rm -f $(TARBALL)

mrproper: clean
	-docker rmi $(IMAGE)
