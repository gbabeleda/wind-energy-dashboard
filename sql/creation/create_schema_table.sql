-- Script creates the schema and the table if they dont exist yet in the connected database
CREATE SCHEMA IF NOT EXISTS wind_sites;

CREATE TABLE IF NOT EXISTS wind_sites.upd_wind_site (
    id SERIAL PRIMARY KEY,
    date_time TIMESTAMP NOT NULL,
    wind_speed DECIMAL NOT NULL,
    gust_speed DECIMAL NOT NULL,
    wind_direction DECIMAL NOT NULL
);