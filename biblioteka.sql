-- Tworzenie bazy danych
--CREATE DATABASE [Biblioteka_g2_v2];
--GO
--USE [Biblioteka_g2_v2];

-- Tabela: Kraj
CREATE TABLE country (
	country_id INT IDENTITY (1,1),
	country VARCHAR(20) NOT NULL,
	country_short VARCHAR(3) NOT NULL,
	CONSTRAINT PK_country_country_id PRIMARY KEY CLUSTERED (country_id)
);

-- Tabela: Status
CREATE TABLE [status] (
	status_id INT IDENTITY(1,1) PRIMARY KEY,
	status_name VARCHAR(50) NOT NULL,
	status_desc VARCHAR(200),
	status_type VARCHAR(50),
	[status] BIT
);

-- Tabela: Autorzy
CREATE TABLE authors (
	author_id INT IDENTITY(1,1) PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	birth_date DATE,
	country_id INT NOT NULL DEFAULT 1,
	biography VARCHAR(MAX),
	FOREIGN KEY (country_id) REFERENCES country(country_id)
);

-- Tabela: Książki
IF NOT EXISTS (SELECT 1 FROM [INFORMATION_SCHEMA].[TABLES] WHERE TABLE_NAME = 'books')
BEGIN
	CREATE TABLE books (
		book_id INT IDENTITY(1,1) PRIMARY KEY,
		title VARCHAR(100) NOT NULL,
		isbn VARCHAR(20) UNIQUE,
		publication_year INT,
		publisher VARCHAR(100),
		genre VARCHAR(50),
		available_copies INT DEFAULT 1,
		total_copies INT DEFAULT 1,
		status_id INT NOT NULL,
		FOREIGN KEY (status_id) REFERENCES [status](status_id)
	);
END

-- Tabela: Powiązania Autorów z Książkami
CREATE TABLE authorsBooks (
	author_id INT NOT NULL,
	book_id INT NOT NULL,
	FOREIGN KEY (author_id) REFERENCES authors(author_id),
	FOREIGN KEY (book_id) REFERENCES books(book_id),
	CONSTRAINT PK_authorsBooks_author_id_book_id PRIMARY KEY CLUSTERED (author_id, book_id)
);

-- Tabela: Użytkownicy systemu
CREATE TABLE [user] (
	user_id INT IDENTITY(1,1) PRIMARY KEY,
	username VARCHAR(50) UNIQUE NOT NULL,
	password_hash VARCHAR(255) NOT NULL,
	email VARCHAR(100) UNIQUE NOT NULL,
	[role] VARCHAR(20) CHECK ([role] IN ('admin', 'librarian', 'user')),
	created_at DATETIME DEFAULT GETDATE(),
	last_login DATETIME,
	status_id INT NOT NULL,
	FOREIGN KEY (status_id) REFERENCES [status](status_id)
);

-- Tabela: Czytelnicy
CREATE TABLE readers (
	readers_id INT IDENTITY(1,1) PRIMARY KEY,
	user_id INT NOT NULL,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	[address] VARCHAR(100),
	phone VARCHAR(20),
	registration_date DATE DEFAULT GETDATE(),
	status_id INT NOT NULL,
	FOREIGN KEY (user_id) REFERENCES [user](user_id),
	FOREIGN KEY (status_id) REFERENCES [status](status_id)
);

-- Tabela: Wypożyczenia
CREATE TABLE borrowing (
	borrowing_id INT IDENTITY(1,1) PRIMARY KEY,
	book_id INT NOT NULL,
	readers_id INT NOT NULL,
	borrowing_date DATETIME DEFAULT CURRENT_TIMESTAMP,
	return_date DATETIME,
	due INT NOT NULL,
	[status] VARCHAR(20) CHECK ([status] IN ('wypożyczona', 'zwrócona', 'pretrzymana')) DEFAULT 'wypożyczona',
	status_id INT NOT NULL,
	FOREIGN KEY (book_id) REFERENCES books(book_id),
	FOREIGN KEY (readers_id) REFERENCES readers(readers_id),
	FOREIGN KEY (status_id) REFERENCES [status](status_id)
);

