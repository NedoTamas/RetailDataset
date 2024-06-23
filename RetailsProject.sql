
--select * from df_retails

--top 10 revenue sources
select top 10 ItemName,sum(Price) as sales
from df_retails
group by ItemName
order by sales desc


--top 5 products in each country
with cte as(
select Country, ItemName,sum(Price*Quantity) as sales
from df_retails
group by Country,ItemName)
select * from(
select * 
, ROW_NUMBER() over(partition by Country order by  sales desc) as rn
from cte) A
where rn <= 5
order by Country asc

--Find month over month growth comparison for 2010 and 2011 sales eg: jan 2010 vs jan 2011
with cte as (
select year(InvoiceDate) as i_year, month(InvoiceDate) as i_month,
sum(Price*Quantity) as sales 
from df_retails
group by year(InvoiceDate), month(InvoiceDate)
)
select i_month,
sum(case when i_year = 2010 then sales else 0 end) as sales_2010,
sum(case when i_year = 2011 then sales else 0 end) as sales_2011
from cte
group by i_month
order by i_month

--List out the cancellations for each item, except Manuals, Postage, Discount
select ItemName,
count(case when Cancelled>0 then 1 else null end) as Cancel
from df_retails
where ItemName NOT IN ('Postage', 'Manual', 'Discount')
group by  ItemName
order by Cancel desc

--List out the Top 10 most selling Items by Quantity
select Top 10 ItemName, sum(Quantity) as Amount
from df_retails
group by ItemName
order by Amount Desc