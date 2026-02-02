use study;
-- 가명처리 연습 테이블 

CREATE TABLE patient_raw (
    patient_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(50),
    resident_id CHAR(13),
    phone VARCHAR(20),
    birth DATE,
    sex CHAR(1),
    diagnosis VARCHAR(100)
);

-- 가명처리 연습 데이터 
INSERT INTO patient_raw VALUES
('HOSP_2023_0001', '김민수', '9003151234567', '010-2345-6789', '1990-03-15', 'M', '고혈압'),
('HOSP_2023_0002', '이서연', '8507222234567', '010-9876-5432', '1985-07-22', 'F', '당뇨병'),
('HOSP_2023_0003', '박지훈', '9201103234567', '010-4567-8910', '1992-01-10', 'M', '천식'),
('HOSP_2023_0004', '최은지', '7809054234567', '010-3456-7891', '1978-09-05', 'F', '고지혈증'),
('HOSP_2023_0005', '정현우', '0308125234567', '010-1122-3344', '2003-08-12', 'M', '알레르기비염'),
('HOSP_2023_0006', '한지민', '9902216234567', '010-6677-8899', '1999-02-21', 'F', '편두통'),
('HOSP_2023_0007', '오세훈', '6504177234567', '010-9988-7766', '1965-04-17', 'M', '협심증'),
('HOSP_2023_0008', '윤아름', '0403308234567', '010-5566-7788', '2004-03-30', 'F', '아토피피부염'),
('HOSP_2023_0009', '장동혁', '8809019234567', '010-2211-4433', '1988-09-01', 'M', '요추디스크'),
('HOSP_2023_0010', '신소영', '7306120234567', '010-8899-0011', '1973-06-12', 'F', '골다공증');

SELECT * FROM patient_raw;
-- 가명처리
-- 1. 식별정보 가명키로
CREATE TABLE patient_pseudo_map(pseudo_id CHAR(36) PRIMARY KEY
			,patient_id VARCHAR(50) UNIQUE);
-- UUID(Univerally Unique Identifier) 세계적으로 중복되지 않은 고유한 ID 생성
-- 정보를 식별하기 위한 128비트 숫자, 표준화된 식별 체계
INSERT INTO patient_pseudo_map (pseudo_id, patient_id)
SELECT UUID(), patient_id FROM patient_raw;
SELECT * FROM patient_pseudo_map;
-- 2. 가명정보 테이블
CREATE TABLE patient_pseudo(pseudo_id CHAR(36), birth DATE, gender CHAR(1), diagnosis VARCHAR(100));
SELECT b.pseudo_id, a.birth, a.sex,a.diagnosis FROM patient_raw a 
JOIN patient_pseudo_map b ON a.patient_id = b.patient_id;
SELECT * FROM patient_pseudo;

SELECT STR_TO_DATE(CONCAT(YEAR(birth),'-01-01'),'%Y-%m-%d') FROM patient_pseudo;
SET SQL_SAFE_UPDATES = 0;
UPDATE patient_pseudo SET birth = STR_TO_DATE(CONCAT(YEAR(birth),'-01-01'),'%Y-%m-%d');
SELECT SQL_SAFE_UPDATES = 1;
SELECT birth, gender, COUNT(*) FROM patient_pseudo GROUP BY birth, gender HAVING COUNT(*) < 2;

-- REVOKE SELECT ON patient_raw FROM 유저명
CREATE VIEW patient_research as SELECT pseudo_id, birth, gender, diagnosis FROM patient_pseudo;

SELECT * FROM member ORDER BY mem_bir DESC;
DESCRIBE member;
DROP TABLE member_pseudo;
CREATE TABLE member_pseudo(pseudo_id CHAR(36) PRIMARY KEY
			,age_group VARCHAR(50)
            ,mem_job VARCHAR(50) 
            ,mem_mileage INT);
INSERT INTO member_pseudo (pseudo_id,age_group, mem_job,mem_mileage)
SELECT UUID(), CASE WHEN YEAR(mem_bir) > 1996 THEN '20대'      
			WHEN YEAR(mem_bir) > 1986 THEN '30대'      
			WHEN YEAR(mem_bir) > 1976 THEN '40대'     
			ELSE '50대 이상'                         
END as age_group, mem_job, mem_mileage FROM member;
SELECT * FROM member_pseudo ORDER BY age_group;