-- Tabela: Rezerwacje
CREATE TABLE reservation (
	reservation_id INT IDENTITY(1,1) PRIMARY KEY,
	book_id INT NOT NULL,
	readers_id INT NOT NULL,
	reservation_date DATETIME DEFAULT CURRENT_TIMESTAMP,
	status_id INT NOT NULL,
	FOREIGN KEY (book_id) REFERENCES books(book_id),
	FOREIGN KEY (readers_id) REFERENCES readers(readers_id),
	FOREIGN KEY (status_id) REFERENCES [status](status_id)
);

-- Indeks na rezerwacje (dla wydajności)
CREATE INDEX IX_reservation_book_is ON reservation(book_id);

-- Tabela: Kary
CREATE TABLE fine (
	fine_id INT IDENTITY(1,1) PRIMARY KEY,
	borrowing_id INT NOT NULL,
	amount DECIMAL(10,2) NOT NULL,
	date_issue DATETIME DEFAULT CURRENT_TIMESTAMP,
	date_pay DATETIME,
	status_id INT NOT NULL,
	FOREIGN KEY (borrowing_id) REFERENCES borrowing(borrowing_id),
	FOREIGN KEY (status_id) REFERENCES [status](status_id)
);

-- Wstawienie statusów
INSERT INTO [status] (status_name, status_desc, status_type, [status])
VALUES 
('Dostępna', 'Książka jest dostępna w bibliotece', 'books', 1),
('Niedostępna', NULL, 'books', 1),
('Aktywny', NULL, 'users', 1),
('Nieaktywny', NULL, 'users', 1);

-- Dodanie krajów
INSERT INTO country (country, country_short)
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
('Niemcy', 'DE'),
('Argentyna', 'AR'),
('Australia', 'AU'),
('Austria', 'AT'),
('Belgia', 'BE'),
('Brazylia', 'BR'),
('Bułgaria', 'BG'),
('Chiny', 'CN'),
('Chorwacja', 'HR'),
('Cypr', 'CY'),
('Czechy', 'CZ'),
('Dania', 'DK'),
('Egipt', 'EG'),
('Estonia', 'EE'),
('Finlandia', 'FI'),
('Grecja', 'GR'),
('Hiszpania', 'ES'),
('Holandia', 'NL'),
('Indie', 'IN'),
('Indonezja', 'ID'),
('Irak', 'IQ'),
('Iran', 'IR'),
('Irlandia', 'IE'),
('Islandia', 'IS'),
('Izrael', 'IL'),
('Jamajka', 'JM'),
('Japonia', 'JP'),
('Jemen', 'YE'),
('Kanada', 'CA'),
('Katar', 'QA'),
('Kazachstan', 'KZ'),
('Kenia', 'KE'),
('Kolumbia', 'CO'),
('Korea Południowa', 'KR'),
('Korea Północna', 'KP'),
('Kostaryka', 'CR'),
('Kuba', 'CU'),
('Liban', 'LB'),
('Libia', 'LY'),
('Litwa', 'LT'),
('Luksemburg', 'LU'),
('Łotwa', 'LV'),
('Malezja', 'MY'),
('Malta', 'MT'),
('Maroko', 'MA'),
('Meksyk', 'MX'),
('Mołdawia', 'MD'),
('Monako', 'MC'),
('Mongolia', 'MN'),
('Nepal', 'NP'),
('Nigeria', 'NG'),
('Norwegia', 'NO'),
('Nowa Zelandia', 'NZ'),
('Pakistan', 'PK'),
('Panama', 'PA'),
('Peru', 'PE'),
('Portugalia', 'PT'),
('Rosja', 'RU'),
('Rumunia', 'RO'),
('Rwanda', 'RW'),
('San Escobar', 'SEB'),
('Serbia', 'RS'),
('Singapur', 'SG'),
('Słowacja', 'SK'),
('Słowenia', 'SI'),
('Syria', 'SY'),
('Szwajcaria', 'CH'),
('Szwecja', 'SE'),
('Tajlandia', 'TH'),
('Tanzania', 'TZ'),
('Tunezja', 'TN'),
('Turcja', 'TR'),
('Ukraina', 'UA'),
('Urugwaj', 'UY'),
('Uzbekistan', 'UZ'),
('Watykan', 'VA'),
('Wenezuela', 'VE'),
('Węgry', 'HU'),
('Wietnam', 'VN'),
('Włochy', 'IT'),
('Zambia', 'ZM'),
('Zimbabwe', 'ZW'),
('Gondor', 'GON'),
('Rohan', 'ROH'),
('Hogwart', 'HOG'),
('Atlantyda', 'ATL'),
('Narnia', 'NAR'),
('Wakanda', 'WAK'),
('Elfia', 'ELF'),
('Mordor', 'MOR'),
('Hyrule', 'HYR'),
('Tamriel', 'TAM'),
('Midgard', 'MID'),
('Asgard', 'ASG'),
('Skellige', 'SKL'),
('Novigrad', 'NOV'),
('Zerrikania', 'ZER'),
('Kovir', 'KOV'),
('Cintra', 'CIN'),
('Toussaint', 'TOU'),
('Mahakam', 'MAH'),
('Kaedwen', 'KAE'),
('Aedirn', 'AED');

