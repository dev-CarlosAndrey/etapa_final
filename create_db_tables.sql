-- Comando pra criar o banco de dados 
CREATE DATABASE biblioteca;

-- DDL para PostgreSQL - Comandos para criação das tabelas

CREATE TABLE Aluno (
    id_aluno SERIAL PRIMARY KEY,
    cpf VARCHAR(20) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    rua VARCHAR(100),
    numero VARCHAR(20),
    cidade VARCHAR(50),
    estado VARCHAR(2),
    data_matricula DATE NOT NULL
);

CREATE TABLE telefone_aluno (
    telefone_pk SERIAL PRIMARY KEY,
    id_aluno INT NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES Aluno(id_aluno) ON DELETE CASCADE
);

CREATE TABLE Professor (
    id_professor SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    rua VARCHAR(100),
    numero VARCHAR(20),
    cidade VARCHAR(50),
    estado VARCHAR(2)
);

CREATE TABLE telefone_professor (
    telefone_pk SERIAL PRIMARY KEY,
    id_professor INT NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_professor) REFERENCES Professor(id_professor) ON DELETE CASCADE
);

CREATE TABLE Bibliotecario (
    id_bibliotecario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    data_contratacao DATE NOT NULL,
    rua VARCHAR(100),
    numero VARCHAR(20),
    cidade VARCHAR(50),
    estado VARCHAR(2)
);

CREATE TABLE telefone_bibliotecario (
    telefone_pk SERIAL PRIMARY KEY,
    id_bibliotecario INT NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_bibliotecario) REFERENCES Bibliotecario(id_bibliotecario) ON DELETE CASCADE
);

CREATE TABLE Livro (
    isbn VARCHAR(20) PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    autor VARCHAR(100),
    editora VARCHAR(100),
    ano_publicacao INT
);

CREATE TABLE Emprestimo (
    id_emprestimo SERIAL PRIMARY KEY,
    data_emprestimo DATE NOT NULL,
    data_devolucao DATE,
    id_aluno INT NOT NULL,
    id_bibliotecario INT NOT NULL,
    FOREIGN KEY (id_aluno) REFERENCES Aluno(id_aluno),
    FOREIGN KEY (id_bibliotecario) REFERENCES Bibliotecario(id_bibliotecario)
);

CREATE TABLE inclui (
    id_emprestimo INT NOT NULL,
    isbn VARCHAR(20) NOT NULL,
    quantidade INT DEFAULT 1,
    PRIMARY KEY (id_emprestimo, isbn),
    FOREIGN KEY (id_emprestimo) REFERENCES Emprestimo(id_emprestimo) ON DELETE CASCADE,
    FOREIGN KEY (isbn) REFERENCES Livro(isbn)
);

CREATE TABLE Multa (
    id_multa SERIAL PRIMARY KEY,
    data_emissao DATE NOT NULL,
    valor NUMERIC(10,2) NOT NULL
);

CREATE TABLE gera (
    id_emprestimo INT NOT NULL,
    id_multa INT NOT NULL UNIQUE,
    PRIMARY KEY (id_multa),
    FOREIGN KEY (id_emprestimo) REFERENCES Emprestimo(id_emprestimo),
    FOREIGN KEY (id_multa) REFERENCES Multa(id_multa)
);

CREATE TABLE Reserva (
    id_reserva SERIAL PRIMARY KEY,
    data_reserva DATE NOT NULL,
    id_professor INT NOT NULL,
    FOREIGN KEY (id_professor) REFERENCES Professor(id_professor)
);

CREATE TABLE inclui_reserva (
    id_reserva INT NOT NULL,
    isbn VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_reserva, isbn),
    FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva) ON DELETE CASCADE,
    FOREIGN KEY (isbn) REFERENCES Livro(isbn)
);

CREATE TABLE telefone_reserva (
    telefone_pk SERIAL PRIMARY KEY,
    id_reserva INT NOT NULL,
    telefone VARCHAR(20),
    FOREIGN KEY (id_reserva) REFERENCES Reserva(id_reserva) ON DELETE CASCADE
);
