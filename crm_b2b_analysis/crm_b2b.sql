-- =====================================================
-- PROJETO: B2B CRM & SALES INTELLIGENCE ANALYSIS
-- BASE: CRMSALESOPPORTUNITIES.PUBLIC
-- TABELAS: COMPANIES_NOISY + EMPLOYEES_NOISY
-- FERRAMENTA: SNOWFLAKE
-- AUTOR: NATHALIA DAVANSO
-- =====================================================


-- =====================================================
-- ETAPA 1: ENTENDIMENTO DO PROBLEMA
-- =====================================================

-- Problema de negócio:
-- O time comercial precisa entender quais perfis de empresa
-- e de contato geram mais conversão, quais canais são mais
-- eficientes e onde estão os gargalos do funil B2B.

-- Perguntas centrais:
-- 1. Quais setores e tamanhos de empresa convertem mais?
-- 2. Tomadores de decisão respondem mais campanhas?
-- 3. Qual canal gera mais leads e melhor conversão?
-- 4. Receita anual influencia o comportamento de compra?
-- 5. Qual tipo de campanha performa melhor?

-- Hipótese:
-- H0: O perfil da empresa não influencia a taxa de conversão
-- H1: Empresas de maior porte e receita têm maior taxa de conversão


-- =====================================================
-- ETAPA 2: DATA UNDERSTANDING
-- =====================================================

-- 2.1 Total de registros em cada tabela
SELECT COUNT(*) AS total_empresas
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY;
-- Resultado: 734 empresas

SELECT COUNT(*) AS total_contatos
FROM CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY;
-- Resultado: 5.234 contatos

-- 2.2 Estrutura das tabelas
DESCRIBE TABLE CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY;
DESCRIBE TABLE CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY;

-- 2.3 Amostra dos dados
SELECT * FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY LIMIT 10;
SELECT * FROM CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY LIMIT 10;

-- 2.4 Visão geral da receita anual
SELECT
  MIN(ANNUAL_REVENUE)    AS min_revenue,
  MAX(ANNUAL_REVENUE)    AS max_revenue,
  AVG(ANNUAL_REVENUE)    AS media_revenue,
  MEDIAN(ANNUAL_REVENUE) AS mediana_revenue
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY;
-- Resultado: mín 1.0MM | máx 199.4MM | média 18.4MM | mediana 7.1MM
-- Insight: média (18.4) muito acima da mediana (7.1) — base assimétrica com
-- poucas empresas de receita muito alta puxando a média pra cima

-- 2.5 Visão geral da taxa de conversão
SELECT
  AVG(CONVERSION_RATE)    AS media_conversao,
  MEDIAN(CONVERSION_RATE) AS mediana_conversao,
  STDDEV(CONVERSION_RATE) AS desvio_padrao
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY;
-- Resultado: média 0.80% | mediana 0.80% | desvio 0.33%
-- Insight: média e mediana muito próximas — distribuição simétrica,
-- sem grandes distorções por outliers na taxa de conversão

-- 2.6 Visão geral dos leads gerados
SELECT
  AVG(LEADS_GENERATED)    AS media_leads,
  MEDIAN(LEADS_GENERATED) AS mediana_leads
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY;
-- Resultado: média 6.96 leads | mediana 7.0 leads
-- Insight: média e mediana praticamente iguais — cada empresa gera
-- em média 7 leads, sem grande variação entre elas

-- Classificação das variáveis:
-- Métricas  → Annual_Revenue, Conversion_Rate, Leads_Generated,
--             Marketing_Spend, Total_Purchases_Last_Year
-- Dimensões → Industry, Company_Size, Campaign_Type, Contract_Status,
--             Seniority_Level, Decision_Maker_Flag, Data_Source


-- =====================================================
-- ETAPA 3: DATA QUALITY — COMPANIES_NOISY
-- =====================================================

-- 3.1 Verificação de nulos nas variáveis principais — MÉTRICAS
SELECT
  SUM(CASE WHEN ANNUAL_REVENUE IS NULL THEN 1 ELSE 0 END)           AS nulls_revenue,
  SUM(CASE WHEN CONVERSION_RATE IS NULL THEN 1 ELSE 0 END)          AS nulls_conversao,
  SUM(CASE WHEN LEADS_GENERATED IS NULL THEN 1 ELSE 0 END)          AS nulls_leads,
  SUM(CASE WHEN MARKETING_SPEND IS NULL THEN 1 ELSE 0 END)          AS nulls_marketing,
  SUM(CASE WHEN TOTAL_PURCHASES_LAST_YEAR IS NULL THEN 1 ELSE 0 END) AS nulls_purchases
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY;
-- Resultado: 4 | 8 | 5 | 7 | 6

-- 3.2 Verificação de nulos nas variáveis principais — DIMENSÕES
SELECT
  SUM(CASE WHEN INDUSTRY IS NULL THEN 1 ELSE 0 END)         AS nulls_industry,
  SUM(CASE WHEN COMPANY_SIZE IS NULL THEN 1 ELSE 0 END)     AS nulls_company_size,
  SUM(CASE WHEN CAMPAIGN_TYPE IS NULL THEN 1 ELSE 0 END)    AS nulls_campaign_type,
  SUM(CASE WHEN CONTRACT_STATUS IS NULL THEN 1 ELSE 0 END)  AS nulls_contract_status
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY;
-- Resultado: 0 nulos nas dimensões — sem impacto nas análises de segmentação

-- 3.3 Percentual de nulos por coluna crítica
SELECT
  SUM(CASE WHEN ANNUAL_REVENUE IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100           AS pct_nulls_revenue,
  SUM(CASE WHEN CONVERSION_RATE IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100          AS pct_nulls_conversao,
  SUM(CASE WHEN LEADS_GENERATED IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100          AS pct_nulls_leads,
  SUM(CASE WHEN MARKETING_SPEND IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100          AS pct_nulls_marketing,
  SUM(CASE WHEN TOTAL_PURCHASES_LAST_YEAR IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100 AS pct_nulls_purchases,
  -- Percentual geral (parênteses corretos para evitar erro de precedência)
  (SUM(CASE WHEN ANNUAL_REVENUE IS NULL THEN 1 ELSE 0 END) +
   SUM(CASE WHEN CONVERSION_RATE IS NULL THEN 1 ELSE 0 END) +
   SUM(CASE WHEN LEADS_GENERATED IS NULL THEN 1 ELSE 0 END) +
   SUM(CASE WHEN MARKETING_SPEND IS NULL THEN 1 ELSE 0 END) +
   SUM(CASE WHEN TOTAL_PURCHASES_LAST_YEAR IS NULL THEN 1 ELSE 0 END))
  / (COUNT(*) * 5) * 100 AS pct_nulls_geral
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY;
-- Resultado: ~0.82% de nulos geral — impacto insignificante nas análises

-- 3.4 Inconsistência de case em Company_Size
SELECT COMPANY_SIZE, COUNT(*) AS total
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY
GROUP BY COMPANY_SIZE;

SELECT COUNT(*) AS total_fora_padrao
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY
WHERE COMPANY_SIZE IN ('SMALL', 'small', 'large');
-- Resultado: 4 empresas com case errado — corrigidas via UPPER() nas análises

-- 3.5 Inconsistência em Campaign_Type
SELECT CAMPAIGN_TYPE, COUNT(*) AS total
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY
GROUP BY CAMPAIGN_TYPE;

SELECT
  CASE
    WHEN UPPER(CAMPAIGN_TYPE) IN ('SEM', 'GEM', 'ZEM', 'SE', 'EM') THEN 'SEM'
    WHEN UPPER(CAMPAIGN_TYPE) IN ('EMAIL', 'EMAL') THEN 'Email'
    WHEN UPPER(CAMPAIGN_TYPE) IN ('WEBINAR', 'EBINAR', 'WEBINAK') THEN 'Webinar'
    WHEN UPPER(CAMPAIGN_TYPE) IN ('LINKEDIN ADS', 'LNKEDIN ADS', 'INKEDIN ADS') THEN 'LinkedIn Ads'
    WHEN UPPER(CAMPAIGN_TYPE) IN ('TRADE SHOW', 'TRADE SHPW') THEN 'Trade Show'
    WHEN UPPER(CAMPAIGN_TYPE) LIKE '%CONTENT%' OR UPPER(CAMPAIGN_TYPE) = 'CONTENV MARKETING' THEN 'Content Marketing'
    ELSE CAMPAIGN_TYPE
  END AS campaign_type_clean,
  COUNT(*) AS total
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY
GROUP BY 1
ORDER BY total DESC;
-- Resultado: 22 variações para 6 campanhas reais — erros de digitação corrigidos

-- 3.6 Inconsistência em Contract_Status
SELECT
  CASE
    WHEN UPPER(CONTRACT_STATUS) = 'ACTIVE'  THEN 'Active'
    WHEN UPPER(CONTRACT_STATUS) = 'PENDING' THEN 'Pending'
    WHEN UPPER(CONTRACT_STATUS) = 'EXPIRED' THEN 'Expired'
  END AS contract_status_clean,
  COUNT(*) AS total
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY
GROUP BY 1
ORDER BY total DESC;
-- Resultado: 3 variações de case — corrigidas via UPPER()

-- 3.7 Inconsistência em Payment_Behavior
SELECT
  CASE
    WHEN UPPER(PAYMENT_BEHAVIOR) = 'ON-TIME'          THEN 'On-time'
    WHEN UPPER(PAYMENT_BEHAVIOR) = 'OCCASIONAL DELAY' THEN 'Occasional Delay'
    WHEN UPPER(PAYMENT_BEHAVIOR) = 'LATE'             THEN 'Late'
    ELSE PAYMENT_BEHAVIOR
  END AS payment_behavior_clean,
  COUNT(*) AS total
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY
GROUP BY 1
ORDER BY total DESC;

-- 3.8 Inconsistência em Preferred_Channel
SELECT
  CASE
    WHEN UPPER(PREFERRED_CHANNEL) = 'SALES REP' THEN 'Sales Rep'
    WHEN UPPER(PREFERRED_CHANNEL) = 'ONLINE'    THEN 'Online'
    WHEN UPPER(PREFERRED_CHANNEL) = 'EMAIL'     THEN 'Email'
    WHEN UPPER(PREFERRED_CHANNEL) = 'DEALER'    THEN 'Dealer'
    ELSE PREFERRED_CHANNEL
  END AS preferred_channel_clean,
  COUNT(*) AS total
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY
GROUP BY 1
ORDER BY total DESC;

-- 3.9 Valores negativos em métricas numéricas
SELECT * FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY WHERE CONVERSION_RATE < 0;
SELECT * FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY WHERE ANNUAL_REVENUE < 0;
-- Resultado: 0 registros — sem valores impossíveis

-- 3.10 Conversion_Rate deve estar entre 0 e 100
SELECT * FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY
WHERE CONVERSION_RATE NOT BETWEEN 0 AND 100;
-- Resultado: 0 registros — todos os valores dentro do range esperado

-- CONCLUSÃO DATA QUALITY COMPANIES:
-- Dimensões sem nulos — segmentações confiáveis
-- ~0.82% de nulos nas métricas — impacto insignificante
-- Principais problemas: inconsistência de case em Company_Size,
-- Contract_Status, Payment_Behavior e Preferred_Channel (resolvidos com UPPER)
-- Campaign_Type com 22 variações e erros de digitação (resolvidos com CASE WHEN)
-- Nota: numa situação real, criar uma VIEW com os dados já limpos evitaria
-- repetir o CASE WHEN em cada query


-- =====================================================
-- ETAPA 4: DATA QUALITY — EMPLOYEES_NOISY
-- =====================================================

-- Classificação das variáveis:
-- Métricas  → Campaign_Response_Rate, Influence_Score, Tenure_Years, Event_Attendance
-- Dimensões → Decision_Maker_Flag, Seniority_Level, Preferred_Contact_Method,
--             Data_Source, Newsletter_Subscription

-- 4.1 Verificação de nulos e percentual — MÉTRICAS E DIMENSÕES
SELECT
  -- Métricas
  SUM(CASE WHEN CAMPAIGN_RESPONSE_RATE IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100  AS pct_nulls_responserate,
  SUM(CASE WHEN INFLUENCE_SCORE IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100         AS pct_nulls_influencescore,
  SUM(CASE WHEN TENURE_YEARS IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100            AS pct_nulls_tenure,
  SUM(CASE WHEN EVENT_ATTENDANCE IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100        AS pct_nulls_eventatt,
  -- Dimensões
  SUM(CASE WHEN DECISION_MAKER_FLAG IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100     AS pct_nulls_decisionmaker,
  SUM(CASE WHEN PREFERRED_CONTACT_METHOD IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100 AS pct_nulls_contactmethod,
  SUM(CASE WHEN DATA_SOURCE IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100             AS pct_nulls_datasource,
  SUM(CASE WHEN NEWSLETTER_SUBSCRIPTION IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100 AS pct_nulls_newsletter,
  -- Percentual geral
  (SUM(CASE WHEN CAMPAIGN_RESPONSE_RATE IS NULL THEN 1 ELSE 0 END) +
   SUM(CASE WHEN INFLUENCE_SCORE IS NULL THEN 1 ELSE 0 END) +
   SUM(CASE WHEN TENURE_YEARS IS NULL THEN 1 ELSE 0 END) +
   SUM(CASE WHEN EVENT_ATTENDANCE IS NULL THEN 1 ELSE 0 END) +
   SUM(CASE WHEN DECISION_MAKER_FLAG IS NULL THEN 1 ELSE 0 END) +
   SUM(CASE WHEN PREFERRED_CONTACT_METHOD IS NULL THEN 1 ELSE 0 END) +
   SUM(CASE WHEN DATA_SOURCE IS NULL THEN 1 ELSE 0 END) +
   SUM(CASE WHEN NEWSLETTER_SUBSCRIPTION IS NULL THEN 1 ELSE 0 END))
  / (COUNT(*) * 8) * 100 AS pct_nulls_geral
FROM CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY;
-- Resultado: ~0.73% de nulos geral — impacto insignificante

-- 4.2 Verificação de Decision_Maker_Flag
-- NOTA: coluna é Boolean (TRUE/FALSE) — sem necessidade de UPPER()
SELECT
  DECISION_MAKER_FLAG,
  COUNT(*) AS total
FROM CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY
GROUP BY 1
ORDER BY total DESC;
-- Resultado: apenas TRUE e FALSE — sem inconsistências

-- 4.3 Verificação de Active_Flag
-- NOTA: coluna é Boolean (TRUE/FALSE) — sem necessidade de UPPER()
SELECT
  ACTIVE_FLAG,
  COUNT(*) AS total
FROM CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY
GROUP BY 1
ORDER BY total DESC;
-- Resultado: apenas TRUE e FALSE — sem inconsistências

-- 4.4 Inconsistência em Data_Source — campo mais problemático (91 variações)
SELECT
  CASE
    WHEN UPPER(DATA_SOURCE) LIKE '%CRM%' THEN 'CRM'
    WHEN UPPER(DATA_SOURCE) LIKE '%LINK%' OR UPPER(DATA_SOURCE) LIKE '%LNKED%' THEN 'LinkedIn'
    WHEN UPPER(DATA_SOURCE) LIKE '%EMAIL%' OR UPPER(DATA_SOURCE) LIKE '%MAIL%' THEN 'Email Campaign'
    WHEN UPPER(DATA_SOURCE) LIKE '%WEBIN%' OR UPPER(DATA_SOURCE) LIKE '%EBIN%' THEN 'Webinar'
    WHEN UPPER(DATA_SOURCE) LIKE '%FAIR%' OR UPPER(DATA_SOURCE) LIKE '%FAI%' THEN 'Fair'
    ELSE 'Outros/Inválidos'
  END AS data_source_clean,
  COUNT(*) AS total
FROM CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY
GROUP BY 1
ORDER BY total DESC;
-- Resultado: 91 variações para 5 fontes reais — campo mais crítico da base
-- Outros/Inválidos: ~2.4% — impacto insignificante

-- 4.5 Inconsistência em Preferred_Contact_Method
SELECT
  CASE
    WHEN UPPER(PREFERRED_CONTACT_METHOD) LIKE '%EMAIL%'
      OR UPPER(PREFERRED_CONTACT_METHOD) IN ('EMAL','EMATL','EMAIJ','EMAFL','EMAUL','EMAIF','EMAII','EMALL','EAIL','EBAIL','EDAIL','DMAIL','FMAIL') THEN 'Email'
    WHEN UPPER(PREFERRED_CONTACT_METHOD) LIKE '%PHONE%'
      OR UPPER(PREFERRED_CONTACT_METHOD) IN ('PHNE','PHOFE','PHONY','PHPNE','PHOBE','PYONE','PHENE','PHOE','PUONE','PHONR','PHONP','PHONK','PHON') THEN 'Phone'
    WHEN UPPER(PREFERRED_CONTACT_METHOD) LIKE '%LINKEDIN%'
      OR UPPER(PREFERRED_CONTACT_METHOD) LIKE '%LINKED%'
      OR UPPER(PREFERRED_CONTACT_METHOD) LIKE '%LNKED%' THEN 'LinkedIn'
    WHEN UPPER(PREFERRED_CONTACT_METHOD) LIKE '%EVENT%'
      OR UPPER(PREFERRED_CONTACT_METHOD) IN ('IVENTS','WVENTS','EVNTS','EVENS') THEN 'Events'
    ELSE 'Outros/Inválidos'
  END AS contact_method_clean,
  COUNT(*) AS total
FROM CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY
GROUP BY 1
ORDER BY total DESC;

-- 4.6 Inconsistência em Seniority_Level
SELECT
  CASE
    WHEN UPPER(SENIORITY_LEVEL) = 'JUNIOR'   THEN 'Junior'
    WHEN UPPER(SENIORITY_LEVEL) = 'MID'      THEN 'Mid'
    WHEN UPPER(SENIORITY_LEVEL) = 'SENIOR'   THEN 'Senior'
    WHEN UPPER(SENIORITY_LEVEL) = 'DIRECTOR' THEN 'Director'
    WHEN UPPER(SENIORITY_LEVEL) = 'C-LEVEL'  THEN 'C-Level'
    ELSE SENIORITY_LEVEL
  END AS seniority_clean,
  COUNT(*) AS total
FROM CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY
GROUP BY 1
ORDER BY total DESC;

-- 4.7 Inconsistência em Department — 118 variações
SELECT
  CASE
    WHEN UPPER(DEPARTMENT) IN ('MARKETING') OR UPPER(DEPARTMENT) LIKE '%ARKET%' THEN 'Marketing'
    WHEN UPPER(DEPARTMENT) IN ('SALES') OR UPPER(DEPARTMENT) LIKE '%ALE%' THEN 'Sales'
    WHEN UPPER(DEPARTMENT) IN ('ENGINEERING') OR UPPER(DEPARTMENT) LIKE '%GINEER%' THEN 'Engineering'
    WHEN UPPER(DEPARTMENT) IN ('PROCUREMENT') OR UPPER(DEPARTMENT) LIKE '%ROCURE%' THEN 'Procurement'
    WHEN UPPER(DEPARTMENT) IN ('QUALITY') OR UPPER(DEPARTMENT) LIKE '%UALIT%' THEN 'Quality'
    WHEN UPPER(DEPARTMENT) IN ('OPERATIONS') OR UPPER(DEPARTMENT) LIKE '%PERAT%' THEN 'Operations'
    WHEN UPPER(DEPARTMENT) IN ('PRODUCTION') OR UPPER(DEPARTMENT) LIKE '%RODUC%' THEN 'Production'
    WHEN UPPER(DEPARTMENT) IN ('MANAGEMENT') OR UPPER(DEPARTMENT) LIKE '%ANAGE%' THEN 'Management'
    WHEN UPPER(DEPARTMENT) = 'IT' THEN 'IT'
    ELSE 'Outros/Inválidos'
  END AS department_clean,
  COUNT(*) AS total
FROM CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY
GROUP BY 1
ORDER BY total DESC;
-- Resultado: 118 variações para 9 departamentos — campo problemático
-- Outros/Inválidos: ~1.2% — impacto insignificante

-- 4.8 Campaign_Response_Rate — coluna é VARCHAR com sufixo '%'
-- NOTA: usar TRY_CAST(REPLACE(..., '%', '') AS NUMBER) em todas as análises
SELECT *
FROM CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY
WHERE TRY_CAST(REPLACE(CAMPAIGN_RESPONSE_RATE, '%', '') AS NUMBER) NOT BETWEEN 0 AND 100
   OR TRY_CAST(REPLACE(CAMPAIGN_RESPONSE_RATE, '%', '') AS NUMBER) IS NULL;

-- 4.9 Influence_Score — coluna é VARCHAR com valores 'N/A'
-- NOTA: usar TRY_CAST em todas as análises
SELECT
  MIN(TRY_CAST(INFLUENCE_SCORE AS NUMBER)) AS min_score,
  MAX(TRY_CAST(INFLUENCE_SCORE AS NUMBER)) AS max_score,
  AVG(TRY_CAST(INFLUENCE_SCORE AS NUMBER)) AS media_score
FROM CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY;

-- CONCLUSÃO DATA QUALITY EMPLOYEES:
-- ~0.73% de nulos geral — impacto insignificante
-- Decision_Maker_Flag e Active_Flag são VARCHAR (não Boolean) — UPPER() necessário
-- Data_Source: campo mais problemático com 91 variações para 5 fontes
-- Department: 118 variações para 9 departamentos — análises devem ser
-- interpretadas com cautela
-- Campaign_Response_Rate e Influence_Score armazenados como VARCHAR —
-- requer TRY_CAST em cada análise


-- =====================================================
-- ETAPA 5: ESTATÍSTICA DESCRITIVA
-- =====================================================

-- 5.1 Média, mediana e desvio padrão da taxa de conversão
SELECT
  AVG(CONVERSION_RATE)    AS media_conversao,
  MEDIAN(CONVERSION_RATE) AS mediana_conversao,
  STDDEV(CONVERSION_RATE) AS desvio_padrao
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY;
-- Resultado: média 0.80% | mediana 0.80% | desvio 0.33%
-- Insight: distribuição simétrica — média e mediana iguais confirmam
-- que não há distorção por outliers na taxa de conversão

-- 5.2 Média, mediana e desvio padrão da receita anual
SELECT
  AVG(ANNUAL_REVENUE)    AS media_receita,
  MEDIAN(ANNUAL_REVENUE) AS mediana_receita,
  STDDEV(ANNUAL_REVENUE) AS desvio_padrao
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY;
-- Resultado: média 18.4MM | mediana 7.1MM | desvio 32.36MM
-- Insight: desvio padrão (32.36) maior que a média (18.4) indica
-- altíssima variabilidade — existem poucas empresas com receita muito
-- alta que distorcem a média. A mediana (7.1MM) representa melhor
-- o perfil típico das empresas da base

-- 5.3 Intervalo de confiança 95% para a taxa de conversão média
SELECT
  AVG(CONVERSION_RATE) AS media,
  AVG(CONVERSION_RATE) - 1.96 * (STDDEV(CONVERSION_RATE) / SQRT(COUNT(*))) AS ic_inferior,
  AVG(CONVERSION_RATE) + 1.96 * (STDDEV(CONVERSION_RATE) / SQRT(COUNT(*))) AS ic_superior
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY;
-- Resultado: IC 95% entre 0.778% e 0.827%
-- Interpretação: com 95% de confiança, a taxa de conversão média
-- real está entre 0.78% e 0.83%

-- 5.4 Percentis da taxa de conversão
SELECT
  PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY CONVERSION_RATE) AS p50,
  PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY CONVERSION_RATE) AS p75,
  PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY CONVERSION_RATE) AS p90
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY;
-- Resultado: P50: 0.80% | P75: 1.00% | P90: 1.20%
-- Insight: os 10% melhores convertem acima de 1.20% — pouca diferença
-- entre os grupos, base bastante homogênea em termos de conversão


-- =====================================================
-- ETAPA 6: ANÁLISE DE EMPRESAS
-- =====================================================

-- 6.1 Taxa de conversão média por setor
SELECT
  CASE
    WHEN UPPER(INDUSTRY) LIKE '%AERO%' THEN 'Aerospace'
    WHEN UPPER(INDUSTRY) LIKE '%MINING%' THEN 'Mining, metals & minerals'
    WHEN UPPER(INDUSTRY) LIKE '%HEALTH%' THEN 'Healthcare'
    WHEN UPPER(INDUSTRY) LIKE '%SPACE%' OR UPPER(INDUSTRY) = 'SPABE' THEN 'Space'
    WHEN UPPER(INDUSTRY) LIKE '%OIL%' THEN 'Oil & gas'
    WHEN UPPER(INDUSTRY) LIKE '%VEHICLE%' OR UPPER(INDUSTRY) LIKE '%VEHCLE%' OR UPPER(INDUSTRY) LIKE '%VEHICL%' THEN 'Vehicles'
    WHEN UPPER(INDUSTRY) LIKE '%FOOD%' OR UPPER(INDUSTRY) LIKE '%BEVERAGE%' THEN 'Food & beverage'
    WHEN UPPER(INDUSTRY) LIKE '%RESIDEN%' THEN 'Residential'
    WHEN UPPER(INDUSTRY) LIKE '%MACH%' THEN 'Machine building'
    WHEN UPPER(INDUSTRY) LIKE '%UTIL%' THEN 'Utilities'
    WHEN UPPER(INDUSTRY) LIKE '%BUILD%' THEN 'Buildings'
    WHEN UPPER(INDUSTRY) LIKE '%DATA%' THEN 'Data centres'
    ELSE INDUSTRY
  END AS industry_clean,
  COUNT(*) AS total_empresas,
  AVG(CONVERSION_RATE) AS media_conversao
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY
GROUP BY 1
ORDER BY media_conversao DESC;
-- Insight: setor importa — existe variação de conversão entre setores

-- 6.2 Taxa de conversão por tamanho de empresa
SELECT
  CASE
    WHEN UPPER(COMPANY_SIZE) = 'SMALL'  THEN 'Small'
    WHEN UPPER(COMPANY_SIZE) = 'MEDIUM' THEN 'Medium'
    WHEN UPPER(COMPANY_SIZE) = 'LARGE'  THEN 'Large'
  END AS company_size_clean,
  COUNT(*) AS total_empresas,
  AVG(CONVERSION_RATE) AS media_conversao
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY
GROUP BY 1
ORDER BY media_conversao DESC;
-- Resultado: Large 0.82% | Medium 0.80% | Small 0.80%
-- Insight: tamanho não influencia conversão — diferença mínima entre os grupos

-- 6.3 Receita anual média por setor
SELECT
  CASE
    WHEN UPPER(INDUSTRY) LIKE '%AERO%' THEN 'Aerospace'
    WHEN UPPER(INDUSTRY) LIKE '%MINING%' THEN 'Mining, metals & minerals'
    WHEN UPPER(INDUSTRY) LIKE '%HEALTH%' THEN 'Healthcare'
    WHEN UPPER(INDUSTRY) LIKE '%SPACE%' OR UPPER(INDUSTRY) = 'SPABE' THEN 'Space'
    WHEN UPPER(INDUSTRY) LIKE '%OIL%' THEN 'Oil & gas'
    WHEN UPPER(INDUSTRY) LIKE '%VEHICLE%' OR UPPER(INDUSTRY) LIKE '%VEHCLE%' OR UPPER(INDUSTRY) LIKE '%VEHICL%' THEN 'Vehicles'
    WHEN UPPER(INDUSTRY) LIKE '%FOOD%' OR UPPER(INDUSTRY) LIKE '%BEVERAGE%' THEN 'Food & beverage'
    WHEN UPPER(INDUSTRY) LIKE '%RESIDEN%' THEN 'Residential'
    WHEN UPPER(INDUSTRY) LIKE '%MACH%' THEN 'Machine building'
    WHEN UPPER(INDUSTRY) LIKE '%UTIL%' THEN 'Utilities'
    WHEN UPPER(INDUSTRY) LIKE '%BUILD%' THEN 'Buildings'
    WHEN UPPER(INDUSTRY) LIKE '%DATA%' THEN 'Data centres'
    ELSE INDUSTRY
  END AS industry_clean,
  COUNT(*) AS total_empresas,
  AVG(ANNUAL_REVENUE) AS media_receita
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY
GROUP BY 1
ORDER BY media_receita DESC;
-- Insight: setores com maior potencial de receita devem ser priorizados
-- na prospecção comercial

-- 6.4 Leads gerados por tipo de campanha
SELECT
  CASE
    WHEN UPPER(CAMPAIGN_TYPE) IN ('SEM', 'GEM', 'ZEM', 'SE', 'EM') THEN 'SEM'
    WHEN UPPER(CAMPAIGN_TYPE) IN ('EMAIL', 'EMAL') THEN 'Email'
    WHEN UPPER(CAMPAIGN_TYPE) IN ('WEBINAR', 'EBINAR', 'WEBINAK') THEN 'Webinar'
    WHEN UPPER(CAMPAIGN_TYPE) IN ('LINKEDIN ADS', 'LNKEDIN ADS', 'INKEDIN ADS') THEN 'LinkedIn Ads'
    WHEN UPPER(CAMPAIGN_TYPE) IN ('TRADE SHOW', 'TRADE SHPW') THEN 'Trade Show'
    WHEN UPPER(CAMPAIGN_TYPE) LIKE '%CONTENT%' OR UPPER(CAMPAIGN_TYPE) = 'CONTENV MARKETING' THEN 'Content Marketing'
    ELSE CAMPAIGN_TYPE
  END AS campaign_type_clean,
  SUM(LEADS_GENERATED) AS total_leads
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY
GROUP BY 1
ORDER BY total_leads DESC;
-- Resultado: Email gerou mais leads no total
-- Insight: volume de leads não garante qualidade — ver query 6.5

-- 6.5 Taxa de conversão por tipo de campanha
SELECT
  CASE
    WHEN UPPER(CAMPAIGN_TYPE) IN ('SEM', 'GEM', 'ZEM', 'SE', 'EM') THEN 'SEM'
    WHEN UPPER(CAMPAIGN_TYPE) IN ('EMAIL', 'EMAL') THEN 'Email'
    WHEN UPPER(CAMPAIGN_TYPE) IN ('WEBINAR', 'EBINAR', 'WEBINAK') THEN 'Webinar'
    WHEN UPPER(CAMPAIGN_TYPE) IN ('LINKEDIN ADS', 'LNKEDIN ADS', 'INKEDIN ADS') THEN 'LinkedIn Ads'
    WHEN UPPER(CAMPAIGN_TYPE) IN ('TRADE SHOW', 'TRADE SHPW') THEN 'Trade Show'
    WHEN UPPER(CAMPAIGN_TYPE) LIKE '%CONTENT%' OR UPPER(CAMPAIGN_TYPE) = 'CONTENV MARKETING' THEN 'Content Marketing'
    ELSE CAMPAIGN_TYPE
  END AS campaign_type_clean,
  AVG(CONVERSION_RATE) AS media_conversao
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY
GROUP BY 1
ORDER BY media_conversao DESC;
-- Resultado: Email 0.85% | SEM 0.83% | Webinar 0.82% | Content 0.82% |
--            LinkedIn Ads 0.77% | Trade Show 0.73%
-- Insight: Email lidera tanto em volume quanto em conversão
-- Trade Show tem o menor retorno — revisar estratégia

-- 6.6 Status de contrato por tamanho de empresa
SELECT
  CASE
    WHEN UPPER(COMPANY_SIZE) = 'SMALL'  THEN 'Small'
    WHEN UPPER(COMPANY_SIZE) = 'MEDIUM' THEN 'Medium'
    WHEN UPPER(COMPANY_SIZE) = 'LARGE'  THEN 'Large'
  END AS company_size_clean,
  CASE
    WHEN UPPER(CONTRACT_STATUS) = 'ACTIVE'  THEN 'Active'
    WHEN UPPER(CONTRACT_STATUS) = 'PENDING' THEN 'Pending'
    WHEN UPPER(CONTRACT_STATUS) = 'EXPIRED' THEN 'Expired'
  END AS contract_status_clean,
  COUNT(*) AS total
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY
GROUP BY 1, 2
ORDER BY company_size_clean, total DESC;
-- Insight: taxa de contratos ativos ~75% em todos os tamanhos
-- Tamanho da empresa não influencia o status do contrato

-- 6.7 Canal preferido por setor
SELECT
  CASE
    WHEN UPPER(INDUSTRY) LIKE '%AERO%' THEN 'Aerospace'
    WHEN UPPER(INDUSTRY) LIKE '%MINING%' THEN 'Mining, metals & minerals'
    WHEN UPPER(INDUSTRY) LIKE '%HEALTH%' THEN 'Healthcare'
    WHEN UPPER(INDUSTRY) LIKE '%SPACE%' OR UPPER(INDUSTRY) = 'SPABE' THEN 'Space'
    WHEN UPPER(INDUSTRY) LIKE '%OIL%' THEN 'Oil & gas'
    WHEN UPPER(INDUSTRY) LIKE '%VEHICLE%' OR UPPER(INDUSTRY) LIKE '%VEHCLE%' OR UPPER(INDUSTRY) LIKE '%VEHICL%' THEN 'Vehicles'
    WHEN UPPER(INDUSTRY) LIKE '%FOOD%' OR UPPER(INDUSTRY) LIKE '%BEVERAGE%' THEN 'Food & beverage'
    WHEN UPPER(INDUSTRY) LIKE '%RESIDEN%' THEN 'Residential'
    WHEN UPPER(INDUSTRY) LIKE '%MACH%' THEN 'Machine building'
    WHEN UPPER(INDUSTRY) LIKE '%UTIL%' THEN 'Utilities'
    WHEN UPPER(INDUSTRY) LIKE '%BUILD%' THEN 'Buildings'
    WHEN UPPER(INDUSTRY) LIKE '%DATA%' THEN 'Data centres'
    ELSE INDUSTRY
  END AS industry_clean,
  CASE
    WHEN UPPER(PREFERRED_CHANNEL) = 'SALES REP' THEN 'Sales Rep'
    WHEN UPPER(PREFERRED_CHANNEL) = 'ONLINE'    THEN 'Online'
    WHEN UPPER(PREFERRED_CHANNEL) = 'EMAIL'     THEN 'Email'
    WHEN UPPER(PREFERRED_CHANNEL) = 'DEALER'    THEN 'Dealer'
    ELSE PREFERRED_CHANNEL
  END AS preferred_channel_clean,
  COUNT(*) AS total
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY
GROUP BY 1, 2
ORDER BY industry_clean, total DESC;
-- Insight: preferência de canal varia por setor — personalizar
-- abordagem comercial por segmento aumenta eficiência


-- =====================================================
-- ETAPA 7: ANÁLISE DE CONTATOS
-- =====================================================

-- 7.1 Taxa de resposta a campanhas por nível de senioridade
SELECT
  CASE
    WHEN UPPER(SENIORITY_LEVEL) = 'JUNIOR'   THEN 'Junior'
    WHEN UPPER(SENIORITY_LEVEL) = 'MID'      THEN 'Mid'
    WHEN UPPER(SENIORITY_LEVEL) = 'SENIOR'   THEN 'Senior'
    WHEN UPPER(SENIORITY_LEVEL) = 'DIRECTOR' THEN 'Director'
    WHEN UPPER(SENIORITY_LEVEL) = 'C-LEVEL'  THEN 'C-Level'
    ELSE SENIORITY_LEVEL
  END AS seniority_clean,
  AVG(TRY_CAST(REPLACE(CAMPAIGN_RESPONSE_RATE, '%', '') AS NUMBER)) AS media_response_rate
FROM CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY
GROUP BY 1
ORDER BY media_response_rate DESC;
-- Insight: senioridade não é fator determinante para resposta a campanhas

-- 7.2 Taxa de resposta por Decision_Maker_Flag
SELECT
  DECISION_MAKER_FLAG,
  AVG(TRY_CAST(REPLACE(CAMPAIGN_RESPONSE_RATE, '%', '') AS NUMBER)) AS media_response_rate
FROM CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY
GROUP BY 1
ORDER BY media_response_rate DESC;
-- Resultado: tomadores de decisão respondem mais campanhas (~8.3% vs ~7.0%)
-- Insight: contatar decision makers gera mais engajamento nas campanhas

-- 7.3 Influence_Score médio por departamento
SELECT
  CASE
    WHEN UPPER(DEPARTMENT) IN ('MARKETING') OR UPPER(DEPARTMENT) LIKE '%ARKET%' THEN 'Marketing'
    WHEN UPPER(DEPARTMENT) IN ('SALES') OR UPPER(DEPARTMENT) LIKE '%ALE%' THEN 'Sales'
    WHEN UPPER(DEPARTMENT) IN ('ENGINEERING') OR UPPER(DEPARTMENT) LIKE '%GINEER%' THEN 'Engineering'
    WHEN UPPER(DEPARTMENT) IN ('PROCUREMENT') OR UPPER(DEPARTMENT) LIKE '%ROCURE%' THEN 'Procurement'
    WHEN UPPER(DEPARTMENT) IN ('QUALITY') OR UPPER(DEPARTMENT) LIKE '%UALIT%' THEN 'Quality'
    WHEN UPPER(DEPARTMENT) IN ('OPERATIONS') OR UPPER(DEPARTMENT) LIKE '%PERAT%' THEN 'Operations'
    WHEN UPPER(DEPARTMENT) IN ('PRODUCTION') OR UPPER(DEPARTMENT) LIKE '%RODUC%' THEN 'Production'
    WHEN UPPER(DEPARTMENT) IN ('MANAGEMENT') OR UPPER(DEPARTMENT) LIKE '%ANAGE%' THEN 'Management'
    WHEN UPPER(DEPARTMENT) = 'IT' THEN 'IT'
    ELSE 'Outros/Inválidos'
  END AS department_clean,
  AVG(TRY_CAST(INFLUENCE_SCORE AS NUMBER)) AS media_influence_score
FROM CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY
GROUP BY 1
ORDER BY media_influence_score DESC;
-- Outros excluídos da interpretação (1.2% da base — impacto insignificante)

-- 7.4 Taxa de resposta por método de contato preferido
SELECT
  CASE
    WHEN UPPER(PREFERRED_CONTACT_METHOD) LIKE '%EMAIL%'
      OR UPPER(PREFERRED_CONTACT_METHOD) IN ('EMAL','EMATL','EMAIJ','EMAFL','EMAUL','EMAIF','EMAII','EMALL','EAIL','EBAIL','EDAIL','DMAIL','FMAIL') THEN 'Email'
    WHEN UPPER(PREFERRED_CONTACT_METHOD) LIKE '%PHONE%'
      OR UPPER(PREFERRED_CONTACT_METHOD) IN ('PHNE','PHOFE','PHONY','PHPNE','PHOBE','PYONE','PHENE','PHOE','PUONE','PHONR','PHONP','PHONK','PHON') THEN 'Phone'
    WHEN UPPER(PREFERRED_CONTACT_METHOD) LIKE '%LINKEDIN%'
      OR UPPER(PREFERRED_CONTACT_METHOD) LIKE '%LINKED%'
      OR UPPER(PREFERRED_CONTACT_METHOD) LIKE '%LNKED%' THEN 'LinkedIn'
    WHEN UPPER(PREFERRED_CONTACT_METHOD) LIKE '%EVENT%'
      OR UPPER(PREFERRED_CONTACT_METHOD) IN ('IVENTS','WVENTS','EVNTS','EVENS') THEN 'Events'
    ELSE 'Outros/Inválidos'
  END AS contact_method_clean,
  AVG(TRY_CAST(REPLACE(CAMPAIGN_RESPONSE_RATE, '%', '') AS NUMBER)) AS media_response_rate
FROM CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY
GROUP BY 1
ORDER BY media_response_rate DESC;
-- Insight: respeitar o método preferido do contato melhora o engajamento

-- 7.5 Contatos ativos vs inativos
SELECT
  CASE
    WHEN ACTIVE_FLAG = TRUE  THEN 'Ativo'
    WHEN ACTIVE_FLAG = FALSE THEN 'Inativo'
  END AS status_contato,
  COUNT(*) AS total,
  COUNT(*) / SUM(COUNT(*)) OVER() * 100 AS percentual
FROM CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY
GROUP BY 1
ORDER BY total DESC;

-- 7.6 Origem dos contatos por fonte (Data_Source)
SELECT
  CASE
    WHEN UPPER(DATA_SOURCE) LIKE '%CRM%' THEN 'CRM'
    WHEN UPPER(DATA_SOURCE) LIKE '%LINK%' OR UPPER(DATA_SOURCE) LIKE '%LNKED%' THEN 'LinkedIn'
    WHEN UPPER(DATA_SOURCE) LIKE '%EMAIL%' OR UPPER(DATA_SOURCE) LIKE '%MAIL%' THEN 'Email Campaign'
    WHEN UPPER(DATA_SOURCE) LIKE '%WEBIN%' OR UPPER(DATA_SOURCE) LIKE '%EBIN%' THEN 'Webinar'
    WHEN UPPER(DATA_SOURCE) LIKE '%FAIR%' OR UPPER(DATA_SOURCE) LIKE '%FAI%' THEN 'Fair'
    ELSE 'Outros/Inválidos'
  END AS data_source_clean,
  COUNT(*) AS total_contatos
FROM CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY
GROUP BY 1
ORDER BY total_contatos DESC;
-- Resultado: CRM é a maior fonte com ~53% dos contatos
-- Insight: base concentrada no CRM — diversificar canais de captação


-- =====================================================
-- ETAPA 8: ANÁLISE COMBINADA (JOIN entre tabelas)
-- =====================================================

-- 8.1 JOIN base — Companies + Employees via Company_ID
SELECT
  c.COMPANY_ID,
  c.INDUSTRY,
  c.COMPANY_SIZE,
  c.ANNUAL_REVENUE,
  c.CONVERSION_RATE,
  e.EMPLOYEE_ID,
  e.NAME,
  e.JOB_TITLE,
  e.SENIORITY_LEVEL,
  e.DECISION_MAKER_FLAG,
  e.CAMPAIGN_RESPONSE_RATE
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY c
INNER JOIN CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY e
  ON c.COMPANY_ID = e.COMPANY_ID
LIMIT 10;
-- INNER JOIN: traz apenas empresas que têm contatos mapeados

-- 8.2 Taxa de conversão da empresa por nível de senioridade do contato
SELECT
  CASE
    WHEN UPPER(e.SENIORITY_LEVEL) = 'JUNIOR'   THEN 'Junior'
    WHEN UPPER(e.SENIORITY_LEVEL) = 'MID'      THEN 'Mid'
    WHEN UPPER(e.SENIORITY_LEVEL) = 'SENIOR'   THEN 'Senior'
    WHEN UPPER(e.SENIORITY_LEVEL) = 'DIRECTOR' THEN 'Director'
    WHEN UPPER(e.SENIORITY_LEVEL) = 'C-LEVEL'  THEN 'C-Level'
    ELSE e.SENIORITY_LEVEL
  END AS seniority_clean,
  AVG(c.CONVERSION_RATE) AS media_conversao
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY c
INNER JOIN CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY e
  ON c.COMPANY_ID = e.COMPANY_ID
GROUP BY 1
ORDER BY media_conversao DESC;
-- Insight: senioridade do contato não é fator determinante
-- na taxa de conversão da empresa

-- 8.3 Receita anual da empresa por departamento do contato
SELECT * FROM (
  SELECT
    CASE
      WHEN UPPER(e.DEPARTMENT) IN ('MARKETING') OR UPPER(e.DEPARTMENT) LIKE '%ARKET%' THEN 'Marketing'
      WHEN UPPER(e.DEPARTMENT) IN ('SALES') OR UPPER(e.DEPARTMENT) LIKE '%ALE%' THEN 'Sales'
      WHEN UPPER(e.DEPARTMENT) IN ('ENGINEERING') OR UPPER(e.DEPARTMENT) LIKE '%GINEER%' THEN 'Engineering'
      WHEN UPPER(e.DEPARTMENT) IN ('PROCUREMENT') OR UPPER(e.DEPARTMENT) LIKE '%ROCURE%' THEN 'Procurement'
      WHEN UPPER(e.DEPARTMENT) IN ('QUALITY') OR UPPER(e.DEPARTMENT) LIKE '%UALIT%' THEN 'Quality'
      WHEN UPPER(e.DEPARTMENT) IN ('OPERATIONS') OR UPPER(e.DEPARTMENT) LIKE '%PERAT%' THEN 'Operations'
      WHEN UPPER(e.DEPARTMENT) IN ('PRODUCTION') OR UPPER(e.DEPARTMENT) LIKE '%RODUC%' THEN 'Production'
      WHEN UPPER(e.DEPARTMENT) IN ('MANAGEMENT') OR UPPER(e.DEPARTMENT) LIKE '%ANAGE%' THEN 'Management'
      WHEN UPPER(e.DEPARTMENT) = 'IT' THEN 'IT'
      ELSE 'Outros'
    END AS department_clean,
    AVG(c.ANNUAL_REVENUE) AS media_receita
  FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY c
  INNER JOIN CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY e
    ON c.COMPANY_ID = e.COMPANY_ID
  GROUP BY 1
) WHERE department_clean != 'Outros'
ORDER BY media_receita DESC;
-- Outros excluídos (1.2% da base — impacto insignificante)

-- 8.4 Impacto de ter Decision Maker mapeado na conversão
SELECT
  e.DECISION_MAKER_FLAG,
  COUNT(DISTINCT c.COMPANY_ID) AS total_empresas,
  AVG(c.CONVERSION_RATE) AS media_conversao
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY c
INNER JOIN CRMSALESOPPORTUNITIES.PUBLIC.EMPLOYEES_NOISY e
  ON c.COMPANY_ID = e.COMPANY_ID
GROUP BY 1
ORDER BY media_conversao DESC;
-- Insight: ter decision maker mapeado não impacta a taxa de conversão da empresa
-- mas impacta o engajamento nas campanhas (ver query 7.2)


-- =====================================================
-- ETAPA 9: KPIs COMERCIAIS
-- =====================================================

-- 9.1 Taxa de conversão geral da base
SELECT AVG(CONVERSION_RATE) AS media_conversao_geral
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY;
-- Resultado: ~0.80% — taxa baixa, indica oportunidade de melhoria no funil

-- 9.2 Custo por lead (Marketing_Spend / Leads_Generated)
-- NOTA: Marketing_Spend é VARCHAR com sufixo 'K' — usar REPLACE + TRY_CAST
SELECT
  AVG(TRY_CAST(REPLACE(MARKETING_SPEND, 'K', '') AS NUMBER) / LEADS_GENERATED) AS custo_por_lead
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY;
-- Resultado: custo médio por lead de ~48.72 (em milhares)

-- 9.3 Top 10 empresas por taxa de conversão
SELECT
  COMPANY_ID,
  CONVERSION_RATE
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY
WHERE CONVERSION_RATE IS NOT NULL
ORDER BY CONVERSION_RATE DESC
LIMIT 10;
-- Insight: poucas empresas se destacam (10%) — a maioria converge
-- para o mesmo patamar (~1.5%)

-- 9.4 Status de contrato por grupo
SELECT
  CASE
    WHEN UPPER(CONTRACT_STATUS) = 'ACTIVE'  THEN 'Active'
    WHEN UPPER(CONTRACT_STATUS) = 'PENDING' THEN 'Pending'
    WHEN UPPER(CONTRACT_STATUS) = 'EXPIRED' THEN 'Expired'
  END AS contract_status_clean,
  COUNT(*) AS total_empresas,
  COUNT(*) / SUM(COUNT(*)) OVER() * 100 AS percentual
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY
GROUP BY 1
ORDER BY total_empresas DESC;

-- 9.5 Comportamento de pagamento por setor
SELECT
  CASE
    WHEN UPPER(INDUSTRY) LIKE '%AERO%' THEN 'Aerospace'
    WHEN UPPER(INDUSTRY) LIKE '%MINING%' THEN 'Mining, metals & minerals'
    WHEN UPPER(INDUSTRY) LIKE '%HEALTH%' THEN 'Healthcare'
    WHEN UPPER(INDUSTRY) LIKE '%SPACE%' OR UPPER(INDUSTRY) = 'SPABE' THEN 'Space'
    WHEN UPPER(INDUSTRY) LIKE '%OIL%' THEN 'Oil & gas'
    WHEN UPPER(INDUSTRY) LIKE '%VEHICLE%' OR UPPER(INDUSTRY) LIKE '%VEHCLE%' THEN 'Vehicles'
    WHEN UPPER(INDUSTRY) LIKE '%FOOD%' OR UPPER(INDUSTRY) LIKE '%BEVERAGE%' THEN 'Food & beverage'
    WHEN UPPER(INDUSTRY) LIKE '%RESIDEN%' THEN 'Residential'
    WHEN UPPER(INDUSTRY) LIKE '%MACH%' THEN 'Machine building'
    WHEN UPPER(INDUSTRY) LIKE '%UTIL%' THEN 'Utilities'
    WHEN UPPER(INDUSTRY) LIKE '%BUILD%' THEN 'Buildings'
    WHEN UPPER(INDUSTRY) LIKE '%DATA%' THEN 'Data centres'
    ELSE 'Outros'
  END AS industry_clean,
  CASE
    WHEN UPPER(PAYMENT_BEHAVIOR) = 'ON-TIME'          THEN 'Adimplente'
    WHEN UPPER(PAYMENT_BEHAVIOR) = 'OCCASIONAL DELAY' THEN 'Atraso Ocasional'
    WHEN UPPER(PAYMENT_BEHAVIOR) = 'LATE'             THEN 'Inadimplente'
  END AS payment_clean,
  COUNT(*) AS total_empresas
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY
WHERE PAYMENT_BEHAVIOR IS NOT NULL
GROUP BY 1, 2
ORDER BY industry_clean, total_empresas DESC;
-- Insight: comportamento de pagamento varia por setor
-- Utilities: setor mais adimplente — menor risco financeiro
-- Space: proporcionalmente mais inadimplentes — maior risco


-- =====================================================
-- ETAPA 10: TESTE DE HIPÓTESE (CONCEITUAL)
-- =====================================================

-- H0: O tamanho da empresa não influencia a taxa de conversão
-- H1: Empresas maiores têm maior taxa de conversão

SELECT
  CASE
    WHEN UPPER(COMPANY_SIZE) = 'SMALL'  THEN 'Small'
    WHEN UPPER(COMPANY_SIZE) = 'MEDIUM' THEN 'Medium'
    WHEN UPPER(COMPANY_SIZE) = 'LARGE'  THEN 'Large'
  END AS company_size_clean,
  COUNT(*) AS total_empresas,
  AVG(CONVERSION_RATE)    AS media_conversao,
  MEDIAN(CONVERSION_RATE) AS mediana_conversao
FROM CRMSALESOPPORTUNITIES.PUBLIC.COMPANIES_NOISY
GROUP BY 1
ORDER BY media_conversao DESC;

-- Resultado: Large 0.82% | Medium 0.80% | Small 0.80%
-- Mediana idêntica para todos os grupos: 0.80%
-- Conclusão: H0 MANTIDA — o tamanho da empresa NÃO influencia
-- a taxa de conversão. A diferença entre os grupos é mínima (0.02%)
-- e a mediana confirma que não há distorção por outliers.


-- =====================================================
-- ETAPA 11: RESUMO EXECUTIVO
-- =====================================================

-- 1. PROBLEMA:
--    Entender quais perfis de empresa e contato geram mais
--    conversão e como otimizar o funil B2B.

-- 2. O QUE OS DADOS MOSTRARAM:
--    - Taxa de conversão geral baixa (~0.80%) — oportunidade de melhoria no funil
--    - Email lidera em volume de leads E em taxa de conversão (0.85%)
--    - Search Engine Marketing (SEM/Google Ads) é o segundo melhor (0.83%)
--    - Trade Show tem o menor retorno (0.73%) — revisar estratégia
--    - Tamanho da empresa não influencia conversão — Large, Medium e Small similares
--    - Comportamento de pagamento varia por setor — Utilities mais adimplente,
--      Space com maior índice de inadimplência
--    - CRM é a principal fonte de contatos (53%) — base concentrada em uma fonte
--    - Department e Data_Source com alto índice de inconsistência —
--      análises por essas dimensões devem ser interpretadas com cautela

-- 3. HIPÓTESE:
--    H0 MANTIDA — tamanho da empresa NÃO influencia a taxa de conversão
--    Diferença entre Large (0.82%), Medium (0.80%) e Small (0.80%) é mínima
--    Mediana idêntica confirma: não há evidência de diferença real

-- 4. DECISÕES POSSÍVEIS:
--    - Concentrar investimento em campanhas de Email e SEM — maior retorno
--    - Revisar estratégia de Trade Show — menor taxa de conversão
--    - Não segmentar prospecção por tamanho de empresa — não há diferença real
--    - Priorizar setores adimplentes como Utilities — menor risco financeiro
--    - Diversificar canais de captação além do CRM — reduzir dependência
--    - Criar VIEW no Snowflake com dados já limpos — evitar repetição
--      de CASE WHEN em cada query (boa prática para produção)

-- 5. LIMITAÇÕES:
--    - Dataset sintético — não representa dados reais de mercado
--    - Data_Source com 91 variações — análise de origem dos leads comprometida
--    - Department com 118 variações — análises por departamento com cautela
--    - Nomes de contatos anonimizados — impossível análise individual
--    - Dataset estático — sem dimensão temporal de evolução do funil
--    - Marketing_Spend e Campaign_Response_Rate armazenados como VARCHAR
--      com sufixos (K, %) — requer tratamento em cada query
