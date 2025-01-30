-- Tarefa 8

-- Questão 1
/* 
Este bloco anônimo verifica a quantidade de estoque (quantest) de um produto com codprod = 1. 
Dependendo do valor, ele atualiza o status do produto para:
1."Estoque dentro do esperado", se o estoque for maior que 30.
2. "Estoque fora do limite mínimo", se o estoque for 30 ou menor.
Problema do código original:
1.O código está fixo para codprod = 1, ou seja, não permite reuso para outros produtos.
2.Precisa ser reescrito como uma função armazenada, permitindo a atualização de qualquer produto.
*/
Create or replace function atualizaStatus (cod produto.codprod%type) --Parâmetro cod: Permite atualizar qualquer produto com base no código passado.
Returns void -- A função não retorna valores, apenas atualiza o banco.
As $$ 
Declare qtd_atual produto.quantest%type;
Begin
  select quantest into strict qtd_atual from produto -- Busca a quantidade de estoque do produto informado.
  where codprod = cod;
  
  if qtd_atual > 30 then -- Atualiza a tabela.
     update produto
      set status = 'Estoque dentro do esperado'
      where codprod = cod; 
  else
    update produto
      set status = 'Estoque fora do limite minimo'
      where codprod =  cod;
  end if;
End;
$$ LANGUAGE 'plpgsql';
-- Testando o código:
select * from produto; 
update produto set status = null where codprod = 5;  
select atualizaStatus(5); 

-- Questão 2
create or replace function getSumSalario() 
returns numeric
as $$ 
  Declare
       salcomp numeric;
       v record;
  Begin
      Salcomp = 0; -- Inicializa a variável para armazenar a soma.
      for v in (select salariofixo from vendedor where salariofixo is not null)   
        loop -- Percorre todos os salários dos vendedores.
        salcomp = salcomp + v.salariofixo; -- Soma cada salário à variável salcomp.
    end loop;
    return salcomp; -- Retorna o valor final.
end;
 $$ LANGUAGE 'plpgsql';

select getSumsalario(); 

-- Questão 2.1: Usando SUM()
create or replace function getSumSalario2() 
returns numeric
as $$ 
  Declare
       salcomp numeric;
Begin
    select sum(salariofixo) into Salcomp from vendedor 
	where salariofixo is not null;
    return salcomp;
end;
 $$ LANGUAGE 'plpgsql';
select getSumsalario2(); 
-- Substitui o loop por uma única consulta SQL (SUM(salariofixo)), que é mais eficiente.
-- Versão 3: eliminando a variável salcomp
create or replace function getSumSalario3() 
returns numeric
as $$ 
Begin
    return (select sum(salariofixo) from vendedor where salariofixo is not null);
end;
 $$ LANGUAGE 'plpgsql';
select getSumsalario3(); 

-- Questão 3
--Criação da tabela fornecedor:
CREATE TABLE fornecedor (
    cod SERIAL PRIMARY KEY,  -- Gera valores automaticamente (chave primaria).
    nome VARCHAR(30) NOT NULL,  -- Armazena os dados de fornecedor.
    cnpj VARCHAR(15) NOT NULL,  
    email VARCHAR(15) NOT NULL  
);
-- Função para inserir na tabela fornecedor:
CREATE OR REPLACE FUNCTION inserir_fornecedor( -- Representam os dados do fornecedor a serem inseridos.
    nome VARCHAR(30),
    cnpj VARCHAR(15),
    email VARCHAR(15)
) 
RETURNS VOID 
AS $$
BEGIN
    INSERT INTO fornecedor (nome, cnpj, email) VALUES (nome, cnpj, email); 
END;
$$ LANGUAGE plpgsql;

create or replace function insereFornecedor(nome IN fornecedor.nome%type,
                                           cnpj1 IN fornecedor.cnpj%type,
                                           email1 IN fornecedor.email%type) 
 Returns void
 As $$ 
 begin
  insert into fornecedor values (default,nome,cnpj1,email1); -- Usa default para o cod, pois é um serial.
 END;
 $$ LANGUAGE plpgsql;

select insereFornecedor('Fabrica3','1234567890','xxx@gmail.com'); 
select * from fornecedor;

-- Questão 4
create or replace function showFornecedor()
returns integer
As $$ 
declare
   vfornecedor Cursor for select cod, nome,email from fornecedor; -- Armazena a consulta select cod, nome, email from fornecedor.
   df varchar(50); 
begin
  for vf in vfornecedor loop -- Percorre todos os fornecedores.
    df = vf.cod|| '--' || vf.nome || '--' || vf.email; -- Concatena os dados usando ||.
    raise notice 'Dados do Fornecedor: %', df; -- Exibe a mensagem no terminal.
  end loop;
return 1; -- Apenas retorna um valor fixo (não é necessário, mas está no código).
END;
$$ LANGUAGE plpgsql;

select showFornecedor(); 

