IMAGE=rawtherapee_builder
ARCHIVE=rawtherapee.tar.gz
UID=$(shell id -u)
GID=$(shell id -g)

$(ARCHIVE): build
	docker run --user $(UID):$(GID) --rm --mount type=bind,src=$(PWD),dst=/shared $(IMAGE)

inspect: build
	docker run --user $(UID):$(GID) -it --rm --mount type=bind,src=$(PWD),dst=/shared $(IMAGE) bash

build:
	docker build . -t $(IMAGE)

clean:
	-rm -f $(ARCHIVE)
