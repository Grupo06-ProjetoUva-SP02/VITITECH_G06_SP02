-- Criação do banco de dados
CREATE DATABASE vititech;

USE vititech;

-- TABELA EMPRESA

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
senha VARCHAR(40),
fk_empresa INT,
perfil TINYINT,
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

-- TABELA SENSOR

CREATE TABLE sensor (
idSensor INT PRIMARY KEY AUTO_INCREMENT,
area_instalada DECIMAL (10,2),
ativo TINYINT,
fk_empresa INT,
fk_propriedade INT,
CONSTRAINT fk_EmpresaSensor FOREIGN KEY (fk_empresa) 
								REFERENCES empresa(idEmpresa),
CONSTRAINT fkPropriedade FOREIGN KEY (fk_propriedade) 
								REFERENCES propriedade(idPropriedade),
fk_tipoUva INT,
FOREIGN KEY (fk_tipoUva) REFERENCES uva(id)
);


-- TABELA MEDIDA

CREATE TABLE medida (
idMedida INT PRIMARY KEY AUTO_INCREMENT,
umidade INT,
data_horario DATETIME DEFAULT CURRENT_TIMESTAMP,
fk_sensor INT,
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
INSERT INTO usuario (nome, email, cpf, senha, fk_empresa, perfil) VALUES
('Carlos Alberto Bento', 'carlos@valedasavas.com.br', '11122233344', 'senha123', 1, 1),
('Fernanda Lima', 'fernanda@adegaserrasul.com.br', '55566677788', 'senha456', 2, 1),
('Ricardo Mendes', 'ricardo@adegaserrasul.com.br', '99900011122', 'senha789', 2, 2),
('Juliana Costa', 'juliana@vinhossr.com.br', '33344455566', 'senha321', 3, 1);

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

-- 5. INSERINDO SENSORES
-- Vinculando aos respectivos idEmpresa e idPropriedade. 
-- Ativo: 1 (Ligado/Funcionando), 0 (Desligado/Manutenção)
INSERT INTO sensor (area_instalada, ativo, fk_empresa, fk_propriedade, fk_tipoUva) VALUES
(150.50, 1, 1, 1, 1), -- Sensor 1 da Empresa 1, Propriedade 1
(200.00, 1, 1, 1, 2), -- Sensor 2 da Empresa 1, Propriedade 1
(350.75, 1, 2, 2, 2), -- Sensor 3 da Empresa 2, Propriedade 2
(120.00, 0, 2, 2, 1), -- Sensor 4 da Empresa 2, Propriedade 2 (Em manutenção)
(500.25, 1, 2, 3, 1), -- Sensor 5 da Empresa 2, Propriedade 3
(80.00, 1, 3, 4, 1);  -- Sensor 6 da Empresa 3, Propriedade 4

-- SELECT PARA VER O TIPO DE UVA QUE O SENSOR ESTÁ MEDINDO
SELECT
s.idSensor AS 'Sensor',
u.nome AS 'Tipo de uva'
FROM sensor AS s
JOIN uva AS u ON fk_tipoUva = u.id;

SELECT * FROM sensor;

-- SELECT MEDIDA
SELECT * FROM medida;

-- LIMPAR MEDIDA
TRUNCATE medida;

-- SELECT DA MEDIDA COM O MINIMO, MAXIMO E TIPO DE UVA
SELECT
m.data_horario AS 'Data e Hora da Medição',
m.umidade AS 'Umidade',
s.idSensor AS 'Sensor',
u.nome AS 'Tipo de uva',
u.minUmidade AS 'Minimo de Umidade',
u.maxUmidade AS 'Máximo de Umidade'
FROM medida AS m 
JOIN sensor AS s ON m.fk_sensor = s.idSensor
JOIN uva AS u ON s.fk_tipoUva = u.id;

-- SELECT COM CASE QUE IDENTIFICA SE ESTÁ EM ALERTA OU NÃO
SELECT
m.data_horario AS 'Data e Hora da Medição',
m.umidade AS 'Umidade',
s.idSensor AS 'Sensor',
u.nome AS 'Tipo de uva',
u.minUmidade AS 'Minimo de Umidade',
u.maxUmidade AS 'Máximo de Umidade',
CASE 
	WHEN m.umidade > u.maxUmidade THEN 'Acima da umidade'
    WHEN m.umidade < u.minUmidade THEN 'Abaixo da umidade'
    ELSE 'Adequado'
END AS 'Situação'
FROM medida AS m 
JOIN sensor AS s ON m.fk_sensor = s.idSensor
JOIN uva AS u ON s.fk_tipoUva = u.id; 