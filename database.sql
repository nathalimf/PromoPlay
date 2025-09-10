CREATE DATABASE IF NOT EXISTS db_promoplay;

USE db_promoplay;

CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO usuarios (nome, email) VALUES ('Logan', 'logan@email.com');
