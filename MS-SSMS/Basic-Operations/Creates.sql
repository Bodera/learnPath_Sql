/*------------------------------------------------------------------------------------------------------------------------
--CREATE TABLES
-------------------------------------------------------------------------------------------------------------------------*/
--Entidade Curso
CREATE TABLE curso (
	CodigoCurso INT PRIMARY KEY
	,Nome VARCHAR(48) NOT NULL
)
--Entidade Aluno
CREATE TABLE aluno (
	CodigoAluno INT PRIMARY KEY
	,Nome VARCHAR(48) NOT NULL
	,CodigoCurso INT REFERENCES curso
)
--Entidade Departamento
CREATE TABLE departamento (
	CodigoDepartamento INT PRIMARY KEY
	,Nome VARCHAR(48) NOT NULL
)
--Entidade Disciplina
CREATE TABLE disciplina (
	CodigoDisciplina INT PRIMARY KEY
	,Nome VARCHAR(48) NOT NULL
	,Creditos INT NOT NULL
	,CodigoDepartamento INT REFERENCES departamento
)
--Entidade Currículo
CREATE TABLE curriculo (
	CodigoCurso INT REFERENCES curso 
	,CodigoDisciplina INT REFERENCES disciplina
	,"Obrigatoria-Opcional" VARCHAR(15) NOT NULL
	,PRIMARY KEY(CodigoCurso, CodigoDisciplina)
)
--Entidade Conceito
CREATE TABLE conceito (
	CodigoAluno INT REFERENCES aluno
	,CodigoDisciplina INT REFERENCES disciplina
	,"Ano-Semestre" DATETIME
	,Conceito VARCHAR(32)
	,PRIMARY KEY (CodigoAluno, CodigoDisciplina, "Ano-Semestre")
)