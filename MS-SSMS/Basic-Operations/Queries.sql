/*------------------------------------------------------------------------------------------------------------------------
QUERIES
Consultas com junção (like, in, between, order by, funções agregadas, group by, having)
-------------------------------------------------------------------------------------------------------------------------*/

--Listar o total de alunos reprovados por departamento
SELECT COUNT(DISTINCT conceito.CodigoAluno) as TotalAprovados, departamento.Nome 
FROM aluno, conceito, disciplina, departamento
WHERE aluno.CodigoAluno = conceito.CodigoAluno
	AND disciplina.CodigoDepartamento = departamento.CodigoDepartamento
	AND conceito.CodigoDisciplina = disciplina.CodigoDisciplina
	AND conceito.Conceito LIKE 'Reprovado'
GROUP BY departamento.Nome 

--Listar os alunos com códigos ímpares que tenham no conceito cursando em ordem decrescente
SELECT DISTINCT aluno.Nome
FROM aluno, conceito 
WHERE aluno.CodigoAluno = conceito.CodigoAluno
AND	UPPER(conceito.Conceito) LIKE 'CURSANDO'
AND conceito.CodigoAluno % 2 <> 0
ORDER BY aluno.Nome DESC

--Listar total de alunos de aprovados por curso
SELECT COUNT(conceito.Conceito) as TotalAprovados, curso.Nome
FROM aluno, curso, conceito
WHERE aluno.CodigoCurso = curso.CodigoCurso
	AND aluno.CodigoAluno = conceito.CodigoAluno
	AND conceito.Conceito LIKE 'Aprovado'
GROUP BY curso.Nome

--listar nome dos alunos do curso de estatística que reprovaram na disciplina 'Cálculo Diferencial e Integral'
SELECT DISTINCT aluno.Nome
FROM aluno, conceito, curso, curriculo, disciplina
WHERE aluno.CodigoAluno = conceito.CodigoAluno
	AND curso.CodigoCurso = aluno.CodigoCurso
	AND curriculo.CodigoCurso = curso.CodigoCurso
	AND disciplina.CodigoDisciplina = curriculo.CodigoDisciplina
	AND curso.Nome LIKE 'Estatística'
	AND disciplina.Nome LIKE 'Cálculo Diferencial e Integral'
	AND conceito.Conceito LIKE 'Reprovado'

----Listar nome dos alunos do curso de Análise de Sistemas com total de crétidos menor ou igual a 40
SELECT DISTINCT aluno.Nome, SUM(disciplina.Creditos) as CreditosAcum
FROM aluno, curso, conceito, curriculo, disciplina
WHERE aluno.CodigoCurso = curso.CodigoCurso
	AND conceito.CodigoAluno = aluno.CodigoAluno
	AND curriculo.CodigoCurso = curso.CodigoCurso
	AND disciplina.CodigoDisciplina = curriculo.CodigoDisciplina
	AND conceito.Conceito LIKE 'Aprovado'
	AND curso.Nome LIKE 'Análise de Sistemas'
GROUP BY aluno.Nome
HAVING SUM(disciplina.Creditos) <= 40

----Listar as 2 disciplinas com maior número de aprovados
SELECT TOP(2) disciplina.Nome as Disciplina, COUNT(conceito.Conceito) as TotalAprovacoes
FROM disciplina, conceito
WHERE disciplina.CodigoDisciplina = conceito.CodigoDisciplina
	AND conceito.Conceito LIKE 'Aprovado'
GROUP BY disciplina.Nome
ORDER BY COUNT(conceito.Conceito) DESC

----Listar as 2 disciplinas com maior número de reprovação durante o ano de 2017
SELECT TOP(2) disciplina.Nome as Disciplina, COUNT(conceito.Conceito) as TotalReprovacoes
FROM disciplina, conceito
WHERE disciplina.CodigoDisciplina = conceito.CodigoDisciplina
	AND conceito.Conceito LIKE 'Reprovado'
	AND YEAR(conceito."Ano-Semestre") = 2017
GROUP BY disciplina.Nome
ORDER BY COUNT(conceito.Conceito) DESC

--Listar total de alunos matriculados por curso
SELECT COUNT(*) as TotalMatriculados, curso.Nome as NomeCurso
FROM aluno, curso
WHERE aluno.CodigoCurso = curso.CodigoCurso
GROUP BY curso.Nome

----Listar nome dos alunos do departamento Setor de Ciências Exatas do curso de Bioengenharia 
--que tenham acumulado o total de créditos superior a 10 durante o primeiro semestre de 2018 e a data de hoje
SELECT aluno.Nome as NomeAluno, SUM(disciplina.Creditos) as TotalCreditos
FROM aluno, departamento, curso, conceito, disciplina
WHERE disciplina.CodigoDisciplina = conceito.CodigoDisciplina
	AND aluno.CodigoCurso = curso.CodigoCurso
	AND conceito.CodigoAluno = aluno.CodigoAluno
	AND disciplina.CodigoDepartamento = departamento.CodigoDepartamento
	AND conceito.Conceito LIKE 'Aprovado'
	AND departamento.Nome LIKE 'Setor de Ciências Exatas'
	AND curso.Nome LIKE 'Bioengenharia'
	AND conceito."Ano-Semestre" BETWEEN ('01/01/2018') AND GETDATE() 
GROUP BY aluno.Nome
HAVING SUM(disciplina.Creditos) > 10


--Listar o nome dos alunos que tenham no conceito reprovado para as disciplinas opcionais do curso Análise de Sistemas
SELECT aluno.Nome
FROM aluno, conceito, curriculo, curso
WHERE 
	aluno.CodigoAluno = conceito.CodigoAluno
	AND curriculo.CodigoCurso = curso.CodigoCurso
	AND aluno.CodigoCurso = curso.CodigoCurso
	AND conceito.Conceito LIKE 'Reprovado'
	AND curso.Nome LIKE 'Análise de Sistemas'
	AND curriculo."Obrigatoria-Opcional" LIKE 'Opcional'
GROUP BY aluno.Nome


/* 
Listar o nome dos alunos que tenham no conceito reprovado agrupados por departamento.
*/
SELECT 


----Listar alunos do departamento Setor de Ciências Exatas do curso Controle e Processos Industriais 
--que tenham acumulado o total de créditos superior a 25 durante o primeiro semestre de 2018 e a data de hoje
SELECT

----Listar alunos com total de créditos superiores a média global adquirida pelos alunos do mesmo curso
SELECT

--Listar Ano-Semestre com maior número de aprovados por curso
SELECT


