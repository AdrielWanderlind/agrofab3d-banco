
CREATE DATABASE agrofab3d;

USE agrofab3d;

-- ==========================================
-- 1. TIPOS DE USUARIO
-- ==========================================

CREATE TABLE tipos_usuario (
    id_tipo_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE,
    descricao VARCHAR(255)
);

INSERT INTO tipos_usuario (nome, descricao) VALUES
('Produtor Rural', 'Usuário que publica necessidades e pesquisa soluções'),
('Empresa', 'Empresa de impressão 3D'),
('Administrador', 'Responsável pelo gerenciamento da plataforma');


-- ==========================================
-- 2. USUARIOS
-- ==========================================

CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,

    id_tipo_usuario INT NOT NULL,

    nome VARCHAR(150) NOT NULL,

    email VARCHAR(150) NOT NULL UNIQUE,

    senha_hash VARCHAR(255) NOT NULL,

    status ENUM(
        'ATIVO',
        'BLOQUEADO',
        'INATIVO'
    ) NOT NULL DEFAULT 'ATIVO',

    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    atualizado_em DATETIME DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    excluido_em DATETIME NULL,

    FOREIGN KEY (id_tipo_usuario)
        REFERENCES tipos_usuario(id_tipo_usuario)
);


-- ==========================================
-- 3. SESSOES
-- ==========================================

CREATE TABLE sessoes (
    id_sessao BIGINT AUTO_INCREMENT PRIMARY KEY,

    id_usuario INT NOT NULL,

    token_hash VARCHAR(255) NOT NULL UNIQUE,

    ip_origem VARCHAR(45),

    dispositivo VARCHAR(255),

    criada_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    expira_em DATETIME NOT NULL,

    revogada_em DATETIME NULL,

    FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario)
);


-- ==========================================
-- 4. DOCUMENTOS E TERMOS
-- ==========================================

CREATE TABLE documentos_termos (
    id_documento INT AUTO_INCREMENT PRIMARY KEY,

    tipo_documento ENUM(
        'TERMOS_DE_USO',
        'POLITICA_DE_PRIVACIDADE'
    ) NOT NULL,

    versao VARCHAR(30) NOT NULL,

    descricao VARCHAR(255),

    url_documento VARCHAR(500),

    hash_documento VARCHAR(255),

    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE (tipo_documento, versao)
);


-- ==========================================
-- 5. ACEITES DOS TERMOS
-- ==========================================

CREATE TABLE aceites_termos (
    id_aceite BIGINT AUTO_INCREMENT PRIMARY KEY,

    id_usuario INT NOT NULL,

    id_documento INT NOT NULL,

    aceito BOOLEAN NOT NULL,

    data_aceite DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    ip_origem VARCHAR(45),

    FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario),

    FOREIGN KEY (id_documento)
        REFERENCES documentos_termos(id_documento),

    UNIQUE (id_usuario, id_documento)
);


-- ==========================================
-- 6. LOGS DE AUTENTICACAO
-- ==========================================

CREATE TABLE logs_autenticacao (
    id_log BIGINT AUTO_INCREMENT PRIMARY KEY,

    id_usuario INT NULL,

    email_tentativa VARCHAR(150),

    tipo_evento ENUM(
        'LOGIN_SUCESSO',
        'LOGIN_FALHA',
        'LOGOUT',
        'CONTA_BLOQUEADA',
        'CONTA_DESBLOQUEADA',
        'CONTA_INATIVADA'
    ) NOT NULL,

    ip_origem VARCHAR(45),

    data_evento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    motivo VARCHAR(255),

    FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario)
);
