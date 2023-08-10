# 	By Lilian Nogueira #
########################

# Question 1. Are the goals for dollars raised significantly different between campaigns that are successful and unsuccessful?
-- 	Yes, they are different. The average amount of money aimed for failed campaigns are 10x higher
-- 	than the successfull campaigns. Time apparently doesn't play a role since successful campaigns needed
-- 	less time to achieve their goals.

SELECT outcome, count(id) AS number_campaigns, AVG(DATEDIFF(deadline, launched)) AS Days_online,
AVG(goal) AS median_dollars_asked, SUM(goal) AS total_dollars_asked, STDDEV(goal) AS stand_dev
FROM campaign
GROUP BY outcome
ORDER BY number_campaigns DESC

--

# Question 2a. What are the top/bottom 3 categories with the most backers?
-- 	The 3 top categories by number of backers are Games, Technology and Design. 
-- 	The bottom 3 are respectively Dance, Journalism and Crafts.

SELECT c.id, c.name AS category, SUM(campaign.backers) AS total_backers from category AS c
LEFT JOIN sub_category AS sc ON c.id = sc.category_id
LEFT JOIN campaign ON campaign.sub_category_id = sc.id
GROUP BY c.id
ORDER BY total_backers DESC LIMIT 3 # It is going to show the top number of backers by category

--

SELECT c.id, c.name AS category, SUM(campaign.backers) AS total_backers from category AS c
LEFT JOIN sub_category as sc ON c.id = sc.category_id
LEFT JOIN campaign ON campaign.sub_category_id = sc.id
GROUP BY c.id
ORDER BY total_backers LIMIT 3 # It is going to show the bottom number of backers by category

-- 

# 	Question 2b. What are the top/bottom 3 subcategories by backers?
-- 	Top 3 subcategories according to number of backers: Tabletop games, product design and video games
-- 	Bottom 3 subcategories according to number of backers: Tabletop games, product design and video games

SELECT sc.id, sc.name AS subcategory, SUM(campaign.backers) AS total_backers FROM category AS c
LEFT JOIN sub_category AS sc ON c.id = sc.category_id
LEFT JOIN campaign ON campaign.sub_category_id = sc.id
GROUP BY sc.id
ORDER BY total_backers DESC LIMIT 3 # It is going to show the top number of backers by subcategory

-- 

SELECT sc.id, sc.name AS subcategory, SUM(campaign.backers) AS total_backers FROM category AS c
LEFT JOIN sub_category AS sc ON c.id = sc.category_id
LEFT JOIN campaign ON campaign.sub_category_id = sc.id
GROUP BY sc.id
ORDER BY total_backers LIMIT 5 # the limit had to be incresead to 5 since subc Literary Spaces and Chiptune did not receive any projects, therefore backers are null

-- 

# 	Question 3a. What are the top/bottom 3 categories that have raised the most money? 
-- 	Top: Tech, Games, Design. 
--  Bottom: Journalism, Dance, Crafts

SELECT c.id, c.name AS category, SUM(campaign.pledged) AS total_money_raised FROM category AS c
LEFT JOIN sub_category AS sc ON c.id = sc.category_id
LEFT JOIN campaign ON campaign.sub_category_id = sc.id
GROUP BY c.id
ORDER BY total_money_raised DESC LIMIT 3 # It is going to show the top amount of money raised by category

-- 

SELECT c.id, c.name AS category, SUM(campaign.pledged) AS total_money_raised FROM category AS c
LEFT JOIN sub_category AS sc ON c.id = sc.category_id
LEFT JOIN campaign ON campaign.sub_category_id = sc.id
GROUP BY c.id
ORDER BY total_money_raised LIMIT 3 # It is going to show the bottom amount of money raised by category

# 	Question 3.b What are the top/bottom 3 subcategories that have raised the most money?
-- 	Top: Product Design, Tabletop games, Video games
-- 	Bottom: Glass, Crochet, Latin

SELECT sc.id, sc.name AS subcategory, SUM(campaign.pledged) AS total_money_raised FROM category AS c
LEFT JOIN sub_category AS sc ON c.id = sc.category_id
LEFT JOIN campaign ON campaign.sub_category_id = sc.id
GROUP BY sc.id
ORDER BY total_money_raised DESC LIMIT 3 # It is going to show the top amount of money raised by subcategory

--

SELECT sc.id, sc.name AS subcategory, SUM(campaign.pledged) AS total_money_raised FROM category AS c
LEFT JOIN sub_category AS sc ON c.id = sc.category_id
LEFT JOIN campaign ON campaign.sub_category_id = sc.id
GROUP BY sc.id
ORDER BY total_money_raised LIMIT 5 # the limit had to be incresead to 5 since subc Literary Spaces and Chiptune did not receive any projects, therefore backers are null

-- 

# 	Question 4. What was the amount the most successful board game company raised? $ 3999795.77
# 	How many backers did they have? 40642

SELECT campaign.sub_category_id, sc.name, campaign.name, campaign. goal, campaign.pledged, campaign.backers, DATEDIFF(campaign.deadline, campaign.launched) AS Days_online, campaign.outcome FROM campaign
JOIN sub_category sc ON campaign.sub_category_id = sc.id
WHERE sc.id = 14 AND outcome = 'successful'
ORDER BY campaign.pledged DESC LIMIT 3

-- 

# Question 5a. Rank the top three countries with the most successful campaigns in terms of dollars (total amount pledged)
-- US, Great Britain and Canada

SELECT  country.id, country.name, COUNT(campaign.id) AS number_campaigns_backed, SUM(campaign.pledged) AS total_raised_by_country  
FROM campaign
JOIN country ON campaign.country_id = country.id
WHERE country.name <> 'N,0"' # to drop country name N,0" from the list
GROUP BY country.id
ORDER BY total_raised_by_country DESC LIMIT 3

# Question 5b. Top three countries with the most successful campaigns in terms of the number of campaigns backed.
-- US, Great Britain and Canada

SELECT  country.name, COUNT(campaign.id) AS number_campaigns_backed, SUM(campaign.pledged) AS total_raised_by_country  
FROM campaign
JOIN country ON campaign.country_id = country.id
GROUP BY country.id
ORDER BY number_campaigns_backed DESC LIMIT 3

-- 
# Do longer, or shorter campaigns tend to raise more money? Why?
-- When we compare the average days in terms of successfull and failed campaigns are very similar (32 and 35 days), so in this sense, it does not matter.
 
SELECT outcome, count(id) AS number_campaigns, AVG(DATEDIFF(deadline, launched)) AS Average_Days_online, AVG(pledged) AS Average_amount_raised
FROM campaign
WHERE outcome = 'failed' OR outcome = 'successful'
GROUP BY outcome

-- For the successful campaigns, we can see that the amount money raised is variable according to days online. In general, we can see that campaigns that were online between 19 and 30 days tend to raise mre money in average.

SELECT outcome, count(id) AS number_of_campaigns, AVG(pledged) AS median_dollars_raised, DATEDIFF(deadline, launched) AS Days_online
FROM campaign
WHERE id in (SELECT id from campaign WHERE DATEDIFF(deadline, launched) < 31 and outcome like 'successful') 
GROUP BY outcome, Days_online
ORDER BY Days_online DESC