--subqueries

WITH tb_cliente_primeiro_dia AS (
    SELECT *
    FROM training.transacoes
    WHERE "DtCriacao"::date = DATE '2025-08-25'
),
tb_cliente_ultimo_dia AS (
    SELECT DISTINCT "IdCliente"
    FROM training.transacoes
    WHERE "DtCriacao"::date = DATE '2025-08-29'
)
SELECT *
FROM tb_cliente_ultimo_dia as T1
left join tb_cliente_ultimo_dia as T2
on T1."IdCliente" = T2."IdCliente" 


-- exercicios ctes e joins 



-- qual o dia com maior engajamento de cada aluno que iniciou o curso no dia 01?

WITH alunos_dia01 AS (
    SELECT DISTINCT t."IdCliente"
    FROM training.transacoes t
    WHERE substr(t."DtCriacao", 1, 10) = '2025-08-25'
)
SELECT 
    t1."IdCliente",
    substr(t2."DtCriacao", 1, 10) AS dtdia,
    COUNT(*) AS qtde_interacoes
FROM alunos_dia01 t1
LEFT JOIN training.transacoes t2
    ON t1."IdCliente" = t2."IdCliente"
   AND t2."DtCriacao" >= '2025-08-25'
   AND t2."DtCriacao" <  '2025-08-30'
GROUP BY 
    t1."IdCliente",
    substr(t2."DtCriacao", 1, 10)
ORDER BY 
    t1."IdCliente",
    dtdia;
