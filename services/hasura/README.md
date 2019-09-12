# Hasura ORM Service

## Hasura Server

The goal of this project is to provide access to a Postgres Database through a GraphQL based API built with [Hasura](https://hasura.io/).

## Stack

- Docker Compose for running the web and database server
- Docker Image: Hasura (latest), Postgres (latest)

## Developer Setup

### Prerequisites

- Install Hasura CLI

  `curl -L https://github.com/hasura/graphql-engine/raw/master/cli/get.sh | bash`

- [Hasura Bash Completion](https://docs.hasura.io/1.0/graphql/manual/hasura-cli/hasura_completion.html#hasura-completion) - Optional install
- [Docker CE](https://store.docker.com/search?type=edition&offering=community)
- [Docker Compose](https://docs.docker.com/compose/)

### Setup Steps

If you have other Docker containers with Postgres DB's running, it is a recommended to stop them as they may be connecting to the same ports.
If you are running locally, ensure you are connected to the VPN in order to successfully authenticate with external resources which require white listed IP's. API Keys will be provided from AWS SSM at build.

1. `git clone https://github.com/orionllc/orionmono.git`
1. `cd orionmono`
1. `yarn install`
1. `yarn workspaces run build`
1. `cd services/hasura`
1. `cp .env.sample .env`
1. Modify .env to supply a
   - HASURA_GRAPHQL_DATABASE_URL=postgres://postgres:@postgres:5432/postgres
   - HASURA_GRAPHQL_ENABLE_CONSOLE=true
   - HASURA_GRAPHQL_ENABLE_TELEMETRY=false
1. `docker-compose pull`
1. `docker-compose build`
1. `docker-compose up`
1. Server will be available at `localhost:80/console`

## Database URL's

The HASURA_GRAPHQL_DATABASE_URL will initially be set to a locally created Postgres Database provided by the Docker container Hasura provides.
To connect to a different database, update the ENV to include username, password, url and database name.

## Interacting with the Admin Console

## DB Dump

The dump file is used to restore the database structure and all the data.

Find the postgres docker container id: <br/>
`docker ps`

### Create a db dump

`` docker exec -t **CONTAINER ID** pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql ``

### Restore a db dump into postgres

`cat your_dump.sql | docker exec -i your-db-container-id psql -U postgres` <br/><br/>
Replace `your_dump.sql` with the name of your dump file and `your-db-container-id` with the id of your postgres container.

## Migrations

Migrations in Hasura are created either through the admin console or manually created migration files.

### Create Migration Files through the Admin console

1. Update the `HASURA_GRAPHQL_ENABLE_CONSOLE` environment variable from `true` to `false`. Changes made through the console served by the cli tool may not take effect if the admin console is live.
1. Open the cli console `hasura console --endpoint http://127.0.0.1:80`
1. Your browser should open to the CLI console `http://localhost:9695/`
1. For each change made to the database (Creating tables, adding relationships, etc.), a set of migration files will be created in `./migrations`.
1. Once complete, `CTRL + C` will stop the CLI console.

### Create Migration Files manually

Creating Migration Files manually allows SQL for Postgres Schema and YAML for Hasura metadata actions.

1. Create the up and down migration files:
   `hasura migrate create <name-of-migration>`
1. Edit the migration file. [File Format Details](https://docs.hasura.io/1.0/graphql/manual/migrations/reference/migration-file-format.html)
1. Apply the migrations [See Applying Migration Files](###applying)

### Applying Migration Files

To run all of the migrations within the migrations directory,

`hasura migrate apply --endpoint localhost:80`

Migrations will be run if necessary.

To check the status of migrations:

`hasura migrate status`

This command will print out each migration version present in the migrations directory and the ones applied on the database, along with a status text.

Example:
|VERSION |SOURCE STATUS | DATABASE STATUS |
|---|---|---|
| 1550925483858 | Present | Present |
| 1550931962927 | Present | Present |
| 1550931970826 | Present | Present |

If `SOURCE STATUS` indicates `Not Present`, it means that the migration version is present on the server, but not on the current user’s local directory. This typically happens if multiple people are collaborating on a project and one of the collaborator forgot to pull the latest changes which included the latest migration files or another collaborator forgot to push the latest migration files that were applied on the database. Syncing of the files would fix the issue.

If `DATABASE STATUS` indicates `Not Present`, it denotes that there are new migration versions in the local directory which are not applied on the database yet. Executing a migrate apply would take care of such scenarios.

### Exporting Metadata

All the actions performed in the admin console, like tracking tables/views/functions, creating relationships, configuring permissions, creating event triggers and remote schemas, etc. can be exported as a JSON file which can be version controlled.

1. Visit: `localhost:80`
1. Click on the Settings gear icon at the top right corner of the console screen.
1. In the Settings page that open, click on the `Export Metadata` button.
1. This will prompt a file download for `metadata.json`. Save the file.

### Importing Metadata

1. Click on the Settings gear icon at the top right corner of the console screen.
1. Click on `Import Metadata` button.
1. Choose a `metadata.json` file to be imported.
1. A notification should appear indicating the success or error.

.
