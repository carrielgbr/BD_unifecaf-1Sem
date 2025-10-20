create database teste002;
use teste002;

show tables;

select * from tbl_endereco_fornecedor;
select * from tbl_fornecedor;

CREATE TABLE tbl_endereco_fornecedor(
	id_endereco_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
    
    id_fornecedor INT NOT NULL UNIQUE, -- CHAVE ESTRANGEIRA
    
    -- DADOS DO ENDEREÇO
    cep_endereco_fornecedor CHAR(8) NOT NULL, -- CEP tem 8 dígitos (sem hífen) e tamanho fixo
    pais_endereco_fornecedor VARCHAR(50) NOT NULL,
    estado_endereco_fornecedor CHAR(2) NOT NULL,   -- UF tem 2 caracteres fixos
    cidade_endereco_fornecedor VARCHAR(100) NOT NULL,
    rua_endereco_fornecedor VARCHAR(255) NOT NULL,
    numero_endereco_fornecedor VARCHAR(10) NOT NULL, -- Pode ser número, 'S/N', etc.
    andar_endereco_fornecedor VARCHAR(50),          -- Opcional, pode ser NULL
    numero_apto_fornecedor VARCHAR(50),             -- Opcional, pode ser NULL
    
    FOREIGN KEY (id_fornecedor) REFERENCES tbl_fornecedor(id_fornecedor) -- DECLARAÇÃO DA CHAVE ESTRANGEIRA
);

-- ALTERANDO AS COLUNAS;
-- alter table tbl_endereco_fornecedor modify column andar_endereco_fornecedor VARCHAR(50) NULL;
-- alter table tbl_endereco_fornecedor modify column numero_apto_fornecedor VARCHAR(50) NULL;

CREATE table tbl_fornecedor (
	id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
	cnpj_forncedor VARCHAR (14) NOT NULL UNIQUE,
	nome_fornecedor VARCHAR (255) NOT NULL,
    razao_social VARCHAR (255) NOT NULL	
);

-- 1. INSIRA PRIMEIRO O FORNECEDOR
INSERT INTO tbl_fornecedor (cnpj_forncedor, nome_fornecedor, razao_social) VALUES ('12345678000195', 'Padaria do Zé', 'Zé da Padoca Comércio de Pães LTDA');
INSERT INTO tbl_fornecedor (cnpj_forncedor, nome_fornecedor, razao_social) VALUES ('34.576.069/0001-80', 'carriel softwares', 'CARRIEL SOFTWARES E ALLAN ENG LTDA');
INSERT INTO tbl_fornecedor (cnpj_forncedor, nome_fornecedor, razao_social) VALUES ('98765432000100', 'Química Limpa', 'Química Limpa Indústria LTDA');
INSERT INTO tbl_endereco_fornecedor (id_fornecedor, cep_endereco_fornecedor, pais_endereco_fornecedor, estado_endereco_fornecedor, cidade_endereco_fornecedor, rua_endereco_fornecedor, numero_endereco_fornecedor) VALUES (LAST_INSERT_ID(), '01000000', 'Brasil', 'SP', 'São Paulo', 'Rua Exemplo', '123');
INSERT INTO tbl_fornecedor (cnpj_forncedor, nome_fornecedor, razao_social) VALUES ('93.288.192/0001-64', 'KANYE WEST', 'KANYE WEST LTDA');
SET @ID_FORNECEDOR = LAST_INSERT_ID();
INSERT INTO tbl_endereco_fornecedor (id_fornecedor, cep_endereco_fornecedor, pais_endereco_fornecedor, estado_endereco_fornecedor, cidade_endereco_fornecedor, rua_endereco_fornecedor, numero_endereco_fornecedor) VALUES (LAST_INSERT_ID(), '01000000', 'Brasil', 'SP', 'São Paulo', 'Rua Exemplo', '123');
-- 2. EM SEGUIDA, INSIRA O ENDEREÇO, UTILIZANDO O ID GERADO
INSERT INTO tbl_endereco_fornecedor (
    id_fornecedor,
    cep_endereco_fornecedor, 
    pais_endereco_fornecedor, 
    estado_endereco_fornecedor, 
    cidade_endereco_fornecedor, 
    rua_endereco_fornecedor, 
    numero_endereco_fornecedor, 
    andar_endereco_fornecedor, 
    numero_apto_fornecedor
)
VALUES (
    -- **CHAVE AQUI!** : Pega o ID que acabou de ser criado no INSERT acima.
    LAST_INSERT_ID(),
    
    '06763200',
    'Brasil',
    'SP',
    'São Paulo',
    'Rua jOSÉ PSTANA',
    '300',
    NULL, -- Não tem andar
    NULL  -- Não tem apartamento
);

------------

SELECT * FROM tbl_categoria;

CREATE TABLE tbl_categoria (
	id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome_categoria VARCHAR(100) UNIQUE  
);

INSERT INTO tbl_categoria (nome_categoria) VALUES ('Limpeza'); 

SET @ID_LIMPEZA = LAST_INSERT_ID();

 CREATE TABLE tbl_produto (
	id_produto INT AUTO_INCREMENT PRIMARY KEY,
    cod_barras_produto 	VARCHAR(20) NOT NULL UNIQUE ,
    nome_produto VARCHAR(255) NOT NULL,
    descricao_produto TEXT,    
    preco_produto DECIMAL(10 ,2) NOT NULL,
    
    id_fornecedor INT NOT NULL UNIQUE,
    id_categoria INT NOT NULL UNIQUE, 
    
    FOREIGN KEY (id_fornecedor) REFERENCES tbl_fornecedor(id_fornecedor),
    FOREIGN KEY (id_categoria) REFERENCES tbl_categoria(id_categoria)
    
);

	INSERT INTO tbl_produto (
		cod_barras_produto, nome_produto, descricao_produto, preco_produto, id_fornecedor, id_categoria
	)
	VALUES (
		'7891234567890',          -- Código de Barras (VARCHAR(20) UNIQUE)
		'Desinfetante Floral',    -- Nome do Produto
		'Desinfetante concentrado com essência floral, 1 litro.', 
		12.50,                    -- Preço de Venda
		@ID_FORNECEDOR,           -- CHAVE ESTRANGEIRA (FK): ID do fornecedor 'Química Limpa'
		@ID_LIMPEZA                -- CHAVE ESTRANGEIRA (FK): ID da categoria 'Limpeza'
	);

SELECT * FROM tbl_produto;

/* CREATE TABLE tbl_entrada (
	id_entrada INT AUTO_INCREMENT PRIMARY KEY,
    nota_entrada,
    fornecedor_entrada,
    produto_entrada,
    qtdes_entrada,
    preco_entrada, 
);*/
DELETE FROM tbl_produto
	 WHERE id_categoria = 1;
-- PASSO 1: DELETAR A TABELA FILHA (tbl_entrada_item)
DROP TABLE IF EXISTS tbl_entrada_item;

-- PASSO 2: DELETAR A TABELA MÃE (tbl_entrada)
DROP TABLE IF EXISTS tbl_entrada;


CREATE TABLE tbl_entrada_item (
    id_entrada_item INT AUTO_INCREMENT PRIMARY KEY,
    
    -- Relacionamentos
    id_entrada INT NOT NULL, -- Liga ao cabeçalho da nota
    id_produto INT NOT NULL, -- Liga ao produto que foi comprado
    
    -- Dados da Transação (imutáveis)
    qtdes_entrada INT NOT NULL,
    
    -- O PREÇO DE CUSTO (FIXO NO MOMENTO DA COMPRA)
    preco_custo DECIMAL(10, 2) NOT NULL,
    
    FOREIGN KEY (id_entrada) REFERENCES tbl_entrada(id_entrada),
    FOREIGN KEY (id_produto) REFERENCES tbl_produto(id_produto)
);

-- Corrigindo a sua modelagem, utilizando chaves estrangeiras (FK)
-- e definindo os tipos de dados corretos.

SELECT * FROM tbl_entrada;

CREATE TABLE tbl_entrada (
    id_entrada INT AUTO_INCREMENT PRIMARY KEY,
    
    -- Dados da Transação
    nota_entrada VARCHAR(50) NOT NULL, -- Tipo de dado para a nota fiscal
    qtdes_entrada INT NOT NULL,
    preco_entrada DECIMAL(10, 2) NOT NULL, -- Seu Preço de Custo (Correto!)
    
    -- Chaves Estrangeiras para o Relacionamento
    id_fornecedor INT NOT NULL,
    id_produto INT NOT NULL,
    
    -- Definição das Chaves Estrangeiras
    FOREIGN KEY (id_fornecedor) REFERENCES tbl_fornecedor(id_fornecedor),
    FOREIGN KEY (id_produto) REFERENCES tbl_produto(id_produto)
);
