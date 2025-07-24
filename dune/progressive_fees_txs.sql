-- Safe Test - Fees for each trade with Progressive Fee Structure Comparison
-- https://dune.com/queries/5524155
with data as (SELECT
    tx_hash,
    feature,
    block_time,
    is_stablecoin_pair,
    usd_value,
    CASE
        WHEN cast(lower(feature) as varchar) = 'cow safeapp' THEN usd_value * 0.001 * 0.45
        WHEN cast(lower(feature) as varchar) = 'oneinch safeapp' THEN usd_value * 0.001 * 0.53
        WHEN cast(lower(feature) as varchar) = 'kyberswap' THEN usd_value * 0.001 * 0.45
        -- Native Swaps (stablecoin-only pairs)
        WHEN cast(lower(feature) as varchar) IN ('native swaps', 'native swaps lifi')
             AND is_stablecoin_pair = 1 THEN
            CASE
                WHEN usd_value <= 100000 THEN usd_value * 0.0010
                WHEN usd_value <= 1000000 THEN usd_value * 0.0007
                ELSE usd_value * 0.0005
            END

        ELSE 0
    END AS normal_fees,
    CASE
        -- Native Swaps (non-stablecoin pairs)
        WHEN cast(lower(feature) as varchar) IN ('native swaps', 'native swaps lifi')
             AND is_stablecoin_pair = 0 THEN
            CASE
                WHEN usd_value <= 100000 THEN usd_value * 0.0035
                WHEN usd_value <= 1000000 THEN usd_value * 0.0020
                ELSE usd_value * 0.0010
            END
        ELSE 0
    END AS native_swaps_fees_as_is,
    CASE
      WHEN cast(lower(feature) as varchar) IN ('native swaps', 'native swaps lifi')
           AND is_stablecoin_pair = 0 THEN
        LEAST(usd_value, 100000) * 0.0035
        + GREATEST(LEAST(usd_value, 1000000) - 100000, 0) * 0.0020
        + GREATEST(usd_value - 1000000, 0) * 0.0010
      ELSE 0
    END AS native_swaps_fees_new_approach

FROM dune.safe.result_testset
where usd_value is not null
), final_table as (
  select 
    tx_hash,
    feature,
    block_time,
    is_stablecoin_pair,
    usd_value,
    sum(normal_fees) + sum(native_swaps_fees_as_is) as current_total_fees,
    sum(normal_fees) + sum(native_swaps_fees_new_approach) as new_total_fees
from data
group by 1,2,3,4,5
order by 1 desc
)
select * from final_table
where current_total_fees > 0
order by usd_value desc