-- 환자별 총 입원 횟수를 출력하시오.
-- admissions
select a.subject_id, count(*) as admission_cnt from mimiciv_hosp.admissions a group by a.subject_id having count(*) > 5 order by admission_cnt desc;
-- diagnoses_icd
-- 입원별 진단코드 수
select * from mimiciv_hosp.diagnoses_icd di ;

-- 문자열 결합 ||
select p.subject_id ||'[' ||p.gender || ']' as gender from mimiciv_hosp.patients p;
-- 문자열 자르기
-- substring(문자열 from 시작위치 for 길이) 인덱스 시작은 1
select substring(a.admission_location from 1 for 7) as len from mimiciv_hosp.admissions a;
-- like : 대소문자 구별 ilike : 대소문자 무시
select * from mimiciv_icu.d_items where linksto like '%chart%';
select * from mimiciv_icu.d_items where linksto ilike '%chart%';
-- 타입 변환 컬럼::타입
select * from mimiciv_hosp.patients p where p.subject_id::text like '10%';

select '123'::int + 10;
-- 현재 날짜, 시간
select current date, current_timestamp;
-- interval year, months, days, hours, minutes, seconds
select a.admittime, a.admittime + interval '1 days' as 입원1일후
	, a.admittime + interval '24 hours' as 입원24시간후
	, a.admittime - interval '24 hours' as 입원24시간전 
	from mimiciv_hosp.admissions a;
-- 1주일 전
select current_timestamp - interval '7days';
-- 시간 제거
select a.admittime, a.admittime::date::timestamp
	, to_char(a.admittime, 'YYYY-MM-DD')
from mimiciv_hosp.admissions a ;
-- 날짜 차이
select a.dischtime - a.admittime as 퇴원입원차이 from mimiciv_hosp.admissions a;
-- interval 타입 계산을 위해 초로 변경
-- EXTRACT(EPOCH FROM interval) 1970-01-27 기준
select extract (epoch from (a.dischtime - a.admittime))/(24*60*60) as stay_day
	,extract(hour from a.admittime) as hours
	,a.admittime
	from mimiciv_hosp.admissions a;
-- YYYY-MM-DD HH24:MI:SS
select a.admittime, TO_CHAR(a.admittime, 'YYYY')
	, to_char(a.admittime, 'YYYY-MM')
	, to_char(a.admittime, 'YYYY-MM-DD HH24:MI:SS') from mimiciv_hosp.admissions a;
-- 새벽 3 ~ 5에 입원한 이력을 조회하시오
select extract(hour from a.admittime) as hours, * from mimiciv_hosp.admissions a where extract(hour from a.admittime) between 3 and 5 order by hours;
-- 날짜 범위 검색 2131-01-01 ~ 2131-05-31 23:59:59
-- 데이터를 검색 (admissions)
select a.* from mimiciv_hosp.admissions a 
where to_char(a.admittime, 'YYYY-MM') in ('2131-01','2131-02','2131-03','2131-04','2131-05');
SELECT a.* FROM mimiciv_hosp.admissions a 
WHERE a.admittime >= '2131-01-01 00:00:00' 
  AND a.admittime < '2131-06-01 00:00:00';
select a.admittime from mimiciv_hosp.admissions a 
where a.admittime between '2131-01-01'::timestamp and '2131-05-31 23:59:59'::timestamp;
--입원 유형별 빈도를 출력하시오 정렬: 빈도 내림차순
select a.admission_type, count(*) as cnt from mimiciv_hosp.admissions a group by rollup(a.admission_type) order by cnt desc;
-- subject_id : 환자 id
-- hadm_id : 입원 id
-- stay_id : icu 입실/퇴실 1회
--			1번 입원에 1번 심장중환자실(ccu) 중환자실 입실/퇴실 Coronary Care Unit (CCU)
--					1번 외과중환자실(sicu) 입실/퇴실 Surgical Intensive Care Unit (SICU)
select first_careunit, count(hadm_id) as icu_admission_cnt from mimiciv_icu.icustays i group by first_careunit order by 2 desc;
select * from mimiciv_icu.procedureevents p  ;

