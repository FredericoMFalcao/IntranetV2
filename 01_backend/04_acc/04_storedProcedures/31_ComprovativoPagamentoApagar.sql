DROP PROCEDURE IF EXISTS ComprovativoPagamentoApagar;

DELIMITER //
-- ------------------------
--  Tabela (virtual): ComprovativoPagamento Funcao: Apagar
--
-- Descrição: apaga um "documento", i.e. uma entrada na tabela sql de documentos
--            Por consequência (manual / não implícita):
--                (1) Elimina a associação das faturas que referenciavam este comprovativo de pagamento (i.e. set null)
--		  (2) Elimina os lançamentos contabilísticos associados a este comprovativo de pagamento
-- ------------------------
CREATE PROCEDURE ComprovativoPagamentoApagar (IN in_ComprovativoPagamentoId INT)

  BEGIN

	IF NOT EXISTS (SELECT Id FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_ComprovativoPagamentoId AND Tipo = 'ComprovativoPagamento')
	  THEN signal sqlstate '23000' set message_text = 'Comprovativo de pagamento inexistente.';
	  
	ELSE
	
	  DELETE FROM <?=tableNameWithModule("Documentos","DOC")?>
	  WHERE Id = in_ComprovativoPagamentoId;
	  
	  UPDATE <?=tableNameWithModule("Documentos","DOC")?>
	  SET Extra = JSON_SET(Extra, '$.ComprovativoPagamentoId', 0)
	  WHERE JSON_VALUE(Extra, '$.ComprovativoPagamentoId') = in_ComprovativoPagamentoId;
	  
	  -- (2) @TODO: Implementar 
	  
	END IF;

  END;
  
//

DELIMITER ;
