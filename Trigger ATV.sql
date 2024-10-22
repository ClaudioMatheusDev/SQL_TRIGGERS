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

-- Inserção de DADOS

INSERT INTO Alunos (Nome)
VALUES
('João Silva'),
('Maria Oliveira'),
('Pedro Santos');

INSERT INTO Disciplinas (NomeDisciplina)
VALUES
('Programação Orientada a Objetos'),
('Bancos de Dados 2'),
('Engenharia de Software 1');

GO
-- Criando um TRIGGER para incluir um aluno tem sua média de notas geral, abaixo de 7.1, é incluido na tabela de apoio

CREATE TRIGGER trg_AvaliaMedia
	ON Provas
AFTER INSERT, UPDATE

AS
BEGIN
	DECLARE @AlunoID INT;		--DECLARE, AQUI ESTÃO AS VARIÁVEIS UTILIZADAS
	DECLARE @Media DECIMAL (4,2); 

	SELECT @AlunoID = i.AlunoID FROM inserted i;  -- ATRIBUINDO VALORES ÀS VARIÁVEIS DECLARADAS
	SELECT @Media = AVG(Nota) FROM Provas WHERE AlunoID = @AlunoID;  -- OBS. O inserted  é um objeto que relaciona a tabela que recebeu a alteração/inserção e disparou o gatilho (TRIGGER)


	IF @Media < 7
	BEGIN 
	IF NOT EXISTS (SELECT 1 FROM ApoioAlunos WHERE AlunoID = @AlunoID)	-- Verificando no IF se o ALUNO já não está na tabela de apoio
				BEGIN
				INSERT INTO ApoioAlunos (AlunoID, AlunoMediaGeral) VALUES (@AlunoID, @Media); -- Caso a media calculada for menor que 7, e o aluno já não estiver na tabela de apoio, ele é inserido
				END
			END
		ELSE -- (ELSE) Se a média não for menor que 7, então o aluno é removido da tabela de apoio
		BEGIN
			DELETE FROM ApoioAlunos WHERE AlunoID = @AlunoID;
		END
	END;

GO

-- Verificando o TRIGGER INSERINDO DADOS

INSERT INTO Provas (AlunoID, DisciplinaID, Nota)
VALUES
(1, 1, 6.5),
(1, 2, 5.8),
(1, 3, 7.2);

GO

SELECT * FROM ApoioAlunos;

-- Verificando o TRIGGER MODIFICANDO DADOS

UPDATE Provas
SET Nota = 10
WHERE
ProvaID = 2 AND AlunoID=1;

SELECT * FROM ApoioAlunos;

-- =================================== MODIFICANDO O TRIGGER E ADICIONANDO FUNÇÕES ===================================

-- Melhore a Trigger construída para incluir qual a disciplina que o aluno tem a menor nota na tabela ApoioAlunos;

ALTER TRIGGER trg_AvaliaMedia
ON Provas
AFTER INSERT, UPDATE

AS
BEGIN
    DECLARE @AlunoID INT;
    DECLARE @Media DECIMAL(4,2);
    DECLARE @MenorNota DECIMAL(4,2);
    DECLARE @NomeDisciplina NVARCHAR(100); -- Adicionando as variáveis Menor Nota e Nome da Disciplina


    SELECT @AlunoID = i.AlunoID FROM inserted i;


    SELECT @Media = AVG(Nota) FROM Provas WHERE AlunoID = @AlunoID;

    
    SELECT TOP 1 @MenorNota = p.Nota, @NomeDisciplina = d.NomeDisciplina-- Obtendo a menor nota do aluno e a disciplina correspondente
    FROM Provas p
    INNER JOIN Disciplinas d ON p.DisciplinaID = d.DisciplinaID
    WHERE p.AlunoID = @AlunoID
    ORDER BY p.Nota ASC;  -- Ordenando por nota crescente para pegar a menor


    IF @Media < 7.1
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM ApoioAlunos WHERE AlunoID = @AlunoID)
        BEGIN
            INSERT INTO ApoioAlunos (AlunoID, AlunoMediaGeral, NomeDisciplina)
            VALUES (@AlunoID, @Media, @NomeDisciplina);
        END
    END
    ELSE
    BEGIN
        DELETE FROM ApoioAlunos WHERE AlunoID = @AlunoID;
    END
END;

GO

