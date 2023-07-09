# Oyasumi

A JSON API to help you sleep better!

## Dependencies:

- **PostgreSQL** >= 14.1
- **Ruby** 3.2.2

## Running with Docker

Use `docker-compose` to run:

```shell
cd oyasumi
docker-compose up -d
```

If running for the first time, create the databases:

```shell
docker exec oyasumi_app_1 rails db:setup
```

Then go wild: http://localhost:3000/

### Running the tests

Check out the tests if you want an overview of what the app can do:

```shell
docker exec oyasumi_app_1 rspec -fd
```

## Resources

TODO: List the endpoints and options for people to use

### Mock Data

TODO: Mention seed data and add rake task for filling the database with some mock data so its easy to see how the following sleeps list works.
