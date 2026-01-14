-- use emp;
-- SELECT * FROM member;
-- SELECT mem_name, mem_mileage FROM member ORDER BY mem_mileage DESC LIMIT 5;
-- SELECT mem_name, mem_bir FROM member ORDER BY mem_bir DESC LIMIT 3;
-- SELECT * FROM member ORDER BY mem_name LIMIT 20, 10; -- LIMIT 시작 위치, 개수

-- CREATE DATABASE emp;
-- DROP DATABASE emp;
use emp;

SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM employees, departments WHERE employees.department_id = departments.department_id;
-- create table
CREATE TABLE ex1 (col1 CHAR(10), col2 VARCHAR(10));
-- input data
INSERT INTO ex1(col1, col2) VALUES('mysql', '마이에스큐엘');
SELECT * FROM ex1;
CREATE TABLE members(mem_id VARCHAR(100) PRIMARY KEY, mem_nm VARCHAR(100), mem_email VARCHAR(100) NOT NULL UNIQUE, mem_nick VARCHAR(100) UNIQUE, age INT, CHECK(age BETWEEN 1 AND 200));
INSERT INTO members(mem_id, mem_email) VALUES("pangsu","pangsu@gmail.com");
INSERT INTO members(mem_id, mem_email,age) VALUES("pangsu2","pangsu3@gmail.com",30);
INSERT INTO members(mem_id, mem_email,age) VALUES("pangsu3","pangsu2@gmail.com",40);
SELECT * FROM members;
SELECT * FROM members WHERE age IS NULL;
-- update value
UPDATE members SET mem_nm = "팽수" WHERE mem_id = "pangsu";
DROP TABLE tb_info;
CREATE TABLE tb_info(info_no INT PRIMARY KEY, nm VARCHAR(100), en_nm VARCHAR(100), email VARCHAR(100), hobby VARCHAR(100), mbti VARCHAR(4), create_dt DATETIME DEFAULT current_timestamp, update_dt DATETIME DEFAULT current_timestamp ON UPDATE current_timestamp);
SELECT * FROM tb_info;




