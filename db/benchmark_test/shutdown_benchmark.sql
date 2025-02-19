-- performance_schemaの記録を無効化する
-- ステートメントとステージのイベントの記録を無効化
UPDATE performance_schema.setup_instruments SET ENABLED = 'NO', TIMED = 'NO' WHERE NAME LIKE '%statement/%';
UPDATE performance_schema.setup_instruments SET ENABLED = 'NO', TIMED = 'NO' WHERE NAME LIKE '%stage/%';

-- ステートメントとステージイベントの消費者を無効化
UPDATE performance_schema.setup_consumers SET ENABLED = 'NO' WHERE NAME LIKE '%events_statements_%';
UPDATE performance_schema.setup_consumers SET ENABLED = 'NO' WHERE NAME LIKE '%events_stages_%';