-- Análise de dados e KPI 


--- MÉTRICAS BÁSICAS 

-- Total de Clientes:

select count (*)
from marketing_campaign mc 

-- Total Gasto:

SELECT 
    SUM(
        COALESCE("MntWines", 0) + 
        COALESCE("MntFruits", 0) + 
        COALESCE("MntMeatProducts", 0) + 
        COALESCE("MntFishProducts", 0) + 
        COALESCE("MntSweetProducts", 0) + 
        COALESCE("MntGoldProds", 0)
    ) AS total_gasto
FROM marketing_campaign;


-- Total de compras:
 
SELECT 
     count(
        COALESCE("MntWines", 0) + 
        COALESCE("MntFruits", 0) + 
        COALESCE("MntMeatProducts", 0) + 
        COALESCE("MntFishProducts", 0) + 
        COALESCE("MntSweetProducts", 0) + 
        COALESCE("MntGoldProds", 0)
    ) AS total_compras
FROM marketing_campaign;


-- Compras por canal:
SELECT
    SUM("NumWebPurchases") AS compras_web,
    SUM("NumCatalogPurchases") AS compras_catalogo,
    SUM("NumStorePurchases") AS compras_loja
FROM marketing_campaign;


-- INDICADORES


-- Média de gasto por cliente

select 
 round (AVG (
        COALESCE("MntWines", 0) + 
        COALESCE("MntFruits", 0) + 
        COALESCE("MntMeatProducts", 0) + 
        COALESCE("MntFishProducts", 0) + 
        COALESCE("MntSweetProducts", 0) + 
        COALESCE("MntGoldProds", 0)
    )) as media_gasto_cliente
  from marketing_campaign mc 



-- Gasto médio por canal -- obs: O dataset não possui valor em R$ por canal, apenas quantidade de compras. Por isso, a média por canal representa o número médio de compras por cliente em cada canal."



SELECT 
    ROUND(AVG("NumWebPurchases"), 2)     AS media_web,
    ROUND(AVG("NumCatalogPurchases"), 2) AS media_catalogo,
    ROUND(AVG("NumStorePurchases"), 2)   AS media_loja
FROM marketing_campaign;


-- Frequência de compra

SELECT 
    "ID",
    "NumDealsPurchases" + "NumWebPurchases" + "NumCatalogPurchases" + "NumStorePurchases" AS total_compras
FROM marketing_campaign
ORDER BY total_compras DESC;



--Recência da última compra

select 
	"ID",
	"Recency"
from marketing_campaign mc 
order by "Recency"



-- KPIS de Makreting 

-- Taxa de resposta às campanhas -- obs:esse kpi é importante pois ajuda a validar e observar qual campanha performou melhor
-- evitando disperdicio de verba, ajudando na segmentação e no benchmarketing. Aqui no caso a campanha que perfomou melhor em termos de resposta é a AcceptedCmp4. 

SELECT 
    ROUND(SUM("AcceptedCmp1") * 100.0 / COUNT(*), 2) AS taxa_cmp1,
    ROUND(SUM("AcceptedCmp2") * 100.0 / COUNT(*), 2) AS taxa_cmp2,
    ROUND(SUM("AcceptedCmp3") * 100.0 / COUNT(*), 2) AS taxa_cmp3,
    ROUND(SUM("AcceptedCmp4") * 100.0 / COUNT(*), 2) AS taxa_cmp4,
    ROUND(SUM("AcceptedCmp5") * 100.0 / COUNT(*), 2) AS taxa_cmp5
FROM marketing_campaign


-- Clientes ativos vs inativos: esse kpi é importante para focar em retenção e upsell, e também pensar em reativação para os inativos,
-- também auxilia em pensar nas segmentações de campanhas e projeção de receita 


select 
status_cliente,
count (*) as total
from (select 
	case
		when "Recency" <= 90 then 'Cliente Ativo'
		else 'Cliente Inativo'
	end as status_cliente
from marketing_campaign mc) as subquery
group by status_cliente
order by total desc

	

-- aqui também pdoeriamos cruzar os inativos com as taxas de resposta de campanhas, a fim de saber se os inativos aceitaram mais que os ativos ou não

SELECT
    status_cliente,
    ROUND(AVG(
        "AcceptedCmp1" + "AcceptedCmp2" + "AcceptedCmp3" + 
        "AcceptedCmp4" + "AcceptedCmp5"
    ) * 100.0 / 5, 2) AS taxa_total
FROM (
    SELECT
        CASE
            WHEN "Recency" <= 90 THEN 'Cliente Ativo'
            ELSE 'Cliente Inativo'
        END AS status_cliente,
        "AcceptedCmp1",
        "AcceptedCmp2",
        "AcceptedCmp3",
        "AcceptedCmp4",
        "AcceptedCmp5"
    FROM marketing_campaign
) AS subquery
GROUP BY status_cliente;



-- Perfil de clientes de alto valor: daqui poderiamos tirar diversas analises que podem ajudar a segmentar campanhas, saber qual melhor canal de comunicação,
-- e como melhorar a retenção desses clientes, no caso dessa analise 100% dos clientees de alta valor tem  renda Alta ou Média Alta, maioria possui graduation ou master, e 
-- as gerações estão distribuídas entre Baby Boomer, Gen X e Millennial

SELECT 
    "Education",
    "Marital_Status",
    faixa_idade,
    faixa_renda,
    COUNT(*) * 100.0 / 10 AS percentual,
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
        SUM(
            COALESCE("MntWines", 0) +
            COALESCE("MntFruits", 0) +
            COALESCE("MntMeatProducts", 0) +
            COALESCE("MntFishProducts", 0) +
            COALESCE("MntSweetProducts", 0) +
            COALESCE("MntGoldProds", 0)
        ) AS total_gasto
    FROM marketing_campaign
    GROUP BY "ID", "Year_Birth", "Education", "Marital_Status", "Income"
    ORDER BY total_gasto DESC
    LIMIT 10
) AS top10
GROUP BY "Education", "Marital_Status", faixa_idade, faixa_renda
ORDER BY percentual DESC;




-- Canal mais eficiente: compras na loja são o canal mais eficiente, saber essa info pode ajudar a fomentar ações para esse canal, e 
-- entender porque os demais ficaram para trás, cruzar com perfis e validar oportunidades de crescimento


SELECT
    SUM("NumWebPurchases") AS compras_web,
    SUM("NumCatalogPurchases") AS compras_catalogo,
    SUM("NumStorePurchases") AS compras_loja
FROM marketing_campaign;


-- Segmentos com maior gasto médio: aqui temos a categoria de vinhos com maior gasto médio, esse tipo de informação ajuda a mapear a priorização do porfólio, podemos cruzar com os perfis,
-- gerar oportunidades de upsell, observar sazonalidade e também a avaliar os demais produtos que tem ticket médio menor. 


SELECT *
FROM (
    SELECT 'vinhos' AS categoria, ROUND(AVG("MntWines"), 2) AS valor FROM marketing_campaign
    UNION ALL
    SELECT 'frutas', ROUND(AVG("MntFruits"), 2) FROM marketing_campaign
    UNION ALL
    SELECT 'carne', ROUND(AVG("MntMeatProducts"), 2) FROM marketing_campaign
    UNION ALL
    SELECT 'doces', ROUND(AVG("MntSweetProducts"), 2) FROM marketing_campaign
    UNION ALL
    SELECT 'premium', ROUND(AVG("MntGoldProds"), 2) FROM marketing_campaign
    UNION ALL
    SELECT 'peixes', ROUND(AVG("MntFishProducts"), 2) FROM marketing_campaign
) t
ORDER BY valor DESC;
ORDER BY valor DESC;
