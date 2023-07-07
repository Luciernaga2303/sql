-- luciernaga
CREATE SCHEMA [luciernaga] 
AUTHORIZATION [dbo]
GO

-- 
CREATE TABLE [luciernaga].[User] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY (1,1),
    [Name] VARCHAR(50) NOT NULL,
    [Password] VARCHAR(50) NOT NULL,
    [RoleId] INT NOT NULL,
    [IsActive] BIT NOT NULL
)

CREATE TABLE [luciernaga].[Project] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY (1,1),
    [Name] VARCHAR(100) NOT NULL,
    [UserId] INT NOT NULL,
    [StatusId] INT NOT NULL,
    CONSTRAINT [FK_Project_StatusId] FOREIGN KEY ([StatusId]) REFERENCES [luciernaga].[CatStatus](Id),
    CONSTRAINT [FK_Project_UserId] FOREIGN KEY ([UserId]) REFERENCES [luciernaga].[User](Id)
)

CREATE TABLE [luciernaga].[CatStatus] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY (1,1),
    [Name] VARCHAR (50) NOT NULL,
    [IsActive] BIT NOT NULL
)

CREATE TABLE [luciernaga].[UserNote] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY (1,1),
    [UserId] INT NOT NULL,
    [Note] VARCHAR(150) NOT NULL,
    CONSTRAINT [FK_UserNote_UserId] FOREIGN KEY ([UserId]) REFERENCES [luciernaga].[User](Id)
)

CREATE TABLE [luciernaga].[CatRol] (
    [Id] INT NOT NULL PRIMARY KEY IDENTITY (1,1),
    [Name] VARCHAR(50) NOT NULL,
    [IsActive] BIT NOT NULL
)

-- 
INSERT INTO [luciernaga].[User]([Name], [Password], [RoleId], [IsActive])
VALUES ('Luz', 'Abc1234#', 1, 1)

INSERT INTO [luciernaga].[Project]([Name], [UserId], [StatusId])
VALUES ('Project1', 1, 1)

INSERT INTO [luciernaga].[CatStatus]([Name], [IsActive])
VALUES ('Active', 1)

INSERT INTO [luciernaga].[UserNote]([UserId], [Note])
VALUES (1, '.')

INSERT INTO [luciernaga].[CatRol]([Name],[IsActive])
VALUES ('BackEnd', 1)

-- con join
SELECT U.Name, U.RoleId, CR.Name AS RolName
FROM [luciernaga].[User] AS U
JOIN [luciernaga].[CatRol] CR ON U.RoleId = CR.Id
WHERE U.Id = 1

-- Update UserNote for a specific user
UPDATE [luciernaga].[UserNote]
SET [Note] = 'Me gusta mucho el bootcamp, sin embargo sentí que esta parte de sql fue muy rapida y tuve que ver la grabacion para entender un poco mas pero explican muy bien y atienden cualquier duda'
WHERE [UserId] = 1

-- Crear GetUsersByRolIdAndIsActive
CREATE PROCEDURE [luciernaga].[GetUsersByRolIdAndIsActive] 
    @RoleId INT, 
    @IsActive BIT
AS
BEGIN
    SELECT P.Name AS ProjectName, CE.Name AS StatusName, U.Name AS UserName, CR.Name AS RolName
    FROM [luciernaga].[Project] P
    JOIN [luciernaga].[CatStatus] CE ON P.StatusId = CE.Id
    JOIN [luciernaga].[User] U ON P.UserId = U.Id
    JOIN [luciernaga].[CatRol] CR ON U.RoleId = CR.Id
    WHERE CR.Id = @RoleId AND U.IsActive = @IsActive
END
GO

-- Execute the stored procedure
EXEC [luciernaga].[GetUsersByRolIdAndIsActive] @RoleId = 1, @IsActive = 1