-- Criado juntamente com IA para estudo e como começar esse projeto...
-- SOMENTE PARA TESTE

-- Cria o banco de dados 'db_chatbot' se ele não existir
CREATE DATABASE IF NOT EXISTS db_chatbot;

-- Seleciona o banco de dados para uso
USE db_chatbot;

-- Tabela de Usuários
CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Conversas
CREATE TABLE conversas (
    id_conversa INT PRIMARY KEY AUTO_INCREMENT,
    -- Permite conversas com usuários anônimos (não logados)
    id_usuario INT NULL,
    data_inicio DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_fim DATETIME,
    -- Define o que acontece quando um usuário é deletado
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE SET NULL
);

-- Tabela de Mensagens
CREATE TABLE mensagens (
    id_mensagem INT PRIMARY KEY AUTO_INCREMENT,
    id_conversa INT NOT NULL,
    tipo ENUM('usuario', 'bot') NOT NULL,
    texto TEXT NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    -- Ao deletar uma conversa, todas as mensagens são apagadas
    FOREIGN KEY (id_conversa) REFERENCES conversas(id_conversa) ON DELETE CASCADE
);

-- Tabela de Tópicos (Funcionalidade Avançada)
CREATE TABLE topicos (
    id_topico INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL UNIQUE
);

-- Tabela de ligação entre conversas e tópicos
CREATE TABLE conversa_topico (
    id_conversa INT,
    id_topico INT,
    PRIMARY KEY (id_conversa, id_topico),
    FOREIGN KEY (id_conversa) REFERENCES conversas(id_conversa) ON DELETE CASCADE,
    FOREIGN KEY (id_topico) REFERENCES topicos(id_topico) ON DELETE CASCADE
);

-- Tabela para coletar feedback sobre a utilidade das respostas do bot
CREATE TABLE feedback_mensagens (
    id_feedback INT PRIMARY KEY AUTO_INCREMENT,
    id_mensagem INT NOT NULL,
    avaliacao ENUM('util', 'inutil') NOT NULL,
    comentario TEXT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    -- Garante que o feedback seja apenas para mensagens do 'bot' (requer um TRIGGER ou lógica de aplicação)
    FOREIGN KEY (id_mensagem) REFERENCES mensagens(id_mensagem) ON DELETE CASCADE
);


-- Adicionar índices em colunas chave para melhorar a performance das buscas
CREATE INDEX idx_conversas_usuario ON conversas(id_usuario);
CREATE INDEX idx_mensagens_conversa ON mensagens(id_conversa);
CREATE INDEX idx_feedback_mensagem ON feedback_mensagens(id_mensagem);


-- ## SEÇÃO DE TESTES ## --

-- Inserindo um novo usuário para teste
INSERT INTO usuarios (nome, email) VALUES ('Logan', 'logan@email.com');
SET @id_logan = LAST_INSERT_ID(); -- Armazena o ID do usuário inserido

-- Iniciando uma nova conversa para o usuário Logan
INSERT INTO conversas (id_usuario) VALUES (@id_logan);
SET @id_conversa_logan = LAST_INSERT_ID(); -- Armazena o ID da conversa

-- Inserindo a primeira mensagem (do usuário)
INSERT INTO mensagens (id_conversa, tipo, texto) VALUES (@id_conversa_logan, 'usuario', 'Olá, tudo bem? Preciso de ajuda.');

-- Inserindo a resposta do bot
INSERT INTO mensagens (id_conversa, tipo, texto) VALUES (@id_conversa_logan, 'bot', 'Olá, como posso te ajudar hoje?');
SET @id_msg_bot = LAST_INSERT_ID(); -- Armazena o ID da mensagem do bot para o feedback

-- Usuário dá um feedback positivo para a resposta do bot
INSERT INTO feedback_mensagens (id_mensagem, avaliacao) VALUES (@id_msg_bot, 'util');

-- Consultando o histórico completo da conversa
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

-- Encerra a conversa
UPDATE conversas
SET data_fim = CURRENT_TIMESTAMP
WHERE id_conversa = @id_conversa_logan;
