SELECT * FROM (
  SELECT `posts`.* FROM `posts`
  WHERE content LIKE :query
  UNION ALL
  SELECT `posts`.* FROM `posts`
  WHERE title LIKE :query
) AS combined_results
LIMIT :limit OFFSET :offset