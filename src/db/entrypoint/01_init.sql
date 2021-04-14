----------------------------------------
-- _aqueduct_version_pgsql table
DROP TABLE IF EXISTS "_aqueduct_version_pgsql";
CREATE TABLE "public"."_aqueduct_version_pgsql" (
    "versionnumber" integer NOT NULL,
    "dateofupgrade" timestamp NOT NULL,
    CONSTRAINT "_aqueduct_version_pgsql_versionnumber_key" UNIQUE ("versionnumber")
) WITH (oids = false);

INSERT INTO "_aqueduct_version_pgsql" ("versionnumber", "dateofupgrade") VALUES
(1,	'2020-11-30 17:32:04.287124');


----------------------------------------
-- users table
DROP TABLE IF EXISTS "users";
DROP SEQUENCE IF EXISTS users_userid_seq;
CREATE SEQUENCE users_userid_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;

CREATE TABLE "public"."users" (
    "userid" bigint DEFAULT nextval('users_userid_seq') NOT NULL,
    "email" text NOT NULL,
    "firstname" text NOT NULL,
    "lastname" text NOT NULL,
    CONSTRAINT "users_email_key" UNIQUE ("email"),
    CONSTRAINT "users_pkey" PRIMARY KEY ("userid")
) WITH (oids = false);

INSERT INTO "users" ("email", "firstname", "lastname") VALUES
('max@test.de',	'Max',	'Mustermann'),
('anna@test.de',	'Anna',	'Bolika'),
('klaus@test.de',	'Klaus',	'Trophobie'),
('claire@test.de',	'Claire',	'Grube'),
('ariel@test.de',	'Ariel',	'L'),
('jan@test.de',	'Jan',	'F'),
('david@test.de',	'David',	'K');


----------------------------------------
-- projects table
DROP TABLE IF EXISTS "projects";
DROP SEQUENCE IF EXISTS projects_projectid_seq;
CREATE SEQUENCE projects_projectid_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;

CREATE TABLE "public"."projects" (
    "projectid" bigint DEFAULT nextval('projects_projectid_seq') NOT NULL,
    "name" text NOT NULL,
    "isarchived" boolean DEFAULT false NOT NULL,
    CONSTRAINT "projects_pkey" PRIMARY KEY ("projectid")
) WITH (oids = false);

INSERT INTO "projects" ("name", "isarchived") VALUES
('BeeBusy',	'0'),
('Wedding',	'0'),
('Archived',	'1');


----------------------------------------
-- tasks table
DROP TABLE IF EXISTS "tasks";
DROP SEQUENCE IF EXISTS tasks_taskid_seq;
CREATE SEQUENCE tasks_taskid_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;

CREATE TABLE "public"."tasks" (
    "taskid" bigint DEFAULT nextval('tasks_taskid_seq') NOT NULL,
    "title" text NOT NULL,
    "description" text NOT NULL,
    "deadline" timestamp NOT NULL,
    "created" timestamp NOT NULL,
    "status" text DEFAULT 'todo' NOT NULL,
    "project_projectid" bigint NOT NULL,
    CONSTRAINT "tasks_pkey" PRIMARY KEY ("taskid"),
    CONSTRAINT "tasks_project_projectid_fkey" FOREIGN KEY (project_projectid) REFERENCES projects(projectid) ON DELETE CASCADE NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "tasks_project_projectid_idx" ON "public"."tasks" USING btree ("project_projectid");

INSERT INTO tasks (project_projectId, title, description, status, created, deadline) VALUES
    (1, 'Create database', 'Create a new sql database table', 'todo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (1, 'Create UI', '', 'inProgress', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (1, 'Write tests', 'write unit and integration tests', 'todo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (1, 'Write Dockerfile', 'Create Dockerfile for app', 'todo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (2, 'Bake cake', 'Bake a cake for the wedding', 'todo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (2, 'Invite guests', 'invite some guests', 'todo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    (3, 'Invite guests', 'invite some guests', 'todo', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


----------------------------------------
-- project_members table
DROP TABLE IF EXISTS "project_members";
DROP SEQUENCE IF EXISTS project_members_id_seq;
CREATE SEQUENCE project_members_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;

CREATE TABLE "public"."project_members" (
    "id" bigint DEFAULT nextval('project_members_id_seq') NOT NULL,
    "user_userid" bigint NOT NULL,
    "project_projectid" bigint NOT NULL,
    CONSTRAINT "project_members_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "project_members_unique_idx" UNIQUE ("project_projectid", "user_userid"),
    CONSTRAINT "project_members_project_projectid_fkey" FOREIGN KEY (project_projectid) REFERENCES projects(projectid) ON DELETE CASCADE NOT DEFERRABLE,
    CONSTRAINT "project_members_user_userid_fkey" FOREIGN KEY (user_userid) REFERENCES users(userid) ON DELETE CASCADE NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "project_members_project_projectid_idx" ON "public"."project_members" USING btree ("project_projectid");

CREATE INDEX "project_members_user_userid_idx" ON "public"."project_members" USING btree ("user_userid");

INSERT INTO "project_members" ("user_userid", "project_projectid") VALUES
(2,	3),
(5,	1),
(6,	1),
(7,	1),
(7,	2),
(3,	2);


----------------------------------------
-- task_assignees table
DROP TABLE IF EXISTS "task_assignees";
DROP SEQUENCE IF EXISTS task_assignees_id_seq;
CREATE SEQUENCE task_assignees_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 9223372036854775807 START 1 CACHE 1;

CREATE TABLE "public"."task_assignees" (
    "id" bigint DEFAULT nextval('task_assignees_id_seq') NOT NULL,
    "projectmember_id" bigint NOT NULL,
    "task_taskid" bigint NOT NULL,
    CONSTRAINT "task_assignees_pkey" PRIMARY KEY ("id"),
    CONSTRAINT "task_assignees_unique_idx" UNIQUE ("projectmember_id", "task_taskid"),
    CONSTRAINT "task_assignees_projectmember_id_fkey" FOREIGN KEY (projectmember_id) REFERENCES project_members(id) ON DELETE CASCADE NOT DEFERRABLE,
    CONSTRAINT "task_assignees_task_taskid_fkey" FOREIGN KEY (task_taskid) REFERENCES tasks(taskid) ON DELETE CASCADE NOT DEFERRABLE
) WITH (oids = false);

CREATE INDEX "task_assignees_projectmember_id_idx" ON "public"."task_assignees" USING btree ("projectmember_id");

CREATE INDEX "task_assignees_task_taskid_idx" ON "public"."task_assignees" USING btree ("task_taskid");

INSERT INTO "task_assignees" ("projectmember_id", "task_taskid") VALUES
(4,	1),
(3,	2),
(2,	3),
(3,	3),
(4,	3),
(5,	5),
(6,	6);