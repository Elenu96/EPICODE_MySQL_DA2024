/* ToysGroup è un’azienda che distribuisce articoli (giocatoli) in diverse aree geografiche del mondo. 
I prodotti sono classificati in categorie e i mercati di riferimento dell’azienda sono classificati in regioni di vendita. 
In particolare: 
Le entità individuabili in questo scenario sono le seguenti: 
- Product 
- Region 
- Sales  
Le relazioni tra le entità possono essere descritte nel modo seguente: 
❏ Product e Sales 
Un prodotto può essere venduto tante volte (o nessuna) per cui è contenuto in una o più transazioni di vendita. 
Ciascuna transazione di vendita è riferita ad uno solo prodotto
❏ Region e Sales 
Possono esserci molte o nessuna transazione per ciascuna regione 
Ciascuna transazione di vendita è riferita ad una sola regione  

Fornisci schema concettuale e schema logico. */

# Creazione DataBase

CREATE SCHEMA `toysgroup` ;

# Creazione Tabelle

CREATE TABLE `toysgroup`.`product` (
  `idproduct` INT NOT NULL,
  `name_product` VARCHAR(45) NOT NULL,
  `price` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`idproduct`));
  
  CREATE TABLE `toysgroup`.`region` (
  `name_region` VARCHAR(45) NOT NULL,
  `area` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`name_region`));
  
  CREATE TABLE `toysgroup`.`sales` (
  `idsale` INT NOT NULL AUTO_INCREMENT,
  `data_sale` DATE NOT NULL,
  `idproduct` INT(4) NOT NULL,
  `quantity` INT NOT NULL,
  `amount` DECIMAL(10,2),
  `name_region` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idsale`),
  INDEX `product_sales_idx` (`idproduct` ASC) VISIBLE,
  CONSTRAINT `product_sales`
    FOREIGN KEY (`idproduct`)
    REFERENCES `toysgroup`.`product` (`idproduct`)
    ON DELETE CASCADE
    ON UPDATE CASCADE);
    
ALTER TABLE `toysgroup`.`sales` 
ADD INDEX `region_sales_idx` (`name_region` ASC) VISIBLE;
;
ALTER TABLE `toysgroup`.`sales` 
ADD CONSTRAINT `region_sales`
  FOREIGN KEY (`name_region`)
  REFERENCES `toysgroup`.`region` (`name_region`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

DELIMITER //

CREATE TRIGGER calculate_amount
BEFORE INSERT ON sales
FOR EACH ROW
BEGIN
    DECLARE prod_price DECIMAL(5,2);
    # Recupera il prezzo del prodotto dalla tabella product
    SELECT price INTO prod_price FROM product WHERE idproduct = NEW.idproduct;
    # Calcola l'amount
    SET NEW.amount = prod_price * NEW.quantity;
END //

DELIMITER ;

# Popolamento tabelle

INSERT INTO product (idproduct, name_product, price) VALUES
(1, 'Toy Car', 9.99),
(2, 'Doll', 14.99),
(3, 'Puzzle', 7.49),
(4, 'Action Figure', 12.99),
(5, 'Board Game', 19.99),
(6, 'Lego Set', 29.99),
(7, 'RC Helicopter', 49.99),
(8, 'Train Set', 39.99),
(9, 'Stuffed Animal', 12.49),
(10, 'Building Blocks', 24.99),
(11, 'Toy Robot', 34.99),
(12, 'Race Car Track', 44.99),
(13, 'Water Gun', 9.49),
(14, 'Kite', 6.99),
(15, 'Yo-Yo', 4.99),
(16, 'Marbles', 3.99),
(17, 'Model Airplane', 22.99),
(18, 'Slime Kit', 15.99),
(19, 'Toy Drum Set', 27.99),
(20, 'Jigsaw Puzzle', 5.99);
  
  INSERT INTO region (name_region, area) VALUES
('USA', 'North America'),
('Canada', 'North America'),
('Mexico', 'North America'),
('Brazil', 'South America'),
('Argentina', 'South America'),
('UK', 'Europe'),
('Germany', 'Europe'),
('France', 'Europe'),
('Italy', 'Europe'),
('Spain', 'Europe'),
('Russia', 'Europe'),
('China', 'Asia'),
('Japan', 'Asia'),
('South Korea', 'Asia'),
('India', 'Asia'),
('Australia', 'Oceania'),
('New Zealand', 'Oceania'),
('South Africa', 'Africa'),
('Nigeria', 'Africa'),
('Egypt', 'Africa');
  
  INSERT INTO sales (data_sale, idproduct, quantity, name_region) VALUES
('2023-01-15', 1, 3, 'USA'),
('2023-01-16', 2, 2, 'Germany'),
('2023-01-17', 3, 5, 'Japan'),
('2023-01-18', 4, 1, 'Brazil'),
('2023-01-19', 5, 4, 'Canada'),
('2023-01-20', 6, 1, 'UK'),
('2023-01-21', 7, 2, 'France'),
('2023-01-22', 8, 3, 'Italy'),
('2023-01-23', 9, 2, 'Spain'),
('2023-01-24', 10, 1, 'Russia'),
('2023-01-25', 11, 3, 'China'),
('2023-01-26', 12, 2, 'South Korea'),
('2023-01-27', 13, 4, 'India'),
('2023-01-28', 14, 5, 'Australia'),
('2023-01-29', 15, 1, 'New Zealand'),
('2023-01-30', 16, 2, 'South Africa'),
('2023-01-31', 17, 3, 'Nigeria'),
('2023-02-01', 18, 4, 'Egypt'),
('2023-02-02', 19, 5, 'Mexico'),
('2023-02-03', 20, 1, 'Argentina');

  
# Verificare che i campi definiti come PK siano univoci. 
  
  SELECT p.idproduct
  FROM product p;
  
# Risultato 20 righe
  
  SELECT DISTINCT p.idproduct
  FROM product p;
  
# Risultato 20 righe

SELECT r.name_region
FROM region r;
SELECT DISTINCT r.name_region
FROM region r;

SELECT s.idsale
FROM sales s;
SELECT DISTINCT s.idsale
FROM sales s;

# Esporre l’elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno

SELECT 
    p.idproduct,
    p.name_product,
    YEAR(s.data_sale) AS anno,
    SUM(s.amount) AS fatturato_totale
FROM 
    sales s
JOIN 
    product p ON s.idproduct = p.idproduct
GROUP BY 
    p.name_product, 
    anno
ORDER BY 
    anno;

# Esporre il fatturato totale per stato (region) per anno. Ordina il risultato per data e per fatturato decrescente. 

SELECT 
    r.name_region,
    YEAR(s.data_sale) AS anno,
    SUM(s.amount) AS fatturato_totale
FROM 
    sales s
JOIN 
    region r ON s.name_region = r.name_region
GROUP BY 
    r.name_region, 
    anno
ORDER BY 
    anno;
    
#  Qual è la categoria di articoli maggiormente richiesta dal mercato?

SELECT 
    p.idproduct,
    p.name_product,
    SUM(s.quantity) AS total_quantity_sold
FROM 
    sales s
JOIN 
    product p ON s.idproduct = p.idproduct
GROUP BY 
    p.idproduct, 
    p.name_product
ORDER BY 
    total_quantity_sold DESC
LIMIT 1;

# Quali sono, se ci sono, i prodotti invenduti? Proponi due approcci risolutivi differenti. 
# Primo approccio: LEFT JOIN/NULL
SELECT 
    p.idproduct,
    p.name_product
FROM 
    product p
LEFT JOIN 
    sales s ON p.idproduct = s.idproduct
WHERE 
    s.idproduct IS NULL;
    
# Secondo approccio

SELECT 
    p.idproduct,
    p.name_product
FROM 
    product p
LEFT JOIN 
    sales s ON p.idproduct = s.idproduct
GROUP BY 
    p.idproduct, 
    p.name_product
HAVING 
    COUNT(s.idproduct) = 0;
    
# Esporre l’elenco dei prodotti con la rispettiva ultima data di vendita (la data di vendita più recente)

SELECT 
    p.idproduct,
    p.name_product,
    MAX(s.data_sale) AS ultima_data_vendita
FROM 
    product p
LEFT JOIN 
    sales s ON p.idproduct = s.idproduct
GROUP BY 
    p.idproduct, 
    p.name_product;