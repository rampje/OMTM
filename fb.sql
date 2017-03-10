/* create table containing summary fb post data */
CREATE TABLE "fbPost" ( "from_id" TEXT, "from_name" TEXT, "message" TEXT, "created_time" TEXT, 
						 "type" TEXT, "link" TEXT, "id" TEXT, "story" TEXT, "likes_count" REAL, 
						 "comments_count" REAL, "shares_count" REAL );

/* take union of the tables written from R and insert them into fbTable */
INSERT INTO fbTable
SELECT * FROM Breitbartfb
UNION
SELECT * FROM Foxfb
UNION
SELECT * FROM NYTfb
UNION 
SELECT * FROM Trumpfb
