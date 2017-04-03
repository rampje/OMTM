/* create table containing summary fb post data */
CREATE TABLE "fbPosts" ( "from_id" TEXT, "from_name" TEXT, "message" TEXT, 
						   "created_time" TEXT, "type" TEXT, "link" TEXT, "id" TEXT, 
						   "story" TEXT, "likes_count" REAL, "comments_count" REAL, 
						   "shares_count" REAL, "day_created" INTEGER, 
						   "dow_created" INTEGER, "month_created" INTEGER )

/* take union of the tables written from R and insert them into fbTable */
INSERT INTO fbPosts
SELECT * FROM bbc UNION
SELECT * FROM breitbart UNION
SELECT * FROM cbs UNION 
SELECT * FROM clinton UNION
SELECT * FROM cnn UNION
SELECT * FROM cspan UNION
SELECT * FROM economist UNION
SELECT * FROM faf UNION
SELECT * FROM fox UNION
SELECT * FROM hannity UNION
SELECT * FROM huckabee UNION
SELECT * FROM huffingtonpost UNION
SELECT * FROM nyt UNION
SELECT * FROM oreilly UNION
SELECT * FROM pence UNION
SELECT * FROM sanders UNION
SELECT * FROM sputnik UNION
SELECT * FROM theguardian UNION
SELECT * FROM trump UNION
SELECT * FROM usatoday UNION
SELECT * FROM warren

/* data exploration */
SELECT 
	DISTINCT from_name,
	type,
	CAST(likes_count as INT) as likes,
	COUNT(*) as number_of_posts,
	ROUND(likes_count / COUNT(*)) as likes_per_post
FROM fbPosts
GROUP BY from_id, type
ORDER BY likes_per_post DESC

-- the statuses where hillary conceded election have crazy high amounts of likes
SELECT SUM(likes_count), COUNT(*) FROM fbPosts 
WHERE from_name = "Hillary Clinton" AND type = "status";

SELECT SUM(likes_count), COUNT(*) FROM fbPosts 
WHERE from_name = "Hillary Clinton" AND type != "status"


SELECT 
 strftime('%Y-%m-%d', created_time) AS created_time,
 SUM(likes_count) AS likes_count,
 SUM(comments_count) AS comments_count,
 SUM(shares_count) AS shares_count,
 COUNT(*) as post_count
FROM trump
GROUP BY created_time
ORDER BY created_time DESC