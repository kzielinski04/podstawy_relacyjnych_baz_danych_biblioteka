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

USE [Biblioteka_g2]
GO

-- 1. Najpierw dodajemy statusy, jeśli tabela jest pusta
IF NOT EXISTS (SELECT 1 FROM dbo.[status])
BEGIN
    INSERT INTO dbo.[status] ([id], [nazwa], [typ], [status])
    VALUES 
    (1, 'Dostepna', 'books', '1'),
    (2, 'Wypozyczona', 'books', '1'),
    (3, 'Zaginiona', 'books', '1'),
    (4, 'W trakcie naprawy', 'books', '1'),
    (5, 'Oczekujacy na aktywacje', 'users', '1'),
    (6, 'Konto wygaslo', 'users', '1'),
    (7, 'Zablokowany', 'users', '1'),
    (8, 'W trakcie weryfikacji', 'users', '1'),
    (9, 'Zawieszony', 'users', '1'),
    (10, 'Zwrocona', 'borrowing', '1'),
    (11, 'Przetrzymywana', 'borrowing', '1'),
    (12, 'Zrealizowana', 'reservation', '1'),
    (13, 'Anulowana', 'reservation', '1'),
    (14, 'Oplacone', 'fine', '1'),
    (15, 'Nieoplacone', 'fine', '1')
END
GO

-- 2. Tworzenie brakujących tabel, jeśli nie istnieją
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'country')
BEGIN
    CREATE TABLE [dbo].[country](
        [id] [int] IDENTITY(1,1) NOT NULL,
        [country] [varchar](100) NOT NULL,
        [country_short] [varchar](10) NOT NULL,
        PRIMARY KEY CLUSTERED ([id] ASC)
    ) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'authors')
BEGIN
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
    
    ALTER TABLE [dbo].[authors] WITH CHECK ADD FOREIGN KEY([country_id]) REFERENCES [dbo].[country] ([id])
    ALTER TABLE [dbo].[authors] WITH CHECK ADD FOREIGN KEY([audit_user]) REFERENCES [dbo].[users] ([id])
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'authorsBooks')
BEGIN
    CREATE TABLE [dbo].[authorsBooks](
        [author_id] [int] NOT NULL,
        [book_id] [int] NOT NULL,
        [audit_user] [int] NOT NULL DEFAULT 1,
        PRIMARY KEY CLUSTERED ([author_id] ASC, [book_id] ASC)
    ) ON [PRIMARY]
    
    ALTER TABLE [dbo].[authorsBooks] WITH CHECK ADD FOREIGN KEY([author_id]) REFERENCES [dbo].[authors] ([id])
    ALTER TABLE [dbo].[authorsBooks] WITH CHECK ADD FOREIGN KEY([book_id]) REFERENCES [dbo].[books] ([id])
    ALTER TABLE [dbo].[authorsBooks] WITH CHECK ADD FOREIGN KEY([audit_user]) REFERENCES [dbo].[users] ([id])
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'user')
BEGIN
    CREATE TABLE [dbo].[user](
        [id] [int] IDENTITY(1,1) NOT NULL,
        [username] [varchar](100) NOT NULL,
        [password_hash] [varchar](100) NOT NULL,
        [email] [varchar](250) NOT NULL,
        [role] [varchar](50) NOT NULL,
        [created_at] [datetime] NOT NULL,
        [last_login] [datetime] NULL,
        [status_id] [int] NOT NULL,
        PRIMARY KEY CLUSTERED ([id] ASC)
    ) ON [PRIMARY]
    
    ALTER TABLE [dbo].[user] WITH CHECK ADD FOREIGN KEY([status_id]) REFERENCES [dbo].[status] ([id])
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'readers')
BEGIN
    CREATE TABLE [dbo].[readers](
        [id] [int] IDENTITY(1,1) NOT NULL,
        [user_id] [int] NOT NULL,
        [first_name] [varchar](100) NOT NULL,
        [last_name] [varchar](100) NOT NULL,
        [address] [varchar](200) NOT NULL,
        [phone] [varchar](20) NOT NULL,
        [registration_date] [date] NOT NULL,
        [status_id] [int] NOT NULL,
        PRIMARY KEY CLUSTERED ([id] ASC)
    ) ON [PRIMARY]
    
    ALTER TABLE [dbo].[readers] WITH CHECK ADD FOREIGN KEY([user_id]) REFERENCES [dbo].[user] ([id])
    ALTER TABLE [dbo].[readers] WITH CHECK ADD FOREIGN KEY([status_id]) REFERENCES [dbo].[status] ([id])
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'borrowing')
BEGIN
    CREATE TABLE [dbo].[borrowing](
        [id] [int] IDENTITY(1,1) NOT NULL,
        [book_id] [int] NOT NULL,
        [readers_id] [int] NOT NULL,
        [borrowing_date] [datetime] NOT NULL,
        [return_date] [datetime] NULL,
        [due] [int] NOT NULL,
        [status_id] [int] NOT NULL,
        PRIMARY KEY CLUSTERED ([id] ASC)
    ) ON [PRIMARY]
    
    ALTER TABLE [dbo].[borrowing] WITH CHECK ADD FOREIGN KEY([book_id]) REFERENCES [dbo].[books] ([id])
    ALTER TABLE [dbo].[borrowing] WITH CHECK ADD FOREIGN KEY([readers_id]) REFERENCES [dbo].[readers] ([id])
    ALTER TABLE [dbo].[borrowing] WITH CHECK ADD FOREIGN KEY([status_id]) REFERENCES [dbo].[status] ([id])
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'reservation')
BEGIN
    CREATE TABLE [dbo].[reservation](
        [id] [int] IDENTITY(1,1) NOT NULL,
        [book_id] [int] NOT NULL,
        [readers_id] [int] NOT NULL,
        [reservation_date] [datetime] NOT NULL,
        [status_id] [int] NOT NULL,
        PRIMARY KEY CLUSTERED ([id] ASC)
    ) ON [PRIMARY]
    
    ALTER TABLE [dbo].[reservation] WITH CHECK ADD FOREIGN KEY([book_id]) REFERENCES [dbo].[books] ([id])
    ALTER TABLE [dbo].[reservation] WITH CHECK ADD FOREIGN KEY([readers_id]) REFERENCES [dbo].[readers] ([id])
    ALTER TABLE [dbo].[reservation] WITH CHECK ADD FOREIGN KEY([status_id]) REFERENCES [dbo].[status] ([id])
