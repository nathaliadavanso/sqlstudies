-- =========================================================
-- APOSTILA – MÓDULO 2
-- GROUP BY, COUNT, SUM e JOIN
-- Banco: PostgreSQL
-- =========================================================
-- Pré-requisito:
-- Saber SELECT, FROM, WHERE, operadores e JOIN básico
--
-- Objetivo:
-- Entender AGREGAÇÃO de dados (resumo)
-- =========================================================


-- =========================================================
-- 1) O QUE É GROUP BY? (MODELO MENTAL)
-- =========================================================
-- GROUP BY serve para AGRUPAR linhas
-- e aplicar funções de agregação nelas.
--
-- Pense assim:
-- "Para cada X, calcule Y"
--
-- Exemplo em português:
-- "Para cada cliente, conte quantos pedidos ele fez"


-- =========================================================
-- 2) COUNT – CONTANDO LINHAS
-- =========================================================

-- 2.1) Contar todas as linhas da tabela
     

-- 2.2) Contar pedidos por cliente
SELECT
  customer_id,
  COUNT(*) AS total_pedidos
FROM training.orders o 
GROUP BY customer_id;

-- REGRA DE OURO:
-- Toda coluna no SELECT que NÃO é agregação
-- precisa estar no GROUP BY


-- =========================================================
-- 3) GROUP BY COM MAIS DE UMA COLUNA
-- =========================================================

SELECT
  customer_id,
  status,
  COUNT(*) AS qtd
FROM training.orders o 
GROUP BY customer_id, status;

-- Leia:
-- "Para cada cliente e status, conte pedidos"


-- =========================================================
-- 4) COUNT COM NULL (IMPORTANTE)
-- =========================================================
-- COUNT(*) conta linhas
-- COUNT(coluna) ignora NULL

SELECT COUNT(payment_method)
FROM training.orders 


-- =========================================================
-- 5) SUM – SOMANDO VALORES
-- =========================================================

-- 5.1) Soma total de vendas
SELECT SUM(amount)
FROM training.orders 

-- 5.2) Soma de vendas por cliente
SELECT
  customer_id,
  SUM(amount) AS total_gasto
FROM orders
GROUP BY customer_id;


-- =========================================================
-- 6) JOIN – JUNTANDO TABELAS 
-- =========================================================
-- JOIN é usado quando a informação que você quer
-- está espalhada em MAIS DE UMA TABELA.
--
-- Exemplo do mundo real:
-- • customers -> quem é a pessoa
-- • orders    -> o que ela comprou
--
-- Pergunta:
-- "Quais pedidos cada cliente fez?"
-- → Preciso juntar customers + orders


-- =========================================================
-- 6.1) MODELO MENTAL DO JOIN
-- =========================================================
-- JOIN = ligar tabelas por uma COLUNA EM COMUM
--
-- Essa coluna normalmente é:
-- • Primary Key em uma tabela
-- • Foreign Key na outra
--
-- No nosso caso:
-- customers.customer_id  = orders.customer_id
--
-- Leia em português:
-- "Junte customers com orders ONDE
--  o customer_id de customers é igual
--  ao customer_id de orders"


-- =========================================================
-- 6.2) SINTAXE BÁSICA DO JOIN
-- =========================================================
SELECT
  c.full_name,
  o.order_id,
  o.amount
FROM training.customers c 
JOIN training.orders o 
  ON c.customer_id = o.customer_id;

-- Regras importantes:
-- • JOIN SEMPRE vem depois do FROM
-- • ON define COMO as tabelas se ligam
-- • Nunca use JOIN sem ON (isso gera erro ou lixo)


-- =========================================================
-- 6.3) ALIAS (APELIDOS) – OBRIGATÓRIO NA PRÁTICA
-- =========================================================
-- Alias são apelidos para tabelas
-- customers -> c
-- orders    -> o
--
-- Isso:
-- FROM customers c
--
-- Evita:
-- • nomes longos
-- • ambiguidade de coluna
-- • erros em JOIN

--  ERRO comum:
-- SELECT customer_id
-- FROM customers
-- JOIN orders
-- ON customer_id = customer_id;
--
-- (Postgres não sabe de qual tabela é a coluna)


-- =========================================================
-- 6.4) INNER JOIN (JOIN PADRÃO)
-- =========================================================
-- Quando você escreve apenas JOIN,
-- o Postgres entende como INNER JOIN.
--
-- INNER JOIN retorna SOMENTE: registros que EXISTEM nas duas tabelas

SELECT
  c.full_name,
  o.amount
FROM training.customers c 
INNER JOIN training.orders o 
  ON c.customer_id = o.customer_id;

-- Leia:
-- "Traga apenas clientes que têm pedidos"


-- =========================================================
-- 6.5) LEFT JOIN (MUITO IMPORTANTE)
-- =========================================================
-- LEFT JOIN retorna:
-- • TODOS os registros da tabela da ESQUERDA
-- • Mesmo que não exista correspondência na direita
--
-- customers é a esquerda
-- orders é a direita

SELECT
  c.full_name,
  o.order_id,
  o.amount
FROM training.customers c 
LEFT JOIN training.orders o 
  ON c.customer_id = o.customer_id;

-- Leia:
-- "Traga todos os clientes,
--  mesmo os que não fizeram pedidos"


-- =========================================================
-- 6.6) COMO ESCOLHER ENTRE INNER JOIN E LEFT JOIN (SEM AMBIGUIDADE)
-- =========================================================
-- Regra prática (guarde isso):
--
-- INNER JOIN:
-- • Retorna APENAS registros que existem NAS DUAS tabelas
-- • Registros sem correspondência SÃO DESCARTADOS
--
-- LEFT JOIN:
-- • Retorna TODOS os registros da tabela da ESQUERDA
-- • Mesmo que NÃO exista correspondência na tabela da DIREITA
--
-- Pense assim:
--
-- "Minha tabela principal é a da esquerda?"
-- → use LEFT JOIN
--
-- "Só me importo com registros que existem nas duas?"
-- → use INNER JOIN
--
-- Exemplos em português:
--
-- INNER JOIN:
-- "Quero apenas clientes que fizeram pedidos"
--
-- LEFT JOIN:
-- "Quero todos os clientes, mesmo os que não fizeram pedidos"


-- =========================================================
-- 6.7) JOIN + WHERE 
-- =========================================================
-- ATENÇÃO:
-- WHERE filtra DEPOIS do JOIN
--
-- Esse filtro transforma LEFT JOIN em INNER JOIN sem você perceber!

--  ERRO:
SELECT
  c.full_name,
  o.amount
FROM training.customers c 
LEFT JOIN training.orders o 
  ON c.customer_id = o.customer_id
WHERE o.amount > 100;

-- Isso REMOVE clientes sem pedidos.

--  CORRETO:
SELECT
  c.full_name,
  o.amount
FROM training.customers c 
LEFT JOIN training.orders o 
  ON c.customer_id = o.customer_id
 AND o.amount > 100;

-- Leia:
-- "Traga todos os clientes,
--  e apenas pedidos acima de 100 quando existirem"


-- =========================================================
-- 6.8) JOIN + GROUP BY (CASO REAL)
-- =========================================================
SELECT
  c.full_name,
  COUNT(o.order_id) AS total_pedidos,
  SUM(o.amount)     AS total_gasto
FROM training.customers c 
LEFT JOIN training.orders o 
  ON c.customer_id = o.customer_id
GROUP BY c.full_name;

-- Leia:
-- "Para cada cliente, conte pedidos e some valores"


-- =========================================================
-- 6.9) ERROS MAIS COMUNS COM JOIN
-- =========================================================

-- ERRO 1: JOIN sem ON
-- JOIN orders;

-- ERRO 2: Coluna errada no ON
-- ON c.customer_id = o.order_id;

-- ERRO 3: Esquecer alias
-- SELECT customer_id FROM customers JOIN orders ON ...

-- ERRO 4: Usar WHERE em coluna da tabela da direita no LEFT JOIN

-- ERRO 5: Confundir JOIN com UNION (não são a mesma coisa)


-- =========================================================
-- 6.10) EXERCÍCIOS DE JOIN (PRÁTICA)
-- =========================================================

-- 1) Traga nome do cliente e id do pedido

select c.full_name,
		o.order_id 
from training.customers c 
join training.orders o 
on c.customer_id = o.order_id 



-- 2) Traga todos os clientes, mesmo os que não têm pedidos -- obs nath> aqui eu coloquei left join pois na explicacao ela diz que ele tb traz os nulolas mas que o principal e a tabela da esquerda que e a de customers

select c.customer_id,
		c.full_name,
		o.customer_id 
from training.customers c 
left join training.orders o 
on c.customer_id = o.customer_id 



-- 3) Traga apenas clientes que têm pedidos - obs nath: pensei em colocar inner pois, quero algo que tenha nas 2 tabelas 

select 
    c.customer_id,
    c.full_name,
    o.amount,
    o.order_id
from training.customers c
inner join training.orders o
    on c.customer_id = o.customer_id
order by o.order_id;


-- 4) Traga clientes ativos e seus pedidos obs nath: coloquei inner porque quero algo qe tenha nas 2 tabeas: clien tes ativos e pedidos


select c.full_name,
	   c.customer_id,
	   c.is_active,
	   o.customer_id
from training.customers c 
join training.orders o 
on c.customer_id = o.customer_id 
and c.is_active is true



-- 5) Conte quantos pedidos cada cliente fez

select c.customer_id,
	   c.full_name,
	   count (o.order_id) as totalpedidos
from training.customers c 
join training.orders o
on c.customer_id = o.customer_id 
group by c.customer_id,
		c.full_name 
		

-- 6) Some o valor total gasto por cliente

		
select  c.full_name,
		sum (o.amount)
from training.customers c  
join training.orders o 
on c.customer_id = o.customer_id 
group by c.full_name

		
-- 7) Traga clientes com mais de 2 pedidos


select count (o.order_id) as totalpedidos,
		c.full_name,
		c.customer_id 
from training.customers c 
join training.orders o 
on c.customer_id = o.customer_id 
group by c.customer_id,
	c.full_name 
having count (o.order_id ) > 2
	
	


-- 8) Traga clientes que não fizeram nenhum pedido


select c.full_name,
	c.customer_id,
	o.order_id
from training.customers c 
left join training.orders o 
on c.customer_id = o.customer_id 
where o.order_id is null 



-- 9) Traga clientes com pedidos acima de 100

select 
		c.full_name,
		c.customer_id,
		o.amount 
from training.customers c 
 join training.orders o 
on c.customer_id = o.customer_id 
where o.amount > 100

-- 10) Traga nome do cliente e total gasto,
--     mesmo que ele não tenha pedido (valor 0)







-- Dica:
-- Para o exercício 10, use LEFT JOIN + COALESCE



-- =========================================================
-- 7) WHERE x HAVING (MUITO IMPORTANTE)
-- =========================================================
-- WHERE filtra linhas ANTES do GROUP BY
-- HAVING filtra resultados DEPOIS do GROUP BY

-- Exemplo:
-- clientes com mais de 2 pedidos

SELECT
  customer_id,
  COUNT(*) AS total_pedidos
FROM training.orders
GROUP BY customer_id
HAVING COUNT(*) > 2;


-- =========================================================
-- 8) ERROS COMUNS
-- =========================================================
-- ERRO:
-- SELECT customer_id, amount, SUM(amount)
-- FROM orders
-- GROUP BY customer_id;

-- Correto:
-- amount precisa estar no GROUP BY ou ser agregado


-- =========================================================
-- 9) EXERCÍCIOS (50 NO TOTAL)
-- =========================================================
-- Resolva na ordem. Não pule.


-- ======================
-- BLOCO A – COUNT (1–15)
-- ======================

-- 1) Conte quantos pedidos existem na tabela orders  > obs nath: coluna que conta os pedidos é a order id

select count (order_id)
from training.orders o 

-- 2) Conte quantos clientes existem > obs nath: coluna que conta os pedidos é a costumer id

select count (c.customer_id )
from customers c 

-- 3) Conte quantos pedidos cada cliente fez  obs nath: quantos pedidos > order id, cada cliente: cosutmer id e full name, pra juntar as duas precisa do join, ligo pela chave primaria costumer id do customers com a costumer id da orders, depois separo o count para contar e coloco todo resto no group by, porque tudo que nao e agregacao precisa do group by

select c.customer_id,
		c.full_name,
		count (o.order_id)
from training.customers c 
join orders o 
on c.customer_id = o.customer_id 
group by c.customer_id,
		c.full_name

		
-- 4) Conte quantos pedidos existem por status obs nath: selecionei a tabela orders e foquei em selecionar a coluna de status e contei a de orders, agrupei por status 
		
select status,
	count (order_id) as pedioporstatus
from training.orders
group by status



-- 5) Conte quantos pedidos existem por cliente e status > obs nath: trouxe o memso raciociono do de cima só juntei com a por cliente

		
select 
    c.customer_id,
    c.full_name,
    o.status,
    count(o.order_id) as total_pedidos
from training.customers c 
join training.orders o 
    on c.customer_id = o.customer_id 
group by 
    c.customer_id,
    c.full_name,
    o.status
order by 
    c.customer_id,
    o.status



-- 6) Conte quantos pedidos têm payment_method preenchido obs nath: primeira tentativa nao havia interpretado corretamente o enunciado
    
    
 select o.payment_method,
 		order_id,
		count (o.order_id)
 from  training.orders o 
 group by o.payment_method,
 			o.order_id 
 having o.payment_method is not null
 
 
 select 
    count(*) as total_pedidos_com_payment
from training.orders o
where o.payment_method is not null;

-- 7) Conte quantos pedidos têm payment_method NULL

select 
	count (*) as totalpedidospayment
	from training.orders o 
	where o.payment_method is null

-- 8) Conte quantos clientes estão ativos
	
select 
	count (*) as clientesativos
	from training.customers c 
	where c.is_active is true

-- 9) Conte quantos clientes estão inativos
	
	select 
	count (*) as clientesinativos
	from training.customers c 
	where c.is_active is false


-- 10) Conte quantos clientes têm email preenchido
	
	select 
		count (*) as emailpreenchido
	from training.customers c 
	where c.email is not null

-- 11) Conte quantos pedidos cada cliente ativo fez

	
select c.customer_id,
		c.full_name,
		count (o.order_id) pedidosporcliente
from training.customers c 
join orders o 
on c.customer_id = o.customer_id 
group by c.customer_id,
		c.full_name
having c.is_active is true

	
-- 12) Conte quantos pedidos existem com valor maior que 100

select count (*) 
from training.orders o 
where o.amount > 100

-- 13) Conte quantos pedidos existem por dia

select o.order_date,
		count (order_id)
from training.orders o 
group by o.order_date 

-- 14) Conte quantos pedidos cada cliente fez apenas com status 'paid' obs nath: primeiro fiz cm having e depoois com  where pra entender a dif

select c.customer_id,
	   c.full_name, 
	   o.status,
	   count (o.order_id) qntdepedidos
from training.customers c 
join training.orders o 
on c.customer_id = o.customer_id 
group by c.customer_id,
		 c.full_name,
		 o.status
having status = 'paid'      


select c.customer_id,
	   c.full_name, 
	   count (o.order_id) qntdepedidos
from training.customers c 
join training.orders o 
on c.customer_id = o.customer_id 
where o.status = 'paid'
group by c.customer_id,
		 c.full_name
		

-- 15) Conte quantos clientes fizeram pelo menos 2 pedidos  obs nath: aqui nao entendi como eu contaria, tna primeira tentativa conseugi saber quais, e na segun da tentei trazer quantos mas não entendi 
		 
select c.customer_id,
		c.full_name,
		count (o.order_id) as qtdepedidoporcliente
from training.customers c 
join orders o 
on c.customer_id = o.customer_id 
group by c.customer_id,
		c.full_name
having count (o.order_id) >= 2



select count(distinct c.customer_id)
from training.customers c
join training.orders o 
    on c.customer_id = o.customer_id
group by c.customer_id
having count(o.order_id) >= 2;



-- ======================
-- BLOCO B – SUM (16–30)
-- ======================

-- 16) Some o valor total de todos os pedidos

select sum (o.amount)
from training.orders o 

-- 17) Some o valor total por cliente

select
	c.full_name,
	c.customer_id,
	sum (o.amount) as totalpedido
from training.customers c 
join training.orders o 
on c.customer_id = o.customer_id 
group by
	c.full_name,
	c.customer_id 
order by sum (o.amount) desc


-- 18) Some o valor total apenas de pedidos pagos

select
	sum (o.amount )
from training.orders o 
where o.status = 'paid'


-- 19) Some o valor total por status

select 
	o.status,
	sum (o.amount)
from training.orders o 
group by o.status

-- 20) Some o valor total por cliente e status

select
	c.full_name,
	c.customer_id,
	o.status,
	sum (o.amount) as totalpedido
from training.customers c 
join training.orders o 
on c.customer_id = o.customer_id 
group by
	c.full_name,
	c.customer_id,
	o.status
order by sum (o.amount) desc

-- 21) Some o valor total apenas de clientes ativos

select
	c.full_name,
	c.customer_id,
	c.is_active, 
	sum (o.amount) as totalpedido
from training.customers c 
join training.orders o 
on c.customer_id = o.customer_id 
where c.is_active is true
group by
	c.full_name,
	c.customer_id,
	c.is_active 
order by sum (o.amount) desc


-- 22) Some o valor total apenas de pedidos acima de 100

select 
	sum (o.amount)
from training.orders o 
where o.amount > 100

-- 23) Some o valor total por dia


select 
	o.order_date,
	sum (o.amount) as valortotaldia
from training.orders o 
group by o.order_date
order by o.order_date desc


-- 24) Some o valor total de pedidos com payment_method = 'pix'

select 
	sum (o.amount)
from training.orders o 
where o.payment_method = 'pix'

-- 25) Some o valor total de pedidos com payment_method NULL

select 
	sum (o.amount) as totalpagamentos
from training.orders o 
where o.payment_method is null


-- 26) Some o valor total por cliente ordenando do maior para o menor

select
	c.full_name,
	c.customer_id, 
	sum (o.amount) as totalpedido
from training.customers c 
join training.orders o 
on c.customer_id = o.customer_id 
group by
	c.full_name,
	c.customer_id
order by sum (o.amount) desc
	

-- 27) Some o valor total apenas de clientes que gastaram mais de 200

select
	c.full_name,
	c.customer_id, 
	sum (o.amount) as totalpedido
from training.customers c 
join training.orders o 
on c.customer_id = o.customer_id 
group by
	c.full_name,
	c.customer_id
having sum (o.amount) >= 200
order by totalpedido desc


-- 28) Some o valor total por cliente e filtre apenas quem gastou mais de 150


select
	c.full_name,
	c.customer_id, 
	sum (o.amount) as totalpedido
from training.customers c 
join training.orders o 
on c.customer_id = o.customer_id 
group by
	c.full_name,
	c.customer_id
having sum (o.amount) > 150
order by totalpedido desc



-- 29) Some o valor total de pedidos excluindo status 'cancelled'

select
	sum (o.amount) as totalpedido
from training.orders o 
where o.status != 'cancelled'

-- 30) Some o valor total de pedidos apenas do último mês  -- obs nath: esse tive que recorrer ao chat pois nunca exercitei funcoes de data no postgress

select
    sum(o.amount) as total_ultimo_mes
from training.orders o
where o.order_date >= current_date - interval '1 month';


-- ======================
-- BLOCO C – JOIN + GROUP BY (31–45)
-- ======================

-- 31) Traga nome do cliente e quantidade de pedidos

select 
	c.full_name,
	c.customer_id,
	count (order_id) as qntdepedido
from training.customers c 
join training.orders o 
on c.customer_id = o.customer_id 
group by 
	c.full_name,
	c.customer_id
order by qntdepedido desc


-- 32) Traga nome do cliente e valor total gasto

select 
	c.full_name,
	c.customer_id,
 	sum (o.amount) as totalgasto
 from training.customers c 
 join training.orders o 
 on c.customer_id = o.customer_id 
 group by 
 	c.full_name,
 	c.customer_id 
order by totalgasto desc



-- 33) Traga nome do cliente, quantidade de pedidos e valor total

select 
	c.full_name,
	c.customer_id,
	count (o.order_id) as qtdepedidos,
	sum (o.amount) as valortotalpedido
from training.customers c 
join training.orders o 
on c.customer_id = o.customer_id 
group by 
	c.full_name,
   	c.customer_id
 order by qtdepedidos desc


-- 34) Traga apenas clientes ativos com quantidade de pedidos

select 
	c.customer_id,
	c.full_name,
	count (o.order_id) qntdepedidos
from training.customers c
join training.orders o 
on c.customer_id = o.customer_id 
where c.is_active is true
group by c.customer_id,
	c.full_name
order by qntdepedidos desc
 
 

-- 35) Traga apenas clientes ativos com valor total gasto


select 
	c.customer_id,
	c.full_name,
	sum (o.amount) totalgasto
from training.customers c
join training.orders o 
on c.customer_id = o.customer_id 
where c.is_active is true
group by c.customer_id,
	c.full_name
order by totalgasto desc


-- 36) Traga clientes com mais de 2 pedidos


select 
	c.customer_id,
	c.full_name,
	count (o.order_id) totalpedidos
from training.customers c
join training.orders o 
on c.customer_id = o.customer_id 
group by c.customer_id,
	c.full_name
having count (o.order_id) >= 2
order by totalpedidos desc


-- 37) Traga clientes que gastaram mais de 300

select 
	c.customer_id,
	c.full_name,
	sum (o.amount) totalgasto
from training.customers c
join training.orders o 
on c.customer_id = o.customer_id 
group by c.customer_id,
	c.full_name
having sum (o.amount) >= 300
order by totalgasto desc


-- 38) Traga clientes e total gasto ordenado do maior para o menor

select 
	c.customer_id,
	c.full_name,
	sum (o.amount) totalgasto
from training.customers c
join training.orders o 
on c.customer_id = o.customer_id 
group by c.customer_id,
	c.full_name
order by totalgasto desc


-- 39) Traga clientes e total gasto apenas de pedidos pagos


select 
	c.customer_id,
	c.full_name,
	sum (o.amount) totalgasto
from training.customers c 
join training.orders o 
on c.customer_id = o.customer_id 
where o.status = 'paid'
group by 
		c.customer_id,
	    c.full_name
order by totalgasto desc


-- 40) Traga clientes e total gasto apenas de pedidos não cancelados

select 
	c.customer_id,
	c.full_name,
	sum (o.amount) totalgasto
from training.customers c 
join training.orders o 
on c.customer_id = o.customer_id 
where o.status != 'cancelled'
group by 
		c.customer_id,
	    c.full_name
order by totalgasto desc


-- 41) Traga clientes e total gasto por status


select 
    c.customer_id,
    c.full_name,
    o.status,
    sum(o.amount) as totalgasto
from training.customers c 
join training.orders o 
    on c.customer_id = o.customer_id 
group by 
    c.customer_id,
    c.full_name,
    o.status
order by 
    c.customer_id,
    o.status;


-- 42) Traga clientes e total gasto apenas com paymen

-- 43) Traga clientes e total gasto apenas com payment_method NULL

select 
    c.customer_id,
    c.full_name,
    sum(o.amount) as totalgasto
from training.customers c
join training.orders o 
    on c.customer_id = o.customer_id
where 
    o.payment_method is null
group by 
    c.customer_id,
    c.full_name
order by 
    totalgasto desc;


-- 44) Traga clientes com pedidos acima da média de valor  --- nao sabia fazer essa e pedi ajuda pro chat, tinha tentado da primeira forma antes -- atencao

select 
	c.full_name,
	c.customer_id, 
	AVG (o.amount) as mediavalor
from training.customers c 
join training.orders o 
on c.customer_id = o.customer_id 
group by 
	c.full_name,
	c.customer_id
having > AVG (o.amount) --???????



select distinct
    c.customer_id,
    c.full_name
from training.customers c 
join training.orders o 
    on c.customer_id = o.customer_id 
where 
    o.amount > (select avg(amount) from training.orders);



-- 45) Traga clientes com pelo menos 1 pedido e valor total maior que 100



select  
	c.full_name,
	c.customer_id, 
	count (o.order_id) as totalpedido,
	sum (o.amount) as totalgasto
from training.customers c 
join training.orders o 
on c.customer_id = o.customer_id 
where o.order_id >= 1
group by 
	c.full_name,
	c.customer_id
having count (o.order_id) >= 1 and sum (o.amount) >= 100
order by totalpedido desc

-- ======================
-- BLOCO D – DESAFIOS (46–50)
-- ======================

-- 46) Para cada cliente ativo, mostre:
-- nome, quantidade de pedidos e total gasto

select 
	c.full_name,
	c.customer_id,
	count (o.order_id) as qntdepedidos,
	sum (o.amount) as totalgasto
from training.customers c 
join training.orders o 
on c.customer_id = o.customer_id 
where c.is_active is true
group by c.full_name,
	c.customer_id
order by qntdepedidos desc

-- 47) Traga apenas clientes ativos que fizeram mais de 1 pedido

select 
	c.customer_id,
	count (o.order_id) as qntdepedidos
from training.customers c 
join training.orders o 
on c.customer_id = o.customer_id 
where c.is_active is true
group by c.full_name,
	c.customer_id
having count (o.order_id) > 1
order by qntdepedidos desc

-- 48) Traga clientes cujo total gasto é maior que a média geral  -- esse nao consegui aplicar os conceitos pois não vi aqui nos exercicios






-- 49) Traga clientes com pedidos em mais de um status diferente -- esse epi ajuda pois nao sabia como usar distinct, saboia que tinha distinct mas nao sabia se colocava no inicio do select 


select 
	c.full_name,
	c.customer_id,
	count (distinct o.order_id) as statusdiferentes
from training.customers c 
join training.orders o 
on c.customer_id = o.customer_id 
where c.is_active is true
group by c.full_name,
	c.customer_id
having count (distinct o.order_id) > 1
order by statusdiferentes desc




-- 50) Traga o cliente que mais gastou (top 1)

select 
	c.full_name,
	c.customer_id,
	sum (o.amount) as totalgasto
from training.customers c 
join training.orders o 
on c.customer_id = o.customer_id 
group by c.full_name,
	c.customer_id
order by totalgasto desc
limit 1

