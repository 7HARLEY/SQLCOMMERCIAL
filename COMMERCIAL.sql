SELECT * from EMPLOYEES
/*3.	Afficher par ordre décroissant d'ancienneté les employés de sexe masculin
dont le salaire net (salaire + commission) est supérieur ou égal à 8000.
Le tableau résultant doit inclure les colonnes suivantes : Numéro d'employé, 
Prénom et Nom (en utilisant LPAD ou RPAD pour le formatage), Âge et Ancienneté.*/


SELECT 
EMPLOYEE_NUMBER, 
FIRST_NAME +''+ LAST_NAME as PRENOM_ET_NOM,
(SALARY + ISNULL (COMMISSION, 0)) as SALAIRE_NET, 
DATEDIFF (YEAR, BIRTH_DATE, getdate ())as AGE, 
DATEDIFF (YEAR, HIRE_DATE, getdate ()) as ANCIENNETE
FROM EMPLOYEES
WHERE TITLE <> 'Miss' and  (SALARY + ISNULL (COMMISSION, 0)) >= 8000
ORDER BY SALAIRE_NET DESC;


/*4.	Affichez les produits qui répondent aux critères suivants :
(C1) la quantité est conditionnée en bouteille(s),
(C2) le troisième caractère du nom du produit est « t » ou « T », 
(C3) fourni par les fournisseurs 1, 2 ou 3, 
(C4) le prix unitaire est compris entre 70 et 200 
et (C5) les unités commandées sont spécifiées (non nulles). 
Le tableau résultant doit inclure les colonnes suivantes : numéro de produit,
nom du produit, numéro de fournisseur, unités commandées et prix unitaire.*/

-- REPONSE C1 LA QUANTITÉ EST CONDITIONNÉE EN BOUTEILLE(S)


SELECT PRODUCT_REF , PRODUCT_NAME, SUPPLIER_NUMBER , UNITS_ON_ORDER 
FROM PRODUCTS
where QUANTITY like '%bottles%'

-- REPONSE C2 LE TROISIÈME CARACTÈRE DU NOM DU PRODUIT EST « t » OU « T »
SELECT PRODUCT_REF , PRODUCT_NAME, SUPPLIER_NUMBER , UNITS_ON_ORDER 
FROM PRODUCTS
where PRODUCT_NAME  like '__[t,T]%'

-- REPONSE C3 FOURNI PAR LES FOURNISSEURS 1, 2 OU 3
SELECT PRODUCT_REF , PRODUCT_NAME, SUPPLIER_NUMBER , UNITS_ON_ORDER 
FROM PRODUCTS
where SUPPLIER_NUMBER in (1,2,3)

--REPONSE C4 LE PRIX UNITAIRE EST COMPRIS ENTRE 70 ET 200 
SELECT PRODUCT_REF , PRODUCT_NAME, SUPPLIER_NUMBER , UNITS_ON_ORDER 
FROM PRODUCTS
where UNIT_PRICE BETWEEN 70 AND 200

--(C5) LES UNITÉS COMMANDÉES SONT SPÉCIFIÉES (NON NULLES)
SELECT PRODUCT_REF , PRODUCT_NAME, SUPPLIER_NUMBER , UNITS_ON_ORDER 
FROM PRODUCTS
where UNITS_ON_ORDER IS NOT NULL

select * from CUSTOMERS
select * from SUPPLIERS

/*- 5.	Affichez les clients qui résident dans la même région que le fournisseur 1,
c'est-à-dire qu'ils partagent le même pays, la même ville et les trois derniers chiffres du code postal. 
La requête doit utiliser une seule sous-requête. 
La table résultante doit inclure toutes les colonnes de la table client.*/

SELECT*
FROM CUSTOMERS 
INNER JOIN SUPPLIERS 
ON  CUSTOMERS.CITY = SUPPLIERS.CITY
WHERE SUPPLIERS.SUPPLIER_NUMBER = 1 AND RIGHT (SUPPLIERS.POSTAL_CODE, 3) = RIGHT (CUSTOMERS.POSTAL_CODE,3);


select * from ORDER_DETAILS
select * from ORDERS 

select ORDER_NUMBER, QUANTITY, UNIT_PRICE,QUANTITY * UNIT_PRICE AS COMMANDE,
	CASE 
		WHEN QUANTITY * UNIT_PRICE BETWEEN 0 AND 2000  THEN 'taux de remise = 0%'
		WHEN QUANTITY * UNIT_PRICE BETWEEN 2001 AND 10000  THEN 'taux de remise = 5%'
		WHEN QUANTITY * UNIT_PRICE BETWEEN 10000 AND 40000 THEN 'taux de remise = 10%'
		WHEN QUANTITY * UNIT_PRICE BETWEEN 40000 AND 80000  THEN 'taux de remise = 15%'
		WHEN QUANTITY * UNIT_PRICE  > 80000 THEN 'taux de remise = 15%'
	END AS NOUVEAU_TAUX_DE_REMISE 
from ORDER_DETAILS
WHERE ORDER_NUMBER BETWEEN 10998 AND 11003

/*Affichez le message « appliquer l'ancien taux de remise » 
si le numéro de commande est compris entre 10000 et 10999 et 
« appliquer le nouveau taux de remise » dans le cas contraire.
Le tableau résultant doit afficher les colonnes : numéro de commande,
nouveau taux de remise et note d'application du taux de remise.*/

select ORDER_NUMBER, QUANTITY, UNIT_PRICE,QUANTITY * UNIT_PRICE AS COMMANDE,
	CASE 
		WHEN ORDER_NUMBER BETWEEN 10000 AND 10999  THEN 'Appliquer l''ancien taux de remise '
		ELSE 'Appliquer le nouveau taux de remise'
	END AS 'NOTE_D''APPLICATION_DU_TAUX_DE_REMISE'
