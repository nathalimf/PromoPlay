--Criado juntamente com IA para estudo e como começar esse projeto... 
--SOMENTE PARA TESTE


-- Cria o banco de dados 'db_chatbot' se ele não existir
CREATE DATABASE IF NOT EXISTS db_chatbot;

-- Seleciona o banco de dados para uso
USE db_chatbot;

-- Tabela de Usuários
-- 'id_usuario' será usado para rastrear as conversas de cada pessoa.
-- 'data_cadastro' pode ser útil para ver quando o usuário interagiu pela primeira vez.
CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Conversas
-- Cada linha representa uma interação completa, como uma "sessão" de chat.
-- 'id_conversa' é a chave primária.
-- 'id_usuario' é a chave estrangeira que liga a conversa a um usuário específico.
-- 'data_inicio' e 'data_fim' são úteis para analisar o tempo de cada conversa.
CREATE TABLE conversas (
    id_conversa INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT,
    data_inicio DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_fim DATETIME,
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- Tabela de Mensagens
-- Armazena cada mensagem trocada entre o usuário e o chatbot.
-- 'tipo' ('usuario' ou 'bot') indica quem enviou a mensagem.
-- 'texto' é o conteúdo da mensagem.
-- 'timestamp' registra o momento exato do envio.
-- 'id_conversa' vincula a mensagem à sua conversa correspondente.
CREATE TABLE mensagens (
    id_mensagem INT PRIMARY KEY AUTO_INCREMENT,
    id_conversa INT,
    tipo ENUM('usuario', 'bot') NOT NULL,
    texto TEXT NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_conversa) REFERENCES conversas(id_conversa)
);

-- Tabela Opcional: Tópicos da Conversa
-- Para uma funcionalidade mais avançada, esta tabela pode ajudar a categorizar as conversas.
-- 'nome' poderia ser 'Suporte Técnico', 'Vendas', 'Dúvidas Gerais', etc.
CREATE TABLE topicos (
    id_topico INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL UNIQUE
);

-- Tabela de ligação entre conversas e tópicos
-- Uma conversa pode ter um ou mais tópicos.
CREATE TABLE conversa_topico (
    id_conversa INT,
    id_topico INT,
    PRIMARY KEY (id_conversa, id_topico),
    FOREIGN KEY (id_conversa) REFERENCES conversas(id_conversa),
    FOREIGN KEY (id_topico) REFERENCES topicos(id_topico)
);

-- Inserindo um novo usuário para teste
INSERT INTO usuarios (nome, email) VALUES ('Logan', 'logan@email.com');

-- Obtendo o ID do usuário recém-inserido (útil para a aplicação)
SELECT LAST_INSERT_ID();

-- Iniciando uma nova conversa para o usuário com ID 1
INSERT INTO conversas (id_usuario) VALUES (1);

-- Inserindo a primeira mensagem (do usuário)
INSERT INTO mensagens (id_conversa, tipo, texto) VALUES (1, 'usuario', 'Olá, tudo bem? Preciso de ajuda.');

-- Inserindo a resposta do bot
INSERT INTO mensagens (id_conversa, tipo, texto) VALUES (1, 'bot', 'Olá, como posso te ajudar hoje?');

-- Consultando o histórico completo de uma conversa
SELECT
    m.tipo AS 'Remetente',
    m.texto AS 'Mensagem',
    m.timestamp AS 'Hora da Mensagem'
FROM
    mensagens m
WHERE
    m.id_conversa = 1
ORDER BY
    m.timestamp ASC;

-- Encerra a conversa
UPDATE conversas
SET data_fim = CURRENT_TIMESTAMP
WHERE id_conversa = 1;