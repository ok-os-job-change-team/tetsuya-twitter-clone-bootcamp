-- NOTE: mysql -u [ユーザー名] -p [データベース名] < db/pagination_benchmark.sql で実行

-- キャッシュのクリア
FLUSH TABLES;

-- プロファイリングを有効化
SET profiling = 1;

-- クエリ1: オフセットベースのページネーション
SELECT * FROM posts ORDER BY id LIMIT 20 OFFSET 10000000;

-- キャッシュのクリア
FLUSH TABLES;

-- クエリ2: カーソルベースのページネーション
SELECT * FROM posts WHERE id > 10000000 ORDER BY id LIMIT 20;

-- クエリのプロファイルを確認
SHOW PROFILES;
SHOW PROFILE FOR QUERY 1;
SHOW PROFILE FOR QUERY 3;

-- プロファイリングを無効化
SET profiling = 0;
