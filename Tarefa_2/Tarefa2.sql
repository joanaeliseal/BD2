-- Tarefa 2 - Views e subqueries 

-- Questão 1

select f.titulo
from filme f
where f.codest in (select e.codest
               	from estudio e
               	where e.nomeest like 'P%');

select f.titulo
from filme f
where f.codest in (select e.codest
               	from estudio e
               	where e.nomeest like 'P%')
order by f.titulo;

-- Questão 2

select f.titulo
from filme f
where exists
 	(select e.codest
 	 from estudio e
  	where f.codest = e.codest and nomeest like 'P%')
order by f.titulo;   

-- Questão 3
SELECT c.desccateg 
FROM categoria  c
where c.codcateg in (select f.codcateg from filme f)
order by c.desccateg;

SELECT c.desccateg 
FROM categoria  c join filme f on c.codcateg = f.codcateg
order by c.desccateg;

-- Questão 4
SELECT A.nomeart 
FROM artista A 
WHERE A.codart in (select p.codart 
                        from personagem p
                        where p.nomepers = 'Natalie');
						
SELECT A.nomeart 
FROM artista A 
WHERE exists (select p.codart 
                        from personagem p 
                        where p.codart = a.codart 
			                  and p.nomepers = 'Natalie');

-- Questão 5

SELECT A.nomeart 
FROM artista A 
WHERE A.codart not in (select p.codart 
                        from personagem p
                        );
SELECT A.nomeart 
FROM artista A 
WHERE not exists (select p.codart 
                        from personagem p 
                        where p.codart = a.codart
                        );
						
SELECT A.nomeart 
FROM artista A 
WHERE A.codart in (select p.codart 
                        from personagem p
                        );

-- Questão 6 

Select distinct(a.nomeart)
From artista a JOIN personagem p on a.codart = p.codart
where p.cache = (select avg(p.cache) from personagem p);



