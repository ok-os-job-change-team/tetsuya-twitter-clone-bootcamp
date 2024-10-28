-- NOTE: mysql -u [ユーザー名] -p [データベース名] < db/benchmark_test/benchmark_pagination.sql で実行

-- キャッシュのクリア
FLUSH TABLES;

-- クエリ1: UNION ALL
(SELECT * FROM posts WHERE content LIKE 'あらあら%')
UNION ALL
(SELECT * FROM posts WHERE title LIKE 'あらあら%');

-- キャッシュのクリア
FLUSH TABLES;

-- クエリ2: OR
SELECT * FROM posts WHERE content LIKE 'あらあら%' OR title LIKE 'あらあら%';

-- UNION ALLの実行時間を取得する
SELECT
  EVENT_ID,
  TRUNCATE(TIMER_WAIT/1000000000000,6) AS Duration,
  SQL_TEXT
FROM
  performance_schema.events_statements_history_long
WHERE
  SQL_TEXT LIKE "(SELECT * FROM posts WHERE content LIKE 'あらあら%')%";

SELECT event_name AS Stage, TRUNCATE(TIMER_WAIT/1000000000000,6) AS Duration
FROM performance_schema.events_stages_history_long WHERE NESTING_EVENT_ID=9;

-- ORの実行時間を取得する
SELECT
  EVENT_ID,
  TRUNCATE(TIMER_WAIT/1000000000000,6) AS Duration,
  SQL_TEXT
FROM
  performance_schema.events_statements_history_long
WHERE
  SQL_TEXT = "SELECT * FROM posts WHERE content LIKE 'あらあら%' OR title LIKE 'あらあら%'";

SELECT event_name AS Stage, TRUNCATE(TIMER_WAIT/1000000000000,6) AS Duration
FROM performance_schema.events_stages_history_long WHERE NESTING_EVENT_ID=40;
