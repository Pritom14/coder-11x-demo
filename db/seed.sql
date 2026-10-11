CREATE TABLE IF NOT EXISTS accounts (id serial PRIMARY KEY, name text UNIQUE NOT NULL);
INSERT INTO accounts (name) VALUES ('acme'), ('globex'), ('initech') ON CONFLICT DO NOTHING;
SELECT count(*) AS accounts FROM accounts;
