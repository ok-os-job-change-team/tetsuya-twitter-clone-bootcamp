-- NOTE: mysql -u [ユーザー名] -p [データベース名] < db/benchmark_test/benchmark_pagination.sql で実行

-- キャッシュのクリア
FLUSH TABLES;

-- クエリ1: オフセット法
SELECT * FROM posts ORDER BY id LIMIT 20 OFFSET 10000000;

-- キャッシュのクリア
FLUSH TABLES;

-- クエリ2: シーク法
SELECT * FROM posts WHERE id > 10000000 ORDER BY id LIMIT 20;

-- オフセット法の実行時間を取得する
SELECT
  EVENT_ID,
  TRUNCATE(TIMER_WAIT/1000000000000,6) AS Duration,
  SQL_TEXT
FROM
  performance_schema.events_statements_history_long
WHERE
  SQL_TEXT  = 'SELECT * FROM posts ORDER BY id LIMIT 20 OFFSET 10000000';

SELECT event_name AS Stage, TRUNCATE(TIMER_WAIT/1000000000000,6) AS Duration
FROM performance_schema.events_stages_history_long WHERE NESTING_EVENT_ID=9;

-- シーク法の実行時間を取得する
SELECT
  EVENT_ID,
  TRUNCATE(TIMER_WAIT/1000000000000,6) AS Duration,
  SQL_TEXT
FROM
  performance_schema.events_statements_history_long
WHERE
  SQL_TEXT  = 'SELECT * FROM posts WHERE id > 10000000 ORDER BY id LIMIT 20';

SELECT event_name AS Stage, TRUNCATE(TIMER_WAIT/1000000000000,6) AS Duration
FROM performance_schema.events_stages_history_long WHERE NESTING_EVENT_ID=36;
