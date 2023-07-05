BEGIN;

DROP TABLE IF EXISTS mean_temperature CASCADE;

CREATE TABLE mean_temperature(
    staid integer,
    date date,
    tg integer
);
\copy mean_temperature FROM '../data/mean_temperature.csv' WITH (HEADER true, FORMAT csv);

COMMIT;