MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(patsubst %/,%,$(dir $(MKFILE_PATH)))

TARGET := lzfse.go

all : $(TARGET)

build:
	go build -v -x .

install:
	go install -v -x .

vendor/lzfse:
	git submodule update --init
	cd $(CURRENT_DIR)/vendor/lzfse && \
	make && \
	make install INSTALL_PREFIX=$(CURRENT_DIR) && \
	mv $(CURRENT_DIR)/include/lzfse.h $(CURRENT_DIR) && \
	${RM} -r $(CURRENT_DIR)/bin $(CURRENT_DIR)/include && \
	chmod 644 $(CURRENT_DIR)/lzfse.h

$(TARGET): cgogen.yml vendor/lzfse
	@cgogen cgogen.yml
	@mv -f lzfse/* .
	@${RM} -r lzfse

clean:
	${RM} -r lib vendor/lzfse

.PHONY: build install clean
