-- -- Solution
-- * Get all the details of the courses which are in `inactive` or `draft` state.
SELECT * 
FROM courses 
WHERE course_status IN ('inactive','draft');

-- * Get all the details of the courses which are related to `Python` or `Scala`.
SELECT * FROM courses
WHERE course_name LIKE '%Python%' OR course_name LIKE '%Scala%';

-- * Get count of courses by `course_status`. The output should contain `course_status` and `course_count`.
SELECT 
	course_status
	, COUNT(course_status) as course_count
FROM courses
GROUP BY 1 
ORDER BY 2 DESC;

-- * Get count of `published` courses by `course_author`. The output should contain `course_author` and `course_count`.
SELECT 
	course_author,
	COUNT(course_status) as course_count
FROM courses
WHERE course_status = 'published'
GROUP BY 1;

-- * Get all the details of `Python` or `Scala` related courses in `draft` status.
SELECT * FROM courses 
WHERE (course_name LIKE '%Python%' OR course_name LIKE '%Scala%') 
  AND course_status = 'draft';

-- * Get the author and count where the author have more than **one published** course. The output should contain `course_author` and `course_count`.
WITH cte AS (
SELECT 
	course_author
	, count(course_name) as course_count
FROM courses
GROUP BY 1
)
SELECT *
FROM cte
WHERE course_count > 1;


