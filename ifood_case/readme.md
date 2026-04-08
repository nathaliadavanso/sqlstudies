# Análise de Comportamento e Campanhas de Marketing — iFood Dataset

Este projeto analisa o comportamento de compra de clientes e o impacto de campanhas de marketing utilizando o dataset público do iFood, disponível no Kaggle. A análise foi realizada no Snowflake com visualização no Looker Studio.

## Pergunta Central

**Campanhas de marketing realmente impactam o comportamento de compra?**

---

## Contexto de Negócio

O time de marketing precisa entender se as campanhas estão gerando impacto real no comportamento de compra dos clientes, e quais perfis concentram maior valor para o negócio.

A análise busca responder:
- Campanhas de marketing impactam o gasto dos clientes?
- Quais perfis de clientes gastam mais?
- Quais categorias de produto concentram o consumo?

---

## Dataset Utilizado

- **Fonte:** https://www.kaggle.com/datasets/jackdaoud/marketing-data/data
- **Total de registros:** 2.205 clientes
- **Ferramenta de análise:** Snowflake
- **Período:** Dataset estático (sem atualização em tempo real)

---

## Qualidade dos Dados

| Verificação | Resultado |
|---|---|
| Valores nulos nas variáveis principais | Nenhum |
| Valores negativos no gasto | Nenhum |
| Variáveis binárias (campanhas) | Apenas 0 e 1 — íntegras |
| Consistência MntTotal vs soma das categorias | Consistente (validado com ROUND) |
| Valores extremos de renda e idade | Dentro de intervalos plausíveis |

**Conclusão:** Base com boa qualidade — apta para análise sem necessidade de tratamento.

---

## Estatística Descritiva

| Métrica | Valor |
|---|---|
| Média de gasto | R$ 562,76 |
| Mediana de gasto | R$ 343,00 |
| Desvio padrão | R$ 575,94 |
| IC 95% | R$ 538 a R$ 587 |

A média acima da mediana indica distribuição assimétrica — poucos clientes de alto gasto puxam a média para cima. A mediana representa melhor o cliente típico.

---

## Métricas e KPIs

### Métricas Básicas

| Métrica | Valor |
|---|---|
| Total de clientes | 2.205 |
| Gasto médio por cliente | R$ 562,76 |
| Gasto mediano por cliente | R$ 343,00 |
| Clientes que responderam campanhas | 333 (15,1%) |

### Desempenho por Campanha

| Campanha | Aceitaram | Gasto Médio |
|---|---|---|
| Campanha 5 | 161 | R$ 1.538 |
| Campanha 1 | 142 | R$ 1.407 |
| Campanha 2 | 30 | R$ 1.241 |
| Campanha 4 | 164 | R$ 1.089 |
| Campanha 3 | 163 | R$ 654 |

---

## Análises Realizadas

### Campanhas
- Clientes que respondem campanhas gastam **85% a mais** (R$924 vs R$498)
- A mediana confirma a diferença — não é distorção por outliers
- Campanha 5 tem maior retorno médio (R$1.538)

### Perfil
- Renda tem relação quase linear com gasto
- Clientes sem filhos gastam **4,5x mais** que clientes com 1 filho
- Idade não apresenta tendência clara

### Comportamento
- Recência **não impacta** o gasto — os três grupos gastam valores similares (~R$560)
- Frequência de compra tem relação positiva com o gasto

### Produtos
- Vinho representa **50,5%** do gasto total
- Vinho + carne = **78%** do gasto total

---

## Hipótese

**H0:** Campanhas não impactam o comportamento de compra  
**H1:** Campanhas impactam o comportamento de compra

**Conclusão:** H0 rejeitada. A diferença de R$426 na média entre os grupos é confirmada também pela mediana — não é distorção por outliers. Campanhas impactam significativamente o comportamento de compra.

---

## Insights para o Time de Marketing

**1. Focar campanhas no perfil de maior valor**  
Alta renda + sem filhos = cliente que mais gasta. Concentrar esforços nesse segmento maximiza retorno.

**2. Priorizar a Campanha 5**  
Maior gasto médio entre os aceitantes (R$1.538). Usar como benchmark para novas campanhas.

**3. Vinho e carne são os produtos prioritários**  
Respondem por 78% do gasto. Campanhas promocionais nessas categorias têm maior potencial de retorno.

**4. Recência não é um bom critério de segmentação**  
Clientes antigos gastam tanto quanto recentes — outras variáveis (renda, filhos) são mais preditivas.

---

## Limitações

- Não temos o custo das campanhas — impossível calcular ROI real
- Correlação não implica causalidade — clientes que aceitam campanhas podem já ser naturalmente mais engajados
- Dataset sem dimensão temporal — não é possível analisar sazonalidade ou evolução

---

## Dashboard

[Visualizar dashboard no Looker Studio](https://lookerstudio.google.com/reporting/5b0dd73a-d852-4c6e-b89b-6b910a474723)

---

## Ferramentas Utilizadas

- **Snowflake** — análise e queries SQL
- **Looker Studio** — dashboard e visualização
- **Dataset:** Kaggle — iFood Data Business Analyst Test
