# Revenue Analysis
Link to the Dune Dashboard: https://dune.com/jondar/safe-assignment-23-07-2025/d44bf340-35e8-424e-bbb7-6b87b27da7c7

From the analysis, it emerges that $240,630,552.01 was swapped on Safe during the period, for a total revenue of $276,084.43.
The distribution of volume, revenue, and transaction count varies depending on the protocol: the protocol within Safe that saw the highest volume is the native swap, followed by 1inch. However, looking at revenue, native swap is the absolute leader, contributing 74% of the total. Surprisingly, the highest number of transactions comes from the CoW Swap app.

# New Approach to Fees
## Progressive Fee Structure
For the analysis, I proposed two solutions to modify the current fee settings.
The first is to create a progressive system only for native swaps in non-stablecoin pools.
This solution keeps the same tiers: 0.35%, 0.20%, 0.10%, but instead of having a flat fee depending on the bracket in which the swap amount falls, the proposal is that each portion of the swap amount is charged at the rate for its tier, similar to how progressive tax brackets work.
The reason I propose to change this setting only for swaps in non-stablecoin pools is that those who swap stablecoins do not want to pay high fees and risk becoming users who will look for the most cost-efficient solution. On the other hand, power users who already use the internal apps in Safe risk looking for more efficient solutions outside the platform. Conversely, native users who use the Safe frontend and are not particularly interested in optimizing their costs are the perfect target to increase total revenue. With this solution, considering historical data, there would have been an additional gain of $42,300.00, a 21% increase over Current Native Swaps Fees ($200,874.15).

## New Tier between $0 - $25,000

A second solution could be to create a new tier between 0-$25k. The analysis shows that almost 94% of transactions are in this segment. By introducing a fee of 0.50% on all token pairs (excluding stablecoin-only pairs) and 0.20% for stablecoin-only pairs, an additional $31,391.46 could be earned, increasing total revenue by 11%.

## Data Accuracy

There are 341 transactions where usd_value is null and 706 transactions where trader is null. I also checked the accuracy of the is_stablecoin_pair flag using the dex_trades table on Dune and by checking transactions in blockscan, and it is correct.

# Further analysis
A possible continuation of this analysis would be to cross-reference this data with the connect wallet activity of all Safes to external dapps. One could consider as level 2 power users those who use Safe also outside the platform, level 1 power users those who use the internal apps in Safe, and finally, those who only use Safe's native options as power user 0. The more experienced the user, the more sensitive they will be to fee changes, while less experienced users will probably be less elastic to price changes.