END
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'fine')
BEGIN
    CREATE TABLE [dbo].[fine](
        [id] [int] IDENTITY(1,1) NOT NULL,
        [borrowing_id] [int] NOT NULL,
        [amount] [decimal](10, 2) NOT NULL,
        [date_issue] [datetime] NOT NULL,
        [date_pay] [datetime] NULL,
        [status_id] [int] NOT NULL,
        PRIMARY KEY CLUSTERED ([id] ASC)
    ) ON [PRIMARY]
    
    ALTER TABLE [dbo].[fine] WITH CHECK ADD FOREIGN KEY([borrowing_id]) REFERENCES [dbo].[borrowing] ([id])
    ALTER TABLE [dbo].[fine] WITH CHECK ADD FOREIGN KEY([status_id]) REFERENCES [dbo].[status] ([id])
END
GO

-- 3. Wstawianie danych

-- Kraje
INSERT INTO dbo.country(country, country_short)
VALUES 
('Stany Zjednoczone', 'US'),
('Rosja', 'RU'),
('Japonia', 'JP'),
('Polska', 'PL'),
('Niemcy', 'DE'),
('Wielka Brytania', 'UK'),
('Francja', 'FR'),
('Palau', 'PW'),
('Togo', 'TG'),
('Włochy', 'IT')
GO

-- Książki (dostosowane do oryginalnej struktury tabeli books)
INSERT INTO dbo.books(title, category, publisher, publicationYear, isbn, statusID, audit_user)
VALUES 
('Pieśń o Achillesie', 'powieść historyczna', 'Albatros', 2022, '9788367338615', 1, 1),
('Metro 2033', 'powieść przygodowa', 'Insignis', 2022, '9788367323475', 1, 1),
('Zatracenie', 'powieść psychologiczna', 'Czytelnik', 2025, '9788307036533', 1, 1),
('Cyberpunk 2077. Bez przypadku', 'science fiction', 'Powergraph', 2023, '9788366178984', 1, 1),
('Na Zachodzie bez zmian', 'powieść wojenna', 'Rebis', 2025, '9788383383392', 1, 1),
('Duma i uprzedzenie', 'powieść obyczajowa', 'Świat Książki', 2024, '9788382891362', 1, 1),
('Zgroza w Dunwich i inne przerażające opowieści', 'horror', 'Vesper', 2012, '9788377310984', 1, 1),
('Miecz Kaigenu', 'fantasy', 'Vesper', 2024, '9788377314968', 1, 1),
('Mężczyzna, który rozmawiał z hienami', 'kryminał', 'Czarna Owca', 2025, '9788383825007', 1, 1),
('Idealne morderstwo', 'kryminał', 'Filia', 2022, '9788382801101', 1, 1)
GO

