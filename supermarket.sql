select * from supermarket;

--Correcting date column
SELECT date,REPLACE(date, '-', '/') from supermarket;
--correcting date format in date column
with CTE as(
SELECT date, CONVERT(varchar(10), CAST(date AS DATE), 101) as normalised
from supermarket)
update supermarket set supermarket.date = CTE.normalised
from CTE 
where supermarket.date=CTE.date;

--changing Time Column from datetime to time datatype
ALTER TABLE supermarket
ALTER COLUMN Time time(3);

select * from supermarket;

select distinct date from supermarket;

-- 1.calculating total sales by product line
select product_line,sum(total) as total_sales 
from supermarket
group by product_line;

--2.Identifying Top Performing Branches
select top 1 branch, sum(gross_income) as gross
from supermarket 
group by branch
order by gross desc;

--3.customer segmentation analysis (avg unit price & avg total) of each customer type
select customer_type, avg(unit_price) as average_unit_price, avg(total) as average_total 
from supermarket
group by Customer_type;

--4.month over month growth.
SELECT 
    CAST(YEAR(Date) as varchar(4)) + '-' + right('0'+ CAST(MONTH(Date) as varchar(2)), 2) AS YearMonth,
	sum(total) as Total,
	LAG(sum(total)) over (order by CAST(YEAR(Date) as varchar(4)) + '-' + right('0'+ CAST(MONTH(Date) as varchar(2)), 2)) as previousyear,
	sum(total) - LAG(sum(total)) over (order by CAST(YEAR(Date) as varchar(4)) + '-' + right('0'+ CAST(MONTH(Date) as varchar(2)), 2)) as Month_over_month,
	((sum(total) - LAG(sum(total)) over (order by CAST(YEAR(Date) as varchar(4)) + '-' + right('0'+ CAST(MONTH(Date) as varchar(2)), 2)))/
	LAG(sum(total)) over (order by CAST(YEAR(Date) as varchar(4)) + '-' + right('0'+ CAST(MONTH(Date) as varchar(2)), 2)))*100 as Percentage
FROM supermarket 
group by CAST(YEAR(Date) as varchar(4)) + '-' + right('0'+ CAST(MONTH(Date) as varchar(2)), 2);

--5.Top 10 customers
select top 10 Invoice_ID,sum(total) as total from supermarket
group by Invoice_ID order by sum(total) desc;

--6.gross income and rating by branches
select branch, sum(gross_income) as income, avg(Rating) as rating
from supermarket
group by Branch;

--7.specific month analysis
select Product_line, right('0' + cast(month(date) as varchar(3)),2) as month, sum(total) as total 
from supermarket
where right('0' + cast(month(date) as varchar(3)),2) = 02
group by  Product_line,right('0' + cast(month(date) as varchar(3)),2);

--8.average total sale by payment method 
select Payment,avg(total) as avg_total
from supermarket
group by Payment;

--9.gender based product line preference
select distinct Gender, Product_line from supermarket
order by Gender;

--10.Product line wise Correlation between rating and gross_income
select product_line,
	(avg(rating * gross_income) - avg(rating) * avg(gross_income))/
	(sqrt(avg(rating * rating) - avg(rating) * avg(rating)) * sqrt(avg(gross_income * gross_income) - 
	avg(gross_income) * avg(gross_income))) as correlation from supermarket
	group by product_line;
