CREATE VIEW cart_items_view
AS
    SELECT c.id AS cart_id, p.name AS product_name, ci.quantity, p.price
    FROM shop.carts c
    JOIN shop.cart_items ci ON c.id = ci.cart_id
    JOIN shop.products p ON ci.product_id = p.id;


CREATE VIEW forum_view
AS
    SELECT t.id AS topic_id, t.title, t.contenu AS topic_contenu, p.contenu AS posts_contenu, u.username
    FROM forum.topics t
    JOIN forum.posts p ON t.id = p.topic_id
    JOIN public.users u ON p.user_id = u.id;

