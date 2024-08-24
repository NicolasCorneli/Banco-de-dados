create table departamentos(
id serial,
descricao varchar(40),
primary key(id)
);

create table cidades(
id serial,
nome varchar(30),
primary key(id)
);

create table funcionarios (
id serial,
nome varchar(40),
depto_id int,
cidade_id int,
primary key(id),
foreign key (depto_id) references departamentos(id),
foreign key (cidade_id) references cidades(id)
);


create function soma(int,int) returns int as
'
select $1 + $2;

'
language 'sql';
select soma(10,1);

drop function soma;

insert into departamentos (descricao) values('Financeiros');
insert into departamentos (descricao) values('Contábil');
insert into departamentos (descricao) values('TI');
insert into cidades (nome) values('Pelotas');
insert into cidades (nome) values('Porto Alegre');
insert into cidades (nome) values('São Paulo');
insert into cidades (nome) values('Rio de Janeiro');

insert into funcionarios (nome,depto_id,cidade_id) values('José',1,1);
insert into funcionarios (nome,depto_id,cidade_id) values('Maria',2,3);
insert into funcionarios (nome,depto_id,cidade_id) values('Pedro',1,4);
insert into funcionarios (nome,depto_id,cidade_id) values('Ana',2,1);

create function buscaFuncionarioID(int) returns setof funcionarios as

'
    select * from funcionarios where depto_id = $1;
'
language 'sql';

select * from buscaFuncionarioID(1);


create function countFuncionario(varchar) returns int as

'
      select count(f.id) from funcionarios as f, cidades as c where f.cidade_id = c.id and c.nome like $1; 

'
language 'sql';
select * from countFuncionario('Pelotas');

create function countFuncionarioPorCidade() returns table (cidade_nome varchar, quantidade_funcionarios int) as

'
      SELECT c.nome AS cidade_nome, COUNT(f.id) AS quantidade_funcionarios
      FROM funcionarios AS f
      JOIN cidades AS c ON f.cidade_id = c.id
      GROUP BY c.nome;

'
language 'sql';

select * from countFuncionarioPorCidade();


create table funcionarios_testIF(
id int primary key,
funcionario_codio varchar(20),
funcionario_nome varchar(100),
funcionario_situacao varchar(1) default 'A',
funcionario_comissao real,
funcionario_cargo varchar(30),
data_criacao timestamp,
data_atualizacao timestamp
);

insert into funcionarios_testIF(id,funcionario_nome,funcionario_situacao,funcionario_comissao,funcionario_cargo,data_criacao)
values('0001','VINICIUS CARVALHO','B',5,'GERENTE','01/01/2016');

insert into funcionarios_testIF(id,funcionario_nome,funcionario_situacao,funcionario_comissao,funcionario_cargo,data_criacao)
values('0002','SOUZA','A',2,'GARÇOM','01/01/2016');

create table empregados(
codigo serial,
nome_emp varchar(255),
salario float,
departamento_cod int,
primary key(codigo),
foreign key (departamento_cod) references departamentos (id)
);

create function codigo_empregado(float)
returns setof as $$
declare
    registro record;
    retval integer;
begin
    for registro in select * from empregados where salario >= $1 loop
        return next registro.codigo;
  end loop;
  return;

end;

$$ language 'plpgsql';

select * from codigo_empregado(2000);
