image=rawtherapee_builder
archive=rawtherapee.tar.gz

$(archive): build
	docker run --rm --mount type=bind,src=$(PWD),dst=/shared $(image)

inspect: build
	docker run -it --rm --mount type=bind,src=$(PWD),dst=/shared $(image) bash

build:
	docker build . -t $(image)

clean:
	-rm -f $(archive)
