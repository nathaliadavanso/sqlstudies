# Estudos e Projetos em SQL — Análise de Dados de Marketing

Repositório com projetos práticos e estudos de SQL aplicados à análise de dados de marketing. Inclui dois projetos completos com Data Quality, métricas, KPIs, estatística e storytelling.

## Projetos

### 1. Customer Personality Analysis
Análise de comportamento de clientes e performance de campanhas de marketing utilizando PostgreSQL e DBeaver.

- Ferramenta: PostgreSQL + DBeaver
- Foco: Data Quality, métricas básicas, KPIs de marketing e segmentação
- Dataset: [Kaggle — Customer Personality Analysis](https://www.kaggle.com/datasets/imakash3011/customer-personality-analysis)
- Pasta: [customer_personality_analysis](./customer_personality_analysis)

### 2. iFood Case — Customer Behavior & Campaign Analysis
Análise de comportamento de clientes e impacto de campanhas, com estatística descritiva, intervalo de confiança e teste de hipótese.

- Ferramenta: Snowflake + Looker Studio
- Foco: Data Quality, estatística descritiva, campanhas e storytelling com dados
- Dataset: [Kaggle — Marketing Data](https://www.kaggle.com/datasets/jackdaoud/marketing-data)
- Dashboard: [Visualizar no Looker Studio](https://lookerstudio.google.com/reporting/5b0dd73a-d852-4c6e-b89b-6b910a474723)
- Pasta: [ifood_case](./ifood_case)

## O que os projetos têm em comum

| Aspecto | Customer Personality | iFood Case |
|---|---|---|
| Data Quality | Nulos, duplicatas, tipagem | Nulos, negativos, consistência |
| Métrica central | Gasto médio por cliente | Gasto médio por cliente |
| Canal dominante | Loja física (46,2%) | Loja física |
| Principal produto | Vinho (50% do gasto) | Vinho (50,5% do gasto) |
| Ferramenta SQL | PostgreSQL | Snowflake |
| Visualização | — | Looker Studio |

## O que evoluiu do projeto 1 para o projeto 2

- Migração de PostgreSQL para Snowflake
- Adição de estatística descritiva (média vs mediana, desvio padrão, IC 95%)
- Teste de hipótese conceitual
- Dashboard com storytelling no Looker Studio

## Estudos e Exercícios

- [mentoring_exercises](./mentoring_exercises) — exercícios da mentoria
- [sql_practice](./sql_practice) — prática de SQL

## Ferramentas Utilizadas

- SQL (PostgreSQL e Snowflake)
- DBeaver
- Looker Studio
