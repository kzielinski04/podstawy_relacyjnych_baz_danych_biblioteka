--CREATE DATABASE Biblioteka_g2;

USE Biblioteka_g2
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Tabela: users
CREATE TABLE [dbo].[users](
    [id] [int] IDENTITY(1,1) NOT NULL,
    [name] [varchar](100) NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
) ON [PRIMARY]
GO

-- Tabela: status
CREATE TABLE [dbo].[status](
    [id] [int] NOT NULL,
    [nazwa] [varchar](20) NOT NULL,
    [typ] [varchar](20) NOT NULL,
    [status] [varchar](20) NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
) ON [PRIMARY]
GO

-- Tabela: author
CREATE TABLE [dbo].[author](
    [id] [int] IDENTITY(1,1) NOT NULL,
    [firstName] [varchar](100) NOT NULL,
    [lastName] [varchar](100) NOT NULL,
    [datebirthday] [date] NULL,
    [description] [varchar](500) NULL,
    [audit_user] [int] NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[author] WITH CHECK ADD FOREIGN KEY([audit_user]) REFERENCES [dbo].[users] ([id])
GO

-- Tabela: books
CREATE TABLE [dbo].[books](
    [id] [int] IDENTITY(1,1) NOT NULL,
    [title] [nvarchar](200) NOT NULL,
    [category] [varchar](50) NULL,
    [publisher] [varchar](100) NULL,
    [publicationYear] [int] NOT NULL,
    [isbn] [varchar](20) NULL,
    [statusID] [int] NOT NULL,
    [audit_user] [int] NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[books] WITH CHECK ADD FOREIGN KEY([audit_user]) REFERENCES [dbo].[users] ([id])
GO

ALTER TABLE [dbo].[books] WITH CHECK ADD CONSTRAINT [FK_books_statusID] FOREIGN KEY([statusID]) REFERENCES [dbo].[status] ([id])
GO

-- Tabela: clients
CREATE TABLE [dbo].[clients](
    [id] [int] IDENTITY(1,1) NOT NULL,
    [firstName] [varchar](100) NOT NULL,
    [lastName] [varchar](100) NOT NULL,
    [dateAdd] [datetime] NOT NULL,
    [datebirthday] [date] NULL,
    [email] [varchar](250) NOT NULL,
    [PESEL] [varchar](11) NOT NULL,
    [documentID] [varchar](100) NULL,
    [audit_user] [int] NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
) ON [PRIMARY]
GO

CREATE UNIQUE NONCLUSTERED INDEX IX_clients_email ON [dbo].[clients]([email] ASC)
GO

ALTER TABLE [dbo].[clients] WITH CHECK ADD FOREIGN KEY([audit_user]) REFERENCES [dbo].[users] ([id])
GO

-- Tabela: authorBooks
CREATE TABLE [dbo].[authorBooks](
    [authorID] [int] NOT NULL,
    [bookID] [int] NOT NULL,
    [audit_user] [int] NOT NULL,
    PRIMARY KEY CLUSTERED ([authorID] ASC, [bookID] ASC)
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[authorBooks] WITH CHECK ADD FOREIGN KEY([authorID]) REFERENCES [dbo].[author] ([id])
GO

ALTER TABLE [dbo].[authorBooks] WITH CHECK ADD FOREIGN KEY([bookID]) REFERENCES [dbo].[books] ([id])
GO

ALTER TABLE [dbo].[authorBooks] WITH CHECK ADD FOREIGN KEY([audit_user]) REFERENCES [dbo].[users] ([id])
GO

-- Tabela: borrowings
CREATE TABLE [dbo].[borrowings](
    [id] [int] IDENTITY(1,1) NOT NULL,
    [book_id] [int] NOT NULL,
    [client_id] [int] NOT NULL,
    [borrowdate] [datetime] NOT NULL,
    [returndate] [datetime] NOT NULL,
    [duedate] [date] NOT NULL,
    [status_id] [int] NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[borrowings] WITH CHECK ADD FOREIGN KEY([book_id]) REFERENCES [dbo].[books] ([id])
GO

ALTER TABLE [dbo].[borrowings] WITH CHECK ADD FOREIGN KEY([client_id]) REFERENCES [dbo].[clients] ([id])
GO

ALTER TABLE [dbo].[borrowings] WITH CHECK ADD CONSTRAINT [FK_borrowings_status_id] FOREIGN KEY([status_id]) REFERENCES [dbo].[status] ([id])
GO

ALTER TABLE [dbo].[borrowings] WITH CHECK ADD CONSTRAINT [CHK_returndate_afterborrowdate] CHECK ([returndate] > [borrowdate])
GO

-- Tabela: fines
CREATE TABLE [dbo].[fines](
    [id] [int] IDENTITY(1,1) NOT NULL,
    [book_id] [int] NOT NULL,
    [client_id] [int] NOT NULL,
    [amount] [decimal](10, 2) NOT NULL,
    [fine_date] [datetime] NOT NULL DEFAULT (getdate()),
    [status_id] [int] NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[fines] WITH CHECK ADD FOREIGN KEY([book_id]) REFERENCES [dbo].[books] ([id])
GO

ALTER TABLE [dbo].[fines] WITH CHECK ADD FOREIGN KEY([client_id]) REFERENCES [dbo].[clients] ([id])
GO

ALTER TABLE [dbo].[fines] WITH CHECK ADD CONSTRAINT [FK_fines_status_id] FOREIGN KEY([status_id]) REFERENCES [dbo].[status] ([id])
GO

-- Tabela: reservations (poprawione nazwy kolumn)
CREATE TABLE [dbo].[reservations](
    [id] [int] IDENTITY(1,1) NOT NULL,
    [book_id] [int] NOT NULL,
    [client_id] [int] NOT NULL,
    [book_name] [varchar](100) NOT NULL,
    [owner_name] [varchar](100) NOT NULL,
    [time_of_borrow] [datetime] NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[reservations] WITH CHECK ADD FOREIGN KEY([book_id]) REFERENCES [dbo].[books] ([id])
GO

ALTER TABLE [dbo].[reservations] WITH CHECK ADD FOREIGN KEY([client_id]) REFERENCES [dbo].[clients] ([id])
GO


USE [Biblioteka_g2]
GO

-- 1. Tworzenie brakujących tabel

-- Tabela country
CREATE TABLE [dbo].[country](
    [id] [int] IDENTITY(1,1) NOT NULL,
    [country] [varchar](100) NOT NULL,
    [country_short] [varchar](10) NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
) ON [PRIMARY]
GO

-- Tabela authors (zamiast originalnej author)
CREATE TABLE [dbo].[authors](
    [id] [int] IDENTITY(1,1) NOT NULL,
    [first_name] [varchar](100) NOT NULL,
    [last_name] [varchar](100) NOT NULL,
    [birth_date] [date] NULL,
    [country_id] [int] NULL,
    [biography] [varchar](1000) NULL,
    [audit_user] [int] NOT NULL DEFAULT 1,
    PRIMARY KEY CLUSTERED ([id] ASC)
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[authors] WITH CHECK ADD FOREIGN KEY([country_id]) REFERENCES [dbo].[country] ([id])
GO

ALTER TABLE [dbo].[authors] WITH CHECK ADD FOREIGN KEY([audit_user]) REFERENCES [dbo].[users] ([id])
GO

-- Tabela authorsBooks (zamiast originalnej authorBooks)
CREATE TABLE [dbo].[authorsBooks](
    [author_id] [int] NOT NULL,
    [book_id] [int] NOT NULL,
    [audit_user] [int] NOT NULL DEFAULT 1,
    PRIMARY KEY CLUSTERED ([author_id] ASC, [book_id] ASC)
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[authorsBooks] WITH CHECK ADD FOREIGN KEY([author_id]) REFERENCES [dbo].[authors] ([id])
GO

ALTER TABLE [dbo].[authorsBooks] WITH CHECK ADD FOREIGN KEY([book_id]) REFERENCES [dbo].[books] ([id])
GO

ALTER TABLE [dbo].[authorsBooks] WITH CHECK ADD FOREIGN KEY([audit_user]) REFERENCES [dbo].[users] ([id])
GO

-- 2. Wstawianie danych

-- Najpierw statusy (jeśli nie ma)
IF NOT EXISTS (SELECT 1 FROM dbo.status)
BEGIN
    INSERT INTO [dbo].[status] ([id], [nazwa], [typ], [status])
    VALUES 
    (1, 'Active', 'Book', 'Available'),
    (2, 'Active', 'Book', 'Borrowed'),
    (3, 'Active', 'Book', 'Reserved'),
    (4, 'Inactive', 'Book', 'Lost'),
    (5, 'Active', 'Fine', 'Unpaid'),
    (6, 'Active', 'Fine', 'Paid'),
    (7, 'Active', 'Borrowing', 'Current'),
    (8, 'Active', 'Borrowing', 'Returned'),
    (9, 'Active', 'Borrowing', 'Overdue')
END
GO

-- Dodanie krajów
INSERT INTO [dbo].[country] ([country], [country_short])
VALUES 
('Polska', 'PL'),
('Podlasie', 'POD'),
('Radziwie', 'RAD'),
('Redania', 'RED'),
('Temeria', 'TEM'),
('Nilfgaard', 'NIL'),
('Stany Zjednoczone', 'USA'),
('Wielka Brytania', 'GB'),
('Francja', 'FR'),
('Niemcy', 'DE')
GO

-- Dodanie autorów
INSERT INTO [dbo].[authors] ([first_name], [last_name], [birth_date], [country_id], [biography], [audit_user])
VALUES
('Jan', 'Kaczkowski', '1977-07-26', 1, 'Polski ksiądz katolicki, doktor nauk teologicznych, bioetyk, założyciel i dyrektor Puckiego Hospicjum pw. św. Ojca Pio.', 1),
('Joanna', 'Podsadecka', '1980-05-15', 1, 'Polska pisarka, współautorka książek z Janem Kaczkowskim.', 1),
('Britt', 'Allcroft', '1943-12-14', 8, 'Brytyjska producentka telewizyjna, najbardziej znana jako twórczyni serialu "Tomek i przyjaciele".', 1),
('Andrzej', 'Sapkowski', '1948-06-21', 1, 'Jeden z najpopularniejszych polskich pisarzy fantasy, twórca serii o Wiedźminie.', 1),
('Piotr', 'Fulmański', NULL, 1, 'Polski naukowiec i autor książek z zakresu informatyki.', 1),
('Anna', 'Nowak', '1975-03-10', 1, 'Autorka książek dla dzieci.', 1),
('Michał', 'Kowalski', '1982-11-22', 1, 'Autor poradników związanych z końmi.', 1),
('Ewa', 'Wiśniewska', '1968-09-05', 1, 'Pisarka, autorka powieści obyczajowych.', 1),
('John', 'Smith', '1970-04-18', 7, 'Amerykański autor książek technicznych.', 1),
('Maria', 'Garcia', '1985-07-30', 9, 'Hiszpańska autorka literatury dziecięcej.', 1)
GO

-- Dodanie książek (dostosowane do oryginalnej struktury tabeli books)
INSERT INTO [dbo].[books] ([title], [category], [publisher], [publicationYear], [isbn], [statusID], [audit_user])
VALUES
('DASZ RADĘ OSTATNIA ROZMOWA', 'Biografia', 'Znak', 2020, '9788326824561', 1, 1),
('Julek i DZIURA w BUDŻECIE', 'Dla dzieci', 'Literatura', 2019, '9788378876324', 1, 1),
('Bajki 5 minut przed snem Tomek i przyjaciele', 'Dla dzieci', 'Egmont', 2018, '9788328108522', 1, 1),
('Masaż konia - poradnik', 'Poradnik', 'Galaktyka', 2021, '9788365976123', 1, 1),
('Wiedźmin', 'Fantasy', 'SuperNowa', 2014, '9788375780635', 1, 1),
('Koń z Vallony', 'Powieść', 'Wydawnictwo Literackie', 2017, '9788374692723', 1, 1),
('Blockchain', 'Informatyka', 'PWN', 2020, '9788328356786', 1, 1),
('Learn Swift by examples', 'Informatyka', 'PWN', 2021, '9788328356793', 1, 1),
('NoSQL. Theory and examples', 'Informatyka', 'PWN', 2022, '9788328356809', 1, 1),
('Engineering of Big Data Processing', 'Informatyka', 'PWN', 2023, '9788328356816', 2, 1)
GO

-- Dodanie powiązań autorów z książkami
INSERT INTO [dbo].[authorsBooks] ([author_id], [book_id], [audit_user])
VALUES
(1, 1, 1), (2, 1, 1), -- DASZ RADĘ OSTATNIA ROZMOWA
(6, 2, 1),            -- Julek i DZIURA w BUDŻECIE
(3, 3, 1),            -- Bajki 5 minut przed snem
(7, 4, 1),            -- Masaż konia - poradnik
(4, 5, 1),            -- Wiedźmin
(8, 6, 1),            -- Koń z Vallony
(5, 7, 1),            -- Blockchain
(5, 8, 1),            -- Learn Swift by examples
(5, 9, 1),            -- NoSQL. Theory and examples
(5, 10, 1)            -- Engineering of Big Data Processing
GO
