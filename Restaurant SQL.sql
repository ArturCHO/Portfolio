select * from [dbo].[restauracja_tydzien]

--Average order amount per customer

select order_id, DAY, avg(price) [Avg_Price] 
	from restauracja_tydzien
	group by order_id, day
	order by order_id

--Average order amount on a day

select 
day, 
Avg(Avg_Price) [Avg_price_per_day] from 
	(
	select order_id, DAY, avg(price) [Avg_Price] 
	from restauracja_tydzien
	group by order_id, day
	) as order_avg
group by day
order by Avg_price_per_day desc

--Most frequently ordered dish 

select item_name, count(item_name) [Count] from restauracja_tydzien
group by item_name
order by Count desc

--Peak time

select hour, count(hour) [Top] from restauracja_tydzien
group by hour
order by hour

-- Avg Tip

select day, avg(tip_percent) [Avg_Tip] from restauracja_tydzien
group by day
order by Avg_Tip 

--The most profitable dish

select 
	item_name, 
	sum(price) as Total_Revenue
from restauracja_tydzien
group by item_name
order by Total_Revenue desc;

--The most profitable category 

select 
	category,
	sum(price) as Total_Revenue,
	count(order_id) as Orders_Count
from restauracja_tydzien
group by category
order by Total_Revenue desc;

--Top 3 dishes of the day

with ranked as (
	select 
		day,
		item_name,
		count(*) as Count_Item,
		row_number() over (partition by day order by count(*) desc) as Rank_Day
	from restauracja_tydzien
	group by day, item_name
)
select 
	day,
	item_name,
	Count_Item
from ranked
where Rank_Day <= 3
order by day;
