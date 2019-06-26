--Modificações

----Atualizar tabela disciplina para atribuir +1 créditos à disciplina Administração
UPDATE disciplina
SET Creditos += 1
WHERE LOWER(Nome) LIKE 'administração'
GO
--teste
select * from disciplina WHERE LOWER(Nome) LIKE 'administração'


----Atualizar a tabela curriculo para que a disciplina de Algoritmos e Estruturas de Dados torne-se obrigatória para todos os cursos
UPDATE curriculo
SET "Obrigatoria-Opcional" = 'Obrigatória'
WHERE CodigoDisciplina IN
	(SELECT CodigoDisciplina
	 FROM disciplina
	 WHERE LOWER(Nome) LIKE 'algoritmos e estruturas de dados'
	)
GO
--teste
select "Obrigatoria-Opcional" from curriculo, disciplina 
where curriculo.CodigoDisciplina = disciplina.CodigoDisciplina
	and disciplina.Nome LIKE 'Algoritmos e Estruturas de Dados'


----Atualizar a tabela conceito e aprovar o aluno com Codigo 0046 em todas as disciplinas
UPDATE conceito
SET Conceito = 'Aprovado'
WHERE CodigoAluno IN
	(SELECT CodigoAluno
	 FROM aluno
	 WHERE CodigoAluno = 0046
	)
GO
--teste
select Conceito from conceito where CodigoAluno = 0046


----Remover dados da tabela conceito anteriores ao segundos semestre de 2017 para aluno com Codigo 0006
DELETE FROM conceito
WHERE "Ano-Semestre" < '01/07/2017'
AND CodigoAluno IN
	(SELECT CodigoAluno
	 FROM aluno
	 WHERE CodigoAluno = 0006
	)
GO
--teste
select "Ano-Semestre" from conceito where CodigoAluno = 0006


----Remover dados da tabela conceito dos alunos que tenham nomes iniciados com as letras A ou B
DELETE FROM conceito
WHERE CodigoAluno IN
	(SELECT CodigoAluno
	 FROM aluno
	 WHERE Nome LIKE '[ab]%'
	 )
GO
--teste
select aluno.Nome
from aluno, conceito
where aluno.CodigoAluno = conceito.CodigoAluno
group by aluno.Nome