-- Tarefa 5: Exercício de Revisão

-- Questão 1:
Select cargo,primeironome,matricula
from empregado
order by cargo,primeironome;

-- Questão 2:
SELECT DISTINCT d.nome
FROM departamento d 
JOIN empregado e on d.coddepto = e.coddepto; 

-- Questão 3:
INSERT INTO departamento VALUES (DEFAULT, 'Financeiro');
UPDATE empregado
SET coddepto = 7
WHERE matricula = 5;

select * from departamento;
select * from empregado; 

-- Questão 4:
SELECT d.nome, SUM(salario)
FROM empregado e
JOIN departamento d ON d.coddepto = e.coddepto
GROUP BY d.nome
HAVING SUM(salario) > 8000;

-- Questão 5:
SELECT e.primeironome
FROM empregado e
LEFT JOIN empregado g ON e.gerente = g.matricula
WHERE e.gerente IS NULL;

-- Questão 6:
SELECT primeironome, sobrenome, salario
FROM empregado
WHERE salario = (
	SELECT MAX(salario)
	FROM empregado);

-- Questão 7:
CREATE OR REPLACE VIEW emp_deptoV AS
SELECT e.primeironome, e.sobrenome, e.salario, d.nome AS depto
FROM empregado e
JOIN departamento d ON e.coddepto = d.coddepto;

SELECT * FROM emp_deptoV;

