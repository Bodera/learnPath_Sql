# Banco de Dados
Objetivo: Autonomia no desenvolvimento de aplicações para manipulação de estruturas de dados utilizando linguagem SQL.  
Tutora: Graça  
Dificuldades: Não fazer os exercícios.  
0.[#######---].1  
Pontos fortes: Experiência e persistência.  

## Roteiro de viajem
1. História e teorias fundamentais em sistemas de banco de dados.
2. Modelo E.R. (abordagem em nível operacional, CONJECTURA transações)
3. Comandos DDL e DML

Leitura recomendada: Sistemas de Banco de Dados, Pasta *aulas*.

## Põe quanto é no mínimo que fazes
media = (nota1-nota2) * 0.3 + avg(nota1-nota2) + (pi * 0.2) + 0.1 

PI: diagrama er, um banco funcionando.
## Noções básica de Docker
###### Adicione o usuário ao grupo docker para evitar o modo root.
To list all your containers
```bash
$ sudo docker ps -a 
```

To remove a container you should stop it first
```bash
$ sudo docker stop <YouContainerID> 
$ sudo docker rm <YouContainerID>
```

To list all your images
```bash
$ sudo docker image ls --all
```

Well done.
## Preparando o ambiente
Segue código para instalação da imagem da instância do Microsoft SQL Server 2017 Developer Edition 64-bits.

```bash
$ sudo docker pull mcr.microsoft.com/mssql/server:2017-latest
```
Read the terms, set the password, name the database instance, refer to ?
```bash
$ sudo docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=<YourPassword>' -p 1433:1433 --name sql1 -d mcr.microsoft.com/mssql/server:2017-latest
> <YouGetTheBigHash>
```

To enter in the Docker bash, inside our sqlserver image
```bash
$ sudo docker exec -it sql1 "bash" 
```

Now you need to execute the `sqlcmd` to perform queries
```bash
root# /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P'<YourPassword>'
1>
```

You firts query is get to know what SGBD you're dealing with, lets make our first query
```sql
1> SELECT @@VERSION
2> SELECT SERVERPROPERTY('Edition')
3> GO
/*
Microsoft SQL Server 2017 (RTM-CU13) (KB4466404) - 14.0.3048.4 (X64) 
Nov 30 2018 12:57:58 
Copyright (C) 2017 Microsoft Corporation
Developer Edition (64-bit) on Linux (Ubuntu 16.04.5 LTS) 
*/
```
If for any reason you want to lunch, take a shower or sleep, you can easily leave the `sqlcmd` by typing the command
```sql
1> QUIT
```

## CONJECTURANDO comandos T-SQL 
To create a database
```sql
1> CREATE DATABASE TestDB
2> GO
```
Now the customer wanna a query that brings a list of all databases on our server
```sql
1> SELECT Name from sys.Databases
2> GO
```
You're on the way, to create a table you must specifies the environment, I mean the database that you will modeling.
```sql
1> USE TestDB
2> CREATE TABLE Inventory (id INT, name VARCHAR(50), quantity INT)
3> INSERT INTO Inventory VALUES (1, 'banana', 150); INSERT INTO Inventory VALUES (2, 'orange', 154);
4> GO
```
Faça de conferir um hábito
```sql
1> SELECT * FROM Inventory WHERE quantity > 152;
2> GO
```
Olha como é fácil montar um arquivo de backup do seu banco de dados
```sql
1> BACKUP DATABASE [YourDB] TO DISK =
2> N'/var/opt/mssql/backup/YourDB.bak'
3> WITH NOFORMAT, NOINIT, NAME = N'YourDB-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, STATS = 10
4> GO
```
I hope that you notice that our queries are quite similar to scripts, in certain way they really are. Every Values inserted should end with a semicolon after parenthesis.

In order to enable the SQL Server Agent run inside Docker bash
```bash
root# /opt/mssql/bin/mssql-conf set sqlagent.enabled true
root# systemctl restart mssql-server
```

### Teorias de sistemas de banco de dados
Todo processo é constituído por:
Entrada => Processamento => Saída

E no intermediário nós temos um conceito fundamental: -Armazenamento.

Boas práticas
Evite incosistências: duplicidade, dados em uma única tabela, restrições..
Manutenabilidade: integração de sistemas, relacionamentos, ..
Concorrência: prioridades, controle de nível de acesso, ..
Redundância: backup, escalabilidade
Índices: módulo de otimização de consultas,

Quem faz tudo isso é o SGBD: o software que facilita a manutenção e gerenciamento de sistemas de banco de dados para CONJECTURAR programas aplicativos. Esse SGBD pode ser acessado por uma interface própria ou por um outro software.

Sempre trabalhos com tabelas! É como nosso cérebro aprendeu a organizar os dados. 

* Banco de dados = É uma coleção de dados interrelacionados, representando informações sobre um domínio específico. Ou seja, o dado sempre tem relação com outro.

* Fluxo da informação = Usuário emite um request, tanto faz a ação. SGBD deve receber a solicitação para poder analisar a autorização do comando. 

* Tarefa de um SGBD = Middleware entre o sistema de arquivos do SO. 

Quem gerencia é a pessoa que irá administrar o banco de dados na verdade. Ela é quem irá controlar o esquema de dados.

O projetista monta a estratégia e adequa as abstrções do sistema de banco de dados. São três níveis, visão do usuário, conjunto de usuários, armazenamento.

Na modelagem conceitual não interessa tipo de dado, máscara, etc. Apenas as entidades e seus atributos.
Modelos de dados da modelagem conceitual:
1. Rede
2. Hierárquico
3. Relacional
4. Orientado a objetos
5. Not Only SQL (papo de grafos)

Você precisa entender que os dados podem ser de três tipos fundamentalmente falando: estruturados, semi-estruturados ou não-estruturados.

##### SQL, DDL, DML
Linguagem de consulta : exemplo
Linguagem de definição : exemplo
```sql
-- Alterar esquema ou modelo de uma tabela
ALTER TABLE doc_exc ADD 
```
Linguagem de manipulação : exemplo
```sql
INSERT
SELECT
DELETE
UPDATE 
-- set
```

O dicionário de dados não contém dado algum, apenas metadados, a estrutura do dado.

##### Visão, fato e dimensão
Uma visão é a execução de uma consulta em uma tabela virtual. Um mecanismo de encapsulamento dos dados.
```sql
1> CREATE VIEW v1 as 
2> SELECT Nome FROM  alunos
3> GO
```

## Bônus para quem rala
Veja como fazer as coisas que aprendeu até aqui em uma linha de código :goat:
Once you're in Docker bash, related to you SQL Server image, type the given commands for:
* Create a database
```bash
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -Q 'CREATE DATABASE SampleDB'
```
* List all databases on our server
```bash
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -Q 'SELECT Name FROM sys.Databases'
```

Agora vamos criar alguns jobs. A ideia é codificar uma coleção de transactions separados conforme objetivos exclusivos das rotinas de comando.
* __sp_add_job__ = Create a job named Daily SampleDB Backup
```sql
-- Adds a new job executed by the SQLServerAgent service
-- which we've named 'Daily SampleDB Backup'
1> USE myDB;
2> EXEC dbo.sp_add_job
3> @job_name = N'Daily SampleDB Backup';
4> GO
```
* __sp_add_jobstep__ = Create a job step that creates a backup of the SampleDB database
```sql
-- Adds a step (aka operation) to the job 'Daily SampleDB Backup'
1> USE myDB;
2> EXEC sp_add_jobstep
3> @job_name = N'Daily SampleDB Backup', @step_name = N'Backup database', @subsytem = N'TSQL', @command = N'BACKUP DATABASE SampleDB TO DISK = \
	N''d''''
2
```

```
Recomendação da noite
--nightmare js
```

Eles usam um alias de homem para humano
mas minha teoria é que eles não são pessoas
aprender que falar denada é pesado
adotar usar dizer não há de quê 
e é poucas
epócas em que controlo o vício

Tô pirateando livro
Caluniando o ministro

A motivação que eu vejo de piá aprender
é se mostrar melhor que o próximo