-- Voc� pode tratar um erro com uma mensagem amig�vel, modificando a procedure conforme os comandos abaixo:

CREATE OR REPLACE PROCEDURE incluir_cliente (
    p_id          cliente.id%TYPE,
    p_razao       cliente.razao_social%TYPE,
    p_cnpj        cliente.cnpj%TYPE,
    p_segmercado  cliente.segmercado_id%TYPE,
    p_faturamento cliente.faturamento_previsto%TYPE
) IS
    v_categoria cliente.categoria%TYPE;
    v_cnpj      cliente.cnpj%TYPE;
BEGIN
    v_categoria := categoria_cliente(p_faturamento);
    formata_cnpj(p_cnpj, v_cnpj);
    INSERT INTO cliente VALUES (
        p_id,
        p_razao,
        v_cnpj,
        p_segmercado,
        sysdate,
        p_faturamento,
        v_categoria
    );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        dbms_output.put_line('******************************************');
        dbms_output.put_line('*************** CLIENTE J� CADASTRADO !!!!');
        dbms_output.put_line('******************************************');
END;

/* Aqui, voc� tratar� o erro DUP_VAL_ON_INDEX que est� relacionado a uma lista de exce��es j� mapeadas pelo Oracle. Esta, no caso, acontecer� quando o erro de chave prim�ria ocorrer.
Mas se voc� ajustar a procedure como abaixo, o erro vir� pela interface nativa Oracle, com um n�mero customizado por voc�:*/

CREATE OR REPLACE PROCEDURE incluir_cliente (
    p_id          cliente.id%TYPE,
    p_razao       cliente.razao_social%TYPE,
    p_cnpj        cliente.cnpj%TYPE,
    p_segmercado  cliente.segmercado_id%TYPE,
    p_faturamento cliente.faturamento_previsto%TYPE
) IS
    v_categoria cliente.categoria%TYPE;
    v_cnpj      cliente.cnpj%TYPE;
BEGIN
    v_categoria := categoria_cliente(p_faturamento);
    formata_cnpj(p_cnpj, v_cnpj);
    INSERT INTO cliente VALUES (
        p_id,
        p_razao,
        v_cnpj,
        p_segmercado,
        sysdate,
        p_faturamento,
        v_categoria
    );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(-20010, 'CLIENTE J� CADASTRADO !!!!');
END;

-- Nem sempre todos os erros Oracle est�o mapeados nas exce��es nominadas. Mas voc� pode associar um erro Oracle usando seu n�mero interno e direcion�-lo para um texto customizado:

CREATE OR REPLACE PROCEDURE incluir_cliente (
    p_id          cliente.id%TYPE,
    p_razao       cliente.razao_social%TYPE,
    p_cnpj        cliente.cnpj%TYPE,
    p_segmercado  cliente.segmercado_id%TYPE,
    p_faturamento cliente.faturamento_previsto%TYPE
) IS

    v_categoria cliente.categoria%TYPE;
    v_cnpj      cliente.cnpj%TYPE;
    e_idnulo EXCEPTION;
    PRAGMA exception_init ( e_idnulo, -1400 );
BEGIN
    v_categoria := categoria_cliente(p_faturamento);
    formata_cnpj(p_cnpj, v_cnpj);
    INSERT INTO cliente VALUES (
        p_id,
        p_razao,
        v_cnpj,
        p_segmercado,
        sysdate,
        p_faturamento,
        v_categoria
    );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(-20010, 'CLIENTE J� CADASTRADO !!!!');
    WHEN e_idnulo THEN
        raise_application_error(-20015, 'IDENTIFICADOR DO CLIENTE NULO !!!!');
END;

-- Para evitar de ter que mapear todos os erros que possam ocorrer, podemos criar um erro gen�rico, como no script abaixo:

CREATE OR REPLACE PROCEDURE incluir_cliente (
    p_id          cliente.id%TYPE,
    p_razao       cliente.razao_social%TYPE,
    p_cnpj        cliente.cnpj%TYPE,
    p_segmercado  cliente.segmercado_id%TYPE,
    p_faturamento cliente.faturamento_previsto%TYPE
) IS

    v_categoria cliente.categoria%TYPE;
    v_cnpj      cliente.cnpj%TYPE;
    e_idnulo EXCEPTION;
    PRAGMA exception_init ( e_idnulo, -1400 );
