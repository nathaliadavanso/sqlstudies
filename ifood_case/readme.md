# Análise de Comportamento e Campanhas de Marketing: iFood Dataset

Este projeto analisa o comportamento de compra de clientes e o impacto de campanhas de marketing utilizando o dataset público do iFood, disponível no Kaggle. A análise foi realizada no Snowflake com visualização no Looker Studio.

## Pergunta Central

**Campanhas de marketing impactam na decisão de compra dos clientes?**

---

## Contexto de Negócio

O time de marketing precisa entender se as campanhas estão gerando impacto real no comportamento de compra dos clientes, quais perfis concentram maior valor para o negócio e onde concentrar esforços para maximizar retorno.

A análise busca responder:

- Campanhas de marketing impactam o gasto dos clientes?
- Quais perfis de clientes gastam mais e onde investir?
- Quais categorias de produto concentram o consumo?
- Onde cortar ou realocar investimento de marketing?

---

## Dataset Utilizado

- **Fonte:** [Kaggle: Marketing Data](https://www.kaggle.com/datasets/jackdaoud/marketing-data/data)
- **Total de registros:** 2.205 clientes
- **Ferramenta de análise:** Snowflake
- **Período:** Dataset estático (sem atualização em tempo real)

---

## Qualidade dos Dados

| Verificação | Resultado |
|---|---|
| Valores nulos nas variáveis principais | Nenhum |
| Valores negativos no gasto | Nenhum |
| Variáveis binárias (campanhas) | Apenas 0 e 1: íntegras |
| Consistência MntTotal vs soma das categorias | Consistente (validado com ROUND) |
| Valores extremos de renda e idade | Dentro de intervalos plausíveis |

**Conclusão:** Base com boa qualidade, apta para análise sem necessidade de tratamento.

---

## Estatística Descritiva

| Métrica | Valor |
|---|---|
| Média de gasto | R$ 562,76 |
| Mediana de gasto | R$ 343,00 |
| Desvio padrão | R$ 575,94 |
| IC 95% | R$ 538 a R$ 587 |

A média (R$ 562) acima da mediana (R$ 343) indica distribuição assimétrica: poucos clientes de alto gasto puxam a média para cima. A mediana representa melhor o cliente típico. Isso é importante: planejar campanhas com base na média pode superestimar o retorno esperado.

---

## Métricas e KPIs

### Métricas Básicas

| Métrica | Valor |
|---|---|
| Total de clientes | 2.205 |
| Gasto médio por cliente | R$ 562,76 |
| Gasto mediano por cliente | R$ 343,00 |
| Clientes que aderiram a campanhas | 333 (15,1%) |

### Desempenho por Campanha

Cada campanha foi avaliada por dois critérios: volume de clientes que aderiram e gasto médio desses clientes. Volume alto não garante retorno alto.

| Campanha | Aderiram | Gasto Médio dos que Aderiram |
|---|---|---|
| Campanha 5 | 161 | R$ 1.538 |
| Campanha 1 | 142 | R$ 1.407 |
| Campanha 2 | 30 | R$ 1.241 |
| Campanha 4 | 164 | R$ 1.089 |
| Campanha 3 | 163 | R$ 654 |

A Campanha 3 teve o maior volume de adesões (163 clientes), mas o menor gasto médio (R$ 654): menos da metade do retorno da Campanha 5. Isso indica que atraiu clientes de menor valor. A Campanha 5, com volume similar, gerou retorno médio 135% maior.

---

## Análises Realizadas

### Campanhas

- Clientes que aderem a campanhas gastam **85% a mais** (R$ 924 vs R$ 498)
- A mediana confirma a diferença: não é distorção por outliers
- Campanha 5 tem o maior retorno médio (R$ 1.538)
- Campanha 3 tem o menor retorno apesar do maior volume de adesão

### Perfil

- Renda tem relação quase linear com gasto: quanto maior a renda, maior o gasto
- Clientes sem filhos gastam **4,5x mais** que clientes com 1 filho em casa
- Idade não apresenta tendência clara de impacto no gasto

### Comportamento

- Recência **não impacta** o gasto: clientes que compraram há 30 dias gastam o mesmo que os que compraram há 90 dias
- Frequência de compra tem relação positiva com o gasto

### Produtos

- Vinho representa **50,5%** do gasto total
- Vinho + carne = **78%** do gasto total
- Demais categorias (peixe, doce, frutas) representam menos de 22% juntas

---

## Hipótese

**H0:** Campanhas não impactam o comportamento de compra
**H1:** Campanhas impactam o comportamento de compra

**Conclusão:** H0 rejeitada. A diferença de R$ 426 na média de gasto entre quem aderiu e quem não aderiu é confirmada também pela mediana: não é distorção por outliers. Campanhas impactam significativamente o comportamento de compra.

---

## Insights e Recomendações para o Time de Marketing

**1. Concentrar campanhas no perfil de maior valor**
Clientes de alta renda e sem filhos em casa gastam significativamente mais. Segmentar campanhas para esse perfil aumenta o retorno sem necessariamente aumentar o volume de ações.

**2. Priorizar a Campanha 5 e investigar a Campanha 3**
A Campanha 5 gerou o maior retorno médio (R$ 1.538) com volume similar à Campanha 3. A Campanha 3, apesar do maior volume de adesão, atraiu clientes de menor valor (R$ 654 de gasto médio). Vale investigar o que diferenciou as duas em termos de segmentação e abordagem antes de replicar qualquer uma.

**3. Concentrar ofertas em vinho e carne**
Essas duas categorias respondem por 78% do gasto total. Campanhas promocionais focadas nesses produtos têm maior potencial de retorno. Explorar cross-sell entre os dois.

**4. Não usar recência como critério de segmentação**
Clientes que compraram recentemente gastam o mesmo que clientes antigos. Variáveis como renda e presença de filhos são muito mais preditivas do gasto: usar esses critérios na segmentação de campanhas.

**5. Não planejar com base na média de gasto**
A média (R$ 562) está inflada por poucos clientes de alto valor. O cliente típico gasta R$ 343. Usar a mediana como referência para projeções mais realistas de retorno.

---

## Limitações

- Ausência do custo por campanha: impossível calcular CAC (Custo de Aquisição de Cliente) nem ROI real de cada campanha
- Correlação não implica causalidade: clientes que aderem a campanhas podem já ser naturalmente mais engajados, independente da campanha
- Dataset sem dimensão temporal: não é possível analisar sazonalidade ou evolução do comportamento ao longo do tempo

---

## Dashboard

[Visualizar dashboard no Looker Studio](https://lookerstudio.google.com/reporting/5b0dd73a-d852-4c6e-b89b-6b910a474723)

---

## Ferramentas Utilizadas

- **Snowflake**: análise e queries SQL
- **Looker Studio**: dashboard e visualização
- **Dataset:** Kaggle: Marketing Data

