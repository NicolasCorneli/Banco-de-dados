CREATE TABLE produto (
    cod_prod SERIAL PRIMARY KEY,
    descricao VARCHAR(200),
    qtd_disponivel INT
);

CREATE TABLE itensVenda (
    cod_venda SERIAL PRIMARY KEY,
    id_produto INT REFERENCES produto(cod_prod),
    qtd_vendida INT
);

INSERT INTO produto (descricao, qtd_disponivel) VALUES
('Produto A', 100),
('Produto B', 50),
('Produto C', 200),
('Produto D', 0),
('Produto E', 30);

INSERT INTO itensVenda (id_produto, qtd_vendida) VALUES
(1, 10),
(2, 5),  
(3, 15), 
(4, 20),
(5, 1);  

CREATE OR REPLACE FUNCTION atualiza_estoque() RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT qtd_disponivel FROM produto WHERE cod_prod = NEW.id_produto) >= NEW.qtd_vendida THEN
        UPDATE produto
        SET qtd_disponivel = qtd_disponivel - NEW.qtd_vendida
        WHERE cod_prod = NEW.id_produto;
    ELSE
        RAISE EXCEPTION 'Estoque insuficiente para o produto %', NEW.id_produto;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualiza_estoque
AFTER INSERT ON itensVenda
FOR EACH ROW
EXECUTE FUNCTION atualiza_estoque();

SELECT * FROM produto;
SELECT * FROM itensVenda;

INSERT INTO itensVenda (id_produto, qtd_vendida) VALUES
(1, 11);
