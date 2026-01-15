-- 대학 참조 데이터
INSERT INTO university (id, code)
SELECT 1, 'KHU'
WHERE NOT EXISTS (SELECT 1 FROM university WHERE id = 1);
