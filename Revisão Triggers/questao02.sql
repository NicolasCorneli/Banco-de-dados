CREATE TABLE tb_usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    senha VARCHAR(100)
);

CREATE TABLE tb_bkp_usuarios (
    id_usuario INT,
    nome VARCHAR(100),
    senha VARCHAR(100)
);

INSERT INTO tb_usuarios (nome, senha) VALUES
('Alice', 'senha123'),
('Bob', 'senha456'),
('Charlie', 'senha789'),
('David', 'senha012'),
('Eve', 'senha345');

CREATE or replace function salva_usuario_excluido() returns TRIGGER
as $$
BEGIN
	insert into tb_bkp_usuarios (id_usuario,nome,senha) values (old.id_usuario, old.nome, old.senha);
    return old;
end;
$$ language plpgsql;

create trigger trigger_salva_usuario_excluido
after delete on tb_usuarios
for each row
execute function salva_usuario_excluido();

select * from tb_usuarios;
select * from tb_bkp_usuarios;

delete from tb_usuarios where id_usuario = 5;
