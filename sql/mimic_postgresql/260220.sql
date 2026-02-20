/*
 * postgreSQL 익명 블록 DO $$ .. $$; 형태로 실행
 * 익명 블록은 이름 없이 1회 실행하는 PL/pgSQL
 * */
do $$
begin
	for su in 2..9 loop
		raise notice 'su-%' , 2 * su; 
	end loop;
end;
$$;


create schema if not exists feat;

create table feat.users(
	id int primary key
	,nm text not null
	,update_at TIMESTAMPTZ default now()
);
insert into feat.users (id, nm) values 
(1, 'Nick'),(2, 'Judy'),(3,'Jack');
select * from feat.users;

do $$
declare
 v_id int :=1;
 v_name text;
begin
	select nm into v_name
	from feat.users
	where id = v_id;
	raise notice 'name-%',v_name;
end;
$$;
-- 사용자 정의 함수
create or replace function feat.f_get_nm(p_id int)
 returns text
 language plpgsql
 as $$
 declare
 v_name text;
 begin
 	select nm into v_name --변수에 조회 결과 할당
 	from feat.users
 	where id = p_id;
   return coalesce(v_name, 'N/A');
  end;
$$;
select feat.f_get_nm(2);
-- 프로시저 생성/수정/삭제.. 작업 수행(보통 반환 없음)
create or replace procedure feat.p_update_user(p_id int)
 language plpgsql
as $$
declare
 v_rows int;
begin
 update feat.users
 set updated_at = now()
 where id = p_id;
 get diagnostics v_rows = row_count;
 raise notice 'updated rows-% id-%', v_rows, p_id;
end;
$$;

-- 업데이트 트리거
-- 1. 트리거 함수 생성
-- 2. 트리거 생성
create or replace function feat.trig_fn()
returns trigger
language plpgsql
as $$
 begin
 raise notice '요청 작업이 처리 됐습니다.before=% after=%', old.nm, new.nm;
 return new;
end;
$$;

create trigger test_update
before update
on feat.users
for each row
execute function feat.trig_fn();

update feat.users set nm = '' where id =1;
 end;

-- 변경 이력 저장
create table if not exists feat.monitor_hist(
	hist_id bigserial primary key
	, change_at timestamptz not null default now()
	, change_by text not null default current_user -- db 계정
	, action text not null 
	, row_id bigint
	, old_row jsonb --변경 전 전체
	, new_row jsonb --변경 후 전체
);
-- 트리거 함수
create or replace function feat.trg_monitor_fn()
returns trigger
language plpgsql
as $$
 begin
 	insert into feat.monitor_hist(action, row_id, old_row, new_row)
 	values(
 		TG_OP,
 		old.id,
 		to_jsonb(old),
 		to_jsonb(new)
 	);
	return new;
 end;
 $$;
 create trigger monitor_input
 after update on feat.users
 for each row
 execute function feat.trg_monitor_fn();
 update feat.users set nm='닉' where id=1;
select * from feat.monitor_hist;

create or replace function feat.prevent_del()
 returns trigger
 language plpgsql
 as $$
 begin
 	raise exception 'delete 허용되지 않음.';
	return old;
 end;
 $$;
 
create trigger trg_delete
 before delete
 on feat.users
 for each row
 execute function feat.prevent_del();

delete from feat.users
where id = 1;
-- 삭제
drop trigger trg_delete on feat.users;
drop function feat.f_get_nm;
drop procedure feat.p_update_user;

-- for문으로 구구단을 완성하시오!
do $$
begin
	raise notice '구구단을 해볼까요?';
	for su in 2..9 loop
		raise notice '% 단', su;
		for n in 1..9 loop
			raise notice '% * % = %', su, n, su*n;	
		end loop;	
	end loop;
end;
$$;

