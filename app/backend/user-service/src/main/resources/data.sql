-- 대학 초기 데이터
INSERT INTO university (id, name, code, created_at)
SELECT 1, '경희대학교', 'KHU', NOW()
WHERE NOT EXISTS (SELECT 1 FROM university WHERE id = 1);
