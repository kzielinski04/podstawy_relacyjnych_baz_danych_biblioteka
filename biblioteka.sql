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