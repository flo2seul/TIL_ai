use study;
SELECT * FROM member;

-- DISTINCT 중복 제거
SELECT DISTINCT substring(mem_regno2,1,1) FROM member;
SELECT mem_name, CASE WHEN substring(mem_regno2,1,1) = 1 THEN "남자" ELSE "여자" END as gender FROM member;

/*
	타입 변환 함수
    숫자 <-> 문자 : CAST, CONVERT
    문자 -> 날짜 : STR_TO_DATE()
    날짜 -> 문자 : DATE_FORMAT()
*/
SELECT STR_TO_DATE('20251229', '%Y%m%d'), str_to_date('20251229 09:10:00', '%Y%m%d %H:%i:%s'), DATE_FORMAT(now(),'%Y %m %d %H:%i:%s');
-- 회원의 생일을 출력하시오 2026/01/01 형태로
SELECT mem_name
	, DATE_FORMAT(mem_bir, "%Y/%m/%d") as 날짜표현
    , DAYNAME(mem_bir) as 요일
    , CONCAT(DATE_FORMAT(mem_bir, "%Y/%m/%d")
    ,"(",DAYNAME(mem_bir), ')') as 완성 FROM member;
    
-- SIGNED      | UNSIGNED
-- 음수/양수 가능 | 0 이상만
SELECT CAST('-10' AS SIGNED)
	, CAST('10' AS UNSIGNED)
    , CAST(123 AS CHAR);
    
/* 집계함수
	COUNT: 행수, AVG: 평균, SUM: 합계, MIN/MAX 최소/최대
*/
use emp;
SELECT COUNT(*) as 직원수
	, COUNT(department_id) as 널제외
    , COUNT(DISTINCT department_id) as 중복제외
    , COUNT(employee_id) as 기본키
FROM employees;
-- 부서별 직원수
SELECT department_id -- 집계함수를 제외한 함수
	, COUNT(*) as 부서별직원수
    FROM employees WHERE department_id IS NOT NULL GROUP BY department_id;
-- 부서별, 직업별 직원수
SELECT department_id -- 집계함수를 제외한 컬럼
	, job_id
	, COUNT(*) as 부서별직원수
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id, job_id -- 부서별, 직업별
ORDER BY 1; -- <-- 숫자의 의미는 select 절 첫번째 컬럼
-- 연봉
SELECT SUM(salary) as 합계
	, AVG(salary) as 평균
    , MAX(salary) as 최대
    , MIN(salary) as 최소
FROM employees;
-- 부서별 집계(합계, 평균, 최대, 최소, 직원수) 부서 null 제외
SELECT * FROM employees;
SELECT SUM(department_id) as 합계
	, AVG(department_id) as 평균
    , MAX(department_id) as 최대
    , MIN(department_id) as 최소
FROM employees  WHERE department_id IS NOT NULL GROUP BY department_id ORDER BY 1;
-- 직원수, 최소, 최대 (30,60,90) 부서 조회
SELECT department_id
	, COUNT(*) as 직원수
    , MAX(department_id) as 최대
    , MIN(department_id) as 최소
    FROM employees WHERE department_id IN(30,60,90) GROUP BY(department_id);
-- 직원의 고용일자의 요일별 인원수를 출력하시오.
SELECT * FROM employees;
SELECT DAYNAME(hire_date) as 요일, COUNT(*) 직원수 FROM employees GROUP BY DAYNAME(hire_date) ORDER BY 2 DESC;
-- 집계 결과에 검색
-- 직원수가 10명 이상 부서 출력
SELECT department_id
	,COUNT(*) as 직원수
    FROM employees
    GROUP BY department_id
    HAVING COUNT(*) >= 5 -- 그룹화된 결과에 조건을 걸기 위해 사용
    ORDER BY 2;
-- 급여 평균이 5000이상 부서 출력하시오. (평균 내림차순 정렬)
SELECT department_id, AVG(salary) as 평균
	FROM employees
    GROUP BY department_id
    HAVING AVG(salary) >= 5000
    ORDER BY 2 DESC;
SELECT department_id
	, COUNT(*) as 부서별직원수
    FROM employees
    WHERE department_id IS NOT NULL
    GROUP BY department_id WITH ROLLUP; -- 전체 합계
-- 지역별 대출합계와 총계
SELECT region
	, SUM(loan_jan_amt) as 대출합계
FROM kor_loan_status
GROUP BY region WITH ROLLUP -- GROUP BY절의 확장 기능으로, 그룹화된 데이터에 대해 중간 합계
ORDER BY 1 DESC;
-- 연도별 대출 합계와 총계를 출력하시요
SELECT * FROM kor_loan_status;
SELECT SUBSTRING(period,1,4) as 연도,SUM(loan_jan_amt) as 대출합계
FROM kor_loan_status
GROUP BY 연도 WITH ROLLUP;
-- 날짜값에서 값 추출
-- 입사 연도별 직원수와 총 직원수를 출력하시오
SELECT YEAR(hire_date) 연도
	,COUNT(*) 직원수
FROM employees
GROUP BY YEAR(hire_date) WITH ROLLUP;
use emp;
SELECT substring(nm,1,1) as 성씨
	, COUNT(*) as 명수 
    FROM tb_info
    GROUP BY 성씨
    ORDER BY 명수 DESC;
-- customers 테이블 활용
SELECT * FROM customers;
SELECT cust_gender
	, COUNT(*) as 전체
	FROM customers
    GROUP BY cust_gender WITH ROLLUP;
SELECT  COUNT(CASE WHEN cust_gender = 'F' THEN 1 END) as 여자, COUNT(CASE WHEN cust_gender = "M" THEN 1 END) as 남자, COUNT(*) as 전체
	FROM customers;

