CREATE TABLE count_created_users (
    count_created_users BIGINT
);

INSERT INTO stats(count_created_users) VALUES(0);

CREATE OR REPLACE FUNCTION trigger_insert_user()
RETURNS TRIGGER
AS $$
    BEGIN

        UPDATE stats SET count_created_users = count_created_users + 1;

        RETURN NEW;
    END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER incr_created_users
    AFTER INSERT ON users
    FOR EACH ROW
    EXECUTE PROCEDURE trigger_insert_user();


CREATE TABLE count_created_topics (
    count_created_topics BIGINT
);

INSERT INTO stats(count_created_topics) VALUES(0);

CREATE OR REPLACE FUNCTION trigger_insert_topics()
RETURNS TRIGGER
AS $$
    BEGIN

        UPDATE stats SET count_created_topics = count_created_topics + 1;

        RETURN NEW;
    END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER incr_created_topics
    AFTER INSERT ON topics
    FOR EACH ROW
    EXECUTE PROCEDURE trigger_insert_topics();

