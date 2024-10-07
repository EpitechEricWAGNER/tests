CREATE TABLE IF NOT EXISTS "users" (
    "id" SERIAL PRIMARY KEY,
    "username" VARCHAR(255) NOT NULL CHECK (username <> ''),
    "email" VARCHAR(255) NOT NULL CHECK (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9._%-]+\.[A-Za-z]{2,}$'),
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS "clocks" (
    "id" SERIAL PRIMARY KEY,
    "time" TIMESTAMP NOT NULL,
    "status" BOOLEAN NOT NULL,
    "user_id" INTEGER NOT NULL REFERENCES "users" ("id"),
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

CREATE TABLE IF NOT EXISTS "workingtime" (
    "id" SERIAL PRIMARY KEY,
    "start" TIMESTAMP NOT NULL,
    "end" TIMESTAMP NOT NULL,
    "user_id" INTEGER NOT NULL REFERENCES "users" ("id"),
    "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
