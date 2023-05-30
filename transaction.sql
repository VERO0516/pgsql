BEGIN;

INSERT INTO shop.carts (user_id) VALUES (1);

SELECT id FROM shop.carts WHERE user_id = 1 ORDER BY id DESC LIMIT 1;


SAVEPOINT cart_created;

INSERT INTO shop.cart_items (cart_id, product_id, quantity)
VALUES 
    (1, 1, 2),
    (1, 2, 1);

ROLLBACK TO cart_created;

COMMIT;
