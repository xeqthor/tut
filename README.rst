



docker-compose build --pull base

    # build the remaining container images
    docker-compose build

To run only the frontend in development::

    docker-compose up

You can then access application in browser via http://localhost:8000

Custom compose files
````````````````````

To run the app with different compose files, use the -f argument to override whatever is set in the .env file, e.g::

    docker-compose -f docker-compose.yml -f docker-compose.devel.yml up --build nginx



Migrations
~~~~~~~~~~

Don't forget to run migrations!

You may either run it as an one-off::

    docker-compose run --rm --user=$UID uwsgi django-admin migrate

Or exec a command inside the uwsgi container (if it already runs)::

    docker-compose exec uwsgi django-admin migrate


Reset database
``````````````

If migrations have been recreated run this to drop all your tables and data, and recreate everything from scratch::

    docker-compose build --pull base
    docker-compose build
    docker-compose up -d pg
    docker-compose exec --user=postgres pg dropdb fin
    docker-compose exec --user=postgres pg createdb fin
    docker-compose run --user=$UID uwsgi django-admin fin
    docker-compose run --user=$UID uwsgi django-admin createsuperuser

.. warning::

    Note that if you don't use ``--user=$UID`` you'll get root-owned files all over the place.

    If your shell doesn't provide an ``UID`` variable then use ``--user=$(id --user "$USER")`` instead.


