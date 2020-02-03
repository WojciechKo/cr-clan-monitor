Clash Royale - Clan Monitor

# Development

## Setup Postgres
`docker-compose run api rake db:create` - Initialize database  
`docker-compose run api rake db:migrate` - Migrate database schema

## Run application
`docker-compose up --build frontend` - Run the application

## Quick links

[Api](http://localhost:300)
[Frontend](http://localhost:8080)
[Sidekiq admin panel](http://localhost:3000/sidekiq)

## Rake tasks

`docker-compose run api rake update_clan:members\[Y8YU8L08\]` - Fetch members of the clan with tag `Y8YU8L08`
