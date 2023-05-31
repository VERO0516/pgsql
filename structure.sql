--SCHEMA-----------------------------------------------------------------
CREATE SCHEMA user;
CREATE SCHEMA gallery;
CREATE SCHEMA forum;
CREATE SCHEMA shop;

--TYPE-----------------------------------------------------------------

CREATE DOMAIN email_type AS VARCHAR
  CHECK ( value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );

CREATE DOMAIN password_type AS VARCHAR
  CHECK (value ~ '^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$');


--TABLES-----------------------------------------------------------------
-- Table Users
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    username VARCHAR(255) NOT NULL,
    password password_type NOT NULL,
    email email_type NOT NULL UNIQUE,
    code_postal INTEGER CHECK (code_postal > 0),
    address VARCHAR(255)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table product

CREATE TABLE IF NOT EXISTS shop.products (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    price MONEY NOT NULL,
    stock INTEGER NOT NULL CHECK (stock >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table carts

    CREATE TABLE IF NOT EXISTS shop.carts (
        id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
        user_id BIGINT NOT NULL REFERENCES public.users (id) ON UPDATE CASCADE ON DELETE CASCADE,
        state BOOLEAN DEFAULT FALSE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

-- Table cart_items

CREATE TABLE IF NOT EXISTS shop.cart_items    (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    cart_id BIGINT NOT NULL REFERENCES carts (id) ON UPDATE CASCADE ON DELETE CASCADE,
    product_id BIGINT NOT NULL REFERENCES products (id) ON UPDATE CASCADE ON DELETE CASCADE,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table topics

CREATE TABLE IF NOT EXISTS forum.topics (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    title VARCHAR(100) NOT NULL,
    contenu TEXT NOT NULL,
    user_id BIGINT NOT NULL REFERENCES public.users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    state BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table posts

CREATE TABLE IF NOT EXISTS forum.posts (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    contenu TEXT NOT NULL,
    user_id BIGINT NOT NULL REFERENCES public.users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    topic_id BIGINT NOT NULL REFERENCES topics (id) ON UPDATE CASCADE ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table image

CREATE TABLE IF NOT EXISTS gallery.image (
    id BIGSERIAL PRIMARY KEY NOT NULL CHECK (id > 0),
    title VARCHAR(100) NOT NULL,
    url VARCHAR(255) NOT NULL,
    description TEXT,
    user_id BIGINT NOT NULL REFERENCES public.users (id) ON UPDATE CASCADE ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--TRIGGER-----------------------------------------------------------------

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


--VIEW-----------------------------------------------------------------
CREATE VIEW cart_items_view
AS
    SELECT c.id AS cart_id, p.name AS product_name, ci.quantity, p.price
    FROM shop.carts c
    JOIN shop.cart_items ci ON c.id = ci.cart_id
    JOIN shop.products p ON ci.product_id = p.id;

SELECT product_name, quantity, price
FROM cart_items_view
WHERE cart_id = 1;


CREATE VIEW forum_view
AS
    SELECT t.id AS topic_id, t.title, t.contenu AS topic_contenu, p.contenu AS posts_contenu, u.username
    FROM forum.topics t
    JOIN forum.posts p ON t.id = p.topic_id
    JOIN public.users u ON p.user_id = u.id;

SELECT title, topic_contenu, posts_contenu,username
FROM forum_view
WHERE topic_id = 1;

--FUNCTION-----------------------------------------------------------------

CREATE OR REPLACE FUNCTION calculate_cart_total(p_cart_id BIGINT)
RETURNS NUMERIC
AS $$
DECLARE
    total_price NUMERIC := 0;
BEGIN
    SELECT SUM(quantity * price)
    INTO total_price
    FROM cart_items
    JOIN products ON cart_items.product_id = products.id
    WHERE cart_items.cart_id = p_cart_id;
    
    RETURN total_price;
END;
$$ LANGUAGE plpgsql;
