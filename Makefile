DIR = .
FILE = Dockerfile
IMAGE = m2p
TAG = latest

.PHONY: build rebuild test tag pull login push

build:
	sudo docker build -t $(IMAGE) -f $(DIR)/$(FILE) $(DIR)

rebuild:
	sudo docker build --no-cache -t $(IMAGE) -f $(DIR)/$(FILE) $(DIR)

test:
	true

tag:
	docker tag $(IMAGE) $(IMAGE):$(TAG)

login:
	yes | docker login --username $(USER) --password $(PASS)

push:
ifndef TAG
	docker push $(IMAGE)
else
	docker push $(IMAGE):$(TAG)
endif

bash-enter:
	sudo docker run --rm --name $(IMAGE) -it --entrypoint=bash --privileged -p 9158:9158 -v /home/kane/git/prometheus-jsonpath-exporter/app/config.yaml:/opt/prometheus-jsonpath-exporter/config.yaml $(ARG) $(IMAGE)

run:
	sudo docker run --rm --name $(IMAGE) --privileged -p 9158:9158 -v /home/kane/git/prometheus-jsonpath-exporter/app:/opt/config $(ARG) $(IMAGE) /opt/config/config.yml
exec:
	docker exec -it $(shell docker ps -q --filter "name=$(subst /,-,$(IMAGE))") bash

secret:
	kubectl create secret -n metrics generic exporter.yml --from-file=../prometheus-jsonpath-exporter/exporter.yml
