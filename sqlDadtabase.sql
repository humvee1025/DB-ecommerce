-- ==============================
-- Création des tables pour la boutique
-- ==============================

--  Catégories


CREATE TABLE categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT NOW()
);

--  Marques
CREATE TABLE marques (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL,
    pays VARCHAR(100),
    created_at DATETIME DEFAULT NOW()
);

--  Produits
CREATE TABLE produits (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255) NOT NULL,
    marque_id INT NOT NULL,
    categorie_id INT NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT NOW(),
    statut VARCHAR(50),
    FOREIGN KEY (marque_id) REFERENCES marques(id),
    FOREIGN KEY (categorie_id) REFERENCES categories(id)
);

--  Couleurs
CREATE TABLE couleurs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(50),
    code_hex VARCHAR(10)
);

--  Tailles
CREATE TABLE tailles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(50)
);

--  Variants de produits
CREATE TABLE produit_variants (
    id INT PRIMARY KEY AUTO_INCREMENT,
    produit_id INT NOT NULL,
    couleur_id INT NOT NULL,
    taille_id INT NOT NULL,
    prix DECIMAL(10,2),
    sku VARCHAR(100),
    reduction DECIMAL(10,2),
    FOREIGN KEY (produit_id) REFERENCES produits(id),
    FOREIGN KEY (couleur_id) REFERENCES couleurs(id),
    FOREIGN KEY (taille_id) REFERENCES tailles(id)
);


#DROP TABLE commandes, clients



--  Clients
CREATE TABLE clients (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100),
    prenom VARCHAR(100),
    postnom VARCHAR(100),
    email VARCHAR(255),
    telephone VARCHAR(50),
    created_at DATETIME DEFAULT NOW()
);



-- Entrepots
CREATE TABLE entrepots (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255),
    ville VARCHAR(100),
    rue VARCHAR(255),
    numero INT
);

--Commandes
CREATE TABLE commandes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT NOT NULL,
    date_commande DATETIME,
    statut VARCHAR(50),
    montant DECIMAL(10,2),
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

-- Détails de commandes
CREATE TABLE commande_details (
    id INT PRIMARY KEY AUTO_INCREMENT,
    commande_id INT NOT NULL,
    produit_variant_id INT NOT NULL,
    quantite INT,
    prix DECIMAL(10,2),
    total DECIMAL(10,2),
    FOREIGN KEY (commande_id) REFERENCES commandes(id),
    FOREIGN KEY (produit_variant_id) REFERENCES produit_variants(id)
);



--  Méthodes de paiement
CREATE TABLE methodes_paiement (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100)
);



--  Transporteurs
CREATE TABLE transporteurs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255),
    telephone VARCHAR(50),
    email VARCHAR(255)
);

--  Stocks
CREATE TABLE stocks (
    id INT PRIMARY KEY AUTO_INCREMENT,
    produit_variant_id INT NOT NULL,
    entrepot_id INT NOT NULL,
    quantite INT,
    FOREIGN KEY (produit_variant_id) REFERENCES produit_variants(id),
    FOREIGN KEY (entrepot_id) REFERENCES entrepots(id)
);

--  Mouvements de stock
CREATE TABLE mouvements_stock (
    id INT PRIMARY KEY AUTO_INCREMENT,
    stock_id INT NOT NULL,
    quantite INT,
    type_mouvement VARCHAR(50),
    date_mouvement DATETIME,
    FOREIGN KEY (stock_id) REFERENCES stocks(id)
);

--  Promotions
CREATE TABLE promotions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255),
    type_reduction VARCHAR(10),
    valeur DECIMAL(10,2),
    date_debut DATE,
    date_fin DATE
);

--  Produit_Promotions
CREATE TABLE produit_promotions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    produit_variant_id INT NOT NULL,
    promotion_id INT NOT NULL,
    date_assignation DATETIME,
    FOREIGN KEY (produit_variant_id) REFERENCES produit_variants(id),
    FOREIGN KEY (promotion_id) REFERENCES promotions(id)
);

