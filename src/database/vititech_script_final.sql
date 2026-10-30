CREATE DATABASE vititech;

USE vititech;

CREATE TABLE empresa (
idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
razao_social VARCHAR(100),
cnpj CHAR(14) UNIQUE,
cod_ativacao CHAR(6) UNIQUE,
telefone CHAR(11),
email VARCHAR(50) UNIQUE
);

-- TABELA USUARIO

CREATE TABLE usuario (
idUsuario INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(90),
email VARCHAR(60) UNIQUE,
cpf CHAR(11) UNIQUE,
senha VARCHAR(50),
fk_empresa INT,
CONSTRAINT fkEmpresa FOREIGN KEY (fk_empresa)
								REFERENCES empresa(idEmpresa)
);

-- TABELA PROPRIEDADE

CREATE TABLE propriedade (
idPropriedade INT PRIMARY KEY AUTO_INCREMENT,
filial VARCHAR(45),
uf CHAR(2),
fk_empresa INT,
CONSTRAINT fk_Empresa FOREIGN KEY (fk_empresa) 
								REFERENCES empresa(idEmpresa)
);


-- TABELA TIPOS DE UVA
CREATE TABLE uva(
id INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(45),
minUmidade DECIMAL(5,2),
maxUmidade DECIMAL(5,2)
);


-- TABELA BAIA

CREATE TABLE baia (
idBaia INT PRIMARY KEY AUTO_INCREMENT,
area DECIMAL(10,2),
fk_propriedade INT,
fk_uva INT,
CONSTRAINT fkPropriedade FOREIGN KEY (fk_propriedade)
									REFERENCES propriedade(idPropriedade),
CONSTRAINT fkUva FOREIGN KEY (fk_uva)
							REFERENCES uva(id)

);

-- TABELA SENSOR

CREATE TABLE sensor (
idSensor INT PRIMARY KEY AUTO_INCREMENT,
area_instalada DECIMAL (10,2),
ativo TINYINT,
fk_baia INT,
CONSTRAINT fkBaia FOREIGN KEY (fk_baia)
								REFERENCES baia(idBaia)
);


-- TABELA MEDIDA

CREATE TABLE medida (
idMedida INT PRIMARY KEY AUTO_INCREMENT,
umidade INT,
data_horario DATETIME DEFAULT CURRENT_TIMESTAMP,
nivel_alerta INT,
fk_sensor INT,
CONSTRAINT nivelAlerta CHECK (nivel_alerta IN ('1', '2', '3')),
CONSTRAINT fkSensor FOREIGN KEY (fk_sensor) 
								REFERENCES sensor(idSensor)
);


/*
				CRIAÇÃO DO USUÁRIO
CREATE USER 'user_insert'@'localhost' IDENTIFIED BY 'urubu100';

GRANT INSERT ON vititech.* TO 'user_insert'@'localhost';
*/

-- INSERTS
-- 1. INSERINDO EMPRESAS (Vinícolas)
INSERT INTO empresa (razao_social, cnpj, cod_ativacao, telefone, email) VALUES
('Vinícola Vale das Uvas Ltda', '12345678000199', 'VALE01', '54999991111', 'contato@valedasavas.com.br'),
('Adega Serra Sul S.A.', '98765432000188', 'SUL002', '54988882222', 'admin@adegaserrasul.com.br'),
('Vinhos São Roque & Cia', '45678912000177', 'ROQ003', '11977773333', 'suporte@vinhossr.com.br');

-- 2. INSERINDO USUÁRIOS
-- CPFs com 11 caracteres. Perfil: 1 (Admin/Gerente), 2 (Operador/Técnico)
INSERT INTO usuario (nome, email, cpf, senha, fk_empresa) VALUES
('Carlos Alberto Bento', 'carlos@valedasavas.com.br', '11122233344', 'senha123', 1),
('Fernanda Lima', 'fernanda@adegaserrasul.com.br', '55566677788', 'senha456', 2),
('Ricardo Mendes', 'ricardo@adegaserrasul.com.br', '99900011122', 'senha789', 2),
('Juliana Costa', 'juliana@vinhossr.com.br', '33344455566', 'senha321', 3);

-- 3. INSERINDO PROPRIEDADES
-- Fazendas e filiais vinculadas às empresas, localizadas em estados produtores (RS, SP)
INSERT INTO propriedade (filial, uf, fk_empresa) VALUES
('Fazenda Vale Central - Matriz', 'RS', 1),
('Sítio Colina Verde', 'RS', 2),
('Fazenda Rio das Antas', 'RS', 2),
('Vinhedo São Roque - Leste', 'SP', 3);

-- 4. INSERINDO TIPOS DE UVA
INSERT INTO uva(nome, minUmidade, maxUmidade) VALUES
('Carbenet Suavignon', 50, 75), 
('Carbenet Malbec', 60, 75);

-- 5. INSERINDO BAIAS
-- Baias vinculadas às propriedades da empresa
INSERT INTO baia (area, fk_propriedade, fk_uva) VALUES
('5.00', 1, 1),
('7.00', 2, 1),
('1.5', 3, 2);

-- 6. INSERINDO SENSORES
-- Vinculando aos respectivos idEmpresa e idPropriedade. 
-- Ativo: 1 (Ligado/Funcionando), 0 (Desligado/Manutenção)
INSERT INTO sensor (area_instalada, ativo, fk_baia) VALUES
(150.50, 1, 1), -- Sensor 1 da Empresa 1, Propriedade 1
(200.00, 1, 1), -- Sensor 2 da Empresa 1, Propriedade 1
(350.75, 1, 2), -- Sensor 3 da Empresa 2, Propriedade 2
(120.00, 0, 2), -- Sensor 4 da Empresa 2, Propriedade 2 (Em manutenção)
(500.25, 1, 3), -- Sensor 5 da Empresa 2, Propriedade 3
(80.00, 1, 3);  -- Sensor 6 da Empresa 3, Propriedade 3

-- SELECT PARA VER O TIPO DE UVA POR BAIA
SELECT
b.idBaia AS 'Baia',
u.nome AS 'Tipo de uva'
FROM baia AS b
JOIN uva AS u ON fk_uva = u.id;

-- VER TODOS OS SENSORES
SELECT * FROM sensor;

-- SELECT MEDIDA
SELECT * FROM medida;

-- LIMPAR MEDIDA
TRUNCATE medida;

-- SELECT DA MEDIDA COM O MINIMO, MAXIMO E TIPO DE UVA
SELECT
m.umidade AS 'Umidade',
s.idSensor AS 'Sensor',
b.idBaia AS 'Baia',
u.nome AS 'Tipo de uva',
u.minUmidade AS 'Umidade minima',
maxUmidade AS 'Umidade Máxima'
FROM medida AS m
JOIN sensor AS s ON m.fk_sensor = s.idSensor
JOIN baia AS b ON fk_baia = idBaia
JOIN uva AS u ON b.fk_uva = u.id;

-- SELECT QUE MOSTRA TODAS AS MEDIDAS QUE ESTÃO EM ALERTA
SELECT s.idSensor AS 'Sensor',
data_horario AS 'Data e hora',
umidade AS 'Umidade',
CASE
	WHEN nivel_alerta = 2 THEN 'Moderado'
    WHEN nivel_alerta = 3 THEN 'Critico'
END AS 'Nível de alerta'
FROM medida
JOIN sensor AS s ON fk_sensor = idSensor
WHERE nivel_alerta > 1;

-- SELECT DA ULTIMA MEDIDA REGISTRADA
SELECT umidade AS 'Umidade Atual'
 FROM medida
ORDER BY umidade DESC
LIMIT 1;