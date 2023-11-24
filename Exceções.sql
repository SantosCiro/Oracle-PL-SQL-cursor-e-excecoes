-- Você pode tratar um erro com uma mensagem amigável, modificando a procedure conforme os comandos abaixo:

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
        dbms_output.put_line('*************** CLIENTE JÁ CADASTRADO !!!!');
        dbms_output.put_line('******************************************');
END;

/* Aqui, você tratará o erro DUP_VAL_ON_INDEX que está relacionado a uma lista de exceções já mapeadas pelo Oracle. Esta, no caso, acontecerá quando o erro de chave primária ocorrer.
Mas se você ajustar a procedure como abaixo, o erro virá pela interface nativa Oracle, com um número customizado por você:*/

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
        raise_application_error(-20010, 'CLIENTE JÁ CADASTRADO !!!!');
END;

-- Nem sempre todos os erros Oracle estão mapeados nas exceções nominadas. Mas você pode associar um erro Oracle usando seu número interno e direcioná-lo para um texto customizado:

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
        raise_application_error(-20010, 'CLIENTE JÁ CADASTRADO !!!!');
    WHEN e_idnulo THEN
        raise_application_error(-20015, 'IDENTIFICADOR DO CLIENTE NULO !!!!');
END;

-- Para evitar de ter que mapear todos os erros que possam ocorrer, podemos criar um erro genérico, como no script abaixo:

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
        raise_application_error(-20010, 'CLIENTE JÁ CADASTRADO !!!!');
    WHEN e_idnulo THEN
        raise_application_error(-20015, 'IDENTIFICADOR DO CLIENTE NULO !!!!');
    WHEN OTHERS THEN
        raise_application_error(-20020, 'ERRO NÃO ESPERADO !!!!');
END;

-- Mas é possível exibir o texto original do Oracle quando ocorrer um erro não mapeado. Para isso faça:

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
        raise_application_error(-20010, 'CLIENTE JÁ CADASTRADO !!!!');
    WHEN e_idnulo THEN
        raise_application_error(-20015, 'IDENTIFICADOR DO CLIENTE NULO !!!!');
    WHEN OTHERS THEN
        raise_application_error(-20020, 'ERRO NÃO ESPERADO !!!! - TEXTO ORIGINAL DO ERRO: ' || sqlerrm());
END;

-- Muitas vezes, um erro cometido pelo usuário não é considerado um erro para o Oracle. Estes erros de negócio também podem ser customizados:

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
        raise_application_error(-20010, 'CLIENTE JÁ CADASTRADO !!!!');
    WHEN e_idnulo THEN
        raise_application_error(-20015, 'IDENTIFICADOR DO CLIENTE NULO !!!!');
    WHEN e_faturamento_nulo THEN
        raise_application_error(-20025, 'FATURAMENTO FOI INCLUIDO COM VALOR NULO !!!!');
    WHEN OTHERS THEN
        raise_application_error(-20020, 'ERRO NÃO ESPERADO !!!! - TEXTO ORIGINAL DO ERRO: ' || sqlerrm());
END;