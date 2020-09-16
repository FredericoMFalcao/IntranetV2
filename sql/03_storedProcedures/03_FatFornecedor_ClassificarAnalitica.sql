DROP PROCEDURE IF EXISTS FatFornecedor_ClassificarAnalitica;

DELIMITER //

CREATE PROCEDURE FatFornecedor_ClassificarAnalitica (
IN NumSerie                      TEXT,
IN ValorFatura                   DECIMAL(18,2),
IN ClassificacaoAnalitica        TEXT
-- e.g. [{"CentroResultados": "0101", "Analitica": "0202", "Colaborador": "ABC", "Valor": 1000}, {...}]
)
 BEGIN
  DECLARE i INT;
  SET i = 0;
 
  -- 0. Verificar validade dos argumentos
 
   
  -- 1. Começar Transacao
  START TRANSACTION;
  
  -- 2. Alterar dados
  -- 2.1 Inserir lançamentos
  WHILE i != JSON_LENGTH(ClassificacaoAnalitica) DO
 
   INSERT INTO Lancamentos (Conta, TipoConta, CoefRateio, DocNumSerie)
    VALUES (
     JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.CentroResultados'),
     'CentroResultados',
     JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Valor') / ValorFatura,
     NumSerie
    );

   INSERT INTO Lancamentos (Conta, TipoConta, CoefRateio, DocNumSerie)
    VALUES (
     JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Analitica'),
     'Analitica',
     JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Valor') / ValorFatura,
     NumSerie
    );

   INSERT INTO Lancamentos (Conta, TipoConta, CoefRateio, DocNumSerie)
    VALUES (
     JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Colaborador'),
     'Colaborador',
     JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Valor') / ValorFatura,
     NumSerie
    );

   SET i = i + 1;
   
  END WHILE;



  -- 10. Salvar
  COMMIT;
 END;
//

DELIMITER ;