-- Autorzy
INSERT INTO dbo.authors(first_name, last_name, birth_date, country_id, biography, audit_user)
VALUES 
('Madeline', 'Miller', '1978-07-24', 1, 'Amerykańska pisarka, autorka książek fantasy osadzonych w świecie mitologii greckiej.', 1),
('Dmitry', 'Glukhovsky', '1979-06-12', 2, 'Rosyjski pisarz, dziennikarz, korespondent wojenny, felietonista, radiowiec, prezenter telewizyjny.', 1),
('Osamu', 'Dazai', '1909-06-19', 3, 'Prozaik japoński. Był autorem pesymistycznych utworów, w których poruszał problemy zubożałej arystokracji i inteligencji japońskiej.', 1),
('Rafał', 'Kosik', '1971-10-08', 4, 'Polski pisarz science fiction, założyciel wydawnictwa Powergraph.', 1),
('Erich Maria', 'Remarque', '1898-06-22', 5, 'Niemiecki pisarz, dramaturg, dziennikarz, weteran I wojny światowej.', 1),
('Jane', 'Austen', '1775-12-16', 6, 'Autorka powieści opisujących życie angielskiej klasy wyższej z początku XIX wieku.', 1),
('Howard Phillips', 'Lovecraft', '1890-08-20', 1, 'Amerykański pisarz, autor opowieści grozy (weird fiction) i fantasy, twórca mitologii Cthulhu.', 1),
('Maya Lin', 'Wang', '1992-03-21', 1, 'Autorka fantasy.', 1),
('Przemysław', 'Piotrowski', '1982-06-05', 4, 'Polski dziennikarz związany z tematyką sportową i śledczą, pisarz.', 1),
('Charlie', 'Donlea', '1982-01-13', 1, 'Autor kryminałów.', 1)
GO

-- Autorzy-Książki
INSERT INTO dbo.authorsBooks(author_id, book_id, audit_user)
VALUES 
(1, 1, 1),
(2, 2, 1),
(3, 3, 1),
(4, 4, 1),
(5, 5, 1),
(6, 6, 1),
(7, 7, 1),
(8, 8, 1),
(9, 9, 1),
(10, 10, 1)
GO

-- Użytkownicy
INSERT INTO [dbo].[user](username, password_hash, email, [role], created_at, last_login, status_id)
VALUES 
('karol_szczepanski', '0b14d501a594442a01c6859501bcb3e8164d183d32937b851835442f69d5c94e', 'karol.szczepanski@biblioteka.com', 'admin', '2024-02-01', '2025-04-14', 2),
('wieslaw_wisniewski', '6cf615d5bcaac778252a8f1f3360d23f02f34ec182e259897fd6ce485d7870d4', 'wieslaw.wisniewski@biblioteka.com', 'admin', '2024-02-02', '2025-04-13', 2),
('joanna_szulc', '5906ac361a137e2d286465cd6588sbb5ac3f5ae955001100bc41577c3d751764', 'joanna.szulc@biblioteka.com', 'librarian', '2024-02-03', '2025-04-12', 2),
('pawel_zielinski', 'b97873a40f73abedd8d684a7cd5e5f85e4a9cfb83eac26886640a0813850122b', 'pawel.zielinski@biblioteka.com', 'librarian', '2024-02-04', '2025-04-11', 2),
('aleksandra_kowalska', '8b2c86ea9cf2ea4eb517fd1e06b74f399e7fec0fef92e3b482a6cf2e2b092023', 'aleksandra_kowalska@biblioteka.com', 'librarian', '2024-02-05', '2025-04-10', 2),
('daria_kaczmarek', '598a1a400c1dfdf3697ae69d7e1bc98593f2e15015eed8e9b7e47a83b31693d5', 'daria_kaczmarek@biblioteka.com', 'librarian', '2024-02-06', '2025-04-09', 2),
('krzysztof_wojciechowski', '5860836e8g13fc9837539a597d4086bfc0299e54ad92148d54538b5c3feefb7c', 'krzysztof_wojciechowski@biblioteka.com', 'user', '2024-02-07', '2025-04-08', 2),
('szymon_szymanski', '57f3ebab63f156fd8f776ba645a55d96360b15eeffc8b0e4afe4c05fa88229aa', 'szymon_szymanski@biblioteka.com', 'user', '2024-02-08', '2025-04-07', 2),
('arkadiusz_gorecki', '9323dd6786ebcbf3ac87357cc78ba1abfda6cf5e55cd01097b90d4a286cac90s', 'arkadiusz_gorecki@biblioteka.com', 'user', '2024-02-09', '2025-04-06', 2),
('konrad_wozniak', 'cc4a9ea03fcac15b5fc63c949ac34e7b0fd17906716ac3b8e58c599cdc5a52f0', 'konrad_wozniak@biblioteka.com', 'user', '2024-02-10', '2025-04-05', 2)
GO