-- Dodanie autorów
INSERT INTO authors (first_name, last_name, birth_date, country_id, biography)
VALUES
('Jan', 'Kaczkowski', '1977-07-26', 1, 'Polski ksiądz katolicki, doktor nauk teologicznych, bioetyk, założyciel i dyrektor Puckiego Hospicjum pw. św. Ojca Pio.'),
('Joanna', 'Podsadecka', '1980-05-15', 1, 'Polska pisarka, współautorka książek z Janem Kaczkowskim.'),
('Britt', 'Allcroft', '1943-12-14', 3, 'Brytyjska producentka telewizyjna, najbardziej znana jako twórczyni serialu "Tomek i przyjaciele".'),
('Andrzej', 'Sapkowski', '1948-06-21', 1, 'Jeden z najpopularniejszych polskich pisarzy fantasy, twórca serii o Wiedźminie.'),
('Piotr', 'Fulmański', NULL, 1, 'Polski naukowiec i autor książek z zakresu informatyki.'),
('Anna', 'Nowak', '1975-03-10', 1, 'Autorka książek dla dzieci.'),
('Michał', 'Kowalski', '1982-11-22', 1, 'Autor poradników związanych z końmi.'),
('Ewa', 'Wiśniewska', '1968-09-05', 1, 'Pisarka, autorka powieści obyczajowych.'),
('John', 'Smith', '1970-04-18', 2, 'Amerykański autor książek technicznych.'),
('Maria', 'Garcia', '1985-07-30', 7, 'Hiszpańska autorka literatury dziecięcej.');

-- Dodanie książek
INSERT INTO books (title, isbn, publication_year, publisher, genre, available_copies, total_copies, status_id)
VALUES
('DASZ RADĘ OSTATNIA ROZMOWA', '9788326824561', 2020, 'Znak', 'Biografia', 3, 5, 1),
('Julek i DZIURA w BUDŻECIE', '9788378876324', 2019, 'Literatura', 'Dla dzieci', 2, 2, 1),
('Bajki 5 minut przed snem Tomek i przyjaciele', '9788328108522', 2018, 'Egmont', 'Dla dzieci', 1, 1, 1),
('Masaż konia - poradnik', '9788365976123', 2021, 'Galaktyka', 'Poradnik', 4, 4, 1),
('Wiedźmin', '9788375780635', 2014, 'SuperNowa', 'Fantasy', 5, 7, 1),
('Koń z Vallony', '9788374692723', 2017, 'Wydawnictwo Literackie', 'Powieść', 2, 3, 1),
('Blockchain', '9788328356786', 2020, 'PWN', 'Informatyka', 3, 3, 1),
('Learn Swift by examples', '9788328356793', 2021, 'PWN', 'Informatyka', 2, 2, 1),
('NoSQL. Theory and examples', '9788328356809', 2022, 'PWN', 'Informatyka', 1, 1, 1),
('Engineering of Big Data Processing', '9788328356816', 2023, 'PWN', 'Informatyka', 0, 1, 2);

-- Powiązanie autorów z książkami
INSERT INTO authorsBooks (author_id, book_id)
VALUES
(1, 1), (2, 1),
(6, 2),
(3, 3),
(7, 4),
(4, 5),
(8, 6),
(5, 7),
(5, 8),
(5, 9),
(5, 10);
