USER_NAME=4babushkin
export USER_NAME

BRANCH=$(shell git rev-parse --abbrev-ref HEAD)

GITHASH= $(shell git show --format="%h" HEAD | head -1)

VERSION ?= latest

.PHONY: all ui bot push

all: ui bot


ui:
	echo $(GITHASH) > sources/search_engine_ui/build_info.txt
	echo $(BRANCH) >> sources/search_engine_ui/build_info.txt
	docker build --build-arg VCS_REF=${GITHASH} \
	 --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	 -t ${USER_NAME}/crawler_ui:${GITHASH} sources/search_engine_ui
	docker tag ${USER_NAME}/crawler_ui:${GITHASH} ${USER_NAME}/crawler_ui:$(VERSION)

bot:
	echo ${GITHASH} > sources/search_engine_crawler/build_info.txt
	echo $(BRANCH) >> sources/search_engine_crawler/build_info.txt
	docker build --build-arg VCS_REF=${GITHASH} \
	 --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
	 -t $(USER_NAME)/crawler_bot:${GITHASH} sources/search_engine_crawler
	docker tag $(USER_NAME)/crawler_bot:${GITHASH} $(USER_NAME)/crawler_bot:$(VERSION)
# prom:
# 	docker build --build-arg VCS_REF=${GITHASH} \
# 	 --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
# 	 -t $(USER_NAME)/prometheus:${GITHASH} monitoring/prometheus/config
# 	docker tag $(USER_NAME)/prometheus:${GITHASH} $(USER_NAME)/prometheus:$(VERSION)

# alert:
# 	docker build --build-arg VCS_REF=${GITHASH} \
# 	 --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
# 	 -t $(USER_NAME)/alertmanager:${GITHASH} monitoring/prometheus/alertmanager
# 	docker tag $(USER_NAME)/alertmanager:${GITHASH} $(USER_NAME)/alertmanager:$(VERSION)

# blackbox:
# 	docker build --build-arg VCS_REF=${GITHASH} \
# 	 --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
# 	 -t $(USER_NAME)/blackbox-exporter:${GITHASH} monitoring/prometheus/blackbox-exporter
# 	docker tag $(USER_NAME)/blackbox-exporter:${GITHASH} $(USER_NAME)/blackbox-exporter:$(VERSION)

# mongodb-exporter:
# 	docker build --build-arg VCS_REF=${GITHASH} \
# 	 --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
# 	 -t $(USER_NAME)/mongodb-exporter:${GITHASH} monitoring/prometheus/mongodb-exporter
# 	docker tag $(USER_NAME)/mongodb-exporter:${GITHASH} $(USER_NAME)/mongodb-exporter:$(VERSION)

push:
	docker push $(USER_NAME)/crawler_bot:$(VERSION)
	docker push $(USER_NAME)/crawler_bot:${GITHASH}
	docker push $(USER_NAME)/crawler_ui:$(VERSION)
	docker push $(USER_NAME)/crawler_ui:${GITHASH}
# docker push $(USER_NAME)/prometheus:$(VERSION)
# docker push $(USER_NAME)/prometheus:${GITHASH}
# docker push $(USER_NAME)/alertmanager:$(VERSION)
# docker push $(USER_NAME)/alertmanager:${GITHASH}
# docker push $(USER_NAME)/blackbox-exporter:$(VERSION)
# docker push $(USER_NAME)/blackbox-exporter:${GITHASH}
# docker push $(USER_NAME)/mongodb-exporter:$(VERSION)
# docker push $(USER_NAME)/mongodb-exporter:${GITHASH}