-- Czytelnicy
INSERT INTO dbo.readers([user_id], first_name, last_name, [address], phone, registration_date, status_id)
VALUES 
(7, 'Marcin', 'Skowroński', 'ul. Rubinowa 8, 07-230 Warszawa', '888123444', '2023-12-04', 2),
(8, 'Czesław', 'Biernat', 'ul. Długa 12a, 03-420 Białystok', '013222999', '2021-10-22', 2),
(9, 'Radosław', 'Bielak', 'ul. Liściasta 22, 09-420 Sochaczew', '429381033', '2024-04-01', 2),
(10, 'Sandra', 'Adamska', 'ul. Gościnna 3, 53-123 Koło', '812822944', '2017-01-01', 2),
(1, 'Mirosław', 'Sękiewicz', 'ul. Szmaragdowa 10, 22-222 Świebodzin', '723411081', '2022-04-11', 2),
(2, 'Karol', 'Stępień', 'ul. Warszawska 17b, 08-230 Kraków', '921033884', '2021-06-23', 2),
(3, 'Wiktoria', 'Kowalewska', 'ul. Krótka 3c, 93-222 Gdańsk', '812123033', '2022-04-04', 2),
(4, 'Dominika', 'Majewska', 'ul. Gdańska 14, 09-222 Lublin', '871222034', '2019-02-23', 2),
(5, 'Wiktor', 'Morawski', 'ul. Kolorowa 22, 12-345 Gorzów Wielkopolski', '543123075', '2020-03-15', 2),
(6, 'Maja', 'Rybicka', 'ul. Spacerowa 17b, 94-233 Sopot', '876019283', '2024-01-22', 2)
GO

-- Wypożyczenia
INSERT INTO dbo.borrowing(book_id, readers_id, borrowing_date, return_date, due, status_id)
VALUES 
(1, 1, '2025-04-01', NULL, 7, 10),
(2, 2, '2025-04-02', NULL, 7, 10),
(3, 3, '2025-04-03', NULL, 7, 10),
(4, 4, '2025-04-04', NULL, 7, 10),
(5, 5, '2025-04-05', NULL, 7, 10),
(6, 6, '2025-04-06', NULL, 7, 10),
(7, 7, '2025-04-07', NULL, 7, 10),
(8, 8, '2025-04-08', NULL, 7, 10),
(9, 9, '2025-04-09', NULL, 7, 10),
(10, 10, '2025-04-10', NULL, 7, 10)
GO

-- Rezerwacje
INSERT INTO dbo.reservation(book_id, readers_id, reservation_date, status_id)
VALUES 
(1, 10, '2025-04-08', 12),
(2, 9, '2025-04-09', 13),
(3, 8, '2025-04-10', 12),
(4, 7, '2025-04-11', 13),
(5, 6, '2025-04-12', 12),
(6, 5, '2025-04-13', 13),
(7, 4, '2025-04-14', 12),
(8, 3, '2025-04-15', 12),
(9, 2, '2025-04-16', 13),
(10, 1, '2025-04-17', 12)
GO

-- Kary
INSERT INTO dbo.fine(borrowing_id, amount, date_issue, date_pay, status_id)
VALUES 
(1, 1000.00, '2025-04-09', NULL, 15),
(2, 2000.00, '2025-04-10', NULL, 15),
(3, 1500.00, '2025-04-11', NULL, 15),
(4, 1000.00, '2025-04-12', NULL, 15),
(5, 1200.00, '2025-04-13', NULL, 15),
(6, 3000.00, '2025-04-14', '2025-04-15', 14),
(7, 1000.00, '2025-04-15', '2025-04-16', 14),
(8, 2500.00, '2025-04-16', '2025-04-17', 14),
(9, 3000.00, '2025-04-17', '2025-04-18', 14),
(10, 2200.00, '2025-04-18', '2025-04-19', 14)
GO
