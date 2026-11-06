-- Q1.5.1 : tous les produits
SELECT * FROM produits;

-- Q1.5.2 : produits en rupture de stock
SELECT * FROM produits WHERE quantite = 0;

-- Q1.5.3 : produits du plus cher au moins cher
SELECT * FROM produits ORDER BY prix DESC;

-- Q1.5.4 : nom du produit avec le nom de sa catégorie
SELECT p.nom, c.nom AS categorie
FROM produits p
INNER JOIN categories c ON c.id = p.categorie_id;

-- Q1.5.5 : nombre de produits par catégorie
SELECT c.nom, COUNT(*) AS nb_produits
FROM produits p
INNER JOIN categories c ON c.id = p.categorie_id
GROUP BY c.nom;

-- Q1.5.6 : valeur totale du stock
SELECT SUM(prix * quantite) AS valeur_stock FROM produits;

-- Q4.1 : Insertion d'une catégorie
INSERT INTO categories (nom, description)
VALUES ('Électroménager', 'Petits appareils');
-- Q4.6 : Insertion du produit Stylo bleu
INSERT INTO produits (
    nom, prix, quantite, disponible, date_ajout, categorie_id
)
VALUES (
    'Stylo bleu', 0.500, 100, 1,
    '2026-10-30T15:00:00', 4
);
-- Q5.1.1
SELECT *
FROM produits
ORDER BY nom ASC;
-- Q5.1.2
SELECT *
FROM produits
WHERE id = 3;