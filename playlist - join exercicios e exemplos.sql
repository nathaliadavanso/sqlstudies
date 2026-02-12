-- cruzamento de dados 
 
-- exemplo professor 
select *
from training.transacao_produto tp
left join training.produtos p 
on tp."IdProduto"::varchar = p."IdProduto"

-- meu exemplo -- from é esquerda *** lembrar, no from e a tabela de referencia 
select *
from training.transacoes t 
left join training.clientes c 
on t."IdCliente" = c."idCliente" 


-- trazer todas as colunas da tabela 1 e so 1 da tabela 2 
select
    t.*,
    c."qtdePontos"
from training.transacoes t
left join training.clientes c
    on t."IdCliente" = c."idCliente";

-- exemplo professor 

-- qual categoria teem mais produtos vendidos 

select *
from training.produtos as t1
left join trainin

-- em 2024 quantas transacoes de lovers tivemos?



select *
from training.transacoes as t1
		left join training.transacao_produto as t2
  		on t1."IdTransacao" = t2."IdTransacao"
 			left join training.produtos as t3
 				on t2."IdProduto" = t3."IdProduto"
where t1."DtCriacao" >= '2024-01-01'
  and t1."DtCriacao" <  '2025-01-01'
  and t3."DescCategoriaProduto" = 'lovers'
  
  
  
  -- qual mes tivemos mais lista de preesença assinada?
  
  select * 
  from training.transacoes as t1
  left join training.transacao_produto as t2
  on t1."IdTransacao" = t2."IdTransacao" 
  left join training.produtos as t3 
  on t2."IdProduto" = t3."IdProduto" 
  where ""
  
