build:
	docker-compose build

start:
	docker-compose up

bash:
	docker-compose exec web bash

specs:
	docker-compose exec web bundle exec rspec .
