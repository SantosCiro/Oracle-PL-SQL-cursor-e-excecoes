ALTER SESSION SET "_ORACLE_SCRIPT" = true;

CREATE USER cursoplsql2 IDENTIFIED BY cursoplsql2
    DEFAULT TABLESPACE users;

GRANT connect, resource TO cursoplsql2;

ALTER USER cursoplsql2
    QUOTA UNLIMITED ON users;

-- Execute as linhas abaixo para criar as tabelas que serão usadas neste treinamento:

CREATE TABLE segmercado (
    id        NUMBER(5),
    descricao VARCHAR2(100)
);

CREATE TABLE cliente (
    id                   NUMBER(5),
    razao_social         VARCHAR2(100),
    cnpj                 VARCHAR2(20),
    segmercado_id        NUMBER(5),
    data_inclusao        DATE,
    faturamento_previsto NUMBER(10, 2),
    categoria            VARCHAR2(20)
);

ALTER TABLE segmercado ADD CONSTRAINT segmercaco_id_pk PRIMARY KEY ( id );

ALTER TABLE cliente ADD CONSTRAINT cliente_id_pk PRIMARY KEY ( id );

ALTER TABLE cliente
    ADD CONSTRAINT cliente_segmercado_id FOREIGN KEY ( segmercado_id )
        REFERENCES segmercado ( id );

CREATE TABLE produto_exercicio (
    cod       VARCHAR2(5),
    descricao VARCHAR2(100),
    categoria VARCHAR2(100)
);

CREATE TABLE produto_venda_exercicio (
    id                 NUMBER(5),
    cod_produto        VARCHAR2(5),
    data               DATE,
    quantidade         FLOAT,
    preco              FLOAT,
    valor_total        FLOAT,
    percentual_imposto FLOAT
);

ALTER TABLE produto_exercicio ADD CONSTRAINT produto_exercicio_cod_pk PRIMARY KEY ( cod );

ALTER TABLE produto_venda_exercicio ADD CONSTRAINT produto_venda_exercicio_id_pk PRIMARY KEY ( id );

ALTER TABLE produto_venda_exercicio
    ADD CONSTRAINT produto_venda_exercicio_produto_exercicio_cod FOREIGN KEY ( cod_produto )
        REFERENCES produto_exercicio ( cod );

INSERT INTO segmercado (
    id,
    descricao
) VALUES (
    '3',
    'ATACADISTA'
);

INSERT INTO segmercado (
    id,
    descricao
) VALUES (
    '1',
    'VAREJISTA'
);

INSERT INTO segmercado (
    id,
    descricao
) VALUES (
    '2',
    'INDUSTRIAL'
);

INSERT INTO segmercado (
    id,
    descricao
) VALUES (
    '4',
    'FARMACEUTICOS'
);

INSERT INTO cliente (
    id,
    razao_social,
    cnpj,
    segmercado_id,
    data_inclusao,
    faturamento_previsto,
    categoria
) VALUES (
    '3',
    'SUPERMERCADO CARIOCA',
    '22222222222',
    '1',
    TO_DATE('13/06/22', 'DD/MM/RR'),
    '30000',
    'MÉDIO'
);

INSERT INTO cliente (
    id,
    razao_social,
    cnpj,
    segmercado_id,
    data_inclusao,
    faturamento_previsto,
    categoria
) VALUES (
    '1',
    'SUPERMERCADOS CAMPEAO',
    '1234567890',
    '1',
    TO_DATE('12/06/22', 'DD/MM/RR'),
    '90000',
    'MEDIO GRANDE'
);

INSERT INTO cliente (
    id,
    razao_social,
    cnpj,
    segmercado_id,
    data_inclusao,
    faturamento_previsto,
    categoria
) VALUES (
    '2',
    'SUPERMERCADO DO VALE',
    '11111111111',
    '1',
    TO_DATE('13/06/22', 'DD/MM/RR'),
    '90000',
    'MÉDIO GRANDE'
);

INSERT INTO produto_exercicio (
    cod,
    descricao,
    categoria
) VALUES (
    '41232',
    'Sabor de Verão > Laranja > 1 Litro',
    'Sucos de Frutas'
);

INSERT INTO produto_exercicio (
    cod,
    descricao,
    categoria
) VALUES (
    '32223',
    'Sabor de Verão > Uva > 1 Litro',
    'Sucos de Frutas'
);

INSERT INTO produto_exercicio (
    cod,
    descricao,
    categoria
) VALUES (
    '67120',
    'Frescor da Montanha > Aroma Limão > 1 Litro',
    'Águas'
);

INSERT INTO produto_exercicio (
    cod,
    descricao,
    categoria
) VALUES (
    '92347',
    'Aroma do Campo > Mate > 1 Litro',
    'Mate'
);

INSERT INTO produto_exercicio (
    cod,
    descricao,
    categoria
) VALUES (
    '33854',
    'Frescor da Montanha > Aroma Laranja > 1 Litro',
    'Águas'
);

INSERT INTO produto_venda_exercicio (
    id,
    cod_produto,
    data,
    quantidade,
    preco,
    valor_total,
    percentual_imposto
) VALUES (
    '1',
    '41232',
    TO_DATE('01/01/22', 'DD/MM/RR'),
    '100',
    '10',
    '1000',
    '100'
);

INSERT INTO produto_venda_exercicio (
    id,
    cod_produto,
    data,
    quantidade,
    preco,
    valor_total,
    percentual_imposto
) VALUES (
    '2',
    '92347',
    TO_DATE('01/01/22', 'DD/MM/RR'),
    '200',
    '25',
    '5000',
    '15'
);COPIAR CÓDIGO

/*O próximo passo é criar as procedures e funções. Para isso, execute os comandos abaixo. Lembrando que os mesmos devem ser executados de forma isolada, um a um.
Todos os comandos podem ser obtidos fazendo o download do arquivo ESQUEMA.SQL.
Abaixo, o primeiro bloco a ser executado:*/

create or replace FUNCTION categoria_cliente
(p_FATURAMENTO IN CLIENTE.FATURAMENTO_PREVISTO%type)
RETURN CLIENTE.CATEGORIA%type
IS
   v_CATEGORIA CLIENTE.CATEGORIA%type;
BEGIN
   IF p_FATURAMENTO <= 10000 THEN
      v_CATEGORIA := 'PEQUENO';
   ELSIF p_FATURAMENTO <= 50000 THEN
      v_CATEGORIA := 'MÉDIO';
   ELSIF p_FATURAMENTO <= 100000 THEN
      v_CATEGORIA := 'MÉDIO GRANDE';
   ELSE
      v_CATEGORIA := 'GRANDE';
   END IF;
   RETURN v_CATEGORIA;
END;

-- O segundo bloco:

create or replace FUNCTION obter_descricao_segmercado
(p_ID IN SEGMERCADO.ID%type)
RETURN SEGMERCADO.DESCRICAO%type
IS
   v_DESCRICAO SEGMERCADO.DESCRICAO%type;
BEGIN
   SELECT DESCRICAO INTO v_DESCRICAO FROM SEGMERCADO WHERE ID = p_ID;
   RETURN v_DESCRICAO;
END;

-- Terceiro bloco:

create or replace FUNCTION RETORNA_CATEGORIA
(p_COD IN produto_exercicio.cod%type)
RETURN produto_exercicio.categoria%type
IS
   v_CATEGORIA produto_exercicio.categoria%type;
BEGIN
   SELECT CATEGORIA INTO v_CATEGORIA FROM PRODUTO_EXERCICIO WHERE COD = p_COD;
   RETURN v_CATEGORIA;
END;

-- Quarto bloco:

create or replace FUNCTION RETORNA_IMPOSTO 
(p_COD_PRODUTO produto_venda_exercicio.cod_produto%type)
RETURN produto_venda_exercicio.percentual_imposto%type
IS
   v_CATEGORIA produto_exercicio.categoria%type;
   v_IMPOSTO produto_venda_exercicio.percentual_imposto%type;
BEGIN
   v_CATEGORIA := retorna_categoria(p_COD_PRODUTO);
   IF TRIM(v_CATEGORIA) = 'Sucos de Frutas' THEN
      v_IMPOSTO := 10;
   ELSIF TRIM(v_CATEGORIA) = 'Águas' THEN
      v_IMPOSTO := 20;
   ELSIF TRIM(v_CATEGORIA) = 'Mate' THEN
      v_IMPOSTO := 15;
   END IF;
   RETURN v_IMPOSTO;
END;

-- Quinto bloco:

create or replace PROCEDURE ALTERANDO_CATEGORIA_PRODUTO 
(p_COD produto_exercicio.cod%type
, p_CATEGORIA produto_exercicio.categoria%type)
IS
BEGIN
   UPDATE PRODUTO_EXERCICIO SET CATEGORIA = p_CATEGORIA WHERE COD = P_COD;
   COMMIT;
END;

-- Sexto bloco:

create or replace PROCEDURE EXCLUINDO_PRODUTO 
(p_COD produto_exercicio.cod%type)
IS
BEGIN
   DELETE FROM PRODUTO_EXERCICIO WHERE COD = P_COD;
   COMMIT;
END;

-- Sétimo bloco:

create or replace PROCEDURE INCLUINDO_DADOS_VENDA 
(
p_ID produto_venda_exercicio.id%type,
p_COD_PRODUTO produto_venda_exercicio.cod_produto%type,
p_DATA produto_venda_exercicio.data%type,
p_QUANTIDADE produto_venda_exercicio.quantidade%type,
p_PRECO produto_venda_exercicio.preco%type
)
IS
   v_VALOR produto_venda_exercicio.valor_total%type;
   v_PERCENTUAL produto_venda_exercicio.percentual_imposto%type;
BEGIN
   v_PERCENTUAL := retorna_imposto(p_COD_PRODUTO);
   v_VALOR := p_QUANTIDADE * p_PRECO;
   INSERT INTO PRODUTO_VENDA_EXERCICIO 
   (id, cod_produto, data, quantidade, preco, valor_total, percentual_imposto) 
   VALUES 
   (p_ID, p_COD_PRODUTO, p_DATA, p_QUANTIDADE, p_PRECO, v_VALOR, v_PERCENTUAL);
   COMMIT;
END; 

-- Oitavo bloco:

create or replace PROCEDURE INCLUINDO_PRODUTO 
(p_COD produto_exercicio.cod%type
, p_DESCRICAO produto_exercicio.descricao%type
, p_CATEGORIA produto_exercicio.categoria%type)
IS
BEGIN
   INSERT INTO PRODUTO_EXERCICIO (COD, DESCRICAO, CATEGORIA) VALUES (p_COD, REPLACE(p_DESCRICAO,'-','>')
   , p_CATEGORIA);
   COMMIT;
END;

-- Nono bloco:

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
BEGIN

   v_CATEGORIA := categoria_cliente(p_FATURAMENTO);

   INSERT INTO CLIENTE
   VALUES 
   (p_ID, p_RAZAO, p_CNPJ, p_SEGMERCADO, SYSDATE, p_FATURAMENTO, v_CATEGORIA);
   COMMIT;
END;

-- Décimo bloco:

create or replace PROCEDURE incluir_segmercado
(p_ID IN SEGMERCADO.ID%type, p_DESCRICAO IN SEGMERCADO.DESCRICAO%type)
IS
BEGIN
   INSERT INTO SEGMERCADO (ID, DESCRICAO) VALUES (p_ID, UPPER(p_DESCRICAO));
   COMMIT;
END;

-- O usuário pediu que você formate o CNPJ do cliente com o seguinte formato: Os 3 primeiros dígitos do número digitados concatenados com uma /** , seguidos dos próximos 2 dígitos, concatenados com **- e finalmente todos os dígitos restantes a partir do sexto número. Para obter a função que formata o número, execute o SQL abaixo:

SELECT SUBSTR(CNPJ, 1,3) || '/' || SUBSTR(CNPJ, 4,2) || '-' || SUBSTR(CNPJ,6) AS CNPJ_FORMATADO FROM
        cliente;
    copiar
    código
