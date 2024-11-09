CREATE TABLE dim_cliente (
    cliente_sk SERIAL PRIMARY KEY,  
    cliente_id INT UNIQUE, 
    nome VARCHAR(255),
    data_nascimento DATE,
    endereco VARCHAR(255),
    categoria_fidelidade VARCHAR(50),
    data_ultima_alteracao TIMESTAMP,  
    data_validade DATE, 
    ativo BOOLEAN DEFAULT TRUE 
);

CREATE TABLE dim_quarto (
    quarto_sk SERIAL PRIMARY KEY, 
    quarto_id INT UNIQUE
    tipo_quarto VARCHAR(50),
    status_manutencao VARCHAR(50),
    data_ultima_reforma DATE
);

CREATE TABLE dim_hotel (
    hotel_sk SERIAL PRIMARY KEY, 
    hotel_id INT UNIQUE, 
    nome_hotel VARCHAR(255),
    cidade VARCHAR(100),
    pais VARCHAR(100),
    data_inauguracao DATE
);

CREATE TABLE dim_data (
    data_id SERIAL PRIMARY KEY, 
    data_completa DATE, 
    ano INT,
    mes INT,
    dia INT,
    trimestre INT,
    dia_da_semana VARCHAR(20)
);

CREATE TABLE fato_reserva (
    reserva_sk SERIAL PRIMARY KEY, 
    cliente_sk INT REFERENCES dim_cliente(cliente_sk), 
    quarto_sk INT REFERENCES dim_quarto(quarto_sk),  
    hotel_sk INT REFERENCES dim_hotel(hotel_sk), 
    data_id INT REFERENCES dim_data(data_id), 
    valor_total_reserva NUMERIC(10, 2),
    data_checkin DATE,
    data_checkout DATE
);

CREATE TABLE fato_receita (
    hotel_sk INT REFERENCES dim_hotel(hotel_sk), 
    data_id INT REFERENCES dim_data(data_id), 
    receita_total_diaria NUMERIC(10, 2), 
    despesas_operacionais_diarias NUMERIC(10, 2),
    PRIMARY KEY (hotel_sk, data_id) 
);

INSERT INTO dim_cliente (cliente_id, nome, data_nascimento, endereco, categoria_fidelidade, data_ultima_alteracao)
VALUES
    (1, 'João Silva', '1985-07-15', 'Rua A, 123', 'Bronze', '2023-01-10'),
    (2, 'Maria Oliveira', '1990-02-25', 'Avenida B, 456', 'Ouro', '2023-05-20');

INSERT INTO dim_quarto (quarto_id, tipo_quarto, status_manutencao, data_ultima_reforma)
VALUES
    (101, 'Standard', 'Disponível', '2022-01-15'),
    (102, 'Luxo', 'Em manutenção', '2023-06-10');

INSERT INTO dim_hotel (hotel_id, nome_hotel, cidade, pais, data_inauguracao)
VALUES
    (1, 'Hotel São Paulo', 'São Paulo', 'Brasil', '2010-05-20'),
    (2, 'Hotel Lisboa', 'Lisboa', 'Portugal', '2015-09-10');

INSERT INTO dim_data (data_completa, ano, mes, dia, dia_da_semana)
VALUES
    ('2023-10-01', 2023, 10, 1, 'Domingo'),
    ('2023-10-02', 2023, 10, 2, 'Segunda-feira');

INSERT INTO fato_reserva (cliente_sk, quarto_sk, hotel_sk, data_id, valor_total_reserva, data_checkin, data_checkout)
VALUES
    (1, 101, 1, 1, 500.00, '2023-10-01', '2023-10-04'),
    (2, 102, 2, 2, 1200.00, '2023-10-02', '2023-10-07');

INSERT INTO fato_receita (hotel_sk, data_id, receita_total_diaria, despesas_operacionais_diarias)
VALUES
    (1, 1, 1500.00, 800.00),
    (2, 2, 2000.00, 900.00);

-- 1. Qual é a receita média por cliente em cada categoria de fidelidade?
SELECT 
    c.categoria_fidelidade,
    AVG(fr.valor_total_reserva) AS receita_media_por_cliente
FROM 
    fato_reserva fr
JOIN 
    dim_cliente c ON fr.cliente_sk = c.cliente_sk
GROUP BY 
    c.categoria_fidelidade;

-- 2. Quais hotéis possuem as taxas de ocupação mais altas em um período específico?
SELECT 
    h.nome_hotel,
    COUNT(fr.reserva_sk) * 100.0 / COUNT(dq.quarto_sk) AS taxa_ocupacao
FROM 
    fato_reserva fr
JOIN 
    dim_quarto dq ON fr.quarto_sk = dq.quarto_sk
JOIN 
    dim_hotel h ON fr.hotel_sk = h.hotel_sk
WHERE 
    fr.data_checkin BETWEEN '2023-10-01' AND '2023-10-31'  -- Período específico
GROUP BY 
    h.nome_hotel
ORDER BY 
    taxa_ocupacao DESC;

-- 3. Qual a média de tempo que os clientes de uma determinada categoria de fidelidade permanecem nos hotéis?
SELECT 
    c.categoria_fidelidade,
    AVG(EXTRACT(DAY FROM (fr.data_checkout - fr.data_checkin))) AS media_duracao_permanencia
FROM 
    fato_reserva fr
JOIN 
    dim_cliente c ON fr.cliente_sk = c.cliente_sk
GROUP BY 
    c.categoria_fidelidade;

-- 4. Quais quartos são mais frequentemente reformados, e com que frequência?
SELECT 
    dq.quarto_id,
    COUNT(dq.data_ultima_reforma) AS numero_de_reformas,
    AVG(EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM dq.data_ultima_reforma)) AS anos_entre_reformas
FROM 
    dim_quarto dq
WHERE 
    dq.data_ultima_reforma IS NOT NULL
GROUP BY 
    dq.quarto_id
ORDER BY 
    numero_de_reformas DESC;

-- 5. Qual o perfil dos clientes com maior gasto em reservas por país e categoria de fidelidade?
SELECT 
    h.pais,
    c.categoria_fidelidade,
    c.nome,
    SUM(fr.valor_total_reserva) AS total_gasto
FROM 
    fato_reserva fr
JOIN 
    dim_cliente c ON fr.cliente_sk = c.cliente_sk
JOIN 
    dim_hotel h ON fr.hotel_sk = h.hotel_sk
GROUP BY 
    h.pais, c.categoria_fidelidade, c.nome
ORDER BY 
    total_gasto DESC
LIMIT 10;
