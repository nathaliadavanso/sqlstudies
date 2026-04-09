# Análise B2B CRM & Sales Intelligence

Este projeto analisa dados de CRM B2B com foco em **Data Quality**, perfil de empresas e contatos, performance de campanhas e KPIs comerciais. A análise foi realizada no Snowflake com duas tabelas relacionadas: empresas e contatos.

---

## Pergunta Central

**Quais perfis de empresa e contato geram mais conversão e como otimizar o funil B2B?**

---

## Contexto de Negócio

O time comercial precisa entender quais setores, tamanhos de empresa e tipos de campanha geram mais resultado, e quais perfis de contato são mais engajados — para priorizar esforços e reduzir desperdício de recursos.

A análise busca responder:
- Quais setores e tamanhos de empresa convertem mais?
- Tomadores de decisão respondem mais campanhas?
- Qual canal gera mais leads e melhor conversão?
- Receita anual influencia o comportamento de compra?
- Qual tipo de campanha performa melhor?

---

## Dataset Utilizado

- **Fonte:** [Kaggle — Synthetic B2B CRM & Marketing Dataset](https://www.kaggle.com/datasets/ezogngrd/synthetic-b2b-crm-and-marketing-data)
- **Tabelas:** `COMPANIES_NOISY` (734 empresas) + `EMPLOYEES_NOISY` (5.234 contatos)
- **Relacionamento:** via `Company_ID` (JOIN entre tabelas)
- **Ferramenta:** Snowflake
- **Período:** Dataset estático e sintético

---

## Destaque: Data Quality

Este projeto tem foco especial em Data Quality, o dataset foi construído propositalmente com dados sujos para simular cenários reais de CRM.

### Problemas identificados e tratados

| Campo | Problema | Variações | Solução |
|---|---|---|---|
| `Campaign_Type` | Erros de digitação + case | 22 variações para 6 campanhas | CASE WHEN + UPPER() |
| `Industry` | Erros de digitação + case | 32 variações para 12 setores | CASE WHEN + LIKE |
| `Department` | Erros graves de digitação | 118 variações para 9 departamentos | CASE WHEN + LIKE |
| `Data_Source` | Erros graves de digitação | 90 variações para 5 fontes | CASE WHEN + LIKE |
| `Company_Size` | Inconsistência de case | 6 variações para 3 tamanhos | UPPER() |
| `Contract_Status` | Inconsistência de case | 8 variações para 3 status | UPPER() |
| `Campaign_Response_Rate` | VARCHAR com sufixo `%` | — | TRY_CAST + REPLACE |
| `Marketing_Spend` | VARCHAR com sufixo `K` | — | TRY_CAST + REPLACE |
| `Influence_Score` | VARCHAR com valores `N/A` | — | TRY_CAST |

### Impacto dos nulos

| Tabela | % Nulos geral | Impacto |
|---|---|---|
| Companies (métricas) | 0,82% | Insignificante |
| Employees (métricas + dimensões) | 0,73% | Insignificante |

**Conclusão:** base com boa qualidade estrutural, mas com alto índice de inconsistências textuais, típico de dados exportados de CRM sem padronização.

> **Nota técnica:** Numa situação real de produção, a solução ideal seria criar uma VIEW no Snowflake com todos os dados já limpos, evitando repetir o CASE WHEN em cada query.

---

## Estatística Descritiva

| Métrica | Valor |
|---|---|
| Taxa de conversão média | 0,80% |
| Taxa de conversão mediana | 0,80% |
| Desvio padrão | 0,34% |
| IC 95% | 0,78% a 0,83% |
| Receita média por empresa | 18,4MM |
| Receita mediana por empresa | 7,1MM |
| Custo médio por lead | 48,72K |

A média e mediana de conversão idênticas indicam distribuição simétrica, sem distorção por outliers. Já na receita anual, a média (18,4MM) muito acima da mediana (7,1MM) revela assimetria: poucas empresas de alta receita puxam a média para cima.

---

## Análises Realizadas

### Performance de Campanhas

| Campanha | Taxa de Conversão Média |
|---|---|
| **Email** | **0,85%** |
| SEM (Search Engine Marketing) | 0,83% |
| Webinar | 0,82% |
| Content Marketing | 0,82% |
| LinkedIn Ads | 0,77% |
| Trade Show | 0,73% |

Email lidera tanto em volume de leads quanto em conversão. Trade Show tem o pior retorno.

### Conversão por Setor (Top 5)

| Setor | Taxa de Conversão Média |
|---|---|
| Utilities | 0,90% |
| Mining, metals & minerals | 0,89% |
| Aerospace | 0,83% |
| Oil & gas | 0,82% |
| Vehicles | — |

### Conversão por Tamanho de Empresa

| Tamanho | Média | Mediana |
|---|---|---|
| Large | 0,82% | 0,80% |
| Medium | 0,81% | 0,80% |
| Small | 0,80% | 0,80% |

Diferença mínima entre os grupos, tamanho não é fator determinante.

### Origem dos Contatos

| Fonte | % da Base |
|---|---|
| CRM | 53,5% |
| LinkedIn | 16,6% |
| Email Campaign | 10,6% |
| Webinar | 9,6% |
| Fair | 7,9% |

Base muito concentrada no CRM, oportunidade de diversificar canais de captação.

### Adimplência por Setor (Top 3)

| Setor | % Adimplente |
|---|---|
| Residential | 81,7% |
| Buildings | 81,5% |
| Machine building | 81,0% |

---

## Hipótese

**H0:** O tamanho da empresa não influencia a taxa de conversão
**H1:** Empresas maiores têm maior taxa de conversão

**H0 MANTIDA** a diferença entre Large (0,82%), Medium (0,81%) e Small (0,80%) é mínima e a mediana é idêntica para todos os grupos (0,80%). Não há evidência de diferença real.

---

## Insights para o Time Comercial

**1. Email é a campanha mais eficiente**
Lidera em volume de leads e em taxa de conversão (0,85%). Priorizar Email e SEM (Search Engine Marketing) no mix de campanhas.

**2. Trade Show tem o pior retorno**
Taxa de conversão 13% abaixo do Email. Revisar estratégia ou realocar budget para canais com maior retorno.

**3. Tamanho da empresa não define conversão**
Não faz sentido segmentar prospecção por porte, Large, Medium e Small convertem de forma similar.

**4. Utilities e Mining convertem mais**
Setores com maior taxa de conversão média, priorizar na prospecção.

**5. Tomadores de decisão respondem mais campanhas**
Decision makers têm taxa de resposta ~8,3% vs ~7,0% dos demais contatos. Mapear e contatar decision makers aumenta engajamento.

**6. Diversificar captação além do CRM**
53,5% dos contatos vêm de uma única fonte. Investir em LinkedIn e Email Campaign reduz dependência e amplia o funil.

**7. Priorizar setores adimplentes**
Residential (81,7%), Buildings (81,5%) e Machine building (81,0%) são os mais confiáveis financeiramente.

---

## Limitações

- Dataset sintético — não representa dados reais de mercado
- `Data_Source` com 90 variações — análise de origem dos leads deve ser interpretada com cautela
- `Department` com 118 variações — análises por departamento com cautela
- Nomes de contatos anonimizados — impossível análise individual
- Dataset estático — sem dimensão temporal de evolução do funil
- `Marketing_Spend` e `Campaign_Response_Rate` armazenados como VARCHAR com sufixos — requer tratamento em cada query

## Próximos Passos

- Criar VIEW no Snowflake com dados já limpos para uso em produção
- Implementar dashboard no Looker Studio com storytelling comercial
- Evoluir para análise RFM (Recência, Frequência, Valor) das empresas
- Adicionar análise temporal quando dados com datas estiverem disponíveis

---

## Ferramentas Utilizadas

- **SQL** (Snowflake) — todas as análises
- **Dataset:** Kaggle — Synthetic B2B CRM & Marketing Dataset
