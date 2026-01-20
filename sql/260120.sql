use study;
CREATE TABLE exp_goods_asia (
       country VARCHAR(10),
       seq     INT,
       goods   VARCHAR(80));

INSERT INTO exp_goods_asia VALUES ('한국', 1, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('한국', 2, '자동차');
INSERT INTO exp_goods_asia VALUES ('한국', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('한국', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('한국', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('한국', 6,  '자동차부품');
INSERT INTO exp_goods_asia VALUES ('한국', 7,  '휴대전화');
INSERT INTO exp_goods_asia VALUES ('한국', 8,  '환식탄화수소');
INSERT INTO exp_goods_asia VALUES ('한국', 9,  '무선송신기 디스플레이 부속품');
INSERT INTO exp_goods_asia VALUES ('한국', 10,  '철 또는 비합금강');

INSERT INTO exp_goods_asia VALUES ('일본', 1, '자동차');
INSERT INTO exp_goods_asia VALUES ('일본', 2, '자동차부품');
INSERT INTO exp_goods_asia VALUES ('일본', 3, '전자집적회로');
INSERT INTO exp_goods_asia VALUES ('일본', 4, '선박');
INSERT INTO exp_goods_asia VALUES ('일본', 5, '반도체웨이퍼');
INSERT INTO exp_goods_asia VALUES ('일본', 6, '화물차');
INSERT INTO exp_goods_asia VALUES ('일본', 7, '원유제외 석유류');
INSERT INTO exp_goods_asia VALUES ('일본', 8, '건설기계');
INSERT INTO exp_goods_asia VALUES ('일본', 9, '다이오드, 트랜지스터');
INSERT INTO exp_goods_asia VALUES ('일본', 10, '기계류');

COMMIT;
-- UNION 중복제거, UNION ALL 중복 제거 안함
SELECT COUNT(*) FROM (SELECT goods FROM exp_goods_asia WHERE country = '한국' UNION ALL
SELECT goods FROM exp_goods_asia WHERE country = '일본' UNION ALL SELECT '테스트') a;
-- UNION을 이용하여 회원의 직업별 마일리지 합계와 총계를 출력하시오
SELECT * FROM member;
SELECT mem_job, SUM(mem_mileage) as 마일리지합계 FROM member GROUP BY mem_job UNION 
SELECT "총계",SUM(mem_mileage) as 총계 FROM member;
/*
	분석함수(매개변수) OVER (PARTITION BY expr1, expr2.... ORDER BY expr3 WINDOW 절) 
				AV6, SUM, MIN, MAX, COUNT, RANK, DENSE_RANK, ROW_NUMBER...
				PARTITION BY: 대상 그룹
                ORDER BY: 그룹에 대한 정렬 기준
                WINDOW: 파티션으로 분할된 그룹에서 더 상세한 그룹으로 분할[ROWS or RANGE]
*/
use emp;
SELECT emp_name, ROW_NUMBER() OVER(ORDER BY emp_name ASC) as rnum, department_id,ROW_NUMBER() OVER(PARTITION BY department_id ORDER BY emp_name)as dep_rnum FROM employees;
SELECT emp_name, salary, RANK() OVER(ORDER BY salary DESC) as rnk, DENSE_RANK() OVER(ORDER BY salary DESC) as dense_rnk FROM employees;
-- 부서 null 제외
-- 부서별 salary 가장 높은 1명씩 조회 하시오.
SELECT * FROM (SELECT emp_name, department_id,salary, RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) as rnk1 FROM employees WHERE department_id IS NOT NULL) t1 WHERE rnk = 1;
-- 전체 직원 급여 순위를 내림차순으로 정하고
-- (단 동일 급여가 있다면 이름으로 정렬 오름차순)
-- 10명 출력하시오
SELECT emp_name, RANK() OVER(ORDER BY salary DESC) as 순위 FROM employees ORDER BY 2, 1 LIMIT 10;
-- 직월이름, 급여, 부서 평균급여, 전체 평균급여
SELECT emp_name, salary, AVG(salary) OVER(PARTITION BY department_id) as 부서평균, AVG(salary) OVER() as 전체평균 FROM employees;
-- 부서별 급여 평균 내림차순으로 순위를 출력하시오.
-- SELECT DISTINCT department_id, AVG(salary) OVER(PARTITION BY department_id) as 부서평균 FROM employees WHERE department_id IS NOT NULL ORDER BY 2 DESC;
SELECT department_id, ROUND(평균,2) as 평균, RANK() OVER(ORDER BY 평균 DESC) as 순위 FROM ( SELECT department_id, AVG(salary) 평균 FROM employees  WHERE department_id IS NOT NULL GROUP BY department_id) t1;
SELECT department_id, ROUND(AVG(salary),2) as 평균, RANK() OVER(ORDER BY AVG(salary) DESC) as 순위 FROM employees WHERE department_id IS NOT NULL GROUP BY department_id;
use study;
-- 부서별 직원 수 내림차순으로 순위 만들고 top 5 부서만 출력하시오.
SELECT * FROM employees;
SELECT department_id, COUNT(emp_name) as 직원수, RANK() OVER(ORDER BY COUNT(emp_name) DESC) as 순위 FROM employees GROUP BY department_id ORDER BY 2 DESC LIMIT 5;
-- 2000년도 판매(금액)왕을 출력하시요 (sales 테이블 활용)
SELECT * FROM sales;
SELECT * FROM employees; -- employee_id
SELECT employee_id FROM employees WHERE YEAR(hire_date) <= "2000";
SELECT employee_id, COUNT(*) FROM sales WHERE substring(sales_month,1,4) = "2000" GROUP BY employee_id;
SELECT s.employee_id, e.emp_name, SUM(quantity_sold*amount_sold) as 판매금액, SUM(quantity_sold) as 판매수량 FROM sales s LEFT JOIN employees e ON s.employee_id = e.employee_id  WHERE e.employee_id IN(SELECT employee_id FROM employees WHERE YEAR(hire_date) = "2000") GROUP BY s.employee_id ORDER BY 3;
SELECT  e.emp_name as 이름, s.employee_id as 사번 , SUM(s.amount_sold) as 판매금액, SUM(s.quantity_sold) as 판매수량 FROM sales s LEFT JOIN employees e ON s.employee_id = e.employee_id  WHERE substring(sales_month, 1, 4) = "2000" GROUP BY s.employee_id, e.emp_name ORDER BY 3 DESC;