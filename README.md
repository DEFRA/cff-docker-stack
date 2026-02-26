# CFF Docker Stack

This repository contains Docker Compose configurations for running the Check for Flooding (CFF) application stack in various configurations.

## Available Components

- `flood-app`: Frontend application
- `flood-service`: Backend API service
- `flood-db`: PostgreSQL database
- `flood-gis`: GeoServer for spatial data
- `flood-cache`: Redis cache server
- `flood-proxy`: Nginx proxy server

## Local Database Provisioning

The stack uses the `flood-db` component which is built from the [flood-db repository](https://github.com/DEFRA/flood-db).

For detailed instructions on creating a local copy of the flood database, refer to the [README in the `docker` subdirectory of the flood-db repository](https://github.com/DEFRA/flood-db/tree/master/database/flooddev/u_flood/setup/docker#readme). This documentation explains how to:

- Set up a local PostgreSQL database with the correct schema
- Import data from a cloud environment
- Configure the database for local development

### Volume Management

The stack uses external volumes for local PostgreSQL data:

- `flood-db-pgdata`: For PostgreSQL data files
- `flood-db-wiyby`: For additional data

Following the instructions for local database provisioning correctly will result in required volume creation.
The required volumes can also be created by running the following commands manually **before** a local database is provisioned.

```bash
docker volume create flood-db-pgdata
docker volume create flood-db-wiyby
```

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

Run the following script from the project root directory to generate a self-signed certificate (valid for twelve months) supporting Redis Transport Layer Security:

```bash
tls/scripts/generate-redis-cert.sh
```

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

### Running Unit Tests

#### flood-app (using an existing container)

```bash
docker compose exec flood-app npm run test:no-coverage
```

#### flood-service (using an existing container)

```bash
docker compose exec flood-service npm run test:no-coverage
```

#### flood-app and flood-service

```bash
docker compose -f docker-compose.yml -f docker-compose-test.yml up --build flood-app flood-service
```

### Running Service Tests - may not work

```bash
docker compose run --build flood-service-tests npx wdio ./wdio.conf.js
```

### Running Specific Tests - may not work

```bash
docker compose run --build flood-service-tests npx wdio ./wdio.conf.js --spec test/stations-test.js --mochaOpts.grep "Must display, the correct timestamp tooltip"
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
