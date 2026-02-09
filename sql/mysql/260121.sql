use emp;
describe sales;
SELECT (SELECT emp_name FROM employees WHERE employee_id = t1.직원번호) as 직원이름, t1.* FROM (SELECT employee_id as 직원번호, SUM(amount_sold) as 판매금액, SUM(quantity_sold) as 판매수량 FROM sales WHERE YEAR(sales_date) = 2000 GROUP BY employee_id ORDER BY 2 DESC) t1 LIMIT 1;
/*
	행 간 비교와 값 선택
	LAG 선행행 값을 가져와서 반환
    LEAD 후행행 값을 반환
*/
SELECT emp_name, department_id, salary, LAG(emp_name, 1, '가장높음') OVER (PARTITION BY department_id ORDER BY salary DESC) as lag_emp_name,LEAD(emp_name, 1, '낮음') OVER (PARTITION BY department_id ORDER BY salary DESC) as lag_emp_name FROM employees WHERE department_id IN(30,60);
use study;
SELECT * FROM 학생;
-- 각 전공별 평점을 기준으로 한단계(행) 높은 평점을 가진 학생과 평점의 차이를 출력하시오!
SELECT 이름, 전공, 평점, LAG(이름, 1,'가장높음' ) OVER (PARTITION BY 전공 ORDER BY 평점 DESC) as 비교학생이름, LAG(평점, 1,0) OVER (PARTITION BY 전공 ORDER BY 평점 DESC) as 비교평점, LAG(평점, 1,평점 ) OVER (PARTITION BY 전공 ORDER BY 평점 DESC) - 평점 as 평점차이 FROM 학생;
/*
	window 절 
    rows : 행 단위로 범위
    range : 논리적 범위
    UNBOUNDED PRECEDING : 파티션으로 구분된 첫번째
    UNBOUNDED FOLLOWING : 파티션으로 구분된 끝 지점
    CURRENT ROW : 현재 
*/
use emp;
SELECT emp_name, hire_date, department_id, salary, 
	SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date 
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as first_cur 
   , SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
   ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) as cur_end
   ,SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
   ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) as pre1_cur
   ,SUM(salary) OVER (PARTITION BY department_id ORDER BY hire_date
   ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) as pre1_foll1
    FROM employees WHERE department_id IN(30,60);
-- 판매왕 직원의 2000년도 매출의 월별 누적금액을 출력하시오.
SELECT * FROM sales;
SELECT t1.* 
, SUM(판매금액) OVER (PARTITION BY sales_month  ORDER BY sales_month ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) as 누적집계  FROM
(SELECT sales_month, SUM(quantity_sold) as 판매수량, SUM(amount_sold) as 판매금액
   FROM sales WHERE employee_id = 153 AND YEAR(sales_date) = 2000 GROUP BY sales_month) t1;

SELECT t1.*, SUM(t1.판매금액) OVER (ORDER BY sales_month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as 누적합계 FROM (
SELECT sales_month, SUM(quantity_sold) as 판매수량 , SUM(amount_sold) as 판매금액 FROM sales 
WHERE employee_id = 153 AND YEAR(sales_date) = 2000 GROUP BY(sales_month)) t1;


SELECT * FROM countries; -- Italy 52770
SELECT * FROM sales;
SELECT * FROM customers;
SELECT t1.* FROM (SELECT s.sales_month, SUM(amount_sold) as month_total_sales FROM sales s 
LEFT JOIN customers c ON (s.cust_id = c.cust_id)  WHERE c.country_id = 52770 AND YEAR(s.sales_date) = 2000 GROUP BY s.sales_month ORDER BY 1 ASC) t1 
WHERE t1.month_total_sales > (SELECT AVG(target.month_total_sales) FROM 
(SELECT s.sales_month, SUM(amount_sold) as month_total_sales FROM sales s LEFT JOIN customers c ON (s.cust_id = c.cust_id)  
WHERE c.country_id = 52770 AND YEAR(s.sales_date) = 2000 GROUP BY s.sales_month) target);


SELECT t1.* FROM (SELECT s.sales_month, SUM(amount_sold) as month_total_sales, AVG(SUM(s.amount_sold)) OVER() as total_avg FROM sales s 
LEFT JOIN customers c ON (s.cust_id = c.cust_id)  WHERE c.country_id = 52770 AND YEAR(s.sales_date) = 2000 GROUP BY s.sales_month ORDER BY 1 ASC) t1 
WHERE t1.month_total_sales > t1.total_avg;






