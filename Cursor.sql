-- Execute o comando abaixo para incluir um novo cliente:

EXECUTE INCLUIR_CLIENTE(30, 'Loja NNM','56854960854906',2,60000);
Você verá que, após esta inclusão, se executarmos o programa PL/SQL abaixo para atualizar os segmentos, ela não irá funcionar:

DECLARE
   v_SEGMERCADO CLIENTE.SEGMERCADO_ID%type := 1;
   v_NUMCLI INTEGER;
BEGIN
   SELECT COUNT(*) INTO v_NUMCLI FROM CLIENTE;
   FOR v_ID IN 1..v_NUMCLI LOOP
      ATUALIZAR_SEGMERCADO (v_ID,v_SEGMERCADO);
   END LOOP;
END;

/*Isso porque os identificadores dos clientes não respeitam uma ordem sequencial. A solução para esse problema é usar um CURSOR.
Execute os comandos abaixo para ver como funciona a estrutura de CURSOR:*/

SET SERVEROUTPUT ON;
DECLARE
   v_ID CLIENTE.ID%type;
   v_RAZAO CLIENTE.RAZAO_SOCIAL%type;
   CURSOR cur_CLIENTE IS SELECT ID, RAZAO_SOCIAL FROM
cliente;

BEGIN
    OPEN cur_cliente;
    LOOP
        FETCH cur_cliente INTO
            v_id,
            v_razao;
        EXIT WHEN cur_cliente%notfound;
        dbms_output.put_line('ID = '
                             || v_id
                             || ', RAZAO = '
                             || v_razao);
    END LOOP;

END;

-- Edite a procedure de atualização dos segmentos para levar em consideração o uso do CURSOR e o problema de atualização ser solucionado quando os identificadores dos clientes não respeitarem uma ordem sequencial:

DECLARE
    v_segmercado cliente.segmercado_id%TYPE := 3;
    v_id         cliente.id%TYPE;
    CURSOR cur_cliente IS
    SELECT
        id
    FROM
        cliente;

BEGIN
    OPEN cur_cliente;
    LOOP
        FETCH cur_cliente INTO v_id;
        EXIT WHEN cur_cliente%notfound;
        atualizar_segmercado(v_id, v_segmercado);
    END LOOP;

    CLOSE cur_cliente;
END;

-- É possível gerenciar o CURSOR usando a estrutura de repetição WHILE ... LOOP:

DECLARE
    v_segmercado cliente.segmercado_id%TYPE := 3;
    v_id         cliente.id%TYPE;
    CURSOR cur_cliente IS
    SELECT
        id
    FROM
        cliente;

BEGIN
    OPEN cur_cliente;
    FETCH cur_cliente INTO v_id;
    WHILE cur_cliente%found LOOP
        atualizar_segmercado(v_id, v_segmercado);
        FETCH cur_cliente INTO v_id;
    END LOOP;

    CLOSE cur_cliente;
END;

-- Ou então você pode usar o FOR, onde muitos comandos de atualização do gerenciamento do CURSOR, dentro do programa PL/SQL, são automaticamente declaradas:

DECLARE
    v_segmercado cliente.segmercado_id%TYPE := 1;
    CURSOR cur_cliente IS
    SELECT
        id
    FROM
        cliente;

BEGIN
    FOR linha_cur_cliente IN cur_cliente LOOP
        atualizar_segmercado(linha_cur_cliente.id, v_segmercado);
    END LOOP;
END;