from ORDER_DETAILS
WHERE ORDER_NUMBER BETWEEN 10998 AND 11003

/*7.AFFICHEZ LES FOURNISSEURS DE BOISSONS. LE TABLEAU OBTENU DOIT AFFICHER LES COLONNES 
: NUMÉRO DE FOURNISSEUR, SOCIÉTÉ, ADRESSE ET NUMÉRO DE TÉLÉPHONE.*/

SELECT * from CUSTOMERS
SELECT * from CATEGORIES


SELECT SUPPLIER_NUMBER, COMPANY , ADDRESS , PHONE
FROM SUPPLIERS 
WHERE  COMPANY like '%Liquids%'

/*8.AFFICHEZ LES CLIENTS DE BERLIN QUI ONT COMMANDÉ AU MAXIMUM 1 (0 OU 1) PRODUIT DE DESSERT.
LE TABLEAU RÉSULTANT DOIT AFFICHER LA COLONNE : CODE CLIENT.*/

SELECT COMPANY,ADDRESS, CITY, POSTAL_CODE, COUNTRY, PHONE, FAX
FROM CUSTOMERS
JOIN ORDERS ON
CUSTOMERS.CUSTOMER_CODE = ORDERS.CUSTOMER_CODE
JOIN ORDER_DETAILS ON
ORDERS.ORDER_NUMBER = ORDER_DETAILS.ORDER_NUMBER
JOIN PRODUCTS ON
ORDER_DETAILS.PRODUCT_REF = PRODUCTS.PRODUCT_REF
JOIN CATEGORIES ON
PRODUCTS.CATEGORY_CODE = CATEGORIES.CATEGORY_CODE
WHERE  CUSTOMERS.CITY = 'Berlin' and CATEGORIES.CATEGORY_CODE = 3

/*9.	Affichez les clients résidant en France et le montant total des commandes 
qu'ils ont passées chaque lundi en avril 1998 (en tenant compte des clients qui n'ont pas
encore passé de commande). Le tableau obtenu doit afficher les colonnes suivantes :
numéro de client, nom de l'entreprise, numéro de téléphone, montant total et pays.*/

SELECT COMPANY,ADDRESS,  QUANTITY * UNIT_PRICE as COMMANDE, ORDER_DATE, COUNTRY
FROM CUSTOMERS
JOIN ORDERS ON
CUSTOMERS.CUSTOMER_CODE = ORDERS.CUSTOMER_CODE
JOIN ORDER_DETAILS ON
ORDERS.ORDER_NUMBER = ORDER_DETAILS.ORDER_NUMBER
WHERE  CUSTOMERS.COUNTRY = 'France' 
and MONTH (ORDER_DATE) = 4 
and DATENAME(WEEKDAY,ORDER_DATE) = 'Monday'
and YEAR (ORDER_DATE) = 1998

/*10.	Affichez les clients qui ont commandé tous les produits. 
Le tableau obtenu doit afficher les colonnes: code client, nom de l'entreprise et numéro de téléphone.*/

SELECT CUSTOMERS.CUSTOMER_CODE, COMPANY, ADDRESS, PHONE
FROM CUSTOMERS	
JOIN ORDERS ON
CUSTOMERS.CUSTOMER_CODE = ORDERS.CUSTOMER_CODE
JOIN ORDER_DETAILS ON
ORDERS.ORDER_NUMBER = ORDER_DETAILS.ORDER_NUMBER
JOIN PRODUCTS ON
ORDER_DETAILS.PRODUCT_REF = PRODUCTS.PRODUCT_REF
JOIN CATEGORIES ON
PRODUCTS.CATEGORY_CODE = CATEGORIES.CATEGORY_CODE
WHERE  CUSTOMERS.COUNTRY = 'France' 
GROUP BY CUSTOMERS.COMPANY, CUSTOMERS.CUSTOMER_CODE, CUSTOMERS.ADDRESS, CUSTOMERS.PHONE
HAVING COUNT (DISTINCT PRODUCTS.PRODUCT_REF) = (SELECT COUNT (*) FROM PRODUCTS);


/*11. Affichez pour chaque client de France le nombre de commandes qu'il a passées. 
Le tableau obtenu doit afficher les colonnes : code client et nombre de commandes.*/

SELECT CUSTOMERS.CUSTOMER_CODE, COUNT (ORDER_NUMBER) as COMMANDES
FROM CUSTOMERS	
JOIN ORDERS ON
CUSTOMERS.CUSTOMER_CODE = ORDERS.CUSTOMER_CODE
WHERE  CUSTOMERS.COUNTRY = 'France' 
GROUP BY CUSTOMERS.CUSTOMER_CODE


/*12.	Affichez le nombre de commandes passées en 1996, 
le nombre de commandes passées en 1997 et la différence entre ces deux nombres.
Le tableau obtenu doit afficher les colonnes suivantes :
commandes en 1996, commandes en 1997 et différence.*/

SELECT * FROM ORDERS

SELECT 
SUM(CASE WHEN YEAR (ORDER_DATE) = 1996 THEN 1 ELSE 0 END) AS COMMANDE_1996,
SUM(CASE WHEN YEAR (ORDER_DATE) = 1997 THEN 1 ELSE 0 END) AS COMMANDE_1997,
ABS(
SUM(CASE WHEN YEAR (ORDER_DATE) = 1996 THEN 1 ELSE 0 END) - 
SUM(CASE WHEN YEAR (ORDER_DATE) = 1997 THEN 1 ELSE 0 END)) AS DIFFERENCE
FROM ORDERS;
