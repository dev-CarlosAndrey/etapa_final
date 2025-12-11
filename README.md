# Sistema de Controle de Biblioteca - Etapa Final

Conteúdo:
- /sql/create_tables.sql  - DDL (PostgreSQL)
- /sql/populate_data.sql - Popula com 100 registros por relação
- /sql/queries.sql       - 10 consultas solicitadas
- /diagram/modelo_logico.png - diagrama lógico (adicione a imagem gerada pelo BRModelo)

Execução:
1. Criar banco PostgreSQL (ex: biblioteca) e conectar:
   psql -U usuario -d biblioteca -f create_tables.sql
2. Popular:
   psql -U usuario -d biblioteca -f populate_data.sql
3. Rodar consultas:
   psql -U usuario -d biblioteca -f queries.sql

Observações:
- Telefone foi modelado como multivalorado (tabelas separadas).
- Foram gerados 100 registros por relação, com datas, nomes e valores plausíveis.
- Alguns data_devolucao podem ser NULL para simular empréstimos em andamento.

Consultas (resumo):
1. Top 10 alunos com mais empréstimos — identifica usuários com maior uso.
2. Livros mais reservados — ajuda em aquisição de exemplares.
3. Média de multas por aluno — indicador de comportamento.
4. Empréstimos sem devolução — riscos/pendências.
5. Professores que fizeram reservas em 2022-2023 — análise temporal.
6. Total arrecadado em multas por ano — relatório financeiro.
7. Livros nunca emprestados — acervo ocioso.
8. Empréstimos que contêm determinados ISBNs — busca por itens.
9. Alunos com multas acima da média — identificar casos atípicos.
10. Média de livros por empréstimo — métrica de uso.

Autor: Carlos Andrey Bezerra Henrique e Maria Eduarda 