BEGIN
    v_categoria := categoria_cliente(p_faturamento);
    formata_cnpj(p_cnpj, v_cnpj);
    INSERT INTO cliente VALUES (
        p_id,
        p_razao,
        v_cnpj,
        p_segmercado,
        sysdate,
        p_faturamento,
        v_categoria
    );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(-20010, 'CLIENTE J� CADASTRADO !!!!');
    WHEN e_idnulo THEN
        raise_application_error(-20015, 'IDENTIFICADOR DO CLIENTE NULO !!!!');
    WHEN OTHERS THEN
        raise_application_error(-20020, 'ERRO N�O ESPERADO !!!!');
END;

-- Mas � poss�vel exibir o texto original do Oracle quando ocorrer um erro n�o mapeado. Para isso fa�a:

CREATE OR REPLACE PROCEDURE incluir_cliente (
    p_id          cliente.id%TYPE,
    p_razao       cliente.razao_social%TYPE,
    p_cnpj        cliente.cnpj%TYPE,
    p_segmercado  cliente.segmercado_id%TYPE,
    p_faturamento cliente.faturamento_previsto%TYPE
) IS

    v_categoria cliente.categoria%TYPE;
    v_cnpj      cliente.cnpj%TYPE;
    e_idnulo EXCEPTION;
    PRAGMA exception_init ( e_idnulo, -1400 );
BEGIN
    v_categoria := categoria_cliente(p_faturamento);
    formata_cnpj(p_cnpj, v_cnpj);
    INSERT INTO cliente VALUES (
        p_id,
        p_razao,
        v_cnpj,
        p_segmercado,
        sysdate,
        p_faturamento,
        v_categoria
    );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(-20010, 'CLIENTE J� CADASTRADO !!!!');
    WHEN e_idnulo THEN
        raise_application_error(-20015, 'IDENTIFICADOR DO CLIENTE NULO !!!!');
    WHEN OTHERS THEN
        raise_application_error(-20020, 'ERRO N�O ESPERADO !!!! - TEXTO ORIGINAL DO ERRO: ' || sqlerrm());
END;

-- Muitas vezes, um erro cometido pelo usu�rio n�o � considerado um erro para o Oracle. Estes erros de neg�cio tamb�m podem ser customizados:

CREATE OR REPLACE PROCEDURE incluir_cliente (
    p_id          cliente.id%TYPE,
    p_razao       cliente.razao_social%TYPE,
    p_cnpj        cliente.cnpj%TYPE,
    p_segmercado  cliente.segmercado_id%TYPE,
    p_faturamento cliente.faturamento_previsto%TYPE
) IS

    v_categoria cliente.categoria%TYPE;
    v_cnpj      cliente.cnpj%TYPE;
    e_idnulo EXCEPTION;
    PRAGMA exception_init ( e_idnulo, -1400 );
    e_faturamento_nulo EXCEPTION;
BEGIN
    IF p_faturamento IS NULL THEN
        RAISE e_faturamento_nulo;
    END IF;
    v_categoria := categoria_cliente(p_faturamento);
    formata_cnpj(p_cnpj, v_cnpj);
    INSERT INTO cliente VALUES (
        p_id,
        p_razao,
        v_cnpj,
        p_segmercado,
        sysdate,
        p_faturamento,
        v_categoria
    );

    COMMIT;
EXCEPTION
    WHEN dup_val_on_index THEN
        raise_application_error(-20010, 'CLIENTE J� CADASTRADO !!!!');
    WHEN e_idnulo THEN
        raise_application_error(-20015, 'IDENTIFICADOR DO CLIENTE NULO !!!!');
    WHEN e_faturamento_nulo THEN
        raise_application_error(-20025, 'FATURAMENTO FOI INCLUIDO COM VALOR NULO !!!!');
    WHEN OTHERS THEN
        raise_application_error(-20020, 'ERRO N�O ESPERADO !!!! - TEXTO ORIGINAL DO ERRO: ' || sqlerrm());
END;