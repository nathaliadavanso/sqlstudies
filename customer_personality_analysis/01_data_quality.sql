-- =====================================================
-- PARTE 1 DO PROJETO
-- QUALIDADE DOS DADOS
-- =====================================================

select * from marketing_campaign mc 
-- ============================
-- Missing Values
-- ============================

-- Quantos valores faltantes existem em cada coluna? -- apenas há valores faltantes para a coluna de income, 24.


SELECT
COUNT(*) - COUNT("Income") AS null_income,
COUNT(*) - COUNT("Dt_Customer") AS null_dt_customer,
COUNT(*) - COUNT("AcceptedCmp1") AS null_cmp1,
COUNT(*) - COUNT("AcceptedCmp2") AS null_cmp2,
COUNT(*) - COUNT("AcceptedCmp3") AS null_cmp3,
COUNT(*) - COUNT("AcceptedCmp4") AS null_cmp4,
COUNT(*) - COUNT("AcceptedCmp5") AS null_cmp5,
COUNT(*) - COUNT("Response") AS null_response
FROM marketing_campaign;

-- Qual o percentual de valores faltantes? -- 1,07% de valores faltantes, tendo em vista que somente a coluna de income (dentre as principais) tem valores faltantes

SELECT
ROUND((COUNT(*) - COUNT("Income")) * 100.0 / COUNT(*),2) AS percentual_null_income
FROM marketing_campaign;

-- Exemplos de colunas críticas:
-- Income
-- Dt_Customer
-- variáveis de campanhas


-- Pergunta-chave:
-- Dá para calcular métricas financeiras sem tratar renda faltante?

--É possível calcular métricas financeiras, mas primeiro é necessário verificar quantos valores de renda estão faltantes e avaliar o impacto desses dados ausentes na análise.

-- ============================
-- Duplicated Values
-- ============================

-- Existem clientes duplicados? não existem ids dupliucados

SELECT "ID",
	  COUNT(*)
FROM marketing_campaign
GROUP BY "ID"
HAVING COUNT(*) > 1;

-- O identificador (ID) é único? não existem valores duplicados na coluna ID, indicando que cada registro representa um cliente único.

-- Existem linhas exatamente iguais? não foram identificadas linhas exatamente iguais, a coluna ID é única para cada registro indicando que cada linha representa um cliente diferente


-- Pergunta-chave:
-- Se um cliente aparece duas vezes, as métricas de campanha ficam infladas? 

--Se um cliente aparecesse duas vezes na base
--as métricas de campanha poderiam ficar infladas pois o mesmo cliente seria contabilizado mais de uma vez nas análises
-- porém nesse caso só há um identificador ID e é único, indicando que cada cliente aparece apenas uma vez nesse dataset

-- ============================
-- Data Types
-- ============================

-- Verificar:
-- Datas como texto
-- Campos numéricos como string
-- Flags (0/1) como texto


-- Exemplos:
-- Dt_Customer → deveria ser data
-- Year_Birth → numérico
-- Income → numérico


-- Pergunta-chave:
-- Quais análises ficam impossíveis se os tipos estiverem errados?

--A análise dos tipos de dados mostrou que a maioria das colunas está no formato adequado,
--mas, a coluna Year_Birth aparece com valores como 1.998, indicando possível interpretação como número decimal
--tipos de dados incorretos podem impactar diversas análises como cálculos de idade dos clientes, análises financeiras, datas de entrada e campanha


-- ============================
-- Padronização de valores
-- ============================

-- Verificar:
-- textos em upper/lower case
-- categorias inconsistentes
-- valores inesperados (ex: negativos)

SELECT DISTINCT "Education"
FROM marketing_campaign;

SELECT DISTINCT "Marital_Status"
FROM marketing_campaign;


-- Exemplo:
-- Education
-- Marital_Status


-- Pergunta-chave:
-- Dá para segmentar clientes se os valores não estão padronizados? 

-- a segmentação pode ficar incorreta pois o SQL interpretaria esses valores como categorias distintas
--é importante padronizar os textos antes de realizar análises de segmentação
