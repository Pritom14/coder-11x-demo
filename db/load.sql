CREATE TABLE IF NOT EXISTS events (id bigserial PRIMARY KEY, account_id int REFERENCES accounts(id), at timestamptz NOT NULL);
TRUNCATE events;
INSERT INTO events (account_id, at)
SELECT 1 + (g % 3), now() - (g || ' seconds')::interval FROM generate_series(1, 100000) g;
SELECT count(*) AS events FROM events;
