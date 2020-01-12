[![Build Status](https://travis-ci.org/WojciechKo/cr-clan-monitor.svg?branch=master)](https://travis-ci.org/WojciechKo/cr-clan-monitor)

# Clash Royale: Clan Monitor

This application tracks an activity of a Players from a Clan from Clash Royale
 and then presents it in an informative way so it's easier to detect the Player
who is a member of the Clan for a while but is not participating in Clan Wars.

# Development setup

## Create the database
`docker-compose run web rake db:create`

## Run database migrations
`docker-compose run web rake db:migrate`

## Run the server
`docker-compose up --build web`

## Run specs
`docker-compose run web bundle exec rspec`
