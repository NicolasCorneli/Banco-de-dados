CREATE TABLE Pedidos (
    pedido_id SERIAL PRIMARY KEY,
    data_pedido DATE NOT NULL,
    cliente_id INT NOT NULL,
    centro_saida_id INT NOT NULL,
    centro_destino_id INT NOT NULL,
    quantidade INT NOT NULL,
    valor_total NUMERIC(10, 2) NOT NULL
);

CREATE TABLE Clientes (
    cliente_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(50) NOT NULL
);

CREATE TABLE Centros (
    centro_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(50) NOT NULL
);

CREATE TABLE Entregas (
    entrega_id SERIAL PRIMARY KEY,
    pedido_id INT NOT NULL,
    data_saida DATE NOT NULL,
    data_chegada DATE NOT NULL,
    quilometragem NUMERIC(10, 2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos (pedido_id)
);

INSERT INTO Clientes (nome, endereco, cidade, estado)
VALUES
('João Silva', 'Rua das Flores, 123', 'São Paulo', 'SP'),
('Maria Souza', 'Av. Brasil, 987', 'Rio de Janeiro', 'RJ'),
('Carlos Mendes', 'Praça Central, 45', 'Belo Horizonte', 'MG');

INSERT INTO Centros (nome, endereco, cidade, estado)
VALUES
('Centro SP', 'Rua Logística, 456', 'São Paulo', 'SP'),
('Centro RJ', 'Av. Transporte, 789', 'Rio de Janeiro', 'RJ'),
('Centro MG', 'Rua Entrega, 321', 'Belo Horizonte', 'MG');

INSERT INTO Pedidos (data_pedido, cliente_id, centro_saida_id, centro_destino_id, quantidade, valor_total)
VALUES
('2024-11-01', 1, 1, 2, 10, 500.00),
('2024-11-02', 2, 2, 3, 5, 200.00),
('2024-11-03', 3, 3, 1, 20, 1000.00);

INSERT INTO Entregas (pedido_id, data_saida, data_chegada, quilometragem)
VALUES
(1, '2024-11-01', '2024-11-02', 450.0),
(2, '2024-11-02', '2024-11-04', 300.0),
(3, '2024-11-03', '2024-11-05', 600.0);


CREATE TABLE DimClientes (
    cliente_sk SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200),
    cidade VARCHAR(100),
    estado VARCHAR(50),
    data_inicio_validade DATE NOT NULL,
    data_fim_validade DATE,
    ativo BOOLEAN NOT NULL
);

CREATE TABLE DimCentros (
    centro_sk SERIAL PRIMARY KEY,
    centro_id INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(200),
    cidade VARCHAR(100),
    estado VARCHAR(50),
    data_inicio_validade DATE NOT NULL,
    data_fim_validade DATE,
    ativo BOOLEAN NOT NULL
);

CREATE TABLE FatoEntregas (
    fato_id SERIAL PRIMARY KEY,
    entrega_id INT NOT NULL,
    pedido_id INT NOT NULL,
    cliente_sk INT NOT NULL,
    centro_saida_sk INT NOT NULL,
    centro_destino_sk INT NOT NULL,
    data_saida DATE NOT NULL,
    data_chegada DATE NOT NULL,
    quilometragem NUMERIC(10, 2) NOT NULL,
    tempo_entrega INTERVAL NOT NULL,
    quantidade INT NOT NULL,
    valor_total NUMERIC(10, 2) NOT NULL,
    FOREIGN KEY (cliente_sk) REFERENCES DimClientes (cliente_sk),
    FOREIGN KEY (centro_saida_sk) REFERENCES DimCentros (centro_sk),
    FOREIGN KEY (centro_destino_sk) REFERENCES DimCentros (centro_sk)
);

INSERT INTO DimClientes (cliente_id, nome, endereco, cidade, estado, data_inicio_validade, data_fim_validade, ativo)
SELECT cliente_id, nome, endereco, cidade, estado, CURRENT_DATE, NULL, TRUE
FROM Clientes;

INSERT INTO DimCentros (centro_id, nome, endereco, cidade, estado, data_inicio_validade, data_fim_validade, ativo)
SELECT centro_id, nome, endereco, cidade, estado, CURRENT_DATE, NULL, TRUE
FROM Centros;

INSERT INTO FatoEntregas (entrega_id, pedido_id, cliente_sk, centro_saida_sk, centro_destino_sk, data_saida, data_chegada, quilometragem, tempo_entrega, quantidade, valor_total)
SELECT 
    e.entrega_id,
    p.pedido_id,
    csk.cliente_sk,
    cssk.centro_sk AS centro_saida_sk,
    cdsk.centro_sk AS centro_destino_sk,
    e.data_saida,
    e.data_chegada,
    e.quilometragem,
    (e.data_chegada - e.data_saida) AS tempo_entrega,
    p.quantidade,
    p.valor_total
FROM 
    Entregas e
JOIN Pedidos p ON e.pedido_id = p.pedido_id
JOIN DimClientes csk ON p.cliente_id = csk.cliente_id AND csk.ativo = TRUE
JOIN DimCentros cssk ON p.centro_saida_id = cssk.centro_id AND cssk.ativo = TRUE
JOIN DimCentros cdsk ON p.centro_destino_id = cdsk.centro_id AND cdsk.ativo = TRUE;
