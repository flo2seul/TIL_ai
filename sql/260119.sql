use emp;
/* 서브쿼리: SQL 문장안에 보조로 사용되는 또다른 SELECT문
	1. 스칼라 서브쿼리(SELECT절)
    2. 인라인 뷰 (FROM절)
    3. 중첩쿼리(WHRER절) */
SELECT emp_name, (SELECT department_name FROM departments WHERE department_id = a.department_id) as dep_nm, (SELECT job_title FROM jobs WHERE jobs.job_id = a.job_id) as job_title FROM employees a;
SELECT count(*) FROM employees, departments WHERE employees.department_id = departments.department_id;
SELECT t1.emp_name, t1.department_name,t2.prod_id,t2.sales_month, t2.amount_sold FROM ( SELECT a.employee_id, a.emp_name, a.salary, b.department_id, b.department_name FROM employees a INNER JOIN departments b ON (a.department_id = b.department_id)) t1 LEFT JOIN sales t2 ON t1.employee_id = t2.employee_id;
SELECT * FROM employees WHERE salary >= (SELECT AVG(salary) FROM employees) ORDER BY 6 DESC;
SELECT employee_id, emp_name, salary FROM employees WHERE salary = (SELECT MAX(salary) FROM employees);
SELECT * FROM employees ORDER BY salary DESC LIMIT 1; -- 동시에 2개 이상의 컬럼값 같은건 조회
SELECT * FROM employees WHERE (employee_id, job_id) IN (SELECT employee_id, job_id FROM job_history);
-- 수강 이력이 없는 학생 조회
use study;
SELECT * FROM 학생 a WHERE NOT EXISTS (SELECT * FROM 수강내역 WHERE 학번 = a.학번);
-- 학점이 2점인 과목을 수강한 학생을 조회하시요
SELECT DISTINCT * FROM 수강내역 
WHERE 과목번호 IN (
    SELECT 과목번호 
    FROM 과목 
    WHERE 학점 = 2
);
SELECT * FROM 학생 WHERE 학번 IN (SELECT 학번 FROM 수강내역 WHERE 과목번호 IN (SELECT 과목번호 FROM 과목 WHERE 학점 = 2));
SELECT * FROM 학생 t1 WHERE EXISTS (SELECT * FROM 수강내역 a WHERE EXISTS (SELECT * FROM 과목 WHERE 과목번호 = a.과목번호 AND 학점 = 2) AND 학번 = t1.학번);
-- 전공별 평점이 가장 높은 학생을 조회하시오.
SELECT 이름, 전공, 평점 FROM 학생 WHERE (전공, 평점) IN (SELECT 전공, MAX(평점) FROM 학생 GROUP BY 전공) ORDER BY 3 DESC;
use study;
SELECT mem_id, mem_name FROM member;
SELECT cart_member, cart_no, cart_prod, cart_qty FROM cart;
SELECT prod_id, prod_sale FROM prod;
SELECT a.mem_id, a.mem_name, b.cart_no, b.cart_prod, b.cart_qty,b.cart_qty, c.prod_sale FROM member a LEFT JOIN cart b ON (a.mem_id = b.cart_member) LEFT JOIN prod c ON (b.cart_prod = c.prod_id);
SELECT a.mem_id, a.mem_name, COUNT(DISTINCT b.cart_no) as 카드사용, COUNT(DISTINCT b.cart_prod) as 상품품목, SUB(b.cart_qty) as 수량, SUM(b.cart_qty * c.prod_sale) as 구매금액 FROM member a 
LEFT JOIN cart b ON (a.meme_id = b.cart_member) LEFT JOIN prod c ON (b.cart_qty = c.prod_id) GROUP BY a.mem_id, a.mem_name ORDER BY 수량 DESC;
SELECT YEAR(hire_date) yyyy, SUM(DAYNAME(hire_date) = "sunday") as sun,SUM(DAYNAME(hire_date) = "monday") as mon,SUM(DAYNAME(hire_date) = "tuesday") as tue, SUM(DAYNAME(hire_date) = "wednesday") as wed,SUM(DAYNAME(hire_date) = "thursday")as thu,SUM(DAYNAME(hire_date) = "friday")as fri,SUM(DAYNAME(hire_date) = "saturday") as sat, COUNT(*) as hire_sum FROM employees GROUP BY yyyy WITH ROLLUP;


