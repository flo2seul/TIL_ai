-- 환자별 총 입원 횟수를 출력하시오.
-- admissions
select a.subject_id, count(*) as admission_cnt from mimiciv_hosp.admissions a group by a.subject_id having count(*) > 5 order by admission_cnt desc;
-- diagnoses_icd
-- 입원별 진단코드 수 + 코드명
select di.hadm_id  , count(*) as diagnoses_cnt  from mimiciv_hosp.diagnoses_icd di group by di.hadm_id order by 2 asc limit 1;
select * from mimiciv_hosp.diagnoses_icd di join mimiciv_hosp.d_icd_diagnoses did on di.icd_code = did.icd_code where di.hadm_id = 22205327;

-- 테이블 코멘트
comment on table mimiciv_hosp.patients is '환자 기본 인적 정보 테이블';
comment on column mimiciv_hosp.patients.subject_id is '환자 식별 번호';