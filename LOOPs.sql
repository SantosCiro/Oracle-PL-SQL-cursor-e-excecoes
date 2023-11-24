-- O objetivo agora � atualizar todos os segmentos de mercados de todos os clientes atualmente cadastrados na tabela. Para isso, voc� tem que repetir a execu��o da procedure diversas vezes para cada um dos clientes:

EXECUTE ATUALIZAR_SEGMERCADO (1,4);
EXECUTE ATUALIZAR_SEGMERCADO (2,4);
EXECUTE ATUALIZAR_SEGMERCADO (3,4);
EXECUTE ATUALIZAR_SEGMERCADO (4,4);
EXECUTE ATUALIZAR_SEGMERCADO (5,4);
EXECUTE ATUALIZAR_SEGMERCADO (6,4);
EXECUTE ATUALIZAR_SEGMERCADO (7,4);
EXECUTE ATUALIZAR_SEGMERCADO (8,4);
EXECUTE ATUALIZAR_SEGMERCADO (9,4);

-- Mas como o identificador do cliente � um n�mero sequencial, podemos fazer um programa em PL/SQL para fazer essa atualiza��o:

DECLARE
    v_segmercado cliente.segmercado_id%TYPE := 2;
    v_id         cliente.id%TYPE := 1;
BEGIN
    atualizar_segmercado(v_id, v_segmercado);
    v_id := v_id + 1;
    atualizar_segmercado(v_id, v_segmercado);
    v_id := v_id + 1;
    atualizar_segmercado(v_id, v_segmercado);
    v_id := v_id + 1;
    atualizar_segmercado(v_id, v_segmercado);
    v_id := v_id + 1;
    atualizar_segmercado(v_id, v_segmercado);
    v_id := v_id + 1;
    atualizar_segmercado(v_id, v_segmercado);
    v_id := v_id + 1;
    atualizar_segmercado(v_id, v_segmercado);
    v_id := v_id + 1;
    atualizar_segmercado(v_id, v_segmercado);
    v_id := v_id + 1;
    atualizar_segmercado(v_id, v_segmercado);
END;

-- Como voc� repetiu um bloco de comando diversas vezes, uma vez para cada cliente, � poss�vel substituir esta repeti��o por um looping usando a estrutura LOOP ... END LOOP:

DECLARE
    v_segmercado cliente.segmercado_id%TYPE := 3;
    v_id         cliente.id%TYPE := 1;
BEGIN
    LOOP
        atualizar_segmercado(v_id, v_segmercado);
        v_id := v_id + 1;
        EXIT WHEN v_id > 9;
    END LOOP;
END;

-- No c�digo acima, � preciso conhecer, de antem�o, o n�mero de clientes existentes na tabela, neste momento. Mas isso pode ser feito pelo pr�prio programa PL/SQL:

DECLARE
    v_segmercado cliente.segmercado_id%TYPE := 3;
    v_id         cliente.id%TYPE := 1;
    v_numcli     INTEGER;
BEGIN
    SELECT
        COUNT(*)
    INTO v_numcli
    FROM
        cliente;

    LOOP
        atualizar_segmercado(v_id, v_segmercado);
        v_id := v_id + 1;
        EXIT WHEN v_id > v_numcli;
    END LOOP;

END;

-- N�o temos � disposi��o apenas o comando de repeti��o LOOP ... END LOOP. Essa repeti��o pode ser feita com a estrutura de repeti��o FOR. Inclusive, � a mais apropriada quando temos o n�mero de intera��es previamente definido:

DECLARE
    v_segmercado cliente.segmercado_id%TYPE := 4;
    v_numcli     INTEGER;
BEGIN
    SELECT
        COUNT(*)
    INTO v_numcli
    FROM
        cliente;

    FOR v_id IN 1..v_numcli LOOP
        atualizar_segmercado(v_id, v_segmercado);
    END LOOP;
END;

-- � poss�vel passar os par�metros de forma nomeada para a procedure:

DECLARE
    v_segmercado cliente.segmercado_id%TYPE := 1;
    v_numcli     INTEGER;
BEGIN
    SELECT
        COUNT(*)
    INTO v_numcli
    FROM
        cliente;

    FOR v_id IN 1..v_numcli LOOP
        atualizar_segmercado(p_segmercado_id => v_segmercado, p_id => v_id);
    END LOOP;

END;

-- O comando de sa�da do LOOP ... END LOOP pode ser chamado em qualquer linha do bloco de comandos do programa PL/SQL, desde que dentro da estrutura de repeti��o:

DECLARE
    v_segmercado cliente.segmercado_id%TYPE := 2;
    v_id         cliente.id%TYPE := 1;
    v_numcli     INTEGER;
BEGIN
    SELECT
        COUNT(*)
    INTO v_numcli
    FROM
        cliente;

    LOOP
        IF v_id <= v_numcli THEN
            atualizar_segmercado(v_id, v_segmercado);
            v_id := v_id + 1;
        ELSE
            EXIT;
        END IF;
    END LOOP;

END;

-- Outra estrutura de repeti��o apresentada foi o WHILE ... LOOP:

DECLARE
    v_segmercado cliente.segmercado_id%TYPE := 3;
    v_id         cliente.id%TYPE := 1;
    v_numcli     INTEGER;
BEGIN
    SELECT
        COUNT(*)
    INTO v_numcli
    FROM
        cliente;

    WHILE v_id <= v_numcli LOOP
        atualizar_segmercado(v_id, v_segmercado);
        v_id := v_id + 1;
    END LOOP;

END;