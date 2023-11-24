-- Inicie esta aula transformando a formata��o do CNPJ em uma fun��o, passando como par�metros o valor de entrada e o valor de sa�da:

CREATE OR REPLACE PROCEDURE formata_cnpj (
    p_cnpj       IN cliente.cnpj%TYPE,
    p_cnpj_saida OUT cliente.cnpj%TYPE
) IS
BEGIN
    p_cnpj_saida := substr(p_cnpj, 1, 3)
                    || '/'
                    || substr(p_cnpj, 4, 2)
                    || '-'
                    || substr(p_cnpj, 6);
END;

-- Para entender melhor como funciona os par�metros IN e OUT, execute o programa abaixo e veja como os valores s�o retornados:

SET SERVEROUTPUT ON;

DECLARE
    v_cnpj       cliente.cnpj%TYPE;
    v_cnpj_saida cliente.cnpj%TYPE;
BEGIN
    v_cnpj := '1234567890';
    v_cnpj_saida := '1234567890';
    dbms_output.put_line(v_cnpj
                         || '      '
                         || v_cnpj_saida);
    formata_cnpj(v_cnpj, v_cnpj_saida);
    dbms_output.put_line(v_cnpj
                         || '      '
                         || v_cnpj_saida);
END;

/*Repita as experi�ncias apresentadas nesta aula, onde veremos que, quando associamos um valor ao par�metro IN dentro da procedure, temos um erro.
Outro teste que deve ser feito � o de usar ao par�metro OUT ao mesmo tempo como sa�da e atribui��o de valor. Voc� ver� que isso tamb�m nos retornar� um erro, n�o na execu��o da procedure, mas o valor retornar� vazio.
Existe uma forma de usar o par�metro como entrada e sa�da ao mesmo tempo (IN OUT). Crie uma procedure como abaixo e teste:*/

CREATE OR REPLACE PROCEDURE formata_cnpj_simples_inout (
    p_cnpj IN OUT cliente.cnpj%TYPE
) IS
BEGIN
    p_cnpj := substr(p_cnpj, 1, 3)
              || '/'
              || substr(p_cnpj, 4, 2)
              || '-'
              || substr(p_cnpj, 6);
END;
Para testar, fa�a:

SET SERVEROUTPUT ON;
DECLARE
   v_CNPJ cliente.cnpj%type;
BEGIN
   v_CNPJ := '1234567890';
   dbms_output.put_line(v_CNPJ);
   FORMATA_CNPJ_SIMPLES_INOUT(v_CNPJ);
   dbms_output.put_line(v_CNPJ);
END;

-- Altere a procedure INCLUIR_CLIENTE e acrescente a chamada � fun��o FORMATA_CNPJ:

create or replace PROCEDURE incluir_cliente
(
p_ID CLIENTE.ID%type,
p_RAZAO CLIENTE.RAZAO_SOCIAL%type,
p_CNPJ CLIENTE.CNPJ%type,
p_SEGMERCADO CLIENTE.SEGMERCADO_ID%type,
p_FATURAMENTO CLIENTE.FATURAMENTO_PREVISTO%type
)
IS
  v_CATEGORIA CLIENTE.CATEGORIA%type;
  v_CNPJ CLIENTE.CNPJ%type;
BEGIN

   v_CATEGORIA := categoria_cliente(p_FATURAMENTO);
   FORMATA_CNPJ(p_CNPJ, v_CNPJ);

   INSERT INTO CLIENTE
   VALUES 
   (p_ID, p_RAZAO, v_CNPJ, p_SEGMERCADO, SYSDATE, p_FATURAMENTO, v_CATEGORIA);
   COMMIT;
END;

-- Crie novos clientes na tabela de clientes:

EXECUTE INCLUIR_CLIENTE (5, 'MERCEARIA XYZ', '999288292999',1,10000);
EXECUTE INCLUIR_CLIENTE (6, 'FARMACIA ABC', '999277292999',1,10000);
EXECUTE INCLUIR_CLIENTE (7, 'MERCADINHO QWE', '999266292999',1,10000);
EXECUTE INCLUIR_CLIENTE (8, 'TAVERNA POI', '999244292999',1,10000);
EXECUTE INCLUIR_CLIENTE (9, 'BAR 222', '999233292999',1,10000);
8) Crie uma fun��o chamada ATUALIZAR_SEGMENTO, que vai mudar o segmento de mercado de um determinado cliente:
CREATE OR REPLACE PROCEDURE atualizar_segmercado (
    p_id            cliente.id%TYPE,
    p_segmercado_id cliente.segmercado_id%TYPE
) IS
BEGIN
    UPDATE cliente
    SET
        segmercado_id = p_segmercado_id
    WHERE
        id = p_id;

    COMMIT;
END;