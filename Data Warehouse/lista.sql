CREATE TABLE Dim_Loja (
    CGCLoja CHAR(12) PRIMARY KEY,
    Nome_Loja VARCHAR(30),
    Endereco VARCHAR(100),
    Cidade VARCHAR(30),
    Estado CHAR(2),
    Pais CHAR(20)
);

CREATE TABLE Dim_Cliente (
    CPF CHAR(12) PRIMARY KEY,
    Nome VARCHAR(30),
    Endereco VARCHAR(100),
    Cidade VARCHAR(30),
    Estado CHAR(2),
    Pais CHAR(20),
    Bairro CHAR(10),
    Renda NUMERIC(15, 2)
);

CREATE TABLE Dim_Veiculo (
    NumeroChassi CHAR(30) PRIMARY KEY,
    Nome VARCHAR(30),
    Modelo CHAR(10),
    DataInicioFabricacao DATE,
    DataFimFabricacao DATE,
    CGCFabricante CHAR(12)
);

CREATE TABLE Dim_Tempo (
    Data DATE PRIMARY KEY,
    Ano INT,
    Mes INT,
    Trimestre INT,
    DiaSemana CHAR(10)
);

CREATE TABLE Fato_Vendas (
    ID_Venda SERIAL PRIMARY KEY,
    CGCLoja CHAR(12) REFERENCES Dim_Loja(CGCLoja),
    NumeroChassi CHAR(30) REFERENCES Dim_Veiculo(NumeroChassi),
    CPF CHAR(12) REFERENCES Dim_Cliente(CPF),
    DataCompra DATE REFERENCES Dim_Tempo(Data),
    ValorCompra NUMERIC(15, 2),
    ValorImposto NUMERIC(15, 2)
);


INSERT INTO Dim_Tempo (Data, Ano, Mes, Trimestre, DiaSemana) VALUES
('2024-01-01', 2024, 1, 1, 'Segunda-feira'),
('2024-01-02', 2024, 1, 1, 'Terça-feira'),
('2024-01-03', 2024, 1, 1, 'Quarta-feira');

INSERT INTO Dim_Loja (CGCLoja, Nome_Loja, Endereco, Cidade, Estado, Pais) VALUES
('123456789012', 'Loja A', 'Rua Exemplo 1', 'Cidade A', 'SP', 'Brasil'),
('234567890123', 'Loja B', 'Rua Exemplo 2', 'Cidade B', 'RJ', 'Brasil');

INSERT INTO Dim_Cliente (CPF, Nome, Endereco, Cidade, Estado, Pais, Bairro, Renda) VALUES
('12345678901', 'Cliente 1', 'Rua Exemplo 3', 'Cidade C', 'MG', 'Brasil', 'Centro', 5000.00),
('23456789012', 'Cliente 2', 'Rua Exemplo 4', 'Cidade D', 'SP', 'Brasil', 'Sul', 7000.00);

INSERT INTO Dim_Veiculo (NumeroChassi, Nome, Modelo, DataInicioFabricacao, DataFimFabricacao, CGCFabricante) VALUES
('CHASSI123456', 'Veiculo 1', 'Modelo A', '2022-01-01', '2023-01-01', 'FAB1234567890'),
('CHASSI234567', 'Veiculo 2', 'Modelo B', '2023-01-01', '2024-01-01', 'FAB2345678901');

INSERT INTO Fato_Vendas (CGCLoja, NumeroChassi, CPF, DataCompra, ValorCompra, ValorImposto) VALUES
('123456789012', 'CHASSI123456', '12345678901', '2024-01-01', 45000.00, 5000.00),
('234567890123', 'CHASSI234567', '23456789012', '2024-01-02', 60000.00, 7000.00);

-- Total das vendas de uma determinada loja em um período
SELECT CGCLoja, SUM(ValorCompra) AS TotalVendas
FROM Fato_Vendas
WHERE DataCompra BETWEEN '2024-01-01' AND '2024-12-31'
AND CGCLoja = '123456789012'
GROUP BY CGCLoja;

-- Lojas que mais venderam em um determinado período:
SELECT CGCLoja, SUM(ValorCompra) AS TotalVendas
FROM Fato_Vendas
WHERE DataCompra BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY CGCLoja
ORDER BY TotalVendas DESC
LIMIT 5;

-- Veículos de maior aceitação em uma determinada região:
SELECT V.Modelo, COUNT(*) AS TotalVendas
FROM Fato_Vendas F
JOIN Dim_Veiculo V ON F.NumeroChassi = V.NumeroChassi
JOIN Dim_Cliente C ON F.CPF = C.CPF
WHERE C.Estado = 'SP'
GROUP BY V.Modelo
ORDER BY TotalVendas DESC
LIMIT 5;

-- Lojas que menos venderam num determinado período de tempo
SELECT CGCLoja, SUM(ValorCompra) AS TotalVendas
FROM Fato_Vendas
WHERE DataCompra BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY CGCLoja
ORDER BY TotalVendas ASC
LIMIT 5;

-- Perfil de clientes nos quais deve-se investir
SELECT 
    C.Cidade,
    C.Estado,
    C.Bairro,
    AVG(C.Renda) AS RendaMedia,
    COUNT(F.CPF) AS TotalCompras,
    AVG(F.ValorCompra) AS ValorMedioCompra
FROM Fato_Vendas F
JOIN Dim_Cliente C ON F.CPF = C.CPF
WHERE F.DataCompra BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY C.Cidade, C.Estado, C.Bairro
HAVING AVG(F.ValorCompra) > 30000 
ORDER BY RendaMedia DESC, TotalCompras DESC;
