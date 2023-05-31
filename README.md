## Structure de la base de données
**SCHEMA Public**
    - Table "users" : Stocke les informations des utilisateurs, y compris leur nom d'utilisateur, leur mot de passe, leur adresse e-mail et leur adresse postale.

S**CHEMA gallery**
- Table "image" : Stocke les informations sur les images de la galerie, y compris le titre, l'URL, la description, l'ID de l'utilisateur et la date de création.

**SCHEMA forum**
- Table "topics" : Stocke les informations sur les sujets du forum, y compris le titre, le contenu, l'ID de l'utilisateur, l'état et la date de création.
- Table "posts" : Stocke les informations sur les messages du forum, y compris le contenu, l'ID de l'utilisateur, l'ID du sujet et la date de création.

S**CHEMA shop**
    - Table "carts" : Stocke les informations sur les paniers d'achat des utilisateurs, y compris l'ID de l'utilisateur, l'état du panier et la date de création.
    - Table "cart_items" : Stocke les informations sur les articles du panier, y compris l'ID du panier, l'ID du produit, la quantité et la date de création.
    - Table "products" : Stocke les informations sur les produits, y compris leur nom, leur description, leur prix et leur stock.
    
## TYPE
Le domaine email_type est défini comme une chaîne de caractères (VARCHAR) et il vérifie que la valeur correspond au format d'une adresse e-mail valide à l'aide d'une expression régulière.

Le domaine password_type est également défini comme une chaîne de caractères (VARCHAR) et il vérifie que la valeur respecte certaines règles pour un mot de passe fort. Il doit contenir au moins une lettre minuscule, une lettre majuscule et un chiffre.

## TRIGGER
La table count_created_users stocke le nombre total d'utilisateurs créés
La table count_created_topics stocke le nombre total de sujets créés

## FUNCTION
La function calculate_cart_total effectue une requête pour calculer la somme des quantités multipliées par les prix des produits contenus dans le panier spécifié par l'identifiant du panier. 

## VIEW
La view cart_items_view vue récupère les colonnes id de la table carts, name de la table products, quantity de la table cart_items et price de la table products. 

La view forum_view vue récupère les colonnes id de la table topics, title, contenu (renommée en topic_contenu) de la table topics, contenu (renommée en posts_contenu) de la table posts et username de la table users. 

