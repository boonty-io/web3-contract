# Informations about workflow and code

## ERC20

supply + fee are sent to the contract when it's created
if you run "activityFinished()":
    - if all reward was distributed(only owner or boonty), the fee are sent to boonty
    - if not all reward was distributed + after activityEnd(only owner or boonty), fee are sent to boonty and the remaining rewards are sent to the contract owner(brand)
    - if not all reward was distributed + before activityEnd(only owner), fees are sent to boonty and the remaining rewards are sent to the contract owner(brand)

fee = %

## ERC721

fee are send to boonty when the contract is created
if you run "activityFinished()", you will stop the possibility to claim rewards.

fee = x USDT


On prend de sfrais sur les récompenses non distribuées actuellement? Oui. A voir apres avec la brand pour s'arranger au cas par cas.
Donc les frais tombe ou sont calculé au début de l'activité peu importe la durée.