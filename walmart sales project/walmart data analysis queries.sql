select * from sales;

-- select *,
-- (
-- 	CASE
-- 	 WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
-- 	 WHEN time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
-- 	 WHEN time BETWEEN '16:00:00' AND '23:59:59' THEN 'Evening'
-- 	END
-- ) AS time_of_day
-- from sales;

---------------------------------------------------------------------------------------------

-- alter table sales add column time_of_day varchar(20);

-- update sales
-- set time_of_day =(
-- 	CASE
-- 	 WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
-- 	 WHEN time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
-- 	 WHEN time BETWEEN '16:00:00' AND '23:59:59' THEN 'Evening'
--  	END
-- );

---------------------------------------------------------------------------------------------

-- alter table sales add column day varchar(10);

-- use to_char function to find the day from date
-- update sales
-- set day=to_char(date,'Day')

---------------------------------------------------------------------------------------------

-- use to_char function to find the month from date
-- alter table sales add column month varchar(10);

-- update sales
-- set month = to_char(date,'Month');

----------------------------------------------------------------------------------------------
------------------------------ GENERIC QUESTIONS ---------------------------------------------


--How many unique cities does the data have?
-- select distinct(city)
-- from sales;

----------------------------------------------------------------------------------------------

--In which city is each branch?
-- select distinct(city),branch from sales;


----------------------------------------------------------------------------------------------
----------------------------- Product Questions ----------------------------------------------

--How many unique product lines does the data have?
-- select distinct(product_line)
-- from sales;

----------------------------------------------------------------------------------------------

--What is the most common payment method?
-- select count(payment) as  no_of_payment, sales.payment
-- from sales
-- group by payment
-- order by no_of_payment desc;

---------------------------------------------------------------------------------------------

--What is the most selling product line?
-- SELECT
-- 	SUM(quantity) as qty,
--     product_line
-- FROM sales
-- GROUP BY product_line
-- ORDER BY qty DESC;

---------------------------------------------------------------------------------------------

--What is the total revenue by month?
-- select sum(total) as revenue_by_month , month
-- from sales
-- group by month;

---------------------------------------------------------------------------------------------

--What month had the largest COGS?
-- select month , sum(COGS) max_COGS
-- from sales
-- group by month
-- order by max_COGS desc;

---------------------------------------------------------------------------------------------

--What product line had the largest revenue?
-- select product_line , sum(total) revenue_by_product_line
-- from sales
-- group by product_line
-- order by revenue_by_product_line desc;

--------------------------------------------------------------------------------------------

--What is the city with the largest revenue?
-- select city , sum(total) total_revenue
-- from sales
-- group by city
-- order by total_revenue desc;

--------------------------------------------------------------------------------------------

--What product line had the largest VAT?
-- select avg(tax_pct) as VAT, product_line
-- from sales
-- group by product_line
-- order by VAT desc

------------------------------------------------------------------------------------

--Fetch each product line and add a column to those product line showing "Good", "Bad". 
--Good if its greater than average sales

-- select Round(avg(quantity)) as qnt
-- from sales;

-- select product_line ,
-- 	case
-- 		when avg(quantity)>=6 then 'Good'
-- 	else 'Bad'
-- end	as remark
-- from sales
-- group by product_line

---------------------------------------------------------------------------------------------
--What is the most common product line by gender?
-- SELECT
-- 	gender,
--     product_line,
--     COUNT(gender) AS total_cnt
-- FROM sales
-- GROUP BY gender, product_line
-- ORDER BY total_cnt DESC;

---------------------------------------------------------------------------------------------
--What is the average rating of each product line
-- SELECT
-- 	ROUND(AVG(rating), 2) as avg_rating,
--     product_line
-- FROM sales
-- GROUP BY product_line
-- ORDER BY avg_rating DESC;



----------------------------------------------------------------------------------------------
--------------------------------- Sales ------------------------------------------------------

--Number of sales made in each time of the day per weekday
-- select sum(quantity) , time_of_day
-- from sales
-- where day not in ('Saturday','Sunday')
-- group by time_of_day
-- order by sum(quantity) desc;

----------------------------------------------------------------------------------------------

--Which of the customer types brings the most revenue?
-- select sum(total) as revenue , customer_type
-- from sales
-- group by customer_type
-- order by revenue desc;

----------------------------------------------------------------------------------------------

--Which city has the largest tax percent/ VAT (Value Added Tax)?
-- select avg(tax_pct) as VAT, city
-- from sales
-- group by city
-- order by VAT desc

----------------------------------------------------------------------------------------------

--Which customer type pays the most in VAT?
-- select sum(tax_pct) as VAT_paid, customer_type
-- from sales
-- group by customer_type
-- order by VAT_paid desc;

----------------------------------------------------------------------------------------------
------------------------------ Customer ------------------------------------------------------

--How many unique customer types does the data have?
-- select distinct(customer_type)
-- from sales

---------------------------------------------------------------------------------------------

--Which customer type buys the most?
-- SELECT
-- 	customer_type,
--     COUNT(*)
-- FROM sales
-- GROUP BY customer_type;

----------------------------------------------------------------------------------------------

-- What is the gender of most of the customers?
-- SELECT
-- 	gender,
-- 	COUNT(*) as gender_cnt
-- FROM sales
-- GROUP BY gender
-- ORDER BY gender_cnt DESC;

----------------------------------------------------------------------------------------------

-- Which time of the day do customers give most ratings?
-- SELECT
-- 	time_of_day,
-- 	AVG(rating) AS avg_rating
-- FROM sales
-- GROUP BY time_of_day
-- ORDER BY avg_rating DESC;

----------------------------------------------------------------------------------------------
--------------------------------- ChatGPT questions-------------------------------------------

--Write a query to calculate the average gross income for Member and Normal customers.
-- select avg(gross_income) as avg_income , customer_type
-- from sales
-- group by customer_type;

---------------------------------

--Write a query to find the average Quantity sold per Product line for each Branch
-- select avg(quantity),product_line , branch
-- from sales
-- group by product_line, branch
-- order by avg(quantity)

----------------------------------
--Write a query to list all transactions where the Total sales exceed the average Total sales of all transactions.
-- select *
-- from sales
-- where "total" > (select avg(total) from sales )

-----------------------------------

--Write a query to find the Product line with the highest total sales in each City.
-- select product_line , sum(total) as total_sales , city
-- from sales
-- group by city, product_line
-- order by total_sales desc;

------------------------------------

--Write a query to calculate the total sales (SUM(Total)) and average Rating for each Product line in each Branch.
-- select sum(total) as total_sales, avg(rating) avg_rating, product_line , Branch
-- from sales
-- group by product_line, branch

-------------------------------------

--Write a query to find the top 3 Product lines with the highest average gross income.
-- select product_line, avg(gross_income)
-- from sales
-- group by product_line
-- order by avg(gross_income) desc
-- limit 3

--------------------------------------

--Write a query to find the Product line with the highest total sales for each Customer type in each Branch.
-- select product_line, customer_type , branch , total_sales
-- from
-- 	(select product_line , customer_type , branch ,
-- 	sum(total) as total_sales,
-- 	rank() over(partition by branch,customer_type order by sum(total) desc) as sales_rank
-- from sales
-- group by branch , customer_type , product_line) t
-- where sales_rank=1
-- order by total_sales desc

---------------------------------------

--Write a query to find the top 3 Branches with the highest average Rating for transactions that have Total sales above the average total sales.
-- with total_sales as(
-- 	select *
-- 	from sales
-- 	where "total" > (select avg(total) from sales)
-- )
-- select 
-- 	avg(rating) as avg_rating , branch 
-- from total_sales
-- group by branch
-- order by avg_rating desc
-- limit 3

---------------------------------------

--Write a query to identify the Customer type that contributes the highest total sales for each Branch in each month.
-- with monthly_sales as(
-- 	select branch , product_line , customer_type , sum(total) as total_sales ,month,
-- 	rank() over(partition by branch , month order by sum(total) desc ) as sales_rank
-- 	from sales
-- 	group by month , customer_type , branch , product_line
-- )
-- select branch , product_line,customer_type,month
-- from monthly_sales
-- where sales_rank=1
-- order by branch,month;

---------------------------------------------
--Write a query to identify the Product line that has the highest increase in total sales month over month for each Branch.
--first find monthly sales then monthly growth , store them in a cte then from use other query to fetch the data use order and group by clause:

-- with monthly_sales as (
-- 	select month , product_line, branch , sum(total) as monthly_total_sales
-- 	from sales
-- 	group by branch , product_line, month
-- ),
-- monthly_growth as (
-- 	select 
-- 		product_line, month , branch, monthly_total_sales,
-- 	lag(monthly_total_sales) over(partition by branch , product_line order by month) as previous_month_sales,
-- 	(monthly_total_sales - 	lag(monthly_total_sales) over(partition by branch , product_line order by month) ) as sales_growth
-- 	from monthly_sales
--  )
-- select branch, product_line,max(sales_growth) as max_sales_growth
-- from monthly_growth
-- group by branch , product_line
-- order by max_sales_growth desc , branch;

--------------------------------------------------


















