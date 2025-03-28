-- Tarefa 10: Triggers

-- Questão 1:
CREATE OR REPLACE FUNCTION audita_atualizacao_cargo()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.cargo IS DISTINCT FROM OLD.cargo THEN
    RAISE NOTICE 'Troca realizada: Descrição do Cargo % mudou para %', OLD.cargo, NEW.cargo;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_audita_cargo
AFTER UPDATE ON empregado
FOR EACH ROW
EXECUTE FUNCTION audita_atualizacao_cargo();

UPDATE empregado 
SET cargo = 'Analista de Sistemas Inicial' 
WHERE matricula = 13;

SELECT * FROM empregado;

-- Questão 2:
CREATE TABLE emp_backup (
  matricula INTEGER,
  nome_completo VARCHAR(50)
);

CREATE OR REPLACE FUNCTION backup_empregado()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO emp_backup (matricula, nome_completo)
  VALUES (OLD.matricula, OLD.primeironome || ' ' || OLD.sobrenome);
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_backup_empregado
AFTER DELETE ON empregado
FOR EACH ROW
EXECUTE FUNCTION backup_empregado();

