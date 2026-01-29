select "IdProduto", "DescNomeProduto" 
from training.produtos


-- exercicios aula 09 

--1) selecione todos os clientes com email cadastrado 

select *
from training.clientes
where "flEmail" = 1

-- 2) selecione todas as transações de 50 pontos exatos

select * 
from training.transacoes t 
where "QtdePontos" = 50

-- 3) selecione todos os clientes com mais de 500 pontos

select * 
from training.clientes c 
where "qtdePontos" >= 500

--4) selecione produtos que contém churn no nome

select * 
from training.produtos p 
where "DescNomeProduto" like '%Churn%'

-- obs: aqui poderia usar or or or e inserir o nome de cada valor, ou in e colocar entre parenteses


-- pratica aula - adc colunas 

-- 1) adc +10 pontos 

select *,
	"qtdePontos" + 10 
from training.clientes c 

 -- 1.2) adc mais uma coluna modificada

select *,
	"qtdePontos" + 10, 
	"qtdePontos" * 2 
from training.clientes c 

-- 1.3) filtrando menos colunas na consulta 

select 
	"idCliente",
	"qtdePontos",
	"qtdePontos" + 10 as QtdePontosPlus10, 
	"qtdePontos" * 2 as QtdePontosX10 
from training.clientes c 


--1.4) moficiando coluna de data texto para data-hora - dificuldade maior, 40% entedimento

select 
	"idCliente",
	--"qtdePontos",
	--"qtdePontos" + 10 as QtdePontosPlus10, 
	--"qtdePontos" * 2 as QtdePontosX10,
	"DtCriacao",
	substr ("DtCriacao",1,19) as dtsubstring
from training.clientes c 

select 
	"idCliente",
	--"qtdePontos",
	--"qtdePontos" + 10 as QtdePontosPlus10, 
	--"qtdePontos" * 2 as QtdePontosX10,
	"DtCriacao",
	date( substr("DtCriacao",1,19))as dtcriacaonova
from training.clientes c 



-- exercicios aula 10 

-- 1) lista de transações com apenas 1 ponto

select 
	"IdTransacao",
	"QtdePontos"
from training.transacoes t 
where "QtdePontos" = 1


--2) lista de pedidos realizados no fim de semana --- não sei fazer esse, colei do chatgpt 

select 
	"IdTransacao",
	"DtCriacao",
	to_char("DtCriacao"::timestamp, 'Day') as dia_semana
from training.transacoes;

select 
	"IdTransacao",
	"DtCriacao",
	trim(to_char("DtCriacao"::timestamp, 'Day')) as dia_semana
from training.transacoes
where extract(dow from "DtCriacao"::timestamp) in (0, 6);



--3) lista de clientes com 0 pontos 

select 
	"idCliente",
	"qtdePontos"
from training.clientes c 
where "qtdePontos" = 0

--4) lista de clientes com 100 a 200 pontos e ambos 

select 
	"idCliente",
	"qtdePontos"
from training.clientes c 
where "qtdePontos" between 100 and 200

-- tb podeira ser (correção professor)

select 
	"idCliente",
	"qtdePontos"
from training.clientes
where "qtdePontos" >= 100
  and "qtdePontos" <= 200;


--5) lista de produtos que começa com nome venda de 

select 
	"IdProduto",
	"DescNomeProduto"
from training.produtos p 
where "DescNomeProduto" like 'Venda de%'

--6) lista de produtos com nome que termina com lover

select 
	"IdProduto",
	"DescNomeProduto"
from training.produtos p 
where "DescNomeProduto" like '%Lover'


--7) lista de produtos que são chapéu

select 
	"IdProduto",
	"DescNomeProduto"
from training.produtos p 
where "DescNomeProduto" like '%Chapéu%'


--8) lista de transacoes com o produto resgatar ponei 

-- não tenho essa tabela 


--9) listar toda sas transacoes add uma coluna nova sinalizando "alto" "medio" "baixo" para o valor dos pontos (<10, <500, >= 500)

select *
from training.clientes c 
order by "qtdePontos" desc
limit 10;

--exemplo data de criacao

select *
from training.clientes c 
order by "DtCriacao"

-- outro criterio de ordenacao mais antigo para mais novo e mais ponto pra quem tem menos ponto -- so add outa coluna 

select *
from training.clientes c 
order by "DtCriacao" asc, "qtdePontos" desc

-- outro criterio de ordenacao mais antigo para mais novo e mais ponto pra quem tem menos ponto -- mas com where so quem tem twitch

select *
from training.clientes c 
where "flTwitch" >= 1
order by "DtCriacao" asc, "qtdePontos" desc
