use emp;
SELECT * FROM tb_ info;
DESCRIBE tb_info;

INSERT INTO tb_info(info_no, nm, en_nm, email) VALUES(19, '닉', 'NICK', 'nick@gmail.com');

UPDATE tb_info SET hobby = "서핑" WHERE info_no = 19;
UPDATE tb_info SET hobby = "영화보기" WHERE info_no = 9;
UPDATE tb_info SET mbti = "INTJ" WHERE info_no = 9;

-- autocommit on -> 자동으로 반영됨
SHOW variables like "autocommit";
-- 0: off, 1: on
SET autocommit = 0;

DELETE FROM tb_info WHERE info_no = 19;

SELECT * FROM employees;
SET sql_safe_updates = 0;
/*
 검색 조건이 없으면 전체가 업데이트됨 (delete도 같음)
*/
UPDATE employees SET salary = 0;
ROLLBACK;

CREATE TABLE ex4 ( id INT AUTO_INCREMENT PRIMARY KEY, qry INT, price DECIMAL(3,2), reg_date DATE, reg_time TIME, reg_datetime DATETIME, reg_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP );
SELECT * FROM ex4;
-- DROP TABLE ex4;
INSERT INTO ex4 (qry, price) VALUES (10, 9.99);
INSERT INTO ex4 (qry, price) VALUES (20, 8.999); -- warning 반올림 됨
INSERT INTO ex4 (qry, price) VALUES (10, 9.999); -- error 반올림 경고 범위를 넘음
INSERT INTO ex4 (reg_date) VALUES ('2026-01-14');
INSERT INTO ex4 (reg_date) VALUES ('2026-13-14'); -- error
INSERT INTO ex4 (reg_time) VALUES ('10:43:00');
INSERT INTO ex4 (reg_date, reg_datetime) VALUES(CURDATE(), NOW());
-- %Y 연도 %m 월 %d 일 %H 시 %i 분 %s 초
SELECT reg_date, reg_time,reg_datetime, reg_ts, DATE_FORMAT(reg_datetime, '%Y-%m-%d') as 날짜,DATE_FORMAT(reg_datetime, '%H:%i:%s') as 시간 FROM ex4;
SELECT * FROM ex4 WHERE reg_date = curdate();
INSERT INTO ex4 (reg_date) VALUES ('2026-01-08');
INSERT INTO ex4 (reg_date) VALUES ('2026-01-01');
COMMIT;
SELECT * FROM ex4 WHERE reg_date BETWEEN '2026-01-07' AND '2026-01-14'; 

/*
 문자열 대표함수 concat(여러값을 하나의 문자열), length(문자열 길이 검사), upper/lower(대소문자 변환), substring(문자열 일부 추출)
*/
SELECT CONCAT(emp_name, '[', employee_id, ']') as 직원, LENGTH(emp_name) as 길이, commission_pct, salary, salary * IFNULL(commission_pct,0) as 상여,UPPER(emp_name) FROM employees;

/*
	대표 숫자함수
    ABS(절대값), ROUND(반올림), MOD(나머지계산)
*/

SELECT ABS(-10), ROUND(10.555,1), MOD(7,3);

/*
	날짜/시간 대표함수
    NOW, CURDATE, DAYNAME, DAYOFWEEK(숫자로 요일알려줌)
*/
SELECT NOW(), CURDATE(), DAYNAME(NOW()), DAYOFWEEK(NOW());
SELECT emp_name, hire_date, DAYNAME(hire_date) FROM employees WHERE dayname(hire_date) = "Monday";
-- decode(str, '비교값1', '변환값1','그밖에')
-- CASE WHEN '조건1' true라면 THEN '값1'
SELECT cust_name, cust_gender, CASE WHEN cust_gender = 'M' THEN "남자" ELSE "여자" END AS 성별 FROM customers;

-- member 회원의 마일리지
use study;
SELECT * FROM member ORDER BY mem_mileage DESC;
SELECT mem_id, mem_name, CASE WHEN mem_mileage > 8000 THEN "VIP" WHEN mem_mileage > 5000 THEN "GOLD" ELSE "SILVER" END AS 등급 FROM member ORDER BY mem_mileage DESC;
SELECT mem_id, SUBSTRING(mem_id, 1,1), REPLACE(mem_id,'a','') FROM member; -- SUBSTRING(대상, 시작위치, 길이) REPLACE(대상, 검색어, 변경값)
-- 회원의 성별을 출력하시오
SELECT mem_name,SUBSTRING(mem_regno2,1,1), CASE WHEN SUBSTRING(mem_regno2,1,1) = 2 THEN "여자" ELSE "남자" END AS 성별  FROM member;



 