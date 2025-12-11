-- Gera 100 registros por tabela com dados plausíveis.
-- Utilização de generate_series para facilitar processo de povoamento.

-- 1) Alunos + telefones
INSERT INTO Aluno (cpf, nome, rua, numero, cidade, estado, data_matricula)
SELECT
  ('CPF' || lpad((100000 + s)::text, 11, '0')) AS cpf,
  ('Nome Aluno ' || s) AS nome,
  ('Rua ' || (s % 120 + 1)) AS rua,
  (s % 300 + 1)::text AS numero,
  'Crateús' AS cidade,
  'CE' AS estado,
  (date '2018-01-01' + ((random()*2000)::int) ) AS data_matricula
FROM generate_series(1,100) s;

INSERT INTO telefone_aluno (id_aluno, telefone)
SELECT id_aluno, concat('(88) 9', (1000 + (s*31 % 9000))::text, '-', lpad((s*17 % 10000)::text,4,'0'))
FROM Aluno JOIN generate_series(1,100) s ON Aluno.id_aluno = s;


-- 2) Professores + telefones
INSERT INTO Professor (nome, rua, numero, cidade, estado)
SELECT
  ('Prof Nome ' || s),
  ('Avenida ' || (s % 90 + 1)),
  (s % 400 + 1)::text,
  'Crateús',
  'CE'
FROM generate_series(1,100) s;

INSERT INTO telefone_professor (id_professor, telefone)
SELECT id_professor, concat('(88) 9', (2000 + (s*41 % 8000))::text, '-', lpad((s*23 % 10000)::text,4,'0'))
FROM Professor JOIN generate_series(1,100) s ON Professor.id_professor = s;


-- 3) Bibliotecarios + telefones
INSERT INTO Bibliotecario (nome, data_contratacao, rua, numero, cidade, estado)
SELECT
  ('Biblio Nome ' || s),
  (date '2015-01-01' + ((random()*4000)::int) ),
  ('Travessa ' || (s % 60 + 1)),
  (s % 500 + 1)::text,
  'Crateús',
  'CE'
FROM generate_series(1,100) s;

INSERT INTO telefone_bibliotecario (id_bibliotecario, telefone)
SELECT id_bibliotecario, concat('(88) 9', (3000 + (s*37 % 7000))::text, '-', lpad((s*29 % 10000)::text,4,'0'))
FROM Bibliotecario JOIN generate_series(1,100) s ON Bibliotecario.id_bibliotecario = s;


-- 4) Livros (100)
INSERT INTO Livro (isbn, titulo, autor, editora, ano_publicacao)
SELECT
  ('ISBN' || (100000 + s)),
  ('Livro Exemplo ' || (s % 20 + 1) || ' - Edição ' || (s % 5 + 1)),
  ('Autor ' || (s % 15 + 1)),
  ('Editora ' || (s % 25 + 1)),
  (1990 + (s % 35))
FROM generate_series(1,100) s;


-- 5) Emprestimos (100)
INSERT INTO Emprestimo (data_emprestimo, data_devolucao, id_aluno, id_bibliotecario)
SELECT
  (date '2020-01-01' + ((random()*2000)::int) ),
  (CASE WHEN random() < 0.8 THEN (date '2020-01-01' + ((random()*2000)::int)) ELSE NULL END),
  ((s % 100) + 1),
  ((s % 100) + 1)
FROM generate_series(1,100) s;

-- Ajusta devolução para não ser anterior à retirada: (opcional) - aqui mantemos como está para variabilidade


-- 6) inclui (N:N Emprestimo-Livro)
--    inserir 100 linhas (cada empréstimo relacionado a 1-2 livros)
WITH emps AS (
  SELECT id_emprestimo, generate_series(1, (1 + ((id_emprestimo::int % 2)))) AS seq
  FROM Emprestimo
)
INSERT INTO inclui (id_emprestimo, isbn, quantidade)
SELECT e.id_emprestimo, l.isbn, 1
FROM emps e
JOIN LATERAL (
  SELECT isbn FROM Livro ORDER BY random() LIMIT 1
) l ON true
LIMIT 100;


-- 7) Multas (100) + gera (link multa -> emprestimo)
INSERT INTO Multa (data_emissao, valor)
SELECT
  (date '2020-01-01' + ((random()*2000)::int)),
  round( (random() * 48 + 2)::numeric, 2)
FROM generate_series(1,100) s;

-- Linka cada multa a um empréstimo (1..100 -> 1..100)
INSERT INTO gera (id_emprestimo, id_multa)
SELECT s, s FROM generate_series(1,100) s;


-- 8) Reservas (100) + inclui_reserva + telefone_reserva
INSERT INTO Reserva (data_reserva, id_professor)
SELECT
  (date '2020-01-01' + ((random()*2000)::int)),
  ((s % 100) + 1)
FROM generate_series(1,100) s;

INSERT INTO inclui_reserva (id_reserva, isbn)
SELECT s, (SELECT isbn FROM Livro ORDER BY random() LIMIT 1)
FROM generate_series(1,100) s;

INSERT INTO telefone_reserva (id_reserva, telefone)
SELECT s, concat('(88) 9', (4000 + (s*13 % 6000))::text, '-', lpad((s*7 % 10000)::text,4,'0'))
FROM generate_series(1,100) s;

-- 9) Garantir 1 telefone por aluno/professor/bibliotecario/reserva (já preenchidos acima)



