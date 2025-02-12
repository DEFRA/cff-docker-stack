# Running CFF stack and tests

```
docker compose up --build flood-app flood-service flood-db flood-gis
docker compose exec flood-app npm test
docker compose run --build flood-service-tests npx wdio ./wdio.conf.js --spec test/stations-test.js --mochaOpts.grep "Must display, the correct timestamp tooltip"
```
