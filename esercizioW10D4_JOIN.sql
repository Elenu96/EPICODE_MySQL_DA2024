# Esponi l’anagrafica dei prodotti indicando per ciascun prodotto anche la sua sottocategoria 
# (DimProduct, DimProductSubcategory)

SELECT 
    dimproduct.EnglishProductName AS NomeProdotto, dimproductsubcategory.EnglishProductSubcategoryName AS NomeSottocategoria
FROM
    dimproduct 
        JOIN
    dimproductsubcategory ON dimproduct.ProductSubcategoryKey = dimproductsubcategory.ProductSubcategoryKey;

# Esponi l’anagrafica dei prodotti indicando per ciascun prodotto la sua sottocategoria e la sua categoria 
# (DimProduct, DimProductSubcategory, DimProductCategory)

SELECT 
    DP.EnglishProductName,
    DPS.EnglishProductSubcategoryName,
    DPC.EnglishProductCategoryName
FROM
    dimproduct AS DP
        JOIN
    dimproductsubcategory AS DPS ON DP.ProductSubcategoryKey = DPS.ProductSubcategoryKey
        JOIN
    dimproductcategory AS DPC ON DPS.ProductCategoryKey = DPC.ProductCategoryKey;
    
# Esponi l’elenco dei soli prodotti venduti (DimProduct, FactResellerSales)

SELECT DISTINCT #tolgo i ripetuti
	DP.EnglishProductName 
FROM
    dimproduct AS DP
        JOIN
    factresellersales AS FRS ON DP.ProductKey = FRS.ProductKey
WHERE
    SalesAmount > 0;
    
#oppure

SELECT DISTINCT
    DP.EnglishProductName
FROM
    dimproduct AS DP,
    factresellersales AS FRS 
WHERE
    DP.ProductKey = FRS.ProductKey AND SalesAmount > 0;

# Esponi l’elenco dei prodotti non venduti 
# considera i soli prodotti finiti cioè quelli per i quali il campo FinishedGoodsFlag è uguale a 1

SELECT 
    DP.ProductKey, DP.EnglishProductName
FROM
    dimproduct AS DP
WHERE
    DP.ProductKey NOT IN (SELECT DISTINCT
            DP.EnglishProductName
        FROM
            dimproduct AS DP
                JOIN
            factresellersales AS FRS ON DP.ProductKey = FRS.ProductKey)
        AND DP.FinishedGoodsFlag = 1;
        
# per verificare prendo i primi cinque valori che ottengo dalla query precedente: 210, 211, 212, 213

SELECT DISTINCT #tolgo i ripetuti
    DP.EnglishProductName, DP.ProductKey
FROM
    dimproduct AS DP
        JOIN
    factresellersales AS FRS ON DP.ProductKey = FRS.ProductKey
WHERE
 DP.ProductKey IN (210 , 211, 212, 213);
 
#oppure

SELECT 
    dimproduct.EnglishProductName AS ProdottoNonVenduto,
    factresellersales.ResellerKey
FROM
    dimproduct
        LEFT OUTER JOIN
    factresellersales ON dimproduct.ProductKey = factresellersales.ProductKey
AND
    dimproduct.FinishedGoodsFlag = 1;

# Esponi l’elenco delle transazioni di vendita (FactResellerSales) 
# indicando anche il nome del prodotto venduto (DimProduct)

SELECT 
    *, dimproduct.EnglishProductName AS NomeProdotto
FROM
    factresellersales
        JOIN
    dimproduct ON factresellersales.ProductKey = dimproduct.ProductKey;

# Esponi l’elenco delle transazioni di vendita indicando la categoria di appartenenza di ciascun prodotto venduto

SELECT 
    factresellersales.SalesOrderNumber,
    factresellersales.SalesOrderLineNumber,
    factresellersales.OrderDate,
    factresellersales.UnitPrice,
    factresellersales.OrderQuantity,
    factresellersales.TotalProductCost,
    dimproductcategory.EnglishProductCategoryName AS NomeCategoria
FROM
    dimproductcategory
        JOIN
    dimproductsubcategory ON dimproductcategory.ProductCategoryKey = dimproductsubcategory.ProductCategoryKey
        JOIN
    dimproduct ON dimproductsubcategory.ProductSubcategoryKey = dimproduct.ProductSubcategoryKey
        JOIN
    factresellersales ON dimproduct.ProductKey = factresellersales.ProductKey;

# Esplora la tabella DimReseller
# Esponi in output l’elenco dei reseller indicando, per ciascun reseller, anche la sua area geografica

SELECT 
    *
FROM
    dimreseller
        JOIN
    dimgeography ON dimreseller.GeographyKey = dimgeography.GeographyKey;

# Esponi l’elenco delle transazioni di vendita. 
# Il result set deve esporre i campi: SalesOrderNumber, SalesOrderLineNumber, OrderDate, UnitPrice, Quantity, TotalProductCost. 
# Il result set deve anche indicare il nome del prodotto, il nome della categoria del prodotto, il nome del reseller e l’area geografica

SELECT 
    factresellersales.SalesOrderNumber,
    factresellersales.SalesOrderLineNumber,
    factresellersales.OrderDate,
    factresellersales.UnitPrice,
    factresellersales.OrderQuantity,
    factresellersales.TotalProductCost,
    dimproduct.EnglishProductName AS NomeProdotto,
    dimproductcategory.EnglishProductCategoryName AS NomeCategoria,
    dimreseller.ResellerName,
    dimgeography.City,
    dimgeography.StateProvinceCode
FROM
    dimgeography
        JOIN
    dimreseller ON dimgeography.GeographyKey = dimreseller.GeographyKey
        JOIN
    factresellersales ON dimreseller.ResellerKey = factresellersales.ResellerKey
        JOIN
    dimproduct ON factresellersales.ProductKey = dimproduct.ProductKey
        JOIN
    dimproductsubcategory ON dimproduct.ProductSubcategoryKey = dimproductsubcategory.ProductSubcategoryKey
        JOIN
    dimproductcategory ON dimproductsubcategory.ProductCategoryKey = dimproductcategory.ProductCategoryKey;
