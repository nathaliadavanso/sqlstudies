-- EXERCÍCIOS GROUP BY 


--1) Quantos clietes tem e-mail cadastrado?  (acertei 10/10)

select 
count ("idCliente")
from training.clientes c 
where 
	"flEmail" = 1
	
	-- corrreção professor: apenas fez de outro modo, mas os resultados foram iguais


select count (*)
from training.clientes
where "flEmail" = 1


-- 2)Qual cliente juntou mais pontos positivos em 2025-05? (acertei 5/10)

select "idCliente",
sum ("qtdePontos")    -- some quantoss clientes
from training.clientes
where "DtCriacao" > '2025-05-01'
and "DtCriacao" < '2025-06-01'
group by "idCliente"
order by sum ("qtdePontos") desc

-- correçaõ professor  -- errei a tabela e além do mais não respondi qual é o cliente que mais juntou (add limit)

select "IdCliente",
	sum ("QtdePontos") as totalpontos
from training.transacoes t 
where "DtCriacao" >= '2025-05-01'
and "DtCriacao" < '2025-06-01'
and "QtdePontos" > 0
group by "IdCliente"
order by sum  ("QtdePontos") desc
limit 1


-- 3) Qual cliente mais fez transações no ano de 2024? (acertei 8/10)

select "IdCliente",
count ("IdTransacao")
from training.transacoes t 
where "DtCriacao" > '2023-12-31'
and "DtCriacao" < '2025-01-01'
group by "IdCliente"
order by count ("IdTransacao") desc


-- correçaõ professor: chave primaria na tabela que e id transacao, não entendi a diferenã das nossas queryes mas o resultaddo deu o mesmo

select "IdCliente",
count (*),
count (distinct "IdTransacao") as distinto
from training.transacoes t 
where "DtCriacao" >= '2024-01-01'
and "DtCriacao" < '2025-01-01'
group by "IdCliente"
order by count (*) desc


-- 4) Quantos produtos são de rpg?  (acertei 10/10) faltou pensar em como usar o group by

select 
	count ("DescCategoriaProduto") 
from training.produtos p
where "DescCategoriaProduto" = 'rpg'


-- correçaõ professor: sugestao para otimizar no caso de necessidade de mais categorias (muuuuuuuuuuito melhor caso vc queira ter visao de todos os produtos, porem se tivr mais categorias e vc quer saber uma especifico sej amelhor olhar como fiz a cima)


select "DescCategoriaProduto",
	count (*)
from training.produtos p
group by"DescCategoriaProduto"



-- 5)Qual o valor medio de pontos positivos por dia? (acertei 0/10)   - dificuldade 20/10, errei a interpretacao e nao sei fazer todas as modificacoes de data 

select 
"DtCriacao",
avg ("qtdePontos") as mediapontos
from training.clientes
group by "DtCriacao"
order by "DtCriacao" desc

-- correçaõ professor: primeiro precisa modificar a data que esta em formato com data mais hora segundos e etc, nao da pra usar avg direto pois a tabela original nao ta na granularidade de transacao, seria a media de valor de transacao

select 
sum ("QtdePontos") as totalpontos,
count (distinct substr("DtCriacao",1,10)) as qtdediasunicos,
sum ("QtdePontos") / count (distinct substr("DtCriacao",1,10)) as avgpontosdia
from training.transacoes t 
where "QtdePontos" > 0


-- 6) Qual dia da semana tem mais pedidos em 2025? --- (acertei 0/10)dificuldade 20/10 Dificuldade em interpretar a pergunta e decidir qual transformação aplicar antes do GROUP BY, principalmente em colunas de data com timestamp.

select 
	"DtCriacao",
    count ("IdTransacao")
from training.transacoes
where "DtCriacao" >= '2025-01-01'
and  "DtCriacao" < '2026-01-01'
group by "DtCriacao"



-- correçaõ professor: a funcao que ele usa strftime nao tem no postgres e nao encontrei qual no postgres enm como colocar.

select 
	 strftime ('w%',substr ("DtCriacao",1,10)) as diasemana,
	 count (distinct "IdTransacao") as qtdetransacao
from training.transacoes
where substr("DtCriacao",1,4) = '2025'
group by 1



--7) Qual produto mais transacionado? - não consegui fazer porque não tenho a tabela transacoes.produto


-- correçaõ professor: 

select "IdProduto",
	count (*)
from transacoes.produto
group by "IdProduto"
order by count (*) desc
limit 1


--8) Qual produto com mais pontos transacionados? - não consegui fazer porque não tenho a tabela transacoes.produto


-- correçaõ professor: 

select "IdProduto",
	sum (VlProduto) as totalpontos
from transacoees.produto
group by "IdProduto"
order by SUM ("VlProduto") desc





