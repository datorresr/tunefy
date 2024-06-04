#!/bin/bash

# Update package list and install PostgreSQL
sudo apt-get update
sudo apt-get -y install postgresql postgresql-contrib

# Copy init.sql to the PostgreSQL directory
sudo cp /tmp/init.sql /var/lib/postgresql/init.sql

# Run init.sql as the postgres user
sudo -u postgres psql -f /var/lib/postgresql/init.sql