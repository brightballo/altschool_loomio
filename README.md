# Loomie App: Directions for Local Deployment using Docker

## Prerequisites:
- Docker
- A running Redis Container
- A running Postgres container/server running at port 5432

## Step 1: Start redis container

First pull the image:
```sh
docker pull redis
```

Then run a redis container:
```sh
docker run --name my-redis -p 6379:6379 -d redis
```

## Step 2: Start postgres container and create credentials

First pull the image:
```sh
docker pull postgres
```

Then run the images:
```sh
docker run --name <container_name> -v /data:/var/lib/postgresql/data -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=your_password -p 5432:5432 -d postgres

```

Then exec into the postgres container and create a db:
```sh
docker exec -it -u postgres <container_name> psql

CREATE DATABASE loomio_development; # this creates a db for development
```

exit the container.

Now your db is ready to connect with the backend

## Step 3: Run the app

First pull the image:

```sh
docker pull 4568910/loomio_image:v1
```

Next, run the run the app container, while ensuring to pass in your envs like so:
```sh
docker run -dit --network=host --name loomio -e DB_USERNAME=postgres -e DB_PASSWORD=12345 <imageID_OR_name>
```

*N.B: Ensure that the username and password are the same with what you set in the postgres DB*

** Did you notice that I set ```--network=host```? This spares us from having to bind ports manually.**


## Step 4: Test the app

If you did everything correctly to this point, the app should be running just fine.

You can go ahead to visit [localhost:8080/dev/](http://localhost:8080/dev/) and try out the different parts of the app.

