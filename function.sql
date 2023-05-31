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
