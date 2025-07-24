-- Safe Test - Segments Metrics Detail
-- https://dune.com/queries/5524249
with data as (SELECT
    block_time,
    tx_hash,
    feature,
    is_stablecoin_pair,
    trader,
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
WHERE usd_value IS NOT NULL
)
, segments as (
    SELECT 
        CASE 
            WHEN usd_value < 5000 THEN '0-5k'
            WHEN usd_value < 25000 THEN '5k-25k'
            WHEN usd_value < 50000 THEN '25k-50k'
            WHEN usd_value < 100000 THEN '50k-100k'
            WHEN usd_value < 250000 THEN '100k-250k'
            WHEN usd_value < 1000000 THEN '250k-1M'
            ELSE '>1M'
        END as volume_segment,
        trader,
        tx_hash,
        usd_value,
        fee_usd
    FROM data
)

SELECT
    volume_segment,
    COUNT(DISTINCT trader) as unique_traders,
    COUNT(DISTINCT tx_hash) as unique_transactions,
    SUM(usd_value) as total_volume_usd,
    SUM(fee_usd) as total_fee_usd
FROM segments
GROUP BY volume_segment
ORDER BY 
    CASE volume_segment 
        WHEN '0-5k' THEN 1
        WHEN '5k-25k' THEN 2
        WHEN '25k-50k' THEN 3
        WHEN '50k-100k' THEN 4
        WHEN '100k-250k' THEN 5
        WHEN '250k-1M' THEN 6
        WHEN '>1M' THEN 6
    END
