CREATE TABLE ExecutivoDeCinema (
    codigo INTEGER PRIMARY KEY,
    nome VARCHAR(50),
    patrimonio NUMERIC(8,2)
);

CREATE TABLE Estudio (
    nome VARCHAR(30) PRIMARY KEY,
    endereco VARCHAR(70),
    codigo_presente INTEGER REFERENCES ExecutivoDeCinema (codigo)
);

CREATE TABLE Filme (
    titulo VARCHAR(50),
    ano INTEGER,
    duracao INTEGER,
    colorido BOOLEAN,
    genero VARCHAR(20),
    nome_estudio VARCHAR(30) REFERENCES Estudio(nome),
    codigo_produtor INTEGER REFERENCES ExecutivoDeCinema(codigo),
    PRIMARY KEY(titulo, ano)
);

CREATE TABLE EstrelaDeCinema (
    nome VARCHAR(50) PRIMARY KEY,
    endereco VARCHAR(70),
    sexo CHAR(1),
    dataNascimento DATE
);

CREATE TABLE Elenco (
    titulo_filme VARCHAR(50),
    ano_filme INTEGER,
    nome_estrela VARCHAR(50) REFERENCES EstrelaDeCinema(nome),
    PRIMARY KEY(titulo_filme, ano_filme, nome_estrela),
    FOREIGN KEY(titulo_filme, ano_filme) REFERENCES Filme(titulo, ano)
);

INSERT INTO ExecutivoDeCinema (codigo, nome, patrimonio) VALUES
(1, 'Steven Spielberg', 350000.00),
(2, 'Kathleen Kennedy', 200000.00),
(3, 'Martin Scorsese', 20000.00);

INSERT INTO Estudio (nome, endereco, codigo_presente) VALUES
('Universal Pictures', '100 Universal City Plaza, Universal City, CA', 1),
('Lucasfilm', '1110 Galleria Blvd, Suite 300, Roseville, CA', 2),
('Paramount Pictures', '5555 Melrose Ave, Hollywood, CA', 3);

INSERT INTO Filme (titulo, ano, duracao, colorido, genero, nome_estudio, codigo_produtor) VALUES
('Jurassic Park', 1993, 127, TRUE, 'Aventura', 'Universal Pictures', 1),
('Star Wars: A New Hope', 1977, 121, TRUE, 'Ficção Científica', 'Lucasfilm', 2),
('Goodfellas', 1990, 145, FALSE, 'Crime', 'Paramount Pictures', 3);

INSERT INTO EstrelaDeCinema (nome, endereco, sexo, dataNascimento) VALUES
('Sam Neill', 'New Zealand', 'M', '1947-09-14'),
('Mark Hamill', 'Oakland, California', 'M', '1951-09-25'),
('Robert De Niro', 'New York City, New York', 'M', '1943-08-17');

INSERT INTO Elenco (titulo_filme, ano_filme, nome_estrela) VALUES
('Jurassic Park', 1993, 'Sam Neill'),
('Star Wars: A New Hope', 1977, 'Mark Hamill'),
('Goodfellas', 1990, 'Robert De Niro'),
('Jurassic Park', 1993, 'Laura Dern'),
('Star Wars: A New Hope', 1977, 'Carrie Fisher');


CREATE PROCEDURE Mudanca(
    IN nome_estrela VARCHAR(50),
    IN endereco_novo VARCHAR(255))
as $$
BEGIN
    UPDATE EstrelaDeCinema
    SET endereco = endereco_novo
    WHERE nome = nome_estrela;
END;
$$
LANGUAGE plpgsql;

CALL Mudanca('Maria Silva', 'Rua Nova, 123');
