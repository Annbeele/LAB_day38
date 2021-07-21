# 1. Write a SELECT statement that lists the customer id along with their
# account number, type, the city the customer lives in and their postalcode.

select * from address; #postal code and city
select * from customer; #cust id and type and account #
select * from customeraddress; # joining fiels-cust id, addr id

select customerID, AccountNumber, CustomerType, City, PostalCode
from customer c
join customeraddress ca using(CustomerID)
join address a using(AddressID);

# 2. 	Write a SELECT statement that lists the 20 most recently launched products, their name and colour
SELECT Name, Color from product
ORDER BY SellStartDate DESC
LIMIT 20;


# 3. Write a SELECT statement that shows how many products are on each shelf in 2/5/98
SELECT * from productinventory;
SELECT shelf, count(distinct ProductID)
FROM productinventory
WHERE ModifiedDate = '1998-05-02'
GROUP BY shelf;


# 4. I am trying to track down a vendor email address… his name is Stuart and he works at
#G&K Bicycle Corp. Can you help?
SELECT * FROM contact;
SELECT * FROM vendorcontact;
SELECT * FROM vendor;

SELECT EmailAddress
FROM contact c
JOIN vendorcontact vc using(ContactID)
JOIN vendor v
WHERE c.FirstName = 'Stuart'
AND v.Name = 'G & K Bicycle Corp.';


# 5. What’s the total sales tax amount for sales to Germany? What’s the
# top region in Germany by sales tax?
SELECT * FROM salestaxrate;
SELECT * FROM salesterritory;




# 5.1. total sales tax amount for sales to Germany

#solució cutre, buscant manualment:
SELECT * FROM salesorderheader; #--> TaxAmt
SELECT * FROM stateprovince
WHERE CountryRegionCode = 'DE'; #--> Veig q el territory ID of Germany = 8

SELECT SUM(TaxAmt) from salesorderheader
WHERE TerritoryID='8';

#Solució bona, parametritzada:

# ATENCIÓ: al fer join de les taules, fem duplicats!
# per passar de Germany a territory ID ho junto amb saleterritory i no amb
# la tab province xq a terriotory id no esta duplicat i a provice sí
SELECT * FROM salesorderheader
join salesterritory using (TerritoryID) 
WHERE Name = 'Germany';

#si ho uníssim amb stateprovince veiem q ens donaria 18.361 rows i x tant tenim duplicats
# i per tant ens estaria donant un resultat q no està bé
SELECT * FROM salesorderheader
JOIN stateprovince using (TerritoryID)
WHERE CountryRegionCode = 'DE';

#Per tant la solució bona parametritzada  seria:
SELECT sum(TaxAmt) FROM salesorderheader
join salesterritory using (TerritoryID) 
WHERE Name = 'Germany';

# 5.1.2 What’s the top region in Germany by sales tax?
SELECT sp.Name as RegionName, sum(s.TaxAmt) as taxtotal
 FROM salesorderheader s # amounts
 join salesterritory st using(TerritoryID) # country - filter
 join address a on s.BillToAddressID = a.AddressID # ship address - to get region
 join stateprovince sp using(StateProvinceID) # region 
 where st.Name = 'Germany'
 Group by sp.Name
 order by sum(s.TaxAmt) DESC
 LIMIT 1;


# 6. Summarise the distinct # transactions by month
SELECT DISTINCT (count(TransactionID)), DATE_FORMAT(TransactionDate, '%Y%m')
FROM transactionhistory
GROUP BY DATE_FORMAT(TransactionDate,'%Y%m');

# 7. Which ( if any) of the sales people exceeded their sales quota this year
# and last year?
SELECT * FROM salesperson;
SELECT * FROM salesorderheader;
SELECT * FROM contacttype;
SELECT * FROM store;

SELECT SalesPersonID, SalesQuota, SalesYTD, SalesLastYear from salesperson
WHERE SalesYTD > SalesQuota AND SalesLastYear > SalesQuota;

# 8. Do all products in the inventory have photos in the database and a text product description? 


# 9. What's the average unit price of each product name on purchase orders which were not fully, but at least partially rejected?


# 10. How many engineers are on the employee list? Have they taken any sickleave?
#where title like '%ngineer%' and title not in ( 'Engineering Manager', 'Vice President of Engineering');

# 11. How many days difference on average between the planned and actual end date of workorders in the painting stages?

