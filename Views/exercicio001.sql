CREATE TABLE ALUNO (
    matricula INT PRIMARY KEY,
    nome VARCHAR(50),
    sexo VARCHAR(10)
);

CREATE TABLE DISCIPLINA (
    codigo INT PRIMARY KEY,
    nome VARCHAR(50),
    creditos INT
);

CREATE TABLE CURSA (
    matricula INT REFERENCES ALUNO(matricula),
    codigo INT REFERENCES DISCIPLINA(codigo),
    semestreAno VARCHAR(10),
    nota DECIMAL(3,1),
    falta INT,
    PRIMARY KEY (matricula, codigo, semestreAno)
);

INSERT INTO ALUNO (matricula, nome, sexo) VALUES
(1, 'João Silva', 'Masculino'),
(2, 'Maria Santos', 'Feminino'),
(3, 'Carlos Lima', 'Masculino'),
(4, 'Ana Oliveira', 'Feminino'),
(5, 'Pedro Souza', 'Masculino'),
(6, 'Sofia Alves', 'Feminino'),
(7, 'Rafael Pereira', 'Masculino'),
(8, 'Luana Fernandes', 'Feminino'),
(9, 'Lucas Rodrigues', 'Masculino'),
(10, 'Beatriz Costa', 'Feminino');

INSERT INTO DISCIPLINA (codigo, nome, creditos) VALUES
(1, 'Estrutura de Dados', 4),
(2, 'Projeto Integrador', 4),
(3, 'Orientação a Objetos', 4),
(4, 'Requisitos de Software', 2),
(5, 'Sistema de Banco de Dados', 4);

INSERT INTO CURSA (matricula, codigo, semestreAno, nota, falta) VALUES
(1, 1, '1/2021', 8.5, 0),
(2, 1, '1/2021', 9.0, 1),
(3, 2, '1/2021', 7.8, 2),
(4, 3, '2/2021', 9.5, 0),
(5, 4, '2/2021', 7.0, 3),
(6, 5, '2/2021', 8.0, 0),
(7, 3, '1/2022', 8.5, 1),
(8, 4, '1/2022', 7.5, 0),
(9, 5, '2/2022', 9.5, 1),
(10, 2, '2/2022', 8.0, 1);

-- 1. View para determinar o número de alunos matriculados em cada disciplina
CREATE VIEW NumeroAlunosPorDisciplina AS
SELECT 
    d.nome AS disciplina,
    COUNT(c.matricula) AS total_alunos
FROM 
    DISCIPLINA d
JOIN 
    CURSA c ON d.codigo = c.codigo
GROUP BY 
    d.nome;

-- 2. View para calcular a média geral das notas dos alunos em cada disciplina
CREATE VIEW MediaNotasPorDisciplina AS
SELECT 
    d.nome AS disciplina,
    ROUND(AVG(c.nota), 2) AS media_notas
FROM 
    DISCIPLINA d
JOIN 
    CURSA c ON d.codigo = c.codigo
GROUP BY 
    d.nome;

-- 3. View para calcular a média de faltas dos alunos em cada disciplina
CREATE VIEW MediaFaltasPorDisciplina AS
SELECT 
    d.nome AS disciplina,
    ROUND(AVG(c.falta), 2) AS media_faltas
FROM 
    DISCIPLINA d
JOIN 
    CURSA c ON d.codigo = c.codigo
GROUP BY 
    d.nome;


SELECT * FROM NumeroAlunosPorDisciplina;

SELECT * FROM MediaNotasPorDisciplina;

SELECT * FROM MediaFaltasPorDisciplina;
