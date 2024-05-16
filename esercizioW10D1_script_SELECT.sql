# Interrogare e filtrare le tabelle
# Connettiti al db aziendale o esegui il restore del db

# Esplora la tabelle dei prodotti (DimProduct)

SELECT *            
FROM dimproduct;

# Interroga la tabella dei prodotti (DimProduct) ed esponi in output i campi ProductKey, ProductAlternateKey, EnglishProductName, Color, StandardCost, FinishedGoodsFlag. 
# Il result set deve essere parlante per cui assegna un alias se lo ritieni opportuno.

SELECT 
    dimproduct.ProductKey AS IDproduct,
    dimproduct.ProductAlternateKey AS CodiceModello,
    dimproduct.EnglishProductName AS 'Name',
    dimproduct.Color,
    dimproduct.StandardCost,
    dimproduct.FinishedGoodsFlag
FROM
    dimproduct;

# Partendo dalla query scritta nel passaggio precedente, esponi in output i soli prodotti finiti cioè quelli per cui il campo FinishedGoodsFlag è uguale a 1.

SELECT 
    dimproduct.ProductKey AS IDproduct,
    dimproduct.ProductAlternateKey AS CodiceModello,
    dimproduct.EnglishProductName AS 'Name',
    dimproduct.Color,
    dimproduct.StandardCost,
    dimproduct.FinishedGoodsFlag
FROM
    dimproduct
WHERE
    dimproduct.FinishedGoodsFlag = 1;

# Scrivi una nuova query al fine di esporre in output i prodotti il cui codice modello (ProductAlternateKey) comincia con FR oppure BK. 
# Il result set deve contenere il codice prodotto (ProductKey), il modello, il nome del prodotto, il costo standard (StandardCost) e il prezzo di listino (ListPrice).

SELECT 
    dimproduct.ProductKey AS IDproduct,
    dimproduct.ProductAlternateKey AS CodiceModello,
    dimproduct.EnglishProductName AS 'Name',
    dimproduct.Color,
    dimproduct.StandardCost,
    dimproduct.FinishedGoodsFlag
FROM
    dimproduct
WHERE
	dimproduct.ProductAlternateKey LIKE 'FR%' OR dimproduct.ProductAlternateKey LIKE 'BK%';

# Arricchisci il risultato della query scritta nel passaggio precedente del Markup applicato dall’azienda (ListPrice - StandardCost)

SELECT 
    dimproduct.ProductKey AS IDproduct,
    dimproduct.ProductAlternateKey AS CodiceModello,
    dimproduct.EnglishProductName AS 'Name',
    dimproduct.Color,
    dimproduct.StandardCost,
    dimproduct.FinishedGoodsFlag,
    dimproduct.ListPrice - dimproduct.StandardCost AS Markup
FROM
    dimproduct
WHERE
	dimproduct.ProductAlternateKey LIKE 'FR%' OR dimproduct.ProductAlternateKey LIKE 'BK%';

# Scrivi un’altra query al fine di esporre l’elenco dei prodotti finiti il cui prezzo di listino è compreso tra 1000 e 2000.

SELECT 
    dimproduct.ProductKey AS IDproduct,
    dimproduct.ProductAlternateKey AS CodiceModello,
    dimproduct.EnglishProductName AS 'Name',
    dimproduct.Color,
    dimproduct.StandardCost,
    dimproduct.FinishedGoodsFlag
FROM
    dimproduct
WHERE
	dimproduct.ListPrice BETWEEN 1000 AND 2000; # oppure 1000 =< dimproduct.ListPrice =< 2000;

# Esplora la tabella degli impiegati aziendali (DimEmployee)

SELECT 
    *
FROM
    dimemployee;

# Esponi, interrogando la tabella degli impiegati aziendali, l’elenco dei soli agenti. 
# Gli agenti sono i dipendenti per i quali il campo SalespersonFlag è uguale a 1.

SELECT 
    *
FROM
    dimemployee
WHERE
    SalesPersonFlag = 1;

# Interroga la tabella delle vendite (FactResellerSales). 

SELECT 
    *
FROM
    factresellersales;

# Esponi in output l’elenco delle transazioni registrate a partire dal 1 gennaio 2020 dei soli codici prodotto: 597, 598, 477, 214.
# Calcola per ciascuna transazione il profitto (SalesAmount - TotalProductCost).

SELECT 
    *,
    factresellersales.SalesAmount - factresellersales.TotalProductCost AS Profitto
FROM
    factresellersales
WHERE
    factresellersales.OrderDate >= '2020-01-01'
        AND (factresellersales.productkey = 597
        OR factresellersales.productkey = 589
        OR factresellersales.productkey = 477
        OR factresellersales.productkey = 214); # factresellersales.productkey IN (597, 589, 477, 214)

