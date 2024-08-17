CREATE DATABASE gerencimanto_de_tarefas;

CREATE TABLE usuarios (
    id serial,
    nome varchar(40),
    email varchar(40),
    senha varchar(40),
    primary key (id)
);

CREATE TABLE categorias (
    id serial,
    descricao varchar(40),
    primary key (id)
);

CREATE TABLE tarefas (
    id serial,
    descricao varchar(40),
    usuario_id int,
    categoria_id int,
    primary key (id),
    foreign key (usuario_id) references usuarios(id),
    foreign key (categoria_id) references categorias(id)
);

INSERT INTO usuarios (nome, email, senha) VALUES ('José', 'exemple@exemple.com', '123');
INSERT INTO usuarios (nome, email, senha) VALUES ('Maria', 'exemple@exemple.com', '123');
INSERT INTO usuarios (nome, email, senha) VALUES ('Pedro', 'exemple@exemple.com', '123');
INSERT INTO usuarios (nome, email, senha) VALUES ('João', 'exemple@exemple.com', '123');
INSERT INTO usuarios (nome, email, senha) VALUES ('MAquiavel', 'exemple@exemple.com', '123');

INSERT INTO categorias (descricao) VALUES ('Trabalho');
INSERT INTO categorias (descricao) VALUES ('Estudo');
INSERT INTO categorias (descricao) VALUES ('Lazer');
INSERT INTO categorias (descricao) VALUES ('Casa');
INSERT INTO categorias (descricao) VALUES ('Outros');

INSERT INTO tarefas (descricao, usuario_id, categoria_id) VALUES ('Estudar SQL', 1, 2);
INSERT INTO tarefas (descricao, usuario_id, categoria_id) VALUES ('Estudar Python', 2, 2);
INSERT INTO tarefas (descricao, usuario_id, categoria_id) VALUES ('Estudar Java', 3, 2);
INSERT INTO tarefas (descricao, usuario_id, categoria_id) VALUES ('Estudar PHP', 4, 2);
INSERT INTO tarefas (descricao, usuario_id, categoria_id) VALUES ('Estudar Ruby', 5, 2);

SELECT
    u.nome,
    c.descricao,
    t.descricao
FROM
    usuarios AS u,
    categorias AS c,
    tarefas AS t
WHERE
    u.id = t.usuario_id AND
    c.id = t.categoria_id;

SELECT
    u.nome AS nome_usuario,
    c.descricao AS descricao_categoria,
    t.descricao AS descricao_tarefa
FROM
    usuarios u
INNER JOIN
    tarefas t ON u.id = t.usuario_id
INNER JOIN
    categorias c ON c.id = t.categoria_id;

SELECT
    u.nome AS nome_usuario,
    c.descricao AS descricao_categoria
FROM
    usuarios u
LEFT JOIN
    tarefas t ON u.id = t.usuario_id
LEFT JOIN
    categorias c ON c.id = t.categoria_id;

SELECT
    u.nome AS nome_usuario,
    c.descricao AS descricao_categoria,
    t.descricao AS descricao_tarefa
FROM
    usuarios u
LEFT JOIN
    tarefas t ON u.id = t.usuario_id
LEFT JOIN
    categorias c ON c.id = t.categoria_id;

SELECT
    u.nome AS nome_usuario,
    c.descricao AS descricao_categoria
FROM
    usuarios u
RIGHT JOIN
    tarefas t ON u.id = t.usuario_id
RIGHT JOIN
    categorias c ON c.id = t.categoria_id;


SELECT
    u.nome AS nome_usuario,
    c.descricao AS descricao_categoria
FROM
    usuarios u
FULL OUTER JOIN
    tarefas t ON u.id = t.usuario_id
FULL OUTER JOIN
    categorias c ON c.id = t.categoria_id;

SELECT
    u.nome AS nome_usuario,
    c.descricao AS descricao_categoria,
    t.descricao AS descricao_tarefa
FROM
    usuarios u
FULL OUTER JOIN
    tarefas t ON u.id = t.usuario_id
FULL OUTER JOIN
    categorias c ON c.id = t.categoria_id;

SELECT count(*) FROM usuarios;
SELECT min(id) FROM usuarios;
SELECT max(id) FROM usuarios;
select avg(id) from usuarios;
SELECT sum(id) FROM usuarios;

SELECT
    u.nome AS nome_usuario,
    c.descricao AS descricao_categoria,
    t.descricao AS descricao_tarefa
FROM
    usuarios u
INNER JOIN
    tarefas t ON u.id = t.usuario_id
INNER JOIN
    categorias c ON c.id = t.categoria_id
GROUP BY
    u.nome, c.descricao, t.descricao
HAVING
    COUNT(u.id) > 1;

SELECT
    u.nome AS nome_usuario,
    c.descricao AS descricao_categoria,
    t.descricao AS descricao_tarefa
FROM
    usuarios u
INNER JOIN
    tarefas t ON u.id = t.usuario_id
INNER JOIN
    categorias c ON c.id = t.categoria_id
ORDER BY RANDOM();
