/*
 * allergies : 1차원 (알레르기 목록)
 * vitals : 2차원 (시간 x 지표)
 * 
 * */

create table mimiciv_hosp.patient_monitor(
	patient_id int primary key
	, allergies text[] default '{}'
	, vitals int [][]
	, create_at timestamp default now()
);
insert into mimiciv_hosp.patient_monitor values(
	1001, ARRAY['penicillin', 'aspirin']
	,'{{80, 120, 98},{85,118,97},{78,122,99}}'
	, now()
);
select * from mimiciv_hosp.patient_monitor;
select * from mimiciv_hosp.patient_monitor where 'penicillin' = any(allergies);
select cardinality(allergies)
, cardinality(vitals)  -- 배열의 총 원소 개수 
, array_dims(vitals) as dims -- 배열의 차원 수
, array_length(vitals, 1) as len1 -- 특정 차원의 길이
from mimiciv_hosp.patient_monitor;

-- unnest
select patient_id, unnest(vitals) from mimiciv_hosp.patient_monitor;
-- 수정
update mimiciv_hosp.patient_monitor set vitals[1][1] = 82, vitals[1][2] = 100 where patient_id = 1001;
insert into mimiciv_hosp.patient_monitor values(
	1002, ARRAY['dust mite', 'cat dander'],
	'{{89,118,88}}',now()	
);

select * from mimiciv_hosp.admissions a;
select round(avg(extract(epoch from (a.dischtime - a.admittime))/86400),2) as avg_los from mimiciv_hosp.admissions a;
select avg(a.dischtime - a.admittime) from mimiciv_hosp.admissions a;

select round(count(a.deathtime)::numeric /count(a.admittime)*100,2) as death_percent from mimiciv_hosp.admissions a;
select round(count(case when deathtime is not null then 1 end) * 100.0 / count(*),2)||'%' as mortality_rate from mimiciv_hosp.admissions a;

select count(*) from mimiciv_hosp.admissions a where a.deathtime - a.admittime < interval '48 hours 1 second';
select count(*) from mimiciv_hosp.admissions a where a.deathtime < a.admittime + interval '48 hours 1 second' and a.deathtime >= a.admittime;



