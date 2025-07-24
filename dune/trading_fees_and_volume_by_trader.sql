-- Safe Test - Trading Fees and Volume by Safe{Wallet}
-- https://dune.com/queries/5524133
with data as (SELECT
    block_time,
    tx_hash,
    trader,
    feature,
    is_stablecoin_pair,
    usd_value,
    CASE
        WHEN cast(lower(feature) as varchar) = 'cow safeapp' THEN usd_value * 0.001 * 0.45
        WHEN cast(lower(feature) as varchar) = 'oneinch safeapp' THEN usd_value * 0.001 * 0.53
        WHEN cast(lower(feature) as varchar) = 'kyberswap' THEN usd_value * 0.001 * 0.45

        -- Native Swaps (non-stablecoin pairs)
        WHEN cast(lower(feature) as varchar) IN ('native swaps', 'native swaps lifi')
             AND is_stablecoin_pair = 0 THEN
            CASE
                WHEN usd_value <= 100000 THEN usd_value * 0.0035
                WHEN usd_value <= 1000000 THEN usd_value * 0.0020
                ELSE usd_value * 0.0010
            END

        -- Native Swaps (stablecoin-only pairs)
        WHEN cast(lower(feature) as varchar) IN ('native swaps', 'native swaps lifi')
             AND is_stablecoin_pair = 1 THEN
            CASE
                WHEN usd_value <= 100000 THEN usd_value * 0.0010
                WHEN usd_value <= 1000000 THEN usd_value * 0.0007
                ELSE usd_value * 0.0005
            END

        ELSE 0
    END AS fee_usd
FROM dune.safe.result_testset
where usd_value is not null
)
select
    trader
    , sum(usd_value) as usd_value
    , sum(fee_usd) as fee_usd
    , sum(fee_usd) / sum(usd_value) * 1.0 as fee_percentage
    , count(distinct tx_hash) as tx_count
from data
group by 1
order by 3 desc
