-- New Final E-Commerce Project

-- 1 - Identify the top 5 cities with the highest total revenue.

Select
	City,
    Sum(`Total Spend`) AS Total_Revenue
From e_commerce_customer
Group By City
Order BY Total_Revenue DESC
Limit 5;

-- 2 - Which membership type has the highest average satisfaction level?

Select
	`Membership Type`,
    AVG(`Satisfaction Level`) AS Avg_Satisfaction_Level,
    Count(*) AS Satisfaction_Level_Count
From e_commerce_customer
Group By `Membership Type`
Order By Avg_Satisfaction_Level;

-- 3 - Which customer segment (based on Membership Type + Age Group) spends the most on average?

Select
Case
	When Age <=30 Then'Young'
	When Age between 30 and 50 Then 'Adult'
    else 'Senior'
End AS Customer_segment,
    `Membership Type`,
    AVG(`Total Spend`) AS AVG_Spending,
    Count(*) Customer_Count
From e_commerce_customer
Group By Customer_segment, `Membership Type`
Order By AVG_Spending DESC;

-- 4 - Segment Customers Based on Total Spend Using NTILE

Select
	`Membership Type`,
    `Total Spend`,
NTILE(4) Over (Order By `Total Spend` DESC) AS Sales_Quartile
From e_commerce_customer;

-- 5 - Group above quartiles into tier names and count customers in each tier.

With spend_ranks AS (
Select
	`Customer ID`,
    `Total Spend`,
    Ntile(4) Over (Order By `Total Spend` DESC) AS Tier
    From e_commerce_customer
)
Select
Case
	When Tier = 1 Then 'Top Spenders'
    When Tier  = 2 Then 'High Spenders'
    When Tier  = 3 Then 'Modrate Spenders'
    Else 'Budget Spenders'
End AS Spending_Tier,
Count(*) As Number_Of_Customers
From spend_ranks
GROUP BY Spending_Tier;

-- 6 - Average rating by gender — who gives better reviews?

Select
	Gender,
    AVG(`Average Rating`) AS AVG_Rating
From e_commerce_customer
Group By Gender
Order By AVG_Rating DESC;

-- 7 - Which membership tier has the most returning customers = Use "Days Since Last Purchase" → lower value = more recent activity.

Select
	`Membership Type`,
    AVG(`Days Since Last Purchase`) AS Avg_Days_Since_Last_Purchase
From e_commerce_customer
Group By `Membership Type`
Order By Avg_Days_Since_Last_Purchase;

EXPLAIN
SELECT City, SUM(`Total Spend`)
FROM e_commerce_customer
GROUP BY City;

Explain
 With Spend_Rank AS(
 Select
	`Customer ID`,
    `Total Spend`,
    NTILE(4) Over (Order By `Total Spend` DESC) AS Tier
From e_commerce_customer
)
Select
	Case
		When Tier = 1 Then 'Top Spenders'
		When Tier = 2 Then 'High Spenders'
		When Tier = 3 Then 'Modrate Spenders'
        Else 'Budget Spenders'
End AS Spending_Tier,
Count(*) AS Customer_Count
From Spend_Rank
GROUP BY Spending_Tier;