INSERT INTO public.users(username, password, email, code_postal, address)
VALUES 
('JohnDoe', 'PASSword123', 'johndoe@example.com', 12345, '123 emile lepu '),
('JaneSmith', 'PASSword456', 'janesmith@example.com', 54321, '456 emile lepu ');

INSERT INTO shop.products(name, description, price, stock)
VALUES 
('iPhone 12', 'A powerful smartphone from Apple', 999.99, 10),
('Samsung Galaxy S21', 'A flagship Android smartphone', 899.99, 15);

INSERT INTO shop.carts(user_id)
VALUES (1);

INSERT INTO shop.cart_items(cart_id, product_id, quantity)
VALUES (1, 1, 1),
VALUES (1, 1, 1);

INSERT INTO forum.topics(title, contenu, user_id)
VALUES ('Topic1', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', 1);


INSERT INTO forum.posts (contenu, user_id, topic_id)
VALUES
    ('good', 1, 1),
    (':)', 2, 1);


INSERT INTO gallery.images (title, url, description, user_id)
VALUES
    ('image1', 'https://example.com/image1.jpg', 'Integer feugiat velit quis ipsum aliquam', 1),
    ('image2', 'https://example.com/image2.jpg', 'Integer feugiat velit quis ipsum aliquam', 1),
    ('image3', 'https://example.com/image3.jpg', 'Integer feugiat velit quis ipsum aliquam', 2);


--VIEW-----------------------------------------------------------------

SELECT product_name, quantity, price
FROM cart_items_view
WHERE cart_id = 1;

SELECT title, topic_contenu, posts_contenu,username
FROM forum_view
WHERE topic_id = 1;