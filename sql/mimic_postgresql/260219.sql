/*
 * WITH
 * 별칭으로 사용하여 SELECT문을 다른 SELECT 문에서 참조할 수 있다.
 * 
 * */

select * from (select a.hadm_id, a.subject_id from mimiciv_hosp.admissions a) t1;
with t1 as (select a.hadm_id, a.subject_id from mimiciv_hosp.admissions a),
t2 as (select l.hadm_id, count(*) as cnt from mimiciv_hosp.labevents l group by l.hadm_id)
select * from t1 left join t2 on t1.hadm_id = t2.hadm_id;

-- with 대상 검색 -> 집계 -> 결과
with filtered as (
	select l.hadm_id, l.valuenum
	from mimiciv_hosp.labevents l
	where l.valuenum is not null
)
, agg as (
	select hadm_id, round(avg(valuenum)::numeric,3) as mean_v
	from filtered
	group by hadm_id
)
select *
from agg order by mean_v desc;

--재귀 with
with recursive nums as (
	select 1 as n -- 시작
	union all
	select n+1
	from nums 
	where n < 12
)
select n from nums;
--  이번달 1일부터 마지막 날 까지 출력
with recursive cal as (
	select date_trunc('month', now())::date as day
	union all
	select day + 1
	from cal
	where day < (date_trunc('month', now()) + interval'1 month -1 day')::date
)
select day from cal;
-- 202601 - 202612 행을 출력
with recursive cal as (
	select 1 as n 
	union all
	select n+1
	from cal 
	where n < 12
)
select n 
	,lpad(n::text, 2, '0')
	,to_char(now(), 'yyyy')
	,to_char(now(), 'yyyy') || lpad(n::text, 2, '0') as mm
	,to_char(make_date(2026, n, 1),'yyyymm')
from cal;
-- 이번주 mon-sun 출력
with recursive cal as (
	select 16 as n 
	union all
	select n+1
	from cal 
	where n < 22
)
select
	to_char(make_date(2026, 2, n),'yyyymmdd') as date
	,to_char(make_date(2026, 2, n),'fmday') as day
from cal;
--
select date_trunc('week',now());
with recursive week_cal as (
	select date_trunc('week', now())::date as d
	union all
	select d + 1
	from week_cal
	where d < date_trunc('week', now())::date + 6
)
select d, to_char(d,'Dy') as weekday_en from week_cal;

-- 재귀with를 위한 
select * from public.dept;

with recursive org as (
	select dept_id, dept_name, parent_id, 1 as depth
	from dept
	where parent_id is null -- 시작조건
	union all
	select d.*, o.depth + 1 as depth
	from dept d
	inner join org o on d.parent_id = o.dept_id -- 부모 -> 자식 트리를 확장
)
select depth, repeat('    ', depth-1) || dept_name as tree
from org;

with recursive org as (
	select dept_id, dept_name, parent_id, 1 as depth
	, ARRAY[dept_id] as path_id
	, dept_name as path_txt
	from public.dept
	where parent_id is null
	union all
	select d.dept_id, d.dept_name, d.parent_id, o.depth + 1
	, o.path_id || d.dept_id
	, o.path_txt || '>' || d.dept_name
	from public.dept d
	inner join org o on d.parent_id = o.dept_id
	where not (d.dept_id = any(o.path_id)) 
)
select * from org;

use emp;

with recursive months as (
	select 1 as m
	union all
	select m + 1
	from months
	where m < 12
)
, a as (select concat('2012', lpad(m,2,'0')) as period from months)
, b as (select * from emp.kor_loan_status kis
	where region = '대전'
	and gubun = '기타대촐'
	and period like '2012%'
)
select a.period, ifnull(b.loan_jan_amt,0) as amt
from a
left outer join b on a.period = b.period;

-- kor_loan_status 테이블에서 '연도별' '최종월(마지막월)' 기준 가장 대출이 많은 도시와 잔액을 구하시오
-- 2011 년의 최종년도는 12월 이지만 2013년은 11월 
select b2.*
from (
        select period,
               region,
               sum(loan_jan_amt) jan_amt
        from emp.kor_loan_status 
        group by period, region
     ) b2
inner join (
        select b.period,
               max(b.jan_amt) max_jan_amt
        from (
                select period, region, sum(loan_jan_amt) jan_amt
                from emp.kor_loan_status 
                group by period, region
             ) b
        inner join (
                select max(period) max_month
                from emp.kor_loan_status
                group by substr(period,1,4)
             ) a
          on b.period = a.max_month
        group by b.period
     ) c   
  on b2.period = c.period
 and b2.jan_amt = c.max_jan_amt;

with b as (select period, region, sum(loan_jan_amt) jan_amt
        from emp.kor_loan_status 
        group by period, region)
, c as ( 
        select b.period,
               max(b.jan_amt) max_jan_amt
        from  b
        inner join (
                select max(period) max_month
                from emp.kor_loan_status
                group by substr(period,1,4)
             ) a
          on b.period = a.max_month
        group by b.period
     )
  select b.* from b
 inner join c on b.period = c.period
 and b.jan_amt = c.max_jan_amt;