--  Avis produits
CREATE TABLE avis_produits (
    id INT PRIMARY KEY AUTO_INCREMENT,
    produit_id INT NOT NULL,
    client_id INT NOT NULL,
    note INT,
    commentaire TEXT,
    date_avis DATETIME,
    FOREIGN KEY (produit_id) REFERENCES produits(id),
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

--  Roles
CREATE TABLE roles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100),
    description TEXT
);

--  Utilisateurs 
CREATE TABLE utilisateurs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100),
    email VARCHAR(255),
    mot_de_passe VARCHAR(255),
    role_id INT,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (role_id) REFERENCES roles(id)
);



--  Tickets support
CREATE TABLE tickets_support (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT,
    sujet VARCHAR(255),
    statut VARCHAR(50),
    date_creation DATETIME,
    FOREIGN KEY (client_id) REFERENCES clients(id)
);

--  Notes internes 
CREATE TABLE notes_internes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    utilisateur_id INT,
    contenu TEXT,
    date_creation DATETIME,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id)
);

--  Campagnes marketing
CREATE TABLE campagnes_marketing (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255),
    date_debut DATE,
    date_fin DATE
);

--  Produit images
CREATE TABLE produit_images (
    id INT PRIMARY KEY AUTO_INCREMENT,
    produit_id INT,
    url_image VARCHAR(255),
    description TEXT,
    FOREIGN KEY (produit_id) REFERENCES produits(id)
);

--  Sessions utilisateurs   
CREATE TABLE sessions_utilisateurs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    utilisateur_id INT,
    token VARCHAR(255),
    date_creation DATETIME,
    FOREIGN KEY (utilisateur_id) REFERENCES utilisateurs(id)
);

--  Retours
CREATE TABLE retours (
    id INT PRIMARY KEY AUTO_INCREMENT,
    commande_id INT NOT NULL,
    motif VARCHAR(255),
    date_retour DATETIME,
    FOREIGN KEY (commande_id) REFERENCES commandes(id)
);

--  Fournisseurs
CREATE TABLE fournisseurs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(255),
    telephone VARCHAR(50),
    email VARCHAR(255)
);

CREATE TABLE adresses_clients (
    id INT AUTO_INCREMENT PRIMARY KEY,

    client_id INT NOT NULL,

    pays VARCHAR(100) NOT NULL,
    province VARCHAR(100) NOT NULL,
    ville VARCHAR(100) NOT NULL,
    avenue VARCHAR(150) NOT NULL,

    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_client_id (client_id),
    INDEX idx_ville (ville),

    CONSTRAINT fk_adresse_client
        FOREIGN KEY (client_id)
        REFERENCES clients(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

--  Adresses 
CREATE TABLE adresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT,
    entrepot_id INT,
    pays VARCHAR(100),
    ville VARCHAR(100),
    province VARCHAR(100),
    rue VARCHAR(255),
    numero INT,
    FOREIGN KEY (client_id) REFERENCES clients(id),
    FOREIGN KEY (entrepot_id) REFERENCES entrepots(id)
);

--  Paiements  
CREATE TABLE paiements (
    id INT PRIMARY KEY AUTO_INCREMENT,
    commande_id INT NOT NULL,
    methode_paiement_id INT NOT NULL,
    montant DECIMAL(10,2),
    date_paiement DATETIME,
    statut VARCHAR(50),
    FOREIGN KEY (commande_id) REFERENCES commandes(id),
    FOREIGN KEY (methode_paiement_id) REFERENCES methodes_paiement(id)
);

--  Livraisons 
CREATE TABLE livraisons (
    id INT PRIMARY KEY AUTO_INCREMENT,
    commande_id INT NOT NULL,
    transporteur_id INT NOT NULL,
    date_expedition DATETIME,
    date_livraison DATETIME,
    statut VARCHAR(50),
    FOREIGN KEY (commande_id) REFERENCES commandes(id),
    FOREIGN KEY (transporteur_id) REFERENCES transporteurs(id)
);
