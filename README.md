# CFF Docker Stack

This repository contains Docker Compose configurations for running the Check for Flooding (CFF) application stack in various configurations.

## Available Components

- `flood-app`: Frontend application
- `flood-service`: Backend API service
- `flood-db`: PostgreSQL database
- `flood-gis`: GeoServer for spatial data
- `flood-cache`: Redis cache server
- `flood-proxy`: Nginx proxy server

## Running the Stack

### Local Stack

Note: flood-gis is not currently working so flood-app should be configured to point at the dev env geoserver through FLOOD_APP_GEOSERVER_URL env var in `docker-compose.yml`

To run a minimal local stack:

```bash
docker compose up --build flood-app flood-service flood-db
```

### Using Remote Database

Update FLOOD_SERVICE_CONNECTION_STRING in `docker-compose.yml` to point at the DB in one of the environments (e.g. dev)

```bash
docker compose up --build flood-app flood-service
```

### Adding Redis Cache

To include Redis caching with the stack:

```bash
docker compose -f docker-compose.yml -f docker-compose-redis-7.yml up --build flood-app flood-service flood-db flood-cache
```

### Adding Nginx Proxy

To run the stack with an Nginx proxy in front:

```bash
docker compose -f docker-compose.yml -f docker-compose-nginx.yml up --build flood-app flood-service flood-db flood-proxy
```

### Full Production-like Stack

To run a complete production-like stack with all components:

```bash
docker compose -f docker-compose.yml -f docker-compose-redis-7.yml -f docker-compose-nginx.yml up --build
```

## Debugging

For debugging Node.js applications:

```bash
docker compose -f docker-compose.yml -f docker-compose-debug.yml up --build
```

Then connect to the debug port (9229) using Chrome DevTools or your IDE.

## Running Tests

### Running Application Tests

```bash
docker compose exec flood-app npm test
```

### Running Service Tests - may not work

```bash
docker compose run --build flood-service-tests npx wdio ./wdio.conf.js
```

### Running Specific Tests - may not work

```bash
docker compose run --build flood-service-tests npx wdio ./wdio.conf.js --spec test/stations-test.js --mochaOpts.grep "Must display, the correct timestamp tooltip"
```

## Database Setup

The stack uses the `flood-db` component which is built from the [flood-db repository](https://github.com/DEFRA/flood-db). 

For detailed instructions on creating a local copy of the flood database, refer to the README in the `docker` subdirectory of the flood-db repository. This documentation explains how to:

- Set up a local PostgreSQL database with the correct schema
- Import data from production or pre-production environments
- Configure the database for local development

## Volume Management

The stack uses external volumes for PostgreSQL data:

- `flood-db-pgdata`: For PostgreSQL data files
- `flood-db-wiyby`: For additional data

Make sure these volumes exist before starting the stack:

```bash
docker volume create flood-db-pgdata
docker volume create flood-db-wiyby
```

## Network

All services are connected to the `cff-internal` network for internal communication.

## Contributing to this project

If you have an idea you'd like to contribute please log an issue.

All contributions should be submitted via a pull request.

## License

THIS INFORMATION IS LICENSED UNDER THE CONDITIONS OF THE OPEN GOVERNMENT LICENCE found at:

[http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3)

The following attribution statement MUST be cited in your products and applications when using this information.
> Contains public sector information licensed under the Open Government license v3
