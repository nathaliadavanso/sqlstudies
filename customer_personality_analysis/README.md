# Análise de Marketing — Customer Personality Dataset

Este projeto analisa o comportamento de clientes e a performance de campanhas de marketing utilizando um dataset público do Kaggle, com foco em Data Quality, métricas e KPIs.

## Contexto de Negócio

Uma empresa de varejo precisa entender melhor quem são seus clientes, quais campanhas geram mais engajamento e onde concentrar esforços de marketing para maximizar resultado.

A análise busca responder:

- Quais campanhas estão funcionando e quais precisam ser revisadas?
- Quais canais de venda têm maior potencial?
- Qual o perfil dos clientes que mais gastam?
- Onde o time de marketing deve concentrar esforços?

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

**1. Taxa de adesão às campanhas**

| Campanha | Adesões | Taxa |
|---|---|---|
| Campanha 1 | 144 | 6,43% |
| Campanha 2 | 30 | 1,34% |
| Campanha 3 | 163 | 7,28% |
| Campanha 4 | 167 | 7,46% |
| Campanha 5 | 163 | 7,28% |

A Campanha 2 teve adesão de apenas 1,34% — 5,5x abaixo da Campanha 4, que liderou o ranking. Essa diferença expressiva sugere que o formato, canal ou segmentação da Campanha 2 não foram adequados ao perfil da base. Antes de investir em novas rodadas, é recomendável investigar o que diferenciou essas duas campanhas em termos de abordagem e público.

**2. Clientes ativos vs inativos**

| Status | Clientes | % |
|---|---|---|
| Ativos (até 90 dias) | 2.042 | 91,2% |
| Inativos (acima de 90 dias) | 198 | 8,8% |

A base está majoritariamente ativa, o que indica bom engajamento geral. Contudo, os 198 clientes inativos representam receita potencial não capturada — considerando o gasto médio de R$ 606 por cliente, esse grupo pode representar até R$ 120 mil em receita se reativado. Uma estratégia de reativação com ofertas personalizadas baseadas no histórico de compra é recomendada.

**3. Perfil de clientes de alto valor**

Os top 10 clientes por gasto total apresentam perfil consistente: 100% com renda alta ou média alta, maioria com ensino superior e distribuição entre Baby Boomer, Gen X e Millennial. Gasto entre R$ 2.302 e R$ 2.525 — comportamento uniforme que indica potencial de fidelização com benefícios exclusivos.

**4. Canal mais eficiente**

A loja física concentra 46,2% das compras — o dobro do canal web (32,6%). Esse resultado é coerente com o perfil demográfico da base: clientes acima de 60 anos, casados e com nível superior tendem a preferir canais diretos e presenciais. O canal web, com média de 4,08 compras por cliente, ainda tem potencial de crescimento — vale investigar barreiras de conversão digital para esse perfil.

**5. Segmentos com maior gasto médio**

Vinho representa 50% do gasto médio por cliente (R$ 303,94). Vinho e carne juntos concentram cerca de 78% do gasto total. As demais categorias — peixe, doce e frutas — ficam abaixo de R$ 40 de média cada.

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
- Clientes que mais aderem a campanhas: identificados por soma das 5 campanhas

### Performance de Campanhas

- Total de clientes que aderiram a pelo menos 1 campanha: 667 (29,8% da base)
- Campanha mais eficiente: Campanha 4 (7,46%)
- Campanha menos eficiente: Campanha 2 (1,34%) — 5,5x abaixo da melhor campanha

## Insights e Recomendações para o Time de Marketing

**1. Pausar ou reformular a Campanha 2**
Com taxa de adesão de apenas 1,34%, a Campanha 2 está muito abaixo das demais. Antes de novos investimentos, investigar o que diferenciou essa campanha das outras em formato, canal e segmentação. Usar a Campanha 4 como benchmark.

**2. Fortalecer a presença na loja física e investigar barreiras no digital**
A loja concentra 46,2% das compras — reflexo direto do perfil maduro da base. Ao mesmo tempo, o canal web tem média de 4,08 compras por cliente, o que indica espaço para crescimento. Vale testar ações digitais adaptadas ao perfil 60+, como comunicação mais clara e processos de compra simplificados.

**3. Concentrar campanhas em vinho e carne**
Essas duas categorias representam 78% do gasto total. Campanhas promocionais nessas categorias têm maior potencial de retorno. Explorar cross-sell entre os dois produtos.

**4. Criar estratégia de reativação para os 198 inativos**
Considerando o gasto médio da base, esse grupo representa receita potencial relevante. Uma campanha segmentada com base no histórico de compra de cada cliente pode ser o caminho.

**5. Fidelizar os clientes de alto valor**
Os top 10 clientes têm comportamento uniforme e perfil consistente. Uma estratégia de fidelização com benefícios exclusivos pode aumentar a retenção desse grupo de maior impacto na receita.

## Limitações do Dataset

- Ausência de dados de custo por campanha — não foi possível calcular CAC (Custo de Aquisição de Cliente) nem ROI real de cada campanha
- Ausência de dados de receita por cliente — impossibilita o cálculo de LTV (Lifetime Value)
- Dataset estático — não representa comportamento em tempo real
- Ausência de dados sobre canal de aquisição dos clientes
- Categorias inconsistentes em Marital_Status (Absurd, YOLO) indicam necessidade de limpeza
- Ausência de dados sobre valor por canal (apenas volume de compras)

## Próximos Passos

- Tratar valores inconsistentes em Marital_Status antes de segmentações
- Criar modelo de customer scoring com base em RFM (Recência, Frequência, Valor)
- Implementar dashboard no Looker Studio ou Power BI
- Incluir dados de custo de campanha para viabilizar cálculo de CAC e ROI
- Evoluir para análises preditivas de churn e LTV

## Ferramentas Utilizadas

- **SQL** (PostgreSQL) — todas as análises
- **DBeaver** — ambiente de desenvolvimento
- **Dataset:** Kaggle — Customer Personality Analysis
