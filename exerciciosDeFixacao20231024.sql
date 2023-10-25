CREATE DATABASE exercicios_trigger;
USE exercicios_trigger;

-- Criação das tabelas
CREATE TABLE Clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);

CREATE TABLE Auditoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mensagem TEXT NOT NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    estoque INT NOT NULL
);

CREATE TABLE Pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    produto_id INT,
    quantidade INT NOT NULL,
    FOREIGN KEY (produto_id) REFERENCES Produtos(id)
);

insert into Clientes (nome)
values("Cleiton"), ("Nicholas"), ("Roberth") , ("Joardoson");

insert into Auditoria (mensagem)
values("Entregue tudo nos conformes"), ("Problema na entrega"), ("Entregue tudo nos conformes"),("Problema na entrega") ;

insert into Produtos (nome, estoque)
values("Roupa", "50"), ("Tênis", "90"), ("Meias", "10"), ("Chinelos", "25");

insert into Pedidos (produto_id, quantidade)
values("1", "50"), ("1", "49"), ("2", "90"), ("4", "25")

-- exercicio 01
delimiter //
create trigger inserir_cliente after insert on Clientes
for each row 
begin
    insert into Auditoria (mensagem)
    values (concat('Novo cliente inserido: ', new.nome, '. Data e hora: ', now()));
end;
//
delimiter ;

-- exercicio 02
delimiter //
create trigger  deletar_cliente before delete on Clientes
for each row 
begin
    insert into Auditoria (mensagem)
    values (concat('Tentativa de excluir cliente: ', old.nome, '. Data e hora: ', now()));
end;
//
delimiter ;

-- exercicio 03 
delimiter //
create trigger atualizar_cliente after update on Clientes
for each row
begin
    insert into Auditoria (mensagem)
    values (concat('Nome do cliente atualizado. Nome antigo: ', old.nome, ', Novo nome: ', new.nome, '. Data e hora: ', now()));
end;
//
delimiter ;

-- exercicio 04
delimiter //
create trigger previsao_de_erros before update on Clientes
for each row
begin
    if new.nome is null or new.nome = '' then
        signal sqlstate '45000'
        set message_text = 'Nome não pode ser vazio ou NULL. Operação de atualização cancelada.';
    end if;
end;
//
delimiter ;

-- exercicio 05
delimiter //
create trigger atualizar_pedidos after insert on Pedidos
for each row
begin
    update Produtos set estoque = estoque - new.quantidade where id = new.produto_id;
    if (select estoque from Produtos where id = new.produto_id) < 5 then
        insert into Auditoria (mensagem)
        values (concat('Estoque baixo para o produto com ID ', new.produto_id, '. Data e hora: ', now()));
    end if;
end;
//
delimiter ;


