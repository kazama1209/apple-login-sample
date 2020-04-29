.PHONY: init
init:
	docker-compose build

.PHONY: install
install:
	docker-compose run --rm web bundle install
	docker-compose run --rm web yarn install
	docker-compose run --rm web bin/rails db:create

.PHONY: run
run:
	rm -rf tmp/pids/*.pid
	docker-compose up