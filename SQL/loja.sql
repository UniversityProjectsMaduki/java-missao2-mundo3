CREATE TABLE Usuario (
    idOperador INT PRIMARY KEY,
    nome VARCHAR(255),
    senha VARCHAR(255)
);

CREATE TABLE Pessoa (
    idPessoa INT PRIMARY KEY,
    nome VARCHAR(255),
    logradouro VARCHAR(255),
    cidade VARCHAR(255),
    estado CHAR(2),
    telefone VARCHAR(11),
    email VARCHAR(255)
);

CREATE TABLE PessoaFisica (
    idPessoaFisica INT PRIMARY KEY,
    cpf VARCHAR(11),
    FOREIGN KEY (idPessoaFisica) REFERENCES Pessoa(idPessoa)
);

CREATE TABLE PessoaJuridica (
    idPessoaJuridica INT PRIMARY KEY,
    cnpj VARCHAR(14),
    FOREIGN KEY (idPessoaJuridica) REFERENCES Pessoa(idPessoa)
);

CREATE TABLE Produto (
    idProduto INT PRIMARY KEY,
    nome VARCHAR(255),
    quantidade INT,
    precoVenda NUMERIC
);

CREATE TABLE MovimentoCompra (
    idMovimentoCompra INT PRIMARY KEY,
    quantidade INT,
    precoUnitario NUMERIC,
    idProduto INT,
    idFornecedor INT,
    idOperador INT,
    FOREIGN KEY (idProduto) REFERENCES Produto(idProduto),
    FOREIGN KEY (idFornecedor) REFERENCES PessoaJuridica(idPessoaJuridica),
    FOREIGN KEY (idOperador) REFERENCES Usuario(idOperador)
);

CREATE TABLE MovimentoVenda (
    idMovimentoVenda INT PRIMARY KEY,
    quantidade INT,
    precoUnitario NUMERIC,
    idProduto INT,
    idComprador INT,
    idOperador INT,
    FOREIGN KEY (idProduto) REFERENCES Produto(idProduto),
    FOREIGN KEY (idComprador) REFERENCES PessoaFisica(idPessoaFisica),
    FOREIGN KEY (idOperador) REFERENCES Usuario(idOperador)
);

CREATE SEQUENCE PessoaIdSequence
    START WITH 1
    INCREMENT BY 1;




INSERT INTO Usuario (idOperador, nome, senha) VALUES (1, 'op1', 'op1');
INSERT INTO Usuario (idOperador, nome, senha) VALUES (2, 'op2', 'op2');


INSERT INTO Produto (idProduto, nome, quantidade, precoVenda) VALUES (1, 'Banana', 100, 5.00);
INSERT INTO Produto (idProduto, nome, quantidade, precoVenda) VALUES (2, 'Laranja', 500, 2.00);
INSERT INTO Produto (idProduto, nome, quantidade, precoVenda) VALUES (3, 'Manga', 800, 4.00);


INSERT INTO Pessoa (idPessoa, nome, logradouro, cidade, estado, telefone, email) VALUES (7, 'Joao', 'Rua 12, casa 3, Quitanda', 'Riacho do Sul', 'PA', '1111-1111', 'email@example.com');


INSERT INTO PessoaFisica (idPessoaFisica, cpf) VALUES (7, '11111111111');


INSERT INTO Pessoa (idPessoa, nome, logradouro, cidade, estado, telefone, email) VALUES (15, 'JJC', 'Rua 11, Centro', 'Riacho do Norte', 'PA', '2222-2222', 'email@example.com');
INSERT INTO PessoaJuridica (idPessoaJuridica, cnpj) VALUES (15, '22222222222222');



INSERT INTO MovimentoVenda (idMovimentoVenda, idProduto, idComprador, idOperador, quantidade, precoUnitario) VALUES (1, 1, 7, 1, 20, 4.00);
INSERT INTO MovimentoVenda (idMovimentoVenda, idProduto, idComprador, idOperador, quantidade, precoUnitario) VALUES (4, 1, 7, 1, 15, 2.00);
INSERT INTO MovimentoVenda (idMovimentoVenda, idProduto, idComprador, idOperador, quantidade, precoUnitario) VALUES (5, 1, 7, 2, 10, 3.00);


INSERT INTO MovimentoCompra (idMovimentoCompra, idProduto, idFornecedor, idOperador, quantidade, precoUnitario) VALUES (7, 1, 15, 1, 15, 5.00);
INSERT INTO MovimentoCompra (idMovimentoCompra, idProduto, idFornecedor, idOperador, quantidade, precoUnitario) VALUES (8, 1, 15, 1, 20, 4.00);



SELECT * FROM Pessoa INNER JOIN PessoaFisica ON Pessoa.idPessoa = PessoaFisica.idPessoaFisica;


SELECT * FROM Pessoa INNER JOIN PessoaJuridica ON Pessoa.idPessoa = PessoaJuridica.idPessoaJuridica;




SELECT idProduto, SUM(quantidade * precoUnitario) AS TotalEntradas FROM MovimentoCompra GROUP BY idProduto;













-- Resultados


SELECT p.*, pf.cpf
FROM Pessoa p
INNER JOIN PessoaFisica pf ON p.idPessoa = pf.idPessoaFisica;


SELECT p.*, pj.cnpj
FROM Pessoa p
INNER JOIN PessoaJuridica pj ON p.idPessoa = pj.idPessoaJuridica;

SELECT 
    mc.idMovimentoCompra, 
    pr.nome AS NomeProduto, 
    p.nome AS NomeFornecedor, 
    mc.quantidade, 
    mc.precoUnitario, 
    (mc.quantidade * mc.precoUnitario) AS ValorTotal
FROM 
    MovimentoCompra mc
INNER JOIN 
    Produto pr ON mc.idProduto = pr.idProduto
INNER JOIN 
    PessoaJuridica pj ON mc.idFornecedor = pj.idPessoaJuridica
INNER JOIN 
    Pessoa p ON pj.idPessoaJuridica = p.idPessoa;


SELECT 
    mv.idMovimentoVenda, 
    pr.nome AS Produto, 
    p.nome AS Comprador, 
    mv.quantidade, 
    mv.precoUnitario, 
    (mv.quantidade * mv.precoUnitario) AS ValorTotal
FROM 
    MovimentoVenda mv
INNER JOIN 
    Produto pr ON mv.idProduto = pr.idProduto
INNER JOIN 
    PessoaFisica pf ON mv.idComprador = pf.idPessoaFisica
INNER JOIN 
    Pessoa p ON pf.idPessoaFisica = p.idPessoa;


SELECT pr.nome AS Produto, SUM(mc.quantidade * mc.precoUnitario) AS ValorTotalEntradas
FROM MovimentoCompra mc
INNER JOIN Produto pr ON mc.idProduto = pr.idProduto
GROUP BY pr.nome;


SELECT pr.nome AS Produto, SUM(mv.quantidade * mv.precoUnitario) AS ValorTotalSaidas
FROM MovimentoVenda mv
INNER JOIN Produto pr ON mv.idProduto = pr.idProduto
GROUP BY pr.nome;


SELECT u.*
FROM Usuario u
LEFT JOIN MovimentoCompra mc ON u.idOperador = mc.idOperador
WHERE mc.idMovimentoCompra IS NULL;

SELECT u.nome AS Operador, SUM(mc.quantidade * mc.precoUnitario) AS ValorTotalEntrada
FROM MovimentoCompra mc
INNER JOIN Usuario u ON mc.idOperador = u.idOperador
GROUP BY u.nome;


SELECT u.nome AS Operador, SUM(mv.quantidade * mv.precoUnitario) AS ValorTotalSaida
FROM MovimentoVenda mv
INNER JOIN Usuario u ON mv.idOperador = u.idOperador
GROUP BY u.nome;

SELECT pr.nome AS Produto, SUM(mv.quantidade * mv.precoUnitario) / SUM(mv.quantidade) AS PrecoMedioPonderado
FROM MovimentoVenda mv
INNER JOIN Produto pr ON mv.idProduto = pr.idProduto
GROUP BY pr.nome;


