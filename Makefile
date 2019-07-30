USER_NAME=4babushkin
export USER_NAME

BRANCH=$(shell git rev-parse --abbrev-ref HEAD)

GITHASH= $(shell git show --format="%h" HEAD | head -1)

VERSION ?= latest

.PHONY: all ui bot push

all: ui bot


ui:
	echo $(GITHASH) > sources/crawler_ui/build_info.txt
	echo $(BRANCH) >> sources/crawler_ui/build_info.txt
	docker build --build-arg VCS_REF=${GITHASH} \
	 --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	 -t ${USER_NAME}/crawler_ui:${GITHASH} sources/crawler_ui
	docker tag ${USER_NAME}/crawler_ui:${GITHASH} ${USER_NAME}/crawler_ui:$(VERSION)

bot:
	echo ${GITHASH} > sources/crawler/build_info.txt
	echo $(BRANCH) >> sources/crawler/build_info.txt
	docker build --build-arg VCS_REF=${GITHASH} \
	 --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	 -t $(USER_NAME)/crawler:${GITHASH} sources/crawler
	docker tag $(USER_NAME)/crawler:${GITHASH} $(USER_NAME)/crawler:$(VERSION)

push:
	docker push $(USER_NAME)/crawler:$(VERSION)
	docker push $(USER_NAME)/crawler:${GITHASH}
	docker push $(USER_NAME)/crawler_ui:$(VERSION)
	docker push $(USER_NAME)/crawler_ui:${GITHASH}
