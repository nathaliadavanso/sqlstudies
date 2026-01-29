-- =========================================================
-- APOSTILA (ALUNA) - SQL NO POSTGRES (PASSO A PASSO)
-- Tema: Sintaxe + Data Quality + Join (2 tabelas: customers e orders)
-- Como usar:
--   1) Rode o DDL (criar tabelas)
--   2) Insira os dados (dados “sujos” de propósito)
--   3) Siga os passos 1 → 10, rodando uma query por vez
-- =========================================================

-- =========================================================
-- 0) MACETES DO POSTGRES (muito úteis)
-- =========================================================
-- Se estiver no psql:
-- \dt                  -> lista tabelas
-- \dn                  -> lista schemas
-- \d customers         -> mostra colunas + tipos
-- \d+ orders           -> mais detalhes
--
-- Se estiver no DBeaver:
-- clique na tabela -> “Properties” / “Columns” / “DDL”

-- =========================================================
-- 1) CRIAR O AMBIENTE (DDL)
-- =========================================================
CREATE SCHEMA IF NOT EXISTS training;
SET search_path TO training;

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
  customer_id   BIGSERIAL PRIMARY KEY,
  full_name     TEXT NOT NULL,
  email         TEXT,
  phone         TEXT,
  birth_date    DATE,
  created_at    TIMESTAMP NOT NULL DEFAULT NOW(),
  is_active     BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE orders (
  order_id       BIGSERIAL PRIMARY KEY,
  customer_id    BIGINT,
  order_date     DATE NOT NULL,
  status         TEXT NOT NULL,
  amount         NUMERIC(12,2) NOT NULL,
  payment_method TEXT,
  created_at     TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Observação didática:
-- ainda NÃO colocamos FK/UNIQUE/CHECK para permitir "data quality" primeiro.


-- =========================================================
-- 2) INSERIR DADOS (com sujeira de propósito)
-- =========================================================
INSERT INTO customers (full_name, email, phone, birth_date, created_at, is_active) VALUES
('Ana Silva', 'ana.silva@email.com', '(41) 99999-1111', '1995-04-10', NOW() - INTERVAL '30 days', true),
('Bruno Lima', 'bruno.lima@email.com', NULL, '1989-02-20', NOW() - INTERVAL '10 days', true),
('Carla Souza', 'carla.souza@email.com', '41 98888-2222', NULL, NOW() - INTERVAL '5 days', true),

-- sujeiras:
('Carla Souza', 'carla.souza@email.com', '41 98888-2222', NULL, NOW() - INTERVAL '4 days', true), -- duplicada
('   Diego  Santos  ', 'DIEGO@EMAIL.COM', '41977773333', '2035-01-01', NOW() - INTERVAL '2 days', true), -- birth_date futura
('Eva', NULL, '41966665555', '1999-12-31', NOW() - INTERVAL '1 days', true), -- email nulo
('Felipe Nunes', 'felipe.nunes@email.com', '41955554444', '1990-07-12', NOW() - INTERVAL '20 days', false); -- inativo

INSERT INTO orders (customer_id, order_date, status, amount, payment_method, created_at) VALUES
(1, CURRENT_DATE - 7, 'paid', 120.50, 'credit_card', NOW() - INTERVAL '7 days'),
(1, CURRENT_DATE - 3, 'shipped', 89.90, 'pix', NOW() - INTERVAL '3 days'),
(2, CURRENT_DATE - 1, 'paid', 250.00, 'credit_card', NOW() - INTERVAL '1 day'),

-- sujeiras:
(999, CURRENT_DATE - 2, 'paid', 10.00, 'pix', NOW() - INTERVAL '2 days'),       -- customer_id inexistente
(3, CURRENT_DATE + 5, 'paid', 30.00, 'pix', NOW()),                             -- order_date no futuro
(2, CURRENT_DATE - 4, 'cancelled', -15.00, 'credit_card', NOW() - INTERVAL '4'),-- amount negativo
(2, CURRENT_DATE - 4, 'PAID', 15.00, 'cash', NOW() - INTERVAL '4'),             -- status inconsistente + payment inválido
(7, CURRENT_DATE - 8, 'paid', 55.00, 'pix', NOW() - INTERVAL '8');              -- pedido de cliente inativo


-- =========================================================
-- 3) SINTAXE BÁSICA: SELECT + FROM
-- =========================================================
-- Ideia:
-- SELECT = o que eu quero ver (colunas)
-- FROM   = de onde vem (tabela)

-- 3.1) Ver tudo (iniciante pode usar *)
SELECT *
FROM customers;

-- 3.2) Ver só algumas colunas (vírgula separa colunas!)
SELECT full_name, email
FROM customers;

-- 3.3) Exercício (faça você):
-- Traga customer_id, full_name, is_active da tabela customers
SELECT customer_id, full_name, is_active
FROM customers;
 -- duvida nath > precisa do ponto e virgula no final?

-- =========================================================
-- 4) WHERE (FILTRO)
-- =========================================================
-- WHERE = “com qual regra”
-- Regras importantes:
-- - Texto usa aspas simples: 'Ana Silva'
-- - Número não usa aspas: 1
-- - Boolean no Postgres: true/false

-- 4.1) Filtrar por boolean
SELECT *
FROM customers
WHERE is_active = true;

-- 4.2) Filtrar por texto (aspas simples!)
SELECT *
FROM customers
WHERE full_name = 'Ana Silva';

-- 4.3) Filtrar por número
SELECT *
FROM customers
WHERE customer_id = 1;

-- 4.4) Exercício:
-- Traga pedidos (orders) com amount > 100
select * 
from orders
where amount > 100


-- =========================================================
-- 5) OPERADORES (comparação)
-- =========================================================
-- =   igual
-- <>  diferente (padrão SQL)
-- !=  diferente (atalho, Postgres aceita)
-- > < >= <=  comparações numéricas

SELECT *
FROM orders
WHERE status <> 'paid';

SELECT *
FROM orders
WHERE amount >= 100;

-- Exercício:
-- Traga pedidos onde payment_method != 'pix'

select *
from orders 
where payment_method != 'pix'
-- =========================================================
-- 6) NULL (muito importante)
-- =========================================================
-- NULL não é um valor. É ausência.
-- Então NÃO use:
--   email = NULL
-- Use:
--   email IS NULL
--   email IS NOT NULL

SELECT *
FROM customers
WHERE email IS NULL;

SELECT *
FROM customers
WHERE email IS NOT NULL;

-- Exercício:
-- Traga customers que NÃO têm birth_date preenchida
select *
from customers 
where birth_date is null;
-- =========================================================
-- 7) ORDER BY (ordenar)
-- =========================================================
-- ORDER BY coluna ASC  (crescente / padrão)
-- ORDER BY coluna DESC (decrescente)

SELECT *
FROM orders
ORDER BY order_date DESC;

-- Exercício:
-- Liste customers por created_at do mais novo para o mais antigo
select * 
from orders 
order by created_at DESC;
-- =========================================================
-- 8) LIKE, ILIKE, NOT LIKE
-- =========================================================
-- LIKE  -> diferencia maiúscula/minúscula
-- ILIKE -> ignora maiúscula/minúscula (Postgres)
-- %     -> qualquer texto

SELECT *
FROM customers
WHERE full_name LIKE '%Silva%';

SELECT *
FROM customers
WHERE full_name ILIKE '%silva%';

SELECT *
FROM customers
WHERE email NOT LIKE '%@email.com';

-- EXERCÍCIO
-- Traga clientes cujo nome COMEÇA com 'Ana'
select *
from costumers
where full_name LIKE 'Ana%';
-- =========================================================
-- 9) AND / OR / NOT
-- =========================================================
SELECT *
FROM customers
WHERE is_active = true
  AND email IS NOT NULL;

SELECT *
FROM orders
WHERE status = 'paid'
   OR status = 'shipped';

-- EXERCÍCIO
-- Traga pedidos pagos OU com valor maior que 100

select *
from orders
where status = 'paid'
	or amount > 100
-- =========================================================
-- 10) JOIN (juntar as tabelas)
-- =========================================================
-- JOIN = juntar customers com orders
-- Regra: ON liga a chave certa:
-- customers.customer_id = orders.customer_id

SELECT
  c.customer_id,
  c.full_name,
  c.email,
  o.order_id,
  o.order_date,
  o.status,
  o.amount
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
ORDER BY o.order_date DESC;

-- 10.1) JOIN só para clientes ativos
SELECT
  c.full_name,
  o.order_id,
  o.amount
FROM customers c
JOIN orders o
  ON c.customer_id = o.customer_id
WHERE c.is_active = true;

-- 10.2) Exercício final:
-- Para cada cliente ativo, conte quantos pedidos ele tem.
-- (Dica: COUNT + GROUP BY)


-- =========================================================
-- 11) LIMPEZA DE TEXTO: regexp_replace (macete de Postgres)
-- =========================================================
-- Função:
-- regexp_replace(texto, padrão, substituição, flags)
--
-- Exemplo MAIS USADO:
-- regexp_replace(full_name, '\s+', ' ', 'g')
--
-- Leia em português:
-- '\s+' -> qualquer espaço em branco (1 ou mais)
-- ' '   -> substitui por UM espaço
-- 'g'   -> global (troca todas as ocorrências)
--
-- Dica:
-- use TRIM para tirar espaços do começo e fim
-- e lower() para padronizar email

-- Faça um SELECT * para verificar os nomes perceba que Diego Santos tem um espaço extra 
select full_name from customers;

UPDATE customers
SET
  full_name = regexp_replace(trim(full_name), '\s+', ' ', 'g'),
  email     = lower(trim(email))
WHERE true;

-- Exercício:
-- Rode um SELECT para ver como ficou o nome do “Diego  Santos”, dica use LIKE

SELECT *
FROM customers
WHERE full_name LIKE '%Santos%';

-- =========================================================
-- 12) TESTES PRÁTICOS (COMPLETE)
-- =========================================================
-- TESTE 1
-- Traga clientes ativos com email preenchido

select * 
from customers 
where is_active = true 
and email IS NOT NULL

-- TESTE 2
-- Traga pedidos com status diferente de 'cancelled'
select *
from orders
where status != 'cancelled'


-- TESTE 3
-- Traga clientes cujo nome contenha 'Souza'

select * 
from customers
where full_name like '%Souza%'
-- =========================================================
-- 13) TESTES FINAIS – ACHE O ERRO (SINTAXE)
-- =========================================================

-- ERRO 1
SELECT full_name email
FROM customers;
-- correto seria: select full_name, email from customers
-- ERRO 2
SELECT *
FROM customers
WHERE full_name = Ana Silva;
-- erro esta na falta de aspas no nome 
-- ERRO 3
SELECT *
FROM customers
WHERE email = NULL;
-- erro esta na função: IS NULL
-- ERRO 4
SELECT *
FROM customers is_active = true;
-- erro esta na falta da função where - where is active = true
-- ERRO 5
SELECT c.full_name, o.amount
FROM customers c
JOIN orders o
  ON c.customer_id = o.id;
-- não entendi esse
-- ERRO 6
SELECT *
FROM customers
WHERE full_name likE '%Silva%'
-- erro faltando  colocar o nome em aspas e com %
-- =========================================================
-- 14) DATA QUALITY (achando sujeira)
-- =========================================================

-- 14.1) Duplicidade de email
SELECT email, COUNT(*) AS qtd
FROM customers
WHERE email IS NOT NULL
GROUP BY email
HAVING COUNT(*) > 1;

-- 14.2) Datas de nascimento no futuro
SELECT *
FROM customers
WHERE birth_date IS NOT NULL
  AND birth_date > CURRENT_DATE;

-- 14.3) Pedidos com customer_id que não existe (FK quebrada na prática)
SELECT o.*
FROM orders o
LEFT JOIN customers c
  ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL;

-- 14.4) amount inválido
SELECT *
FROM orders
WHERE amount <= 0;

-- 14.5) order_date no futuro
SELECT *
FROM orders
WHERE order_date > CURRENT_DATE;

-- 14.6) Ver valores diferentes (domínio)
SELECT DISTINCT status FROM orders;
SELECT DISTINCT payment_method FROM orders;

