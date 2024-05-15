# Interrogare, filtrare e raggruppare
#1.Scrivi una query per verificare che il campo ProductKey nella tabella DimProduct sia una chiave primaria. 
# Quali considerazioni/ragionamenti è necessario che tu faccia? ProductKey - DISTINCT ProductKey --> stesso numero di righe

SELECT COUNT(ProductKey) AS ChiavePrimaria1, COUNT(DISTINCT ProductKey) AS ChiavePrimaria2
FROM dimproduct;

#2.Scrivi una query per verificare che la combinazione dei campi SalesOrderNumber e SalesOrderLineNumber sia una PK.
# DISTINCT dei due campi insieme --> stesse righe della tabella

SELECT COUNT(SalesOrderNumber), COUNT(SalesOrderLineNumber)
FROM factresellersales;

SELECT COUNT(SalesOrderNumber), COUNT(SalesOrderLineNumber), COUNT(DISTINCT SalesOrderNumber, SalesOrderLineNumber)
FROM factresellersales;

#3.Conta il numero transazioni (SalesOrderLineNumber) realizzate ogni giorno a partire dal 1 Gennaio 2020.factresellersales

SELECT OrderDate, COUNT(SalesOrderLineNumber) AS NumeroDiTransazioni
FROM factresellersales
WHERE OrderDate >= "2020.01.01"
GROUP BY OrderDate;

#4.Calcola:
		# il fatturato totale (FactResellerSales.SalesAmount), 
		# la quantità totale venduta (FactResellerSales.OrderQuantity)
        # il prezzo medio di vendita (FactResellerSales.UnitPrice) per prodotto (DimProduct)
# a partire dal 1 Gennaio 2020.
# Il result set deve esporre pertanto il nome del prodotto, il fatturato totale, la quantità totale venduta e il prezzo medio di vendita.
# I campi in output devono essere parlanti!

SELECT 
    dimproduct.EnglishProductName AS prodotto,
    SUM(factresellersales.SalesAmount) AS fatturato,
    SUM(factresellersales.OrderQuantity) AS quantitàVenduta,
    SUM(factresellersales.UnitPrice) AS prezzoMedio
FROM
    dimproduct
        JOIN
    factresellersales ON dimproduct.ProductKey = factresellersales.ProductKey
WHERE
    OrderDate >= '2020.01.01'
GROUP BY factresellersales.ProductKey;

#5.Calcola il fatturato totale (FactResellerSales.SalesAmount) e la quantità totale venduta (FactResellerSales.OrderQuantity) per Categoria prodotto (DimProductCategory).
# Il result set deve esporre pertanto il nome della categoria prodotto, il fatturato totale e la quantità totale venduta.
# I campi in output devono essere parlanti!

SELECT 
    dimproductcategory.EnglishProductCategoryName AS NomeCategoria,
    SUM(factresellersales.SalesAmount) AS fatturato,
    SUM(factresellersales.OrderQuantity) AS quantitàVenduta
FROM
    dimproductcategory
        JOIN
    dimproductsubcategory ON dimproductcategory.ProductCategoryKey = dimproductsubcategory.ProductCategoryKey
        JOIN
	dimproduct ON dimproductsubcategory.ProductSubcategoryKey = dimproduct.ProductSubcategoryKey
		JOIN
    factresellersales ON dimproduct.ProductKey = factresellersales.ProductKey
GROUP BY dimproductcategory.EnglishProductCategoryName;

#6.Calcola il fatturato totale per area città (DimGeography.City) realizzato a partire dal 1 Gennaio 2020. 
# Il result set deve esporre l’elenco delle città con fatturato realizzato superiore a 60K.

SELECT 
    dimgeography.City,
    SUM(factresellersales.SalesAmount) AS fatturato
FROM
    dimgeography
        JOIN
    dimsalesterritory ON dimgeography.SalesTerritoryKey = dimsalesterritory.SalesTerritoryKey
        JOIN
    factresellersales ON dimsalesterritory.SalesTerritoryKey = factresellersales.SalesTerritoryKey
WHERE
    OrderDate >= '2020.01.01'
GROUP BY dimgeography.City
HAVING fatturato >= 60000;

/*TIP
Dove non espressamente indicato è necessario individuare in autonomia le tabelle contenenti i dati utili.
In alcuni casi, per maggior chiarezza è stato indicando il percorso NomeTabella.NomeCampo altrimenti la sola indicazione del campo!+/