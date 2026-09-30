

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
								REFERENCES propriedade(idPropriedade)
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