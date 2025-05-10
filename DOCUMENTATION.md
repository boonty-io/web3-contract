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

## Informations

### Both activities

Boonty can set winners at any time. Winners only can receive their rewards if the activity is not finished.
Boonty can set any ERC20 token for fees with any amount of fixed fees.
Boonty can set lower than 20% for fees.

### ERC20

supply + fee are sent to the contract when it's created
fee = %

if you run "activityFinished()":
    - if all reward was distributed(only owner or boonty), the fee are sent to boonty
    - if not all reward was distributed + after activityEnd(only owner or boonty), fee are sent to boonty and the remaining rewards are sent to the contract owner(brand)
    - if not all reward was distributed + before activityEnd(only owner), fees are sent to boonty and the remaining rewards are sent to the contract owner(brand)

### ERC721

fee are send to boonty when the contract is created
fee = x USDC

Anyone can create an activity for a brand. The caller will be pay the fee.

if you(owner) run "activityFinished()", you will stop the possibility to claim rewards.
Boonty can not set the activity as finished.


## FAQ

Are fees charged on rewards not currently distributed? Yes. To be agreed with the brand on a case-by-case basis.
Fees are calculated at the start of the activity, regardless of the duration.
On prend des frais sur les récompenses non distribuées actuellement? Oui. A voir apres avec la brand pour s'arranger au cas par cas.
Donc les frais tombent et sont calculés au début de l'activité peu importe la durée.

