--CRIANDO O BANCO DE DADOS

CREATE DATABASE Test_Trigger;
GO

USE Test_Trigger;

GO

-- Criando a tabelas do banco de dados

CREATE TABLE Alunos (
AlunoID INT PRIMARY KEY IDENTITY(1,1),
Nome NVARCHAR(100)
);

GO

CREATE TABLE Disciplinas (
DisciplinaID INT PRIMARY KEY IDENTITY(1,1),
NomeDisciplina NVARCHAR(100)
);

GO

CREATE TABLE Provas (
ProvaID INT PRIMARY KEY IDENTITY(1,1),
AlunoID INT,
DisciplinaID INT,
Nota DECIMAL(4,2),
FOREIGN KEY (AlunoID) REFERENCES Alunos(AlunoID),
FOREIGN KEY (DisciplinaID) REFERENCES
Disciplinas(DisciplinaID)
);

GO

CREATE TABLE ApoioAlunos (
AlunoID INT PRIMARY KEY,
AlunoMediaGeral DECIMAL(4,2),
FOREIGN KEY (AlunoID) REFERENCES Alunos(AlunoID)
);

GO

-- Inser��o de DADOS

INSERT INTO Alunos (Nome)
VALUES
('Jo�o Silva'),
('Maria Oliveira'),
('Pedro Santos');

INSERT INTO Disciplinas (NomeDisciplina)
VALUES
('Programa��o Orientada a Objetos'),
('Bancos de Dados 2'),
('Engenharia de Software 1');

GO
-- Criando um TRIGGER para incluir um aluno tem sua m�dia de notas geral, abaixo de 7.1, � incluido na tabela de apoio

CREATE TRIGGER trg_AvaliaMedia
	ON Provas
AFTER INSERT, UPDATE

AS
BEGIN
	DECLARE @AlunoID INT;		--DECLARE, AQUI EST�O AS VARI�VEIS UTILIZADAS
	DECLARE @Media DECIMAL (4,2); 

	SELECT @AlunoID = i.AlunoID FROM inserted i;  -- ATRIBUINDO VAL,ORES �S VARI�VEIS DECLARADAS
	SELECT @Media = AVG(Nota) FROM Provas WHERE AlunoID = @AlunoID;  -- OBS. O inserted  � um objeto que relaciona a tabela que recebeu a altera��o/inser��o e disparou o gatilho (TRIGGER)


	IF @Media < 7
	BEGIN 
	IF NOT EXISTS (SELECT 1 FROM ApoioAlunos WHERE AlunoID = @AlunoID)	-- Verificando no IF se o ALUNO j� n�o est� na tabela de apoio
				BEGIN
				INSERT INTO ApoioAlunos (AlunoID, AlunoMediaGeral) VALUES (@AlunoID, @Media); -- Caso a media calculada for menor que 7, e o aluno j� n�o estiver na tabela de apoio, ele � inserido
				END
			END
		ELSE -- (ELSE) Se a m�dia n�o for menor que 7, ent�o o aluno � removido da tabela de apoio
		BEGIN
			DELETE FROM ApoioAlunos WHERE AlunoID = @AlunoID;
		END
	END;

GO

