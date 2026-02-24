-- =========================================================
-- APOSTILA – MÓDULO 3
-- SQL PARA ENTREVISTAS
-- Banco: PostgreSQL
-- =========================================================
-- Objetivo:
-- Aprender a responder perguntas de SQL em entrevistas
-- com clareza, lógica e segurança.
--
-- Aqui o foco NÃO é decorar função.
-- É mostrar raciocínio.
-- =========================================================


-- =========================================================
-- 1) COMO ENTREVISTADORES AVALIAM SQL
-- =========================================================
-- Eles observam:
-- • você sabe ler o problema?
-- • você escolhe JOIN correto?
-- • você entende GROUP BY?
-- • você sabe tratar NULL?
-- • você sabe explicar sua query?
--
-- Regra de ouro:
-- Uma query simples + correta > query complexa + errada


-- =========================================================
-- 2) PEGADINHA CLÁSSICA: COUNT(*), COUNT(coluna)
-- =========================================================

-- Pergunta comum:
-- "Qual a diferença entre COUNT(*) e COUNT(coluna)?"

SELECT COUNT(*) FROM training.orders 
SELECT COUNT(payment_method) FROM training.orders 

-- Explique:
-- COUNT(*) conta linhas
-- COUNT(coluna) ignora NULL


-- =========================================================
-- 3) WHERE x HAVING (CAI MUITO)
-- =========================================================
-- WHERE filtra linhas ANTES do GROUP BY
-- HAVING filtra grupos DEPOIS do GROUP BY

-- Pergunta:
-- "Traga clientes com mais de 2 pedidos"

SELECT customer_id, COUNT(*) AS total
FROM orders
GROUP BY customer_id
HAVING COUNT(*) > 2;


-- =========================================================
-- 4) JOIN x LEFT JOIN (PERGUNTA CLÁSSICA)
-- =========================================================
-- Pergunta:
-- "Por que meus dados sumiram?"

-- INNER JOIN (JOIN)
-- Retorna apenas registros existentes nas duas tabelas

SELECT c.full_name, o.amount
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id;

-- LEFT JOIN
-- Retorna todos da tabela da esquerda

SELECT c.full_name, o.amount
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id;


-- =========================================================
-- 5) PEGADINHA: LEFT JOIN + WHERE
-- =========================================================
-- Essa pergunta elimina MUITA gente

-- ERRADO (vira INNER JOIN):
SELECT c.full_name, o.amount
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
WHERE o.amount > 100;

--  CORRETO:
SELECT c.full_name, o.amount
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
 AND o.amount > 100;


-- =========================================================
-- 6) NULL EM ENTREVISTA (CAI SEMPRE)
-- =========================================================

--  ERRADO:
-- WHERE email = NULL

-- CERTO:
SELECT *
FROM customers
WHERE email IS NULL;

SELECT *
FROM customers
WHERE email IS NOT NULL;


-- =========================================================
-- 7) LIKE x ILIKE (POSTGRES)
-- =========================================================
-- Pergunta:
-- "Como buscar texto ignorando maiúscula/minúscula?"

SELECT *
FROM customers
WHERE full_name ILIKE '%silva%';

SELECT *
FROM customers
WHERE full_name lIKE '%silva%';

-- Explique:
-- LIKE diferencia
-- ILIKE ignora


-- =========================================================
-- 8) DISTINCT (OUTRA CLÁSSICA)
-- =========================================================

-- Pergunta:
-- "Quantos status diferentes existem?"

SELECT DISTINCT status
FROM orders;

-- Ou:
SELECT COUNT(DISTINCT status)
FROM orders;


-- =========================================================
-- 9) AGREGAÇÃO + JOIN (CASO REAL)
-- =========================================================
-- Pergunta:
-- "Quanto cada cliente gastou?"

SELECT
  c.full_name,
  SUM(o.amount) AS total_gasto
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name;


-- =========================================================
-- 10) SUBQUERY SIMPLES (CAI MUITO)
-- =========================================================
-- Pergunta:
-- "Clientes que gastaram acima da média"

SELECT c.full_name
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
GROUP BY c.full_name
HAVING SUM(o.amount) > (
  SELECT AVG(amount)
  FROM orders
);


-- =========================================================
-- 11) ORDER BY x GROUP BY (CONFUSÃO COMUM)
-- =========================================================
-- ORDER BY ordena o resultado final
-- GROUP BY agrupa

SELECT customer_id, SUM(amount) AS total
FROM orders
GROUP BY customer_id
ORDER BY total DESC;


-- =========================================================
-- 12) PERGUNTA DE RACIOCÍNIO (SEM CÓDIGO)
-- =========================================================
-- "Você prefere WHERE ou HAVING para filtrar status?"
--
-- Resposta esperada:
-- WHERE, porque filtra antes da agregação
-- HAVING só quando envolve função agregada


-- =========================================================
-- 13) TESTES DE ENTREVISTA (FAÇA COMO SE FOSSE AO VIVO)
-- =========================================================

-- TESTE 1
-- Traga clientes que NÃO têm pedidos

select 
    c.customer_id,
    c.full_name
from training.customers c 
left join training.orders o 
    on c.customer_id = o.customer_id 
where 
    o.order_id is null;

-- TESTE 2
-- Traga clientes com mais de 3 pedidos

select 
    c.customer_id,
    c.full_name,
    count (o.order_id) as qntdepedidos
from training.customers c 
join training.orders o 
    on c.customer_id = o.customer_id 
group by
	c.customer_id,
    c.full_name
 having  count (o.order_id) > 3
 order by qntdepedidos desc
	


-- TESTE 3
-- Traga o cliente que mais gastou
 
select 
    c.customer_id,
    c.full_name,
   sum (o.amount) as totalgasto
from training.customers c 
join training.orders o 
    on c.customer_id = o.customer_id 
group by
	c.customer_id,
    c.full_name
 order by totalgasto desc
 limit 1 
 

-- TESTE 4
-- Traga clientes cujo total gasto é maior que a média  -- preciso aprender subquerie
 
 
 

-- TESTE 5
-- Traga quantidade de pedidos por status,
 
 select o.status,
 		count (o.order_id) as qntdepedidos
 from training.orders o 
 group by o.status 
 order by qntdepedidos desc
 
 
 
-- ordenando do maior para o menor

-- =========================================================
-- 14) ACHE O ERRO (ENTREVISTA REAL)
-- =========================================================

-- ERRO 1  -- faltou colocar o amount no group by
SELECT customer_id, amount, SUM(amount)
FROM orders
GROUP BY customer_id;

-- ERRO 2 -- não é = nul e sim is null ou is not null
SELECT *
FROM customers
WHERE email = NULL;

-- ERRO 3 -- uspu where e era pra usar and 
SELECT c.full_name
FROM customers c
LEFT JOIN orders o
  ON c.customer_id = o.customer_id
WHERE o.amount > 50;

-- ERRO 4 -- faltou colocar distinct 
SELECT COUNT(distinct status)
FROM orders;

-- Pergunta:
-- Essa query conta o quê exatamente?

-- =========================================================
-- 15) COMO EXPLICAR SUA QUERY (DICA FINAL)
-- =========================================================
-- Sempre explique assim:
--
-- 1) De onde vêm os dados (FROM / JOIN)
-- 2) Quais filtros aplicou (WHERE)
-- 3) Como agrupou (GROUP BY)
-- 4) O que calculou (COUNT / SUM)
-- 5) Qual regra final (HAVING / ORDER BY)