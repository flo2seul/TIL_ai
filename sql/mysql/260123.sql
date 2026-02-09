describe address;
describe customer;
describe item;
describe order_info;
describe reservation;
-- 1
SELECT * FROM customer WHERE job IN ('의사','자영업') AND YEAR(birth) >= 1988 ORDER BY birth;
-- 2
SELECT customer_name, phone_number FROM customer c INNER JOIN address a ON c.zip_code = a.zip_code WHERE a.address_detail = '강남구'; 
-- 3 
SELECT job, COUNT(*) as cnt FROM customer WHERE JOB IS NOT NULL GROUP BY job ORDER BY COUNT(*) DESC;
-- 4
SELECT DAYNAME(first_reg_date) as 요일, COUNT(*) as 회원수 FROM customer GROUP BY DAYNAME(first_reg_date) ORDER BY 2 DESC LIMIT 1;
-- 5
SELECT CASE WHEN sex_code = 'M' THEN '남자' WHEN sex_code = 'F' THEN '여자' ELSE '미등록' END as gender
, COUNT(*) as cnt FROM customer GROUP BY sex_code WITH ROLLUP; -- ROLLUP도 NULL로 잡혀서 이름이 미등록이 됨
-- 6
SELECT MONTH(reserv_date) as 월, COUNT(*) as 취소건수 FROM reservation WHERE cancel = 'Y' GROUP BY MONTH(reserv_date) ORDER BY 2 DESC;
-- 7
SELECT i.product_name as 상품이름, SUM(o.sales) as 상품매출 FROM item i INNER JOIN order_info o ON i.item_id = o.item_id GROUP BY i.product_name ORDER BY 2 DESC;
-- 8
SELECT c.customer_id, c.customer_name, r.branch, COUNT(r.customer_id) as 방문횟수, SUM(r.visitor_cnt) as 방문고객수 FROM reservation r
LEFT OUTER JOIN customer c ON r.customer_id = c.customer_id WHERE r.cancel = 'N' GROUP BY r.customer_id,r.branch ORDER BY 방문횟수 DESC, 방문고객수 DESC;
-- 9
SELECT SUBSTRING(reserv_no,1,6) as Sales_month, i.product_desc as Prod_name
, SUM(CASE WHEN DAYNAME(STR_TO_DATE(reserv_no, '%Y%m%d')) = 'Sunday' THEN o.sales ELSE 0 END) as Sun 
, SUM(CASE WHEN DAYNAME(STR_TO_DATE(reserv_no, '%Y%m%d')) = 'Monday' THEN o.sales ELSE 0 END) as Mon 
, SUM(CASE WHEN DAYNAME(STR_TO_DATE(reserv_no, '%Y%m%d')) = 'Tuesday' THEN o.sales ELSE 0 END) as Tue 
, SUM(CASE WHEN DAYNAME(STR_TO_DATE(reserv_no, '%Y%m%d')) = 'Wednesday' THEN o.sales ELSE 0 END) as Wed 
, SUM(CASE WHEN DAYNAME(STR_TO_DATE(reserv_no, '%Y%m%d')) = 'Thursday' THEN o.sales ELSE 0 END) as Thu 
, SUM(CASE WHEN DAYNAME(STR_TO_DATE(reserv_no, '%Y%m%d')) = 'Friday' THEN o.sales ELSE 0 END) as Fri 
, SUM(CASE WHEN DAYNAME(STR_TO_DATE(reserv_no, '%Y%m%d')) = 'Saturday' THEN o.sales ELSE 0 END) as Sat 
FROM order_info o INNER JOIN item i ON o.item_id = i.item_id WHERE i.product_desc = '온라인_전용상품' GROUP BY SUBSTRING(reserv_no,1,6);
-- 10
SELECT a.address_detail as 주소, COUNT(*) as 회원수 FROM customer c INNER JOIN address a ON c.zip_code = a.zip_code 
WHERE EXISTS (SELECT r.customer_id FROM order_info o INNER JOIN reservation r ON o.reserv_no = r.reserv_no) 
GROUP BY a.address_detail ORDER BY 2 DESC; 

 
