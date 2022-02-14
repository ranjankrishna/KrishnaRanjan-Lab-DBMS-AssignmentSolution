
use `order-directory`;
SELECT * FROM `order-directory`.order;

-- 3 .Display the number of the customer group by their genders 
-- who have placed any order of amount greater than or equal to Rs.3000.

select customer.cus_gender, count(customer.cus_gender) as count
from customer
inner join `order`
on customer.cus_id = `order`.cus_id
where `order`.ord_amount>=3000
group by customer.cus_gender;


-- 4. Display all the order along with product name ordered by a customer having Customer_Id=2;
select `order`.*,product.pro_name 
from `order` ,product_details,product 
where `order`.cus_id=2 and `order`.prod_id=product_details.prod_id and product_details.pro_id=product.pro_id;

-- 5. Display the Supplier details who can supply more than one product.
SELECT * from `order-directory`.supplier s  join (select supp_id, count(SUPP_ID) as cnt from product_details
group by supp_id 
having count(SUPP_ID) > 1 ) p on s.supp_id = p.supp_id;

select supplier.*
from supplier, product_details
where supplier.supp_id in (
	select product_details.supp_id
	from product_details
    group by product_details.supp_id
    having count(product_details.supp_id) > 1
	)
group by supplier.supp_id;

-- 6. Find the category of the product whose order amount is minimum.
-- https://stackoverflow.com/questions/6924896/having-without-group-by

select category.*, product_details.prod_id, `order`.ORD_ID, product.pro_id
from `order`
inner join product_details
on `order`.prod_id = product_details.prod_id
inner join product
on product.pro_id = product_details.pro_id
inner join category
on category.cat_id = product.cat_id
having min(`order`.ord_amount);

-- 7. Display the Id and Name of the Product ordered after “2021-10-05”.
select product.PRO_ID,product.PRO_NAME, `order`.ORD_ID from product
inner join product_details
on product.PRO_ID = product_details.PRO_ID
inner join `order`
on `order`.PROD_ID = product_details.PROD_ID
where `order`.ORD_DATE > "2021-10-05";

select product.pro_id, product.pro_name, `order`.ord_id
from `order`
inner join product_details
on product_details.prod_id = `order`.prod_id
inner join product
on product.pro_id = product_details.pro_id
where `order`.ORD_DATE > "2021-10-05";

select P.PRO_ID, P.PRO_NAME from `PRODUCT` P INNER JOIN
      `PRODUCT_DETAILS` PR on PR.PRO_ID = P.PRO_ID INNER JOIN
           `ORDER` O on O.PROD_ID = PR.PROD_ID where O.ORD_DATE > "2021-10-05";

-- 8. Display customer name and gender whose names start or end with character 'A'.
-- like

select cus_name,cus_gender from customer 
where  ( customer.CUS_NAME like 'A%') OR ( customer.CUS_NAME like '%A');

select customer.cus_name ,customer.cus_gender 
from customer 
where customer.cus_name like 'A%' or customer.cus_name like '%A';

SELECT CUS_NAME, CUS_GENDER FROM CUSTOMER
WHERE CUS_NAME LIKE 'A%'
UNION
SELECT CUS_NAME, CUS_GENDER FROM CUSTOMER
WHERE CUS_NAME LIKE '%A';

delete from category where cat_id=2;

-- 9 Create a stored procedure to display the Rating for a Supplier if any 
-- along with the Verdict on that rating if any like if rating >4 then “Genuine Supplier” if rating >2 “Average Supplier” else “Supplier should not be considered”.
-- You define a DELIMITER to tell the mysql client to treat the statements, 
-- functions, stored procedures or triggers as an entire statement. Normally in a .
--  sql file you set a different DELIMITER like $$. The DELIMITER command is used to change the standard delimiter of MySQL commands

DELIMITER &&
CREATE PROCEDURE proc()
BEGIN
select supplier.supp_id, supplier.supp_name, rating.rat_ratstars,
case 
	when rating.rat_ratstars > 4 THEN 'GENUINE SUPPLIER'
    when rating.rat_ratstars > 2 THEN 'AVERAGE SUPPLIER'
    ELSE 'Supplier should not be considered'
END AS verdict from rating inner join supplier on supplier.supp_id=rating.supp_id;
END &&
DELIMITER ; 

call proc();


