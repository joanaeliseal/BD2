-- Tarefa 4

-- Questão 7:

--7.1:
select a.nomeart
from artista a
where a.codart in (
	select p.codart
	from personagem p
	where p.codfilme in (
		select f.codfilme
		from filme f
		where f.duracao > 120));

-- Reescrita com JOIN:
SELECT DISTINCT a.nomeart
FROM artista a 
JOIN personagem p ON p.codart = a.codart
JOIN filme f ON f.codfilme = p.codfilme
WHERE f.duracao > 120;

--7.2:
select a.codart
from artista a
where pais = 'USA'
	INTERSECT
select p.codart
from personagem p;

-- Reescrita com Subquery:
SELECT a.codart 
FROM artista a 
WHERE pais = 'USA' 
  AND a.codart IN (
      SELECT p.codart 
      FROM personagem p
  );
-- Reescrita com Join:
SELECT DISTINCT a.codart
FROM artista a
JOIN personagem p ON a.codart = p.codart
WHERE pais = 'USA';

--7.3:
select a.codart
from artista a
	EXCEPT
select p.codart
from personagem p;

-- Reescrita com Subquery:
SELECT a.codart
FROM artista a
WHERE a.codart NOT IN (
	SELECT p.codart
	FROM personagem p);

-- Reescrita com Join:
SELECT a.codart
FROM artista a
LEFT JOIN personagem p ON a.codart = p.codart
WHERE p.codart IS NULL;

--7.4:
select distinct a.nomeart
from artista a join personagem p on a.codart = p.codart
where p.cache = (select min(p.cache) from personagem p);

-- Sem subquery:
SELECT a.nomeart
FROM artista a
JOIN personagem p ON a.codart = p.codart
ORDER BY p.cache
LIMIT 1;