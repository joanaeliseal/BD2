-- Exercícios de revisão (12) 

select * from empregado order by matricula;

-- Questão 1
select 123.5678::decimal;
select 123.5678::smallint;
Select coalesce(null,'Nada');

-- Questão 2
Select * from empregado; 

select * 
from pg_indexes
where tablename like 'empregado'; 

create index deptoind on empregado(coddepto); 

-- Questão 3

select matricula, salario from empregado order by salario; 

insert into Empregado values (14,'João', 'Guedes',current_date,
							  'Analista de Sistemas Junior',940.00,null,1);
insert into Empregado values (15,'José', 'Batista',current_date,
							  'Analista de Sistemas Pleno',1200.00,1,1);

Do $$
Declare
  cursor_emp cursor for select salario from empregado; 
  total_emp_recebe_menos integer default 0; 
  total_emp integer default 0;
  percentual decimal;
Begin
  select count(*) into total_emp from empregado;
  for i in cursor_emp loop 
      If i.salario < 1350.00
	     then total_emp_recebe_menos = total_emp_recebe_menos + 1; 
	  end if; 
  end loop; 
  raise notice 'Total de empregados que recebem menos que o salário base: %',total_emp_recebe_menos; 
  raise notice 'Total geral de Empregados: %',total_emp; 
  percentual = round((total_emp_recebe_menos::decimal /total_emp::decimal) *100); 
  raise notice 'Percentual de empregados que recebem menos que o salário base: % %%',percentual; 
 end; $$;
 
 -- 2 segunda parte
 
CREATE OR REPLACE PROCEDURE mostratotaisSal()
LANGUAGE plpgsql
AS $$
DECLARE
  cursor_emp cursor for select salario from empregado; 
  total_emp_recebe_menos integer default 0; 
  total_emp integer default 0;
  percentual decimal;
Begin
  select count(*) into total_emp from empregado;
  for i in cursor_emp loop 
      If i.salario < 1350.00
	     then total_emp_recebe_menos = total_emp_recebe_menos + 1; 
	  end if; 
  end loop; 
  raise notice 'Total de empregados que recebem menos que o salário base: %',total_emp_recebe_menos; 
  raise notice 'Total geral de Empregados: %',total_emp; 
  percentual = round((total_emp_recebe_menos::decimal /total_emp::decimal) *100); 
  raise notice 'Percentual de empregados que recebem menos que o salário base: % %%',percentual; 
 end; $$;
 
 Call mostratotaisSal(); 
 
 -- Questão 4
 
 ALTER TABLE empregado DISABLE TRIGGER ALL; 
 
 -- Questão 5
 
CREATE OR REPLACE function testa_salario() returns trigger
as $$
Begin
    If new.salario > 30000 then
        raise exception 'salario alto';
    end if;
    return new; 
    exception
       when raise_exception then
           Raise notice 'Tentativa de aumento exagerada!!! %', new.salario;
           return null;
 end;
$$ LANGUAGE plpgsql;  

-- drop trigger verSalario on empregado; 

create trigger verSalario 
     BEFORE INSERT OR UPDATE OF salario ON empregado
     FOR EACH ROW  Execute function testa_salario(); 
 
 insert into empregado(matricula,primeironome,salario,gerente,coddepto) 
 values (45,'Poliana45',7000,2,2);
 select * from empregado where primeironome = 'Poliana45'; 
 
 insert into empregado(matricula,primeironome,salario,gerente,coddepto) 
 values (47,'Poliana47',70000,2,2);
 
 select * from empregado where primeironome = 'Poliana47'; 

-- Questão 6

-- drop table testeINC; 

CREATE TABLE testeINC (
      ID           integer    NOT NULL,
      Descricao  VARCHAR(50)  NOT NULL);
ALTER TABLE testeINC ADD CONSTRAINT testepk PRIMARY KEY(ID);

-- truncate table testeInc; 
select * from testeInc; 

select max(id) from testeinc; 
SELECT Coalesce(MAX(id),0) +1 FROM testeINC;

CREATE OR REPLACE Function fazInc()
returns trigger as $$
Declare contador integer; 
BEGIN
  contador:=0;
  SELECT Coalesce(MAX(id),0) +1 INTO contador FROM testeINC;
  NEW.id:=contador;
  return new; 
END;
$$ language plpgsql; 

-- drop trigger testeIncID on testeinc; 
Create TRIGGER testeIncID 
  BEFORE INSERT ON testeINC
  FOR EACH ROW
  Execute procedure fazInc(); 

select * from testeInc; 

insert into testeINC(descricao) values('X');

-- Questão 7
select * from empregado; 

alter table empregado add column data_nasc date; 

update empregado 
set data_nasc = '12/12/2000'
where matricula in (2,3,13,14); 

update empregado 
set data_nasc = '12/12/2015'
where matricula in (4,5,10,11);

select primeironome,data_nasc from empregado; 

-- Questão 8 

CREATE or replace function Idade()
returns trigger as $$
declare idade integer;
BEGIN 
  select ABS(extract (year from age(new.data_nasc))) into idade;
  IF idade < 21 THEN 
    raise exception '%', 'Muito jovem para o cargo!' using errcode = 45000;  
  END IF; 
  return new; 
END;
$$ language plpgsql; 

-- drop trigger verificaidade on empregado; 

Create TRIGGER VerificaIdade 
  Before INSERT ON Empregado 
  FOR EACH ROW 
  execute procedure Idade(); 

insert into Empregado values 
(256,'Joana3', 'Cintra',current_date,'Analista de Sistemas Junior',3400,null,1,'11/02/2016');

insert into Empregado values 
(26,'Patrick2', 'Borges',current_date,'Analista de Sistemas Pleno',7000,1,1,'10/03/2000');

select matricula,primeironome,data_nasc 
from empregado order by matricula; 
 
