
CREATE DATABASE IF NOT EXISTS db_promoplay;

USE db_promoplay;

CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE conversas (
    id_conversa INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NULL,
    data_inicio DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_fim DATETIME,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL
);

CREATE TABLE mensagens (
    id_mensagem INT PRIMARY KEY AUTO_INCREMENT,
    id_conversa INT NOT NULL,
    tipo ENUM('usuario', 'bot') NOT NULL,
    texto TEXT NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_conversa) REFERENCES conversas(id_conversa) ON DELETE CASCADE
);


CREATE TABLE topicos (
    id_topico INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE conversa_topico (
    id_conversa INT,
    id_topico INT,
    PRIMARY KEY (id_conversa, id_topico),
    FOREIGN KEY (id_conversa) REFERENCES conversas(id_conversa) ON DELETE CASCADE,
    FOREIGN KEY (id_topico) REFERENCES topicos(id_topico) ON DELETE CASCADE
);

CREATE TABLE feedback_mensagens (
    id_feedback INT PRIMARY KEY AUTO_INCREMENT,
    id_mensagem INT NOT NULL,
    avaliacao ENUM('util', 'inutil') NOT NULL,
    comentario TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_mensagem) REFERENCES mensagens(id_mensagem) ON DELETE CASCADE
);


CREATE INDEX idx_conversas_usuario ON conversas(id_usuario);
CREATE INDEX idx_mensagens_conversa ON mensagens(id_conversa);
CREATE INDEX idx_feedback_mensagem ON feedback_mensagens(id_mensagem);



INSERT INTO usuarios (nome, email) VALUES ('Logan', 'logan@email.com');
SET @id_logan = LAST_INSERT_ID();

INSERT INTO conversas (id_usuario) VALUES (@id_logan);
SET @id_conversa_logan = LAST_INSERT_ID();
INSERT INTO mensagens (id_conversa, tipo, texto) VALUES (@id_conversa_logan, 'usuario', 'Olá, tudo bem? Preciso de ajuda.');

INSERT INTO mensagens (id_conversa, tipo, texto) VALUES (@id_conversa_logan, 'bot', 'Olá, como posso te ajudar hoje?');
SET @id_msg_bot = LAST_INSERT_ID(); 

INSERT INTO feedback_mensagens (id_mensagem, avaliacao) VALUES (@id_msg_bot, 'util');

SELECT
    m.tipo AS 'Remetente',
    m.texto AS 'Mensagem',
    m.timestamp AS 'Hora da Mensagem'
FROM
    mensagens m
WHERE
    m.id_conversa = @id_conversa_logan
ORDER BY
    m.timestamp ASC;

UPDATE conversas
SET data_fim = CURRENT_TIMESTAMP
WHERE id_conversa = @id_conversa_logan;
