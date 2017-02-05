NAME="multiroomaudio"

NETNAME="mylan"
SUBNET="192.168.5.0/24"
GATEWAY="192.168.5.1"
DEVICE="eth0"

SPOTIFYUSER=""
SPOTIFYPASS=""

.PHONY: build run stop destroy lan

all:
	make lan
	make stop
	make destroy
	make build
	make run

lan:
	docker network create \
		-d macvlan \
		--subnet=$(SUBNET) \
		--gateway=$(GATEWAY) \
		-o parent=$(DEVICE) \
		$(NETNAME)

build:
	docker build --rm --pull --tag $(NAME) .

run:
	docker run -itd \
		--name=$(NAME) \
		--hostname=$(NAME) \
		--restart=always \
		--network=$(NETNAME) \
		--tmpfs /tmp:size=512M \
		$(NAME)

destroy:
	make stop
	docker rm $(NAME)
