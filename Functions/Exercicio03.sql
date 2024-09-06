CREATE DATABASE sqlmagazine;


create table Clientes (
    Id SERIAL primary key,
    Nome VARCHAR(100) not null,
    Saldo DECIMAL(15, 2)
);

create table Contas (
    Id SERIAL primary key,
    FkCliente INT references Clientes(Id),
    Descricao VARCHAR(100),
    Saldo DECIMAL(15, 2)
);

create table Movimentos (
    Id SERIAL primary key,
    FkConta INT references Contas(Id),
    Historico VARCHAR(255),
    Debito DECIMAL(15, 2),
    Credito DECIMAL(15, 2)
);


insert into Clientes (Nome, Saldo) values
('João Silva', 1000.00),
('Maria Souza', 2500.00);


insert into Contas (FkCliente, Descricao, Saldo) values
(1, 'Conta Corrente João', 1000.00),
(2, 'Conta Poupança Maria', 2500.00);


insert into Movimentos (FkConta, Historico, Debito, Credito) values
(1, 'Pagamento de Conta', 200.00, 0),
(1, 'Depósito', 0, 300.00),
(2, 'Transferência Recebida', 0, 500.00),
(2, 'Compra no Cartão', 150.00, 0);

create function incrementar(INTEGER)
returns integer as $$

	select $1 + 1;

$$ language 'sql';

select incrementar(10);

create function ncontas(integer)
returns int8 as $$
select count(*) from Contas
where FkCliente = $1;
$$ language 'sql';

select ncontas(2);

create function cliente_contadesc(varchar(30),varchar(30))
returns int8 as $$
insert into Clientes(Nome) values($1);
insert into Contas(FkCliente,Descricao)
values(currval('clientes_id_seq'),$2);
select currval('clientes_id_seq');
$$ language 'sql';

select cliente_contadesc('Silvio','Conta Poupança Silvio');

create function quemdeve() returns setof integer as $$
select Clientes.id from Clientes
inner join Contas on Clientes.id = Contas.FkCliente
inner join Movimentos on Contas.id = Movimentos.FkConta
group by Clientes.id
having sum(Movimentos.Credito - Movimentos.Debito) < 0;
$$ language 'sql';

select quemdeve();

create function devedores() returns setof Clientes as $$
select * from Clientes where Id in(
select Clientes.id from Clientes
inner join Contas on Clientes.id = Contas.FkCliente
inner join Movimentos on Contas.id = Movimentos.FkConta
group by Clientes.id
having sum(Movimentos.Credito- Movimentos.Debito) < 0
);
$$ language 'sql';

select * from devedores();

create function MaioresClientes(numeric(15,2))
returns setof Clientes as $$
select * from Clientes where Id in (
select Clientes.id from Clientes
inner join Contas on Clientes.id = Contas.FkCliente
inner join Movimentos on Contas.id = Movimentos.FkConta
group by Clientes.id 
having sum(Movimentos.Credito) >= $1
);
$$ language 'sql';

select * from MaioresClientes(300);