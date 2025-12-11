-- Gera 100 registros por tabela com dados plausíveis.
-- Utilização de generate_series para facilitar processo de povoamento.


-- 1) POPULAR ALUNO (100 registros)
INSERT INTO Aluno (cpf, nome, rua, numero, cidade, estado, data_matricula)
SELECT 
    'CPF-' || LPAD(s::text, 11, '0'),
    'Aluno ' || s,
    'Rua ' || (s % 100 + 1),
    (s % 300 + 1)::text,
    'Crateús',
    'CE',
    DATE '2018-01-01' + (s * 2)
FROM generate_series(1, 100) s;

INSERT INTO telefone_aluno (id_aluno, telefone)
SELECT 
    id_aluno,
    '(88) 9' || LPAD((8000 + id_aluno)::text, 4, '0') || '-' ||
    LPAD((id_aluno * 31 % 10000)::text, 4, '0')
FROM Aluno;


-- 2) POPULAR PROFESSOR (100 registros)
INSERT INTO Professor (nome, rua, numero, cidade, estado)
SELECT
    'Professor ' || s,
    'Avenida ' || (s % 80 + 1),
    (s % 500 + 1)::text,
    'Crateús',
    'CE'
FROM generate_series(1, 100) s;

INSERT INTO telefone_professor (id_professor, telefone)
SELECT 
    id_professor,
    '(88) 9' || LPAD((8200 + id_professor)::text, 4, '0') || '-' ||
    LPAD((id_professor * 29 % 10000)::text, 4, '0')
FROM Professor;


-- 3) POPULAR BIBLIOTECARIO (100 registros)
INSERT INTO Bibliotecario (nome, data_contratacao, rua, numero, cidade, estado)
SELECT
    'Bibliotecário ' || s,
    DATE '2016-01-01' + (s * 3),
    'Travessa ' || (s % 120 + 1),
    (s % 300 + 1)::text,
    'Crateús',
    'CE'
FROM generate_series(1, 100) s;

INSERT INTO telefone_bibliotecario (id_bibliotecario, telefone)
SELECT 
    id_bibliotecario,
    '(88) 9' || LPAD((8400 + id_bibliotecario)::text, 4, '0') || '-' ||
    LPAD((id_bibliotecario * 17 % 10000)::text, 4, '0')
FROM Bibliotecario;


-- 4) POPULAR LIVRO (100 registros)
INSERT INTO Livro (isbn, titulo, autor, editora, ano_publicacao)
SELECT
    'ISBN' || LPAD(s::text, 6, '0'),
    'Livro ' || s,
    'Autor ' || (s % 25 + 1),
    'Editora ' || (s % 15 + 1),
    1990 + (s % 35)
FROM generate_series(1, 100) s;


-- 5) POPULAR EMPRESTIMO (100 registros)
INSERT INTO Emprestimo (data_emprestimo, data_devolucao, id_aluno, id_bibliotecario)
SELECT
    DATE '2020-01-01' + (s * 3),
    CASE WHEN s % 4 = 0 THEN NULL ELSE DATE '2020-01-01' + (s * 4) END,
    ((s - 1) % 100) + 1,
    ((s - 1) % 100) + 1
FROM generate_series(1, 100) s;


-- 6) POPULAR INCLUI (100 registros, SEM duplicação)
-- Cada empréstimo recebe 1 livro correspondente ao mesmo número.
INSERT INTO inclui (id_emprestimo, isbn, quantidade)
SELECT
    id_emprestimo,
    'ISBN' || LPAD(id_emprestimo::text, 6, '0'),
    1
FROM Emprestimo;


-- 7) POPULAR MULTA (100 registros)
INSERT INTO Multa (data_emissao, valor)
SELECT
    DATE '2021-01-01' + (s * 5),
    5 + (s % 50)
FROM generate_series(1, 100) s;


-- 8) POPULAR GERA (cada multa -> empréstimo de mesmo id)
INSERT INTO gera (id_emprestimo, id_multa)
SELECT s, s
FROM generate_series(1, 100) s;


-- 9) POPULAR RESERVA (100 registros)
INSERT INTO Reserva (data_reserva, id_professor)
SELECT
    DATE '2022-01-01' + (s * 2),
    ((s - 1) % 100) + 1
FROM generate_series(1, 100) s;


-- 10) POPULAR INCLUI_RESERVA (1 livro único por reserva)
INSERT INTO inclui_reserva (id_reserva, isbn)
SELECT
    id_reserva,
    'ISBN' || LPAD(id_reserva::text, 6, '0')
FROM Reserva;


-- 11) POPULAR TELEFONE_RESERVA (100 registros)
INSERT INTO telefone_reserva (id_reserva, telefone)
SELECT
    id_reserva,
    '(88) 9' || LPAD((8600 + id_reserva)::text, 4, '0') || '-' ||
    LPAD((id_reserva * 7 % 10000)::text, 4, '0')
FROM Reserva;



