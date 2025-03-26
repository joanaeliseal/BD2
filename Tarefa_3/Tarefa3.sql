-- Tarefa 3 

--1.1
Select * from empregado order by matricula;

--1.2 
select * from departamento;

-- 1.3
Insert into departamento values(default,'Marketing','Filial1'); 
select * from empregado; 
update empregado 
set coddepto = 3
where matricula in (5,6); 

--1.4
Select e.primeironome || ' ' || e.sobrenome as "Empregado"
From empregado e
Where e.cargo like 'Analista de Sistemas Pleno'; 

--1.5
Select e.primeironome || ' ' || e.sobrenome as "Empregado", d.nome as "Departamento" 
From empregado e join departamento d on e.coddepto = d.coddepto;

-- 1.6 
select * from departamento; 

Select d.nome, count(*)
From empregado e join departamento d 
on e.coddepto = d.coddepto
Group by d.nome; 

-- 1.7
Select d.nome, sum(e.salario)
From empregado e join departamento d 
on e.coddepto = d.coddepto
Group by d.nome; 

-- 1.8
Select  g.primeironome || ' ' || g.sobrenome as "Gerente",        
        e.primeironome || ' ' || e.sobrenome as "Empregado"  
From (empregado e join empregado g   on e.gerente = g.matricula)   
order by g.Gerente;

-- 1.9
Select  g.primeironome || ' ' || g.sobrenome as "Gerente",        
        e.primeironome || ' ' || e.sobrenome as "Empregado"  
From (empregado e left join empregado g   on e.gerente = g.matricula)   
order by g.Gerente;
		
-- 2.1
select e.primeironome
from empregado e
where e.coddepto in (select d.coddepto
               	from departamento d
               	);

-- 2.2 
Select  e.sobrenome  
From empregado e 
Where e.gerente in 
     (Select g.matricula
	  From empregado g
	  Where g.sobrenome like 'Guedes');
	  
-- 2.3
Select e.primeironome
From empregado e
Where not exists 
      (Select d.nome
	   From departamento d
	   Where d.coddepto = e.coddepto);

Select e.primeironome
From empregado e
Where exists 
      (Select d.nome
	   From departamento d
	   Where d.coddepto = e.coddepto);
	   
select primeironome,coddepto
from empregado; 
	   
-- 3.1
Create or replace view empdepto as
 select e.primeironome,d.nome
 From empregado e JOIN departamento d on e.coddepto = d.coddepto; 
 
 Select * from empdepto; 
 insert into empdepto values ('x','y'); 
 insert into Empregado values 
(default,'Elza', 'Gomes',current_date,'Analista de Sistemas Junior',3400.00,null,1);
 
 -- 4
 Create or replace view deptoins
 as select coddepto, nome
    from departamento; 
 select * from deptoins; 
 insert into deptoins values(4,'Humanas');
 select * from departamento;
 
 -- 5
 Create or replace view empM
 as select primeironome,matricula,dataadmissao
    from empregado
	where primeironome like 'M%'
	with check option; 
	
select * from empM; 
insert into empM values('Ana',14,current_date)
insert into empM values('Mana',14,current_date)
select * from empregado; 

-- 6
select e.coddepto
from empregado e
where e.dataadmissao>'20-01-2023'
   INTERSECT
select d.coddepto
from departamento d;

select distinct e.coddepto
from empregado e
where e.dataadmissao>'20-01-2023' and
   e.coddepto IN 
   (Select d.coddepto from departamento d);

select distinct e.coddepto
from empregado e JOIN departamento d on e.coddepto = d.coddepto
where e.dataadmissao>'20-01-2023';

-- 7 
WITH
Custo_depto as (
  Select d.nome, sum(e.salario) as total_depto
  From empregado e JOIN departamento d on e.coddepto = d.coddepto
  Group by d.nome),
  Custo_medio as (
	Select sum(total_depto)/Count(*) as media_dep
	From Custo_depto)
Select *
From Custo_depto
Where total_depto > (
        	Select media_dep
        	From Custo_medio)
Order by nome; 