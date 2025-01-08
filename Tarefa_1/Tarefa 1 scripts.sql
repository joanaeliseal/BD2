-- TAREFA 1

CREATE TABLE Filme ( 
       CodFILME       Serial  NOT NULL,
       Titulo          Varchar(25),
       Ano             integer,
       Duracao         integer,
       CodCATEG       integer,
       CodEst         integer);

CREATE TABLE Artista ( 
       CodART      Serial  NOT NULL,
       NomeART    Varchar(25),
       Cidade          Varchar(20),
       Pais            Varchar(20),
       DataNasc       Date);

CREATE TABLE Estudio ( 
       CodEst     serial  NOT NULL,
       NomeEst    Varchar(25));

CREATE TABLE Categoria ( 
       CodCATEG       serial  NOT NULL,
       DescCATEG VARCHAR(25));

CREATE TABLE Personagem ( 
       CodART     integer  NOT NULL,
       CodFILME   integer  NOT NULL,
       NomePers  VARCHAR(25),
       Cache           numeric(15,2));

ALTER TABLE Filme ADD CONSTRAINT PKFilme PRIMARY KEY(CodFILME);

ALTER TABLE Artista ADD CONSTRAINT PKArtista PRIMARY KEY(CodART);

ALTER TABLE Estudio ADD CONSTRAINT PKEst PRIMARY KEY(CodEst);

ALTER TABLE Categoria ADD CONSTRAINT PKCategoria PRIMARY KEY(CodCATEG);

ALTER TABLE Personagem ADD CONSTRAINT PKPersonagem PRIMARY KEY(CodART,CodFILME);

ALTER TABLE Filme ADD CONSTRAINT FKFilme1Categ FOREIGN KEY(CodCATEG) REFERENCES Categoria;

ALTER TABLE Filme ADD CONSTRAINT FKFilme2Estud FOREIGN KEY(CodEst) REFERENCES Estudio;

ALTER TABLE Personagem ADD CONSTRAINT FKPersonagem2Artis FOREIGN KEY(CodART) REFERENCES Artista;

ALTER TABLE Personagem ADD CONSTRAINT FKPersonagem1Filme FOREIGN KEY(CodFILME) REFERENCES Filme;

-- Questão 8: os dados aparecem em ordem alfabética, apesar de não terem sido inseridos assim. O ORDER BY organiza os dados
-- em ordem alfabética.

-- Questão 9:
SELECT *
FROM Artista
WHERE NomeArt LIKE 'B%' -- filtra os registros que começam com B
ORDER BY NomeArt;

-- Questão 10:
SELECT *
FROM Filme
WHERE ano = 2019;

-- Questão 11:
UPDATE Personagem
SET cache = cache + cache*0.15;
SELECT * FROM Personagem;

-- QUESTÃO 13:
DELETE FROM Artista
WHERE NomeArt = 'Taylor Lautner';

-- Questão 14
SELECT Titulo
FROM Filme
WHERE Duracao > 120;

-- Questão 15:
SELECT * FROM Artista
WHERE Cidade IS NULL;

UPDATE Artista
SET Cidade = 'Cidade Desconhecida'
WHERE CodArt IN(1,3,4); -- artistas com cidades nulas

-- Questão 16:
SELECT c.DescCateg
FROM Filme f
JOIN Categoria c ON f.CodCateg = c.Codcateg -- campo CodCateg é comum as duas tabelas
WHERE f.Titulo = 'Coringa';

-- Questão 17:
SELECT f.Titulo AS Filme,
		e.NomeEst AS Estudio,
		c.DescCateg AS Categoria,
FROM Filme f
JOIN Estudio e ON f.CodEst = e.CodEst
JOIN Categoria c ON f.CodCateg = c.Codcateg;

-- Questão 18:
SELECT a.NomeArt
FROM Personagem p
JOIN Filme f ON p.CodFilme = f.CodFilme -- relaciona a tabela personagem a tabela filme
JOIN Artista a ON a.CodArt = p.CodArt -- relaciona a tabela personagem com a tabela artista
WHERE f.Titulo = 'Encontro Explosivo'; 

-- Questão 19:
SELECT a.NomeArt, p.NomePers
FROM Artista a
JOIN Personagem p ON a.CodArt = p.CodArt -- liga personagem a artista
JOIN Filme f ON p.CodFilme = f.CodFilme -- liga personagens aos filmes
JOIN Categoria c ON c.CodCateg = f.CodCateg -- liga os filmes as suas categorias
WHERE a.NomeArt LIKE 'B%' -- seleciona artistas que iniciam com a letra B
	AND c.DescCateg = 'Aventura'; -- seleciona os filmes que pertecem a categoria aventura

-- Questão 20:
SELECT c.DescCateg, COUNT(c.DescCateg) AS TotalFilmes -- contador para os filmes em categoria
FROM Categoria c
JOIN Filme f ON c.CodCateg = f.CodCateg
GROUP BY c.DescCateg;

-- Questão 21:
SELECT a.NomeArt, p.NomePers
FROM Artista a
LEFT OUTER JOIN personagem p ON a.codArt = p.codArt;
-- retorna todos os registros da tabela à esquerda (arista), mesmo que
-- não existam correspondências na tabela à direita (personagem)

-- Questão 22:
SELECT CodArt
FROM Artista
EXCEPT
	SELECT codart
	FROM Personagem;
-- Except retorna os valores que estão na primeira consulta, mas não estão na segunda consulta.
-- retorna os códigos (codart) dos artistas que não interpretaram nenhum personagem

-- Questão 23:
SELECT f.Titulo AS filme
FROM filme f
LEFT JOIN Categoria c ON f.codcateg = c.codcateg
WHERE f.codcateg IS NULL;
-- LEFT JOIN: retorna todos os registros da tabela filme, mesmo que não existam categorias correspondentes
-- WHERE: filtra os registros em que a coluna codcateg da tabela filme está vazia (NULL), ou seja, os filmes que não possuem categoria associada