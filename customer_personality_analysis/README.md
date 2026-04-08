# Análise de Marketing — Customer Personality Dataset

Este projeto analisa o comportamento de clientes e a performance de campanhas de marketing utilizando um dataset público do Kaggle, com foco em Data Quality, métricas e KPIs.

## Contexto de Negócio

A análise busca apoiar decisões estratégicas como:

- Otimização de campanhas
- Identificação de clientes de alto valor
- Priorização de canais
- Segmentação de público

## Dataset Utilizado

- **Fonte:** [Kaggle — Customer Personality Analysis](https://www.kaggle.com/datasets/imakash3011/customer-personality-analysis)
- **Total de registros:** 2.240 clientes
- **Período:** Dataset estático (sem atualização em tempo real)
- **Colunas principais:** dados demográficos, comportamento de compra e interação com campanhas

## Qualidade dos Dados

| Verificação | Resultado |
|---|---|
| Valores nulos em Income | 24 registros (1,07%) |
| IDs duplicados | Nenhum — cada cliente é único |
| Linhas duplicadas | Nenhuma |
| Tipagem incorreta | Year_Birth aparece como decimal em alguns ambientes |
| Categorias inconsistentes | Marital_Status contém valores como Absurd e YOLO |

**Impacto:** Os dados possuem boa qualidade geral. A baixa taxa de nulos em renda (1,07%) permite análises financeiras confiáveis. Os valores inconsistentes de estado civil devem ser tratados antes de segmentações mais detalhadas.

## Métricas e KPIs

### Métricas Básicas

| Métrica | Valor |
|---|---|
| Total de clientes | 2.240 |
| Total gasto (todas categorias) | R$ 1.356.988 |
| Total de compras (todos canais) | 28.083 transações |
| Compras via Web | 9.150 (32,6%) |
| Compras em Loja | 12.970 (46,2%) |
| Compras via Catálogo | 5.963 (21,2%) |

### Indicadores

| Indicador | Valor |
|---|---|
| Média de gasto por cliente | R$ 606 |
| Média de compras via Web por cliente | 4,08 |
| Média de compras em Loja por cliente | 5,79 |
| Média de compras via Catálogo por cliente | 2,66 |
| Recência média | 49 dias |

### KPIs de Marketing

**1. Taxa de resposta às campanhas**

| Campanha | Respostas | Taxa |
|---|---|---|
| Campanha 1 | 144 | 6,43% |
| Campanha 2 | 30 | 1,34% |
| Campanha 3 | 163 | 7,28% |
| Campanha 4 | 167 | 7,46% |
| Campanha 5 | 163 | 7,28% |

**2. Clientes ativos vs inativos**

| Status | Clientes | % |
|---|---|---|
| Ativos (≤90 dias) | 2.042 | 91,2% |
| Inativos (>90 dias) | 198 | 8,8% |

**3. Perfil de clientes de alto valor** — Análise dos top 10 clientes por gasto total.

**4. Canal mais eficiente** — Comparação entre Web, Loja e Catálogo.

**5. Segmentos com maior gasto médio** — Comparação de gasto médio por categoria de produto.

## Análises Realizadas

### Segmentação de Clientes

| Segmento | Grupo Dominante |
|---|---|
| Idade | Acima de 60 anos — 744 clientes (33,2%) |
| Renda | Faixa de 40k a 60k — 643 clientes (28,9%) |
| Estado civil | Married — 864 clientes (38,6%) |
| Escolaridade | Graduation — 1.127 clientes (50,3%) |

### Comportamento de Compra

- Top 10 clientes que mais compram: identificados por soma de todos os canais
- Top 10 clientes que mais gastam: gasto entre R$ 2.302 e R$ 2.525
- Clientes que mais respondem campanhas: identificados por soma das 5 campanhas

### Performance de Campanhas

- Total de clientes que responderam ao menos 1 campanha: 667 (29,8% da base)
- Campanha mais eficiente: Campanha 4 (7,46%)
- Campanha menos eficiente: Campanha 2 (1,34%) — 5,5x menos que a melhor campanha

## Insights para o Time de Marketing

**1. Campanha 2 é significativamente ineficiente**
Taxa de resposta de apenas 1,34% — 5,5x menos que a Campanha 4. Usar a Campanha 4 como benchmark antes de investir em novas rodadas.

**2. Loja física é o canal dominante**
46,2% das compras. Canal web tem potencial de crescimento com 4,08 compras médias por cliente.

**3. Vinhos são o principal driver de receita**
R$ 303,94 de gasto médio — 50% do total. Priorizar em campanhas e explorar cross-sell com carne.

**4. Clientes de alto valor têm perfil consistente**
100% com renda alta, maioria com ensino superior. Potencial de fidelização com campanhas segmentadas.

**5. Base majoritariamente ativa — inativos merecem atenção**
91,2% ativos. Os 198 inativos representam receita potencial não capturada.

**6. Perfil demográfico concentrado e maduro**
60+ anos, casados, ensino superior, renda 40k-60k. Responde melhor a canais diretos — explica dominância da loja física.

## Limitações do Dataset

- Ausência de dados temporais detalhados (impossibilita análise de sazonalidade)
- Dataset estático — não representa comportamento em tempo real
- Falta de dados sobre canal de aquisição dos clientes
- Categorias inconsistentes em Marital_Status (Absurd, YOLO)
- Ausência de dados sobre valor por canal (apenas volume)

## Próximos Passos

- Tratar valores inconsistentes em Marital_Status antes de segmentações
- Criar modelo de customer scoring com base em RFM
- Implementar dashboard no Looker Studio ou Power BI
- Investigar diferenciais da Campanha 4 para replicar em futuras campanhas
- Evoluir para análises preditivas de churn e LTV

## Ferramentas Utilizadas

- **SQL** (PostgreSQL) — todas as análises
- **DBeaver** — ambiente de desenvolvimento
- **Dataset:** Kaggle — Customer Personality Analysis
