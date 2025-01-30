-- Tarefa 6

-- Questão 1:
DO $$
DECLARE
  nomeCli VARCHAR(40);
  qtdelinhas INTEGER;
BEGIN
  SELECT nome INTO nomeCli FROM cliente WHERE codcli = 2;
  GET DIAGNOSTICS qtdelinhas := ROW_COUNT;
  RAISE NOTICE 'Nome cliente = %', nomeCli;
  RAISE NOTICE 'Quantidade de registros retornados = %', qtdelinhas;
END$$;
/* 
O que esse código faz?
1.Declara as variáveis nomeCli (para armazenar o nome do cliente) e qtdelinhas (para armazenar a quantidade de registros retornados).
2.Executa um SELECT para buscar o nome do cliente onde codcli = 2 e armazena o valor na variável nomeCli.
3.Usa GET DIAGNOSTICS qtdelinhas := ROW_COUNT; para armazenar na variável qtdelinhas quantos registros foram retornados pela consulta.
4.Exibe mensagens usando RAISE NOTICE, mostrando o nome do cliente e a quantidade de registros retornados.

RETORNO: um registro 
*/

-- Questão 2:
DO $$
DECLARE
  clireg cliente%ROWTYPE;
  info VARCHAR(50);
BEGIN
  clireg.codcli := 13;
  clireg.nome := 'Ariane Botelho';
  clireg.cidade := 'Campina Grande';
  SELECT clireg.nome || ' trabalha em ' || clireg.cidade INTO info;
  RAISE NOTICE 'Informação = %', info;
END$$;
/* 
O que esse código faz?
1.Declara clireg como cliente%ROWTYPE, ou seja, um registro completo da tabela cliente (com todas as colunas).
2.Define manualmente os valores para clireg.codcli, clireg.nome e clireg.cidade.
3.Concatena nome e cidade em uma string e armazena na variável info.
4.Exibe essa informação via RAISE NOTICE.
Para que serve ROWTYPE?
1.ROWTYPE permite que uma variável armazene um registro inteiro de uma tabela, incluindo todos os seus campos, sem precisar declará-los individualmente.
2.Se a estrutura da tabela mudar (por exemplo, se adicionarmos uma nova coluna), o código continuará funcionando sem alterações.
*/

-- Questão 3:
EXPLAIN SELECT * FROM cliente WHERE uf = 'PB';
/*
a) Qual o custo dessa consulta?
cost=0.00...1.20 rows=1 width=338
O PostgreSQL exibe o custo da consulta em forma de "custo inicial" e "custo total".
Se não houver índice na coluna uf, o custo pode ser alto, pois ele precisará varrer toda a tabela.
b) Quantos registros serão obtidos?

c) Tempo de resposta
062 msec.
*/

-- Questão 4:
-- índice e desempenho
CREATE TABLE testaCLI AS SELECT * FROM cliente;
SELECT * FROM testaCLI;
-- bloco anonimo para inserção: criar um grande volume de dados repetindo os registros da tabela cliente 1 milhão de vezes
DO $$
DECLARE i INT := 0;
BEGIN
  WHILE I <= 1000000 LOOP
    INSERT INTO testaCLI SELECT * FROM cliente;
    I := I + 1;
  END LOOP;
END$$; -- 1min e 38secs

-- consulta lenta, pois agora testaCLI tem 1 milhão de registros
SELECT nome FROM testaCLI WHERE uf = 'PB'; -- 10secs
EXPLAIN SELECT nome FROM testaCLI WHERE uf = 'PB'; -- mais rápido!!
-- criando um índice, que acelera as buscas pela coluna 'uf'
CREATE INDEX testaClindex ON testaCLI(uf); -- 24secs
/* Comparação do Desempenho
Executar novamente SELECT nome FROM testaCLI WHERE uf = 'PB' e comparar o tempo com e sem o índice.
Com o índice, a busca deve ser muito mais rápida, 
pois o PostgreSQL pode encontrar os registros diretamente no índice, em vez de escanear toda a tabela.*/

-- Uso de relpages:
SELECT relpages FROM pg_class WHERE relname = 'cliente'; -- 0
SELECT relpages FROM pg_class WHERE relname = 'testacli'; -- 175439
-- relpages indica o número de páginas de disco ocupadas por uma tabela.
-- testaCLI deve ocupar muito mais páginas que cliente, já que contém milhões de registros.
TRUNCATE TABLE testaCLI;

-- Questão 5:
-- índice da tabela cliente:
SELECT * FROM pg_indexes WHERE tablename = 'cliente'; -- mostra os índices existentes
-- Criando um índice adicional:
CREATE INDEX idx_cliente_cidade ON cliente(cidade);
-- Justificativa: Se frequentemente fizermos buscas por cidade, um índice nessa coluna melhorará o desempenho.