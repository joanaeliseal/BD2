-- Exercício 9

-- Verifique 
select * from estudio; 

insert into estudio(codest,nomeest) values (default,'Teste') 
	 returning codest;
select * from categoria; 
insert into categoria(desccateg) values ('Teste1') 
	 returning codcateg;
	 
select * from filme; 
	 
-- Questão 1

Select * from filme order by codfilme; 
--delete from filme where codfilme>19; 
select * from categoria order by codcateg; 
--delete from categoria where codcateg>7;
select * from estudio order by codest; 
-- delete from estudio where codest > 3; 

Create or replace function cria_filme(tit filme.titulo%type, ano1 filme.ano%type, 
						   durac filme.duracao%type, 
						   nomecat varchar, nomeestudio varchar)
Returns void
as $$
Declare cod_cat categoria.codcateg%type; 
        cod_est estudio.codest%type; 
Begin
  Select codcateg into cod_cat from categoria 
         where desccateg = nomecat; 
  If not found then
     insert into categoria(desccateg) values (nomecat) 
	        returning codcateg into cod_cat;
  end if; 
  Select codest into cod_est from estudio
         where nomeest = nomeestudio; 
  If not found then
     insert into estudio(nomeest) values (nomeestudio) 
	 returning codest into cod_est;
  end if; 
  Insert into filme values(default,tit,ano1,durac,cod_cat,cod_est); 
End; 
$$ language plpgsql; 

Select * from filme; 
select * from categoria; 
select * from estudio; 

select cria_filme('Aranha',2021,130,'Aventura','Universal2'); 
select cria_filme('Aranha2',2021,130,'Teste1','Teste1'); 

-- Questão 2

Create or replace function cria_filme2(tit filme.titulo%type, ano1 filme.ano%type, 
							durac filme.duracao%type, 
						   nomecat varchar, nomeestudio varchar)
Returns varchar
as $$
Declare cod_cat categoria.codcateg%type; 
        cod_est estudio.codest%type; 
		msg varchar; 
Begin
  Select codcateg into strict cod_cat from categoria 
         where desccateg = nomecat;   
  Select codest into strict cod_est from estudio
         where nomeest = nomeestudio; 
  Insert into filme values(default,tit,ano1,durac,cod_cat,cod_est); 
  msg = 'Tudo certo';
  return msg; 
  Exception
          When No_data_found then
                msg = 'Nenhuma categoria/estudio foi encontrado';
				return msg; 
         When others then
		      msg = 'Erro desconhecido';
			  return msg; 
End; 
$$ language plpgsql; 

-- drop function cria_filme2; 

Select codcateg from categoria 
         where desccateg = 'Infantil'; 
Select codest 
from estudio 
where nomeest like 'Extra'; 

Select * from filme; 
select * from categoria; 
select * from estudio; 

--Delete from filme where titulo like 'Diver%'; 

select cria_filme2('Divertida mente',2021,130,'Comédia','Disney'); 
select cria_filme2('Divertida mente 2',2021,130,'Infantil','Disney'); 
select cria_filme2('Divertida mente 2',2021,130,'Infantil','Extra'); 


-- Questão 3:
CREATE OR REPLACE FUNCTION cria_filme3(
  tit filme.titulo%TYPE, 
  ano1 filme.ano%TYPE, 
  durac filme.duracao%TYPE, 
  nomecat VARCHAR, 
  nomeestudio VARCHAR
)
RETURNS VARCHAR AS $$
DECLARE 
  cod_cat categoria.codcateg%TYPE;
  cod_est estudio.codest%TYPE;
  msg VARCHAR;
BEGIN
  -- Tenta obter a categoria
  BEGIN
    SELECT codcateg INTO STRICT cod_cat 
    FROM categoria 
    WHERE desccateg = nomecat;
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN
      INSERT INTO categoria(desccateg) 
      VALUES (nomecat) 
      RETURNING codcateg INTO cod_cat;
  END;

  -- Tenta obter o estúdio
  BEGIN
    SELECT codest INTO STRICT cod_est 
    FROM estudio 
    WHERE nomeest = nomeestudio;
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN
      INSERT INTO estudio(nomeest) 
      VALUES (nomeestudio) 
      RETURNING codest INTO cod_est;
  END;

  -- Insere o filme com os códigos obtidos
  INSERT INTO filme 
  VALUES (DEFAULT, tit, ano1, durac, cod_cat, cod_est);

  msg := 'Sucesso na inserção de filme';
  RETURN msg;

-- Tratamento de qualquer outro erro
EXCEPTION
  WHEN OTHERS THEN
    msg := 'Erro desconhecido';
    RETURN msg;
END;
$$ LANGUAGE plpgsql;

-- Categoria e estúdio já existem
SELECT cria_filme3('Matrix', 1999, 120, 'Ficção', 'Warner');

-- Categoria nova, estúdio novo
SELECT cria_filme3('Interestelar', 2014, 169, 'Sci-Fi', 'Paramount');

-- Estúdio já existe, categoria nova
SELECT cria_filme3('Toy Story', 1995, 81, 'Animação', 'Disney');
