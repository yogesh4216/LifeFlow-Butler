BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "meeting" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "email_summary" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "briefing" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "summary" text NOT NULL,
    "priority" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION DROP TABLE
--
DROP TABLE "task" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "task" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "description" text,
    "date" timestamp without time zone NOT NULL,
    "time" text NOT NULL,
    "priority" text NOT NULL,
    "completed" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


--
-- MIGRATION VERSION FOR lifeflow_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('lifeflow_butler', '20260129163104910', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129163104910', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260109031533194', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260109031533194', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
