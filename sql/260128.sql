use study;

-- 1.문제 상황(비정규형) 테이블/데이터
CREATE TABLE Student_0 (
  student_id   VARCHAR(10) NOT NULL,
  student_name VARCHAR(50) NOT NULL,
  course_list  VARCHAR(255) NOT NULL,
  PRIMARY KEY (student_id)
);

INSERT INTO Student_0 (student_id, student_name, course_list) VALUES
('S01', '김민준', 'C01:DB, C02:OS'),
('S02', '이서연', 'C01:DB'),
('S03', '박지훈', 'C03:AI, C02:OS');

SELECT * FROM Student_0;

-- 계정 생성
-- id : appuser, pw:appuser  % <-- 전체 허용
CREATE USER 'appuser'@'%' IDENTIFIED BY 'appuser';
-- 권한 부여
GRANT SELECT, INSERT, UPDATE, DELETE ON money.* TO 'appuser'@'%';
-- 테이블 생성 권한
GRANT CREATE ON money.* TO 'appuser'@'%';


-- 1:1  (회원 <-> 회원상세) 
CREATE TABLE mem (
	  mem_id INT PRIMARY KEY
    , mem_name VARCHAR(50)
    , mem_email VARCHAR(100)
);
CREATE TABLE mem_detail(
       mem_id INT PRIMARY KEY
     , mem_birth DATE
     , mem_addr VARCHAR(100)
     , CONSTRAINT fk_mem_detail
       FOREIGN KEY(mem_id)
       REFERENCES mem(mem_id)
);
INSERT INTO mem VALUES(1, '홍길동','hong@gmail.com');
INSERT INTO mem VALUES(1, '길동','hong@gmail.com'); -- 오류 
INSERT INTO mem_detail VALUES(1, '1990-01-01','서울');
INSERT INTO mem_detail VALUES(2, '1990-01-01','부산'); -- 오류 
SELECT * FROM mem;
-- 1:n (회원 <-> 주문) 
CREATE TABLE mem_orders(
     order_id INT PRIMARY KEY
    ,order_date DATE
    ,mem_id INT 
    ,CONSTRAINT fk_order 
     FOREIGN KEY(mem_id)
     REFERENCES mem(mem_id)
);
INSERT INTO mem_orders VALUES (100, '2026-01-27', 1);
INSERT INTO mem_orders VALUES (101, '2026-01-27', 1);
INSERT INTO mem_orders VALUES (102, '2026-01-27', 1);
SELECT * FROM mem INNER JOIN mem_orders
 ON (mem.mem_id = mem_orders.mem_id);
-- n:m (회원 <-> 수강 <-> 과목)
CREATE TABLE mem_subject(
        subject_id INT PRIMARY KEY
       ,title VARCHAR(100)
);
CREATE TABLE mem_enrollment(
		 mem_id INT 
        ,subject_id INT 
        ,grade CHAR(2)
        ,PRIMARY KEY(mem_id, subject_id)
        ,CONSTRAINT fk_enroll_id FOREIGN KEY(mem_id)
         REFERENCES mem(mem_id)
		,CONSTRAINT fk_enroll_sub FOREIGN KEY(subject_id)
         REFERENCES mem_subject(subject_id)
);
INSERT INTO mem_subject VALUES(10, '데이터베이스');
INSERT INTO mem_subject VALUES(20, 'PYTHON');
INSERT INTO mem_enrollment VALUES(1, 10, 'A');
INSERT INTO mem_enrollment VALUES(1, 20, 'B');
SELECT * FROM mem 
INNER JOIN mem_enrollment
ON(mem.mem_id = mem_enrollment.mem_id)
INNER JOIN mem_subject 
ON(mem_enrollment.subject_id = mem_subject.subject_id);

create table USERS (
  id
);

CREATE DATABASE money;

USE money;


CREATE TABLE USERS(
		    user_id INT PRIMARY KEY AUTO_INCREMENT
		   ,login_id VARCHAR(100) NOT NULL UNIQUE
 		   ,user_pw VARCHAR(255) NOT NULL
		   ,user_nm VARCHAR(100) NOT NULL
		   ,create_dt DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE STOCKS(
       stock_id INT PRIMARY KEY AUTO_INCREMENT
       ,ticker   VARCHAR(20) NOT NULL 
       ,stock_nm VARCHAR(100) NOT NULL
       ,market_code VARCHAR(20) NOT NULL
       ,create_dt DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE WATCHLISTS(
        watch_id INT PRIMARY KEY AUTO_INCREMENT
       ,user_id  INT 
       ,stock_id INT 
       ,memo VARCHAR(1000) 
       ,create_dt DATETIME DEFAULT CURRENT_TIMESTAMP
       ,CONSTRAINT fk_watch_user FOREIGN KEY(user_id) 
        REFERENCES users(user_id)
       ,CONSTRAINT fk_watch_stock FOREIGN KEY(stock_id)
        REFERENCES stocks(stock_id)
);
SELECT user, host
FROM mysql.user;


COMMIT;

-- INSERT 이상: 과목이 아직 없는데 학생 등록
INSERT INTO Student_0 (student_id, student_name, course_list) VALUES ('S04','김펭수', NULL);
-- UDPATE 이상: 문자열 치환으로 변경하면 위험함
UPDATE Student_0 SET course_list = REPLACE(course_list, 'C02:05', 'C02:Database') WHERE student_id = 'S01';
-- DELETE 이상: S02 수강 취소alter
DELETE FROM Student_0 WHERE student_id = 'S02';
SELECT * FROM Student_0;
-- 제 1 정규형을 만족하는 테이블로 변경(student_1nf)
CREATE TABLE Student_1nf (
  student_id   VARCHAR(10) NOT NULL,
  student_name VARCHAR(50) NOT NULL,
  course_list  VARCHAR(10) NOT NULL,
  course_code VARCHAR(10) NOT NULL,
  PRIMARY KEY(student_id, course_code)
);
DROP TABLE Student_1nf;
INSERT INTO Student_1nf (student_id, student_name, course_list,course_code) VALUES
('S01', '김민준', 'C01', 'DB'),
('S01', '김민준', 'C02','OS'),
('S02', '이서연', 'C01','DB'),
('S03', '박지훈', 'C03','AI'),
('S03', '박지훈', 'C02','OS');
SELECT * FROM Student_1nf;

CREATE TABLE Enroll_1NF (
  student_id   VARCHAR(10) NOT NULL,
  course_code  VARCHAR(10) NOT NULL,
  student_name VARCHAR(50) NOT NULL,
  department   VARCHAR(50) NOT NULL,
  course_name  VARCHAR(50) NOT NULL,
  credit       INT NOT NULL,
  grade        CHAR(1) NOT NULL,
  PRIMARY KEY (student_id, course_code)
);

INSERT INTO Enroll_1NF (student_id, course_code, student_name, department, course_name, credit, grade) VALUES
('S01', 'C01', '김민준', '컴공', 'DB', 3, 'A'),
('S01', 'C02', '김민준', '컴공', 'OS', 3, 'B'),
('S02', 'C01', '이서연', '경영', 'DB', 3, 'A');

SELECT * FROM Enroll_1NF;
-- INSERT ERROR
INSERT INTO Enroll_1NF VALUES(NULL, 'C03',NULL, NULL, 'AI',3,NULL);
-- UPDATE ERROR
UPDATE Enroll_1NF SET department = '소프트웨어' WHERE student_id = 'S01' AND course_code='C01';

CREATE TABLE course(
	course_code VARCHAR(10) NOT NULL,
    course_name VARCHAR(10) NOT NULL,
    credit INT NOT NULL,
    PRIMARY KEY(course_code)
);
DROP TABLE enroll;
CREATE TABLE enroll(
 student_id VARCHAR(10) NOT NULL,
 course_code VARCHAR(10) NOT NULL,
 grade CHAR(1) NOT NULL,
 PRIMARY KEY(student_id, course_code),
 CONSTRAINT fk_enroll_stu FOREIGN KEY (student_id) REFERENCES student(student_id),
 CONSTRAINT fk_enroll_course FOREIGN KEY(course_code) REFERENCES course(course_code)
);

CREATE TABLE Order_2NF (
  order_id      VARCHAR(20) NOT NULL,
  customer_id   VARCHAR(20) NOT NULL,
  customer_name VARCHAR(50) NOT NULL,
  customer_grade VARCHAR(20) NOT NULL,
  grade_discount DECIMAL(5,2) NOT NULL,
  order_date    DATE NOT NULL,
  payment_method VARCHAR(20) NOT NULL,
  PRIMARY KEY (order_id)
);

INSERT INTO Order_2NF (order_id, customer_id, customer_name, customer_grade,grade_discount, order_date,payment_method) VALUES
('0100','U01','홍길동','GOLD',0.10, '2026-01-01','CARD'),
('0101','U02','김영희','SILVER',0.05, '2026-01-02','CASH');
SELECT * FROM Order_2NF;
CREATE TABLE tb_grade (
  customer_grade VARCHAR(20) PRIMARY KEY,
  grade_discount DECIMAL(5,2) NOT NULL
);
CREATE TABLE tb_customer(
	customer_id VARCHAR(20) PRIMARY KEY,
	customer_name VARCHAR(50) NOT NULL,
    customer_grade VARCHAR(20) NOT NULL,
    CONSTRAINT fk_grade FOREIGN KEY (customer_grade) REFERENCES tb_grade(customer_grade)
);
CREATE TABLE tb_order(
	order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    order_date DATE NOT NULL,
    payment_method VARCHAR(20) NOT NULL,
    CONSTRAINT fk_order_cust FOREIGN KEY(customer_id) REFERENCES tb_customer(customer_id)
);
-- 등급 데이터 이동
INSERT INTO tb_grade(customer_grade, grade_discount)
SELECT DISTINCT customer_grade, grade_discount FROM order_2nf;
SELECT * FROM tb_grade;
-- 회원 데이터 이동
INSERT INTO tb_customer(customer_id, customer_name, customer_grade)
SELECT customer_id, customer_name, customer_grade FROM order_2NF;
SELECT * FROM tb_customer;
SELECT * FROM order_2NF;
