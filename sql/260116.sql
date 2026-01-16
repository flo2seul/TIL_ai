use study;
-- 기존 테이블 삭제 (안전한 재실행을 위해)
DROP TABLE IF EXISTS 강의내역;
DROP TABLE IF EXISTS 과목;
DROP TABLE IF EXISTS 교수;
DROP TABLE IF EXISTS 수강내역;
DROP TABLE IF EXISTS 학생;

-- ===================================
-- 1. 학생 테이블 (Student) 생성
-- ===================================
CREATE TABLE 학생 (
     학번 INT PRIMARY KEY -- 학번 (Student ID), NUMBER(10) -> INT, Primary Key로 지정
    ,이름 VARCHAR(50) NOT NULL -- 이름 (Name)
    ,주소 VARCHAR(100) -- 주소 (Address)
    ,전공 VARCHAR(50) -- 전공 (Major)
    ,부전공 VARCHAR(500) -- 부전공 (Minor)
    ,생년월일 DATE -- 생년월일 (Date of Birth)
    ,학기 INT -- 학기 (Semester), NUMBER(3) -> INT
    ,평점 DECIMAL(3, 2) -- 평점 (GPA), NUMBER -> DECIMAL(3, 2) (예: 4.50)
);

-- ===================================
-- 2. 교수 테이블 (Professor) 생성
-- ===================================
CREATE TABLE 교수 (
     교수번호 INT PRIMARY KEY -- 교수번호 (Professor ID), NUMBER(3) -> INT, Primary Key 지정
    ,교수이름 VARCHAR(20) NOT NULL -- 교수이름 (Name)
    ,전공 VARCHAR(50) -- 전공 (Major)
    ,학위 VARCHAR(50) -- 학위 (Degree)
    ,주소 VARCHAR(100) -- 주소 (Address)
);

-- ===================================
-- 3. 과목 테이블 (Course) 생성
-- ===================================
CREATE TABLE 과목 (
     과목번호 INT PRIMARY KEY -- 과목번호 (Course ID), NUMBER(3) -> INT, Primary Key 지정
    ,과목이름 VARCHAR(50) NOT NULL -- 과목이름 (Course Name)
    ,학점 INT NOT NULL -- 학점 (Credit), NUMBER(3) -> INT
);

-- ===================================
-- 4. 강의내역 테이블 (Lecture Details) 생성
-- ===================================
CREATE TABLE 강의내역 (
     강의내역번호 INT PRIMARY KEY -- 강의내역번호 (Lecture Detail No), NUMBER(3) -> INT, Primary Key 지정
    ,교수번호 INT NOT NULL -- 교수번호 (Professor ID)
    ,과목번호 INT NOT NULL -- 과목번호 (Course ID)
    ,강의실 VARCHAR(10) -- 강의실 (Classroom)
    ,교시  INT -- 교시 (Time Slot), NUMBER(3) -> INT
    ,수강인원 INT -- 수강인원 (Enrollment), NUMBER(5) -> INT
    ,년월 DATE -- 년월 (Date)
);

-- ===================================
-- 5. 수강내역 테이블 (Enrollment Details) 생성
-- ===================================
CREATE TABLE 수강내역 (
    수강내역번호 INT PRIMARY KEY -- 수강내역번호 (Enrollment Detail No), NUMBER(3) -> INT, Primary Key 지정
    ,학번 INT NOT NULL -- 학번 (Student ID)
    ,과목번호 INT NOT NULL -- 과목번호 (Course ID)
    ,강의실 VARCHAR(10) -- 강의실 (Classroom)
    ,교시 INT -- 교시 (Time Slot), NUMBER(3) -> INT
    ,취득학점 VARCHAR(10) -- 취득학점 (Grade)
    ,년월 DATE -- 년월 (Date)
);

-- ===================================
-- 외래 키 제약 조건 (Foreign Key Constraints) 추가
-- ===================================
-- 수강내역 테이블 외래 키 추가!
ALTER TABLE 수강내역
ADD CONSTRAINT FK_수강_학번 FOREIGN KEY(학번)
REFERENCES 학생(학번);

ALTER TABLE 수강내역
ADD CONSTRAINT FK_수강_과목 FOREIGN KEY(과목번호)
REFERENCES 과목(과목번호);

-- 강의내역 테이블 외래 키!
ALTER TABLE 강의내역
ADD CONSTRAINT FK_강의_교수 FOREIGN KEY(교수번호)
REFERENCES 교수(교수번호);

ALTER TABLE 강의내역
-- ADD CONSTRAINT FK_강의_과목 FOREIGN KEY(과목번호)강의내역
REFERENCES 과목(과목번호);

SELECT * FROM 수강내역;
SELECT * FROM 학생;
SELECT * FROM 학생 INNER JOIN 수강내역 ON 학생.학번 = 수강내역.학번;
SELECT * FROM 학생 LEFT OUTER JOIN 수강내역 ON 학생.학번 = 수강내역.학번;
SELECT 학생.학번, 학생.이름, COUNT(수강내역.수강내역번호) as 수강건수, COUNT(*) as alls FROM 학생 LEFT OUTER JOIN 수강내역 ON 학생.학번 = 수강내역.학번 GROUP BY 학생.학번, 학생.이름;
SELECT a.이름, a.학번, a.전공, b.수강내역번호, b.과목번호 FROM 학생 a LEFT JOIN 수강내역 b ON a.학번 = b.학번 LEFT JOIN 과목 c ON b.과목번호 = c.과목번호;
SELECT a.이름, a.학번, SUM(COALESCE(c.학점,0)) as 총학점 FROM 학생 a LEFT JOIN 수강내역 b ON a.학번 = b.학번 LEFT JOIN 과목 c ON b.과목번호 = c.과목번호 GROUP BY a.이름, a.학번 ORDER BY 3 DESC;

-- 회원의 cart 이용 횟수 조회 (이력이 존재하는) 중복 카드 id는 하나로 처리
SELECT * FROM cart;
SELECT a.mem_id, a.mem_name,COUNT(DISTINCT b.cart_no) as cart이용횟수 FROM member a INNER JOIN cart b ON a.mem_id = b.cart_member GROUP BY a.mem_id, a.mem_name ORDER BY 3 DESC;
use study;
-- prod_sale 정보를 활용하여 모든 고객의 상품품목, 상품수량, 총 구매금액을 출력하시오.
SELECT * FROM member WHERE mem_id = "n001";
SELECT * FROM cart;
SELECT * FROM prod;
SELECT a.mem_id, a.mem_name, COUNT(DISTINCT b.cart_no) as 카트사용, COUNT(DISTINCT b.cart_prod) as 상품품목, SUM(COALESCE(b.cart_qty,0)) as 수량, SUM(COALESCE(c.prod_sale*b.cart_qty,0)) as 총구매금액  FROM member a LEFT OUTER JOIN cart b ON a.mem_id = b.cart_member LEFT OUTER JOIN prod c ON b.cart_prod = c.prod_id GROUP BY a.mem_id, a.mem_name ORDER BY 5 DESC;

