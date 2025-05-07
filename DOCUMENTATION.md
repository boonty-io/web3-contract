# Informations about workflow and code

## Structure

Boonty Factory
    - _asset; // USDT/USDC token address
    - _boontySetWhitelist; // BoontySetWhitelist contract address
    - _fixedFees; // Fees for erc1155
    - _fees; // Fees for erc20 in basis points
    - _activitiesERC20; // List of ERC20-based activities
    - _activitiesERC1155; // List of ERC1155-based activities
 -> deploy ActivitiesERC20
 -> deploy ActivitiesERC1155

## Factory
4 setters functions:
    - setAsset
    - setBoontySetWhitelist
    - setFixedFees
    - setFees
2 public functions to create activity
    - createActivityERC20:
        - must be called by the brand
    - createActivityERC1155:
        - can be called by anyone for a brand

## ERC20

supply + fee are sent to the contract when it's created
fee = %

if you run "activityFinished()":
    - if all reward was distributed(only owner or boonty), the fee are sent to boonty
    - if not all reward was distributed + after activityEnd(only owner or boonty), fee are sent to boonty and the remaining rewards are sent to the contract owner(brand)
    - if not all reward was distributed + before activityEnd(only owner), fees are sent to boonty and the remaining rewards are sent to the contract owner(brand)

## ERC721

fee are send to boonty when the contract is created
fee = x USDT

if you(owner) run "activityFinished()", you will stop the possibility to claim rewards.

On prend des frais sur les récompenses non distribuées actuellement? Oui. A voir apres avec la brand pour s'arranger au cas par cas.
Donc les frais tombent et sont calculés au début de l'activité peu importe la durée.