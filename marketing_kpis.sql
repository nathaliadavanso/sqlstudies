-- Parte 3 do Projeto: Outras Análises de Marketing

-- Segmentação básica


-- Por idade: calculei com base no year birth pois não teemos coluna de idade direta, fiz em faixas de 10 anos pra equilibrar a distribuição entre os grupos

SELECT
    case
	    WHEN "Year_Birth" >= 2005 THEN 'Menos de 20 anos'
        WHEN "Year_Birth" >= 1994 THEN '20 a 30 anos'
        WHEN "Year_Birth" >= 1984 THEN '31 a 40 anos'
        WHEN "Year_Birth" >= 1974 THEN '41 a 50 anos'
        WHEN "Year_Birth" >= 1964 THEN '51 a 60 anos'
        ELSE 'Acima de 60 anos'
    END AS faixa_etaria,
    COUNT(*) AS total_clientes
FROM marketing_campaign mc
GROUP BY faixa_etaria
ORDER BY faixa_etaria;

-- Por renda: usei faixas de 20k pous a mediada do dataset é 51k, valores acima de 100k tratei como outliers para não distorcer a análise

SELECT
    CASE
        WHEN "Income" <= 20000 THEN 'Baixa (até 20k)'
        WHEN "Income" <= 40000 THEN 'Média-Baixa (20k a 40k)'
        WHEN "Income" <= 60000 THEN 'Média (40k a 60k)'
        WHEN "Income" <= 80000 THEN 'Média-Alta (60k a 80k)'
        WHEN "Income" <= 100000 THEN 'Alta (80k a 100k)'
        ELSE 'Outliers (acima de 100k)'
    END AS faixa_renda,
    COUNT(*) AS total_clientes
FROM marketing_campaign mc
GROUP BY faixa_renda
ORDER BY faixa_renda;

-- Por estado civil: coluna já possui categorias bem definidas sem necessidade de agrupamentos adicionais

select
	"Marital_Status", 
	count (*) as total_marital
from marketing_campaign mc 
group by "Marital_Status"
order by total_marital desc


-- Por escolaridade:coluna já possui categorias pré definias sem necessidade de agrupamentos adicionais
select
	"Education", 
	count (*) as total_education
from marketing_campaign mc 
group by "Education"
order by total_education desc


-- Comportamento

--Clientes que mais compram: top 10 clientes que mais compraram

SELECT 
    "ID",
    "NumDealsPurchases" + "NumWebPurchases" + "NumCatalogPurchases" + "NumStorePurchases" AS total_compras
FROM marketing_campaign
ORDER BY total_compras desc
limit 10;


--Clientes que gastam mais: Top 10 clientes que mais gastaram considerando todas as categorias
SELECT
    "ID",
    "MntWines" + "MntFruits" + "MntMeatProducts" + 
    "MntFishProducts" + "MntSweetProducts" + "MntGoldProds" AS total_gasto
FROM marketing_campaign
ORDER BY total_gasto DESC
LIMIT 10;

--Clientes que mais respondem campanhas: Soma das 5 campanhas por cliente, ordenado pelos mais engajados

SELECT
    "ID",
    "AcceptedCmp1" + "AcceptedCmp2" + "AcceptedCmp3" + "AcceptedCmp4" + "AcceptedCmp5" AS total_respostas
FROM marketing_campaign
ORDER BY total_respostas DESC
LIMIT 10;


--Performance de campanhas

--Quantos clientes responderam?

select
	count ("ID"),
    SUM("AcceptedCmp1") +
    SUM("AcceptedCmp2") +
    SUM("AcceptedCmp3") +
    SUM("AcceptedCmp4") +
    SUM("AcceptedCmp5") AS total_respostas
FROM training.marketing_campaign;


--Qual perfil responde mais? Perfil concatenado numa coluna só para facilitar leitura
SELECT
    "Education" || ' | ' || "Marital_Status" || ' | ' || faixa_idade || ' | ' || faixa_renda AS perfil,
    COUNT(*) AS total_clientes,
    ROUND(AVG("Income"), 2) AS media_income
FROM (
    SELECT
        "Education",
        "Marital_Status",
        "Income",
        CASE
            WHEN 2024 - "Year_Birth" BETWEEN 18 AND 27 THEN 'Gen Z'
            WHEN 2024 - "Year_Birth" BETWEEN 28 AND 43 THEN 'Millennial'
            WHEN 2024 - "Year_Birth" BETWEEN 44 AND 59 THEN 'Gen X'
            ELSE 'Baby Boomer'
        END AS faixa_idade,
        CASE
            WHEN "Income" < 30000 THEN 'Baixa'
            WHEN "Income" BETWEEN 30000 AND 60000 THEN 'Média'
            WHEN "Income" BETWEEN 60001 AND 90000 THEN 'Média Alta'
            ELSE 'Alta'
        END AS faixa_renda,
        "AcceptedCmp1" + "AcceptedCmp2" + "AcceptedCmp3" +
        "AcceptedCmp4" + "AcceptedCmp5" AS total_respostas
    FROM marketing_campaign
    ORDER BY total_respostas DESC
    LIMIT 10
) AS top10
GROUP BY "Education", "Marital_Status", faixa_idade, faixa_renda
ORDER BY total_clientes DESC;



--Quais campanhas parecem ineficientes? Total de respostas por campanha para identificar a menos eficiente

SELECT
    SUM("AcceptedCmp1") AS campanha_1,
    SUM("AcceptedCmp2") AS campanha_2,
    SUM("AcceptedCmp3") AS campanha_3,
    SUM("AcceptedCmp4") AS campanha_4,
    SUM("AcceptedCmp5") AS campanha_5
FROM marketing_campaign;

