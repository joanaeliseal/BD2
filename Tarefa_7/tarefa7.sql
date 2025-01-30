-- Tarefa 7
-- Transformar o código atualiza_status_estoque.sql (versão 2) para um equivalente usando a cláusula FOR.

-- Código original na versão 2:
CREATE OR REPLACE FUNCTION atualizaStatus (cod produto.codprod%TYPE)
RETURNS VOID AS $$ 
DECLARE qtd_atual produto.quantest%TYPE;
BEGIN
  SELECT quantest INTO STRICT qtd_atual FROM produto
  WHERE codprod = cod;
  
  IF qtd_atual > 30 THEN
    UPDATE produto SET status = 'Estoque dentro do esperado' WHERE codprod = cod;
  ELSE
    UPDATE produto SET status = 'Estoque fora do limite mínimo' WHERE codprod = cod;
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Usando o FOR:
CREATE OR REPLACE FUNCTION atualizaStatus_FOR()
RETURNS VOID AS $$ 
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN (SELECT codprod, quantest FROM produto) LOOP
    IF rec.quantest > 30 THEN
      UPDATE produto SET status = 'Estoque dentro do esperado' WHERE codprod = rec.codprod;
    ELSE
      UPDATE produto SET status = 'Estoque fora do limite mínimo' WHERE codprod = rec.codprod;
    END IF;
  END LOOP;
END;
$$ LANGUAGE plpgsql;

/* 
Mudanças:
1. Uso de um FOR para percorrer toda a tabela produto e atualizar o status de cada registro.
2. Não precisa passar um código específico (cod), pois o loop percorre todos os produtos.
3. A função atualiza todos os registros da tabela automaticamente.
*/