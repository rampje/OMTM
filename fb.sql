/* create table containing summary fb post data */
CREATE TABLE "fbPosts" ( "from_id" TEXT, "from_name" TEXT, "message" TEXT, 
						   "created_time" TEXT, "type" TEXT, "link" TEXT, "id" TEXT, 
						   "story" TEXT, "likes_count" REAL, "comments_count" REAL, 
						   "shares_count" REAL, "day_created" INTEGER, 
						   "dow_created" INTEGER, "month_created" INTEGER )

/* take union of the tables written from R and insert them into fbTable */
INSERT INTO fbPosts
SELECT * FROM trump UNION
SELECT * FROM breitbart UNION
SELECT * FROM fox UNION 
SELECT * FROM faf UNION
SELECT * FROM nyt UNION
SELECT * FROM bbc UNION
SELECT * FROM economist UNION

/* data exploration */
SELECT 
	type,
	DISTINCT from_name,
	CAST(likes_count as INT) as likes
FROM trump
GROUP BY from_id, type
ORDER BY likes DESC


SELECT 
 strftime('%Y-%m-%d', created_time) AS created_time,
 SUM(likes_count) AS likes_count,
 SUM(comments_count) AS comments_count,
 SUM(shares_count) AS shares_count,
 COUNT(*) as post_count
FROM trump
GROUP BY created_time
ORDER BY created_time DESC



SELECT
	DISTINCT 
