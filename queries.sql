-- 10 Consultas

-- 1) Top 10 alunos com mais empréstimos (JOIN + GROUP BY)
SELECT a.id_aluno, a.nome, COUNT(e.id_emprestimo) AS total_emprestimos
FROM Aluno a
JOIN Emprestimo e ON e.id_aluno = a.id_aluno
GROUP BY a.id_aluno, a.nome
ORDER BY total_emprestimos DESC
LIMIT 10;

-- 2) Livros mais reservados (JOIN + COUNT + HAVING)
SELECT l.isbn, l.titulo, COUNT(ir.id_reserva) AS total_reservas
FROM Livro l
JOIN inclui_reserva ir ON ir.isbn = l.isbn
GROUP BY l.isbn, l.titulo
HAVING COUNT(ir.id_reserva) >= 1
ORDER BY total_reservas DESC
LIMIT 10;

-- 3) Média de multas por aluno (subquery + AVG)
SELECT AVG(sub.qtd_multas) AS media_multas_por_aluno
FROM (
    SELECT e.id_aluno, COUNT(g.id_multa) AS qtd_multas
    FROM Emprestimo e
    LEFT JOIN gera g ON g.id_emprestimo = e.id_emprestimo
    GROUP BY e.id_aluno
) sub;

-- 4) Empréstimos sem devolução (data_devolucao IS NULL) com dados do aluno (INNER JOIN)
SELECT e.id_emprestimo, e.data_emprestimo, a.nome, a.cpf
FROM Emprestimo e
JOIN Aluno a ON a.id_aluno = e.id_aluno
WHERE e.data_devolucao IS NULL;

-- 5) Professores que fizeram reservas em 2022-2023 (EXISTS)
SELECT p.id_professor, p.nome
FROM Professor p
WHERE EXISTS (
    SELECT 1 FROM Reserva r WHERE r.id_professor = p.id_professor AND r.data_reserva BETWEEN '2022-01-01' AND '2023-12-31'
);

-- 6) Total arrecadado em multas por ano (GROUP BY + EXTRACT)
SELECT EXTRACT(YEAR FROM m.data_emissao) AS ano, SUM(m.valor) AS total_multas
FROM Multa m
GROUP BY ano
ORDER BY ano DESC;

-- 7) Livros nunca emprestados (LEFT JOIN)
SELECT l.isbn, l.titulo
FROM Livro l
LEFT JOIN inclui i ON i.isbn = l.isbn
WHERE i.isbn IS NULL;

-- 8) Empréstimos que contêm ISBNs especificados (ANY/ARRAY)
SELECT DISTINCT i.id_emprestimo
FROM inclui i
WHERE i.isbn = ANY (ARRAY['ISBN100005','ISBN100010','ISBN100020']);

-- 9) Alunos com multa maior que a média (subquery + JOINs)
SELECT DISTINCT a.id_aluno, a.nome, m.valor
FROM Aluno a
JOIN Emprestimo e ON e.id_aluno = a.id_aluno
JOIN gera g ON g.id_emprestimo = e.id_emprestimo
JOIN Multa m ON m.id_multa = g.id_multa
WHERE m.valor > (SELECT AVG(valor) FROM Multa);

-- 10) Quantidade média de livros por empréstimo (AGG + AVG)
SELECT AVG(cnt) AS media_livros_por_emprestimo FROM (
    SELECT id_emprestimo, COUNT(*) AS cnt FROM inclui GROUP BY id_emprestimo
) s;
