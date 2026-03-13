-- =====================================================
-- PROJETO: Análise de Clientes e Campanhas de Marketing
-- Dataset: Customer Personality Analysis (Kaggle)
-- Ferramenta: PostgreSQL / DBeaver
--
-- OBJETIVO DO PROJETO
-- Este projeto tem como objetivo analisar o perfil dos clientes,
-- entender seu comportamento de compra e avaliar a performance
-- de campanhas de marketing utilizando SQL.
--
-- CONTEXTO DE NEGÓCIO
-- A empresa deseja entender melhor seus clientes para direcionar
-- campanhas de marketing de forma mais eficiente e identificar
-- quais segmentos geram mais receita.
--
-- CADA LINHA DO DATASET
-- Cada registro representa um cliente da empresa.
--
-- =====================================================
-- DESCRIÇÃO DAS PRINCIPAIS COLUNAS
-- =====================================================
--
-- ID
-- Identificador único do cliente.
--
-- Year_Birth
-- Ano de nascimento do cliente.
--
-- Education
-- Nível de educação do cliente.
--
-- Marital_Status
-- Estado civil do cliente.
--
-- Income
-- Renda anual do cliente.
--
-- Kidhome
-- Número de crianças que vivem na casa do cliente.
--
-- Teenhome
-- Número de adolescentes que vivem na casa do cliente.
--
-- Dt_Customer
-- Data em que o cliente se tornou cliente da empresa.
--
-- Recency
-- Número de dias desde a última compra do cliente.
--
-- =====================================================
-- GASTOS POR CATEGORIA DE PRODUTO
-- =====================================================
--
-- MntWines
-- Valor gasto em vinhos.
--
-- MntFruits
-- Valor gasto em frutas.
--
-- MntMeatProducts
-- Valor gasto em carnes.
--
-- MntFishProducts
-- Valor gasto em peixes.
--
-- MntSweetProducts
-- Valor gasto em doces.
--
-- MntGoldProds
-- Valor gasto em produtos premium.
--
-- =====================================================
-- CANAIS DE COMPRA
-- =====================================================
--
-- NumWebPurchases
-- Número de compras realizadas no site.
--
-- NumCatalogPurchases
-- Número de compras realizadas via catálogo.
--
-- NumStorePurchases
-- Número de compras realizadas em loja física.
--
-- NumWebVisitsMonth
-- Número de visitas ao site no último mês.
--
-- =====================================================
-- CAMPANHAS DE MARKETING
-- =====================================================
--
-- AcceptedCmp1
-- AcceptedCmp2
-- AcceptedCmp3
-- AcceptedCmp4
-- AcceptedCmp5
--
-- Indicam se o cliente respondeu às campanhas de marketing.
-- 1 = respondeu
-- 0 = não respondeu
--
-- Response
-- Indica se o cliente respondeu à última campanha de marketing.
--
-- =====================================================
-- PERGUNTAS DE NEGÓCIO DO PROJETO
-- =====================================================
--
-- 1. Qual é o perfil dos clientes da empresa?
-- 2. Qual é a renda média dos clientes?
-- 3. Quais produtos geram mais receita?
-- 4. Qual canal de compra é mais utilizado?
-- 5. As campanhas de marketing têm boa taxa de resposta?
--
-- =====================================================
-- Este projeto utiliza SQL para explorar o dataset,
-- gerar métricas de negócio e identificar insights
-- relevantes para o time de marketing.
-- =====================================================

select * from marketing_campaign mc 

-- =====================================================
-- DATA QUALITY CHECKS
-- =====================================================

-- Quantidade total de clientes: 

select 
	count (*) as qntdetotalclientes
from marketing_campaign mc 

-- Verificar valores faltantes na renda

select *
from marketing_campaign mc 
where "Income" is null 

-- Verificar possíveis clientes duplicados

select 
	"ID",
	COUNT (*)
from marketing_campaign mc 
group by "ID" 
having COUNT (*) > 1


-- Verificar ano mínimo e máximo de nascimento

select 
	MIN ("Year_Birth"),
	MAX ("Year_Birth")
from marketing_campaign mc 


-- Distribuição de clientes por educação

select 
	"Education",
	count ("ID") as qntdecliente
from marketing_campaign mc 
group by 
	"Education" 
order by count ("ID") desc


 -- Distribuição de clientes por estado civil

select 
	"Marital_Status",
	count ("ID") as qntdecliente
from marketing_campaign mc 
group by 
	"Marital_Status"
order by count ("ID") desc


-- renda média dos clientes

select 
	avg ("Income")
from marketing_campaign mc 

-- renda média por educação
select 
	"Education",
	ROUND (avg ("Income"),2) as mediarenda
from marketing_campaign mc 
group by 
	"Education" 
order by MEDIARENDA desc

---- =====================================================
-- COMPORTAMENTO DE COMPRA
-- =====================================================

-- total gasto por categoria

SELECT *
FROM (
    SELECT 'vinhos' AS categoria, SUM("MntWines") AS valor FROM marketing_campaign
    UNION ALL
    SELECT 'frutas', SUM("MntFruits") FROM marketing_campaign
    UNION ALL
    SELECT 'carne', SUM("MntMeatProducts") FROM marketing_campaign
    UNION ALL
    SELECT 'doces', SUM("MntSweetProducts") FROM marketing_campaign
    UNION ALL
    SELECT 'premium', SUM("MntGoldProds") FROM marketing_campaign
    UNION ALL
    SELECT 'peixes', SUM("MntFishProducts") FROM marketing_campaign
) t
ORDER BY valor DESC;



-- qual canal tem mais compras

SELECT
    SUM("NumWebPurchases") AS compras_web,
    SUM("NumCatalogPurchases") AS compras_catalogo,
    SUM("NumStorePurchases") AS compras_loja
FROM training.marketing_campaign;


-- clientes que responderam campanhas
SELECT
    SUM("AcceptedCmp1") +
    SUM("AcceptedCmp2") +
    SUM("AcceptedCmp3") +
    SUM("AcceptedCmp4") +
    SUM("AcceptedCmp5") AS total_respostas
FROM training.marketing_campaign;