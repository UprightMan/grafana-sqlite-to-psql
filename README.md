# grafana-sqlite-to-psql
A simple tool based on the pgloader image that runs a script to migrate from an sqlite file to a PostgreSQL instance for Grafana

> ⚠️ **Warning:**  Make sure to first point your Grafana instance to the PostgreSQL Instance so it generates the schemas and tables

> ⚠️ **Warning:**  Make sure the Grafana instance is stopped before running the tool

### 🚀 Usage

#### 🐳 Build the migration Docker image:

```bash
docker build -t grafana-migrate .
```

#### 🔁 Run the migration:

```bash
docker run --rm \
  -e DB_USER=grafana \
  -e DB_PASS=mysecret \
  -e DB_HOST=postgres \
  -v $(pwd)/grafana.db:/data/grafana.db \
  grafana-migrate
```

> 📁 Make sure your `grafana.db` file is in the same directory you run this command from or change the run command to use the path to point to your db file.

#### 📌 Optional Environment Variables

You can override these at runtime (defaults shown):

| Variable    | Default    | Description                         |
|-------------|------------|-------------------------------------|
| `DB_HOST`   | `postgres` | Hostname of the PostgreSQL server   |
| `DB_PORT`   | `5432`     | PostgreSQL port                     |
| `DB_NAME`   | `grafana`  | Target database name                |
| `DB_USER`   | `grafana`  | PostgreSQL username                 |
| `DB_PASS`   | `password` | PostgreSQL password                 |

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)