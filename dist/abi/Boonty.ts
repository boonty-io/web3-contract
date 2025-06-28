export const BoontyAbi = [
  {
    "type": "constructor",
    "inputs": [
      {
        "name": "initialOwner",
        "type": "address",
        "internalType": "address"
      },
      {
        "name": "asset",
        "type": "address",
        "internalType": "address"
      }
    ],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "_activitiesERC1155",
    "inputs": [
      {
        "name": "",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "outputs": [
      {
        "name": "",
        "type": "address",
        "internalType": "address"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "_activitiesERC20",
    "inputs": [
      {
        "name": "",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "outputs": [
      {
        "name": "",
        "type": "address",
        "internalType": "address"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "createActivityERC1155",
    "inputs": [
      {
        "name": "supply",
        "type": "uint256",
        "internalType": "uint256"
      },
      {
        "name": "brandName",
        "type": "string",
        "internalType": "string"
      },
      {
        "name": "activityName",
        "type": "string",
        "internalType": "string"
      },
      {
        "name": "uri",
        "type": "string",
        "internalType": "string"
      },
      {
        "name": "activityStart",
        "type": "uint16",
        "internalType": "uint16"
      },
      {
        "name": "hoursAvailable",
        "type": "uint16",
        "internalType": "uint16"
      },
      {
        "name": "brandAddress",
        "type": "address",
        "internalType": "address"
      }
    ],
    "outputs": [
      {
        "name": "",
        "type": "address",
        "internalType": "address"
      }
    ],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "createActivityERC20",
    "inputs": [
      {
        "name": "supply",
        "type": "uint256",
        "internalType": "uint256"
      },
      {
        "name": "brandName",
        "type": "string",
        "internalType": "string"
      },
      {
        "name": "activityName",
        "type": "string",
        "internalType": "string"
      },
      {
        "name": "maxWinners",
        "type": "uint256",
        "internalType": "uint256"
      },
      {
        "name": "activityStart",
        "type": "uint16",
        "internalType": "uint16"
      },
      {
        "name": "hoursAvailable",
        "type": "uint16",
        "internalType": "uint16"
      }
    ],
    "outputs": [
      {
        "name": "",
        "type": "address",
        "internalType": "address"
      }
    ],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "getActivitiesERC1155",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "address[]",
        "internalType": "address[]"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "getActivitiesERC20",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "address[]",
        "internalType": "address[]"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "getActivityERC20",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "address",
        "internalType": "address"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "getAsset",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "address",
        "internalType": "address"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "getBoontySetWhitelist",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "address",
        "internalType": "address"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "getFees",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "uint16",
        "internalType": "uint16"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "getFixedFees",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "owner",
    "inputs": [],
    "outputs": [
      {
        "name": "",
        "type": "address",
        "internalType": "address"
      }
    ],
    "stateMutability": "view"
  },
  {
    "type": "function",
    "name": "renounceOwnership",
    "inputs": [],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "setAsset",
    "inputs": [
      {
        "name": "asset",
        "type": "address",
        "internalType": "address"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "setBoontySetWhitelist",
    "inputs": [
      {
        "name": "boontySetWhitelist",
        "type": "address",
        "internalType": "address"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "setFees",
    "inputs": [
      {
        "name": "newfees",
        "type": "uint16",
        "internalType": "uint16"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "setFixedFees",
    "inputs": [
      {
        "name": "fixedFees",
        "type": "uint256",
        "internalType": "uint256"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "function",
    "name": "transferOwnership",
    "inputs": [
      {
        "name": "newOwner",
        "type": "address",
        "internalType": "address"
      }
    ],
    "outputs": [],
    "stateMutability": "nonpayable"
  },
  {
    "type": "event",
    "name": "ActivityCreated",
    "inputs": [
      {
        "name": "newActivity",
        "type": "address",
        "indexed": false,
        "internalType": "address"
      }
    ],
    "anonymous": false
  },
  {
    "type": "event",
    "name": "OwnershipTransferred",
    "inputs": [
      {
        "name": "previousOwner",
        "type": "address",
        "indexed": true,
        "internalType": "address"
      },
      {
        "name": "newOwner",
        "type": "address",
        "indexed": true,
        "internalType": "address"
      }
    ],
    "anonymous": false
  },
  {
    "type": "error",
    "name": "FailedDeployment",
    "inputs": []
  },
  {
    "type": "error",
    "name": "InsufficientBalance",
    "inputs": [
      {
        "name": "balance",
        "type": "uint256",
        "internalType": "uint256"
      },
      {
        "name": "needed",
        "type": "uint256",
        "internalType": "uint256"
      }
    ]
  },
  {
    "type": "error",
    "name": "OwnableInvalidOwner",
    "inputs": [
      {
        "name": "owner",
        "type": "address",
        "internalType": "address"
      }
    ]
  },
  {
    "type": "error",
    "name": "OwnableUnauthorizedAccount",
    "inputs": [
      {
        "name": "account",
        "type": "address",
        "internalType": "address"
      }
    ]
  },
  {
    "type": "error",
    "name": "SafeERC20FailedOperation",
    "inputs": [
      {
        "name": "token",
        "type": "address",
        "internalType": "address"
      }
    ]
  }
] as const;
// 0x118cdaa7: error OwnableUnauthorizedAccount(address account)
// 0x1e4fbdf7: error OwnableInvalidOwner(address owner)
// 0x2aaa819a: function getActivitiesERC1155()
// 0x370c9828: function createActivityERC1155(uint256,string,string,string,uint16,uint16,address)
// 0x465a8f20: function _activitiesERC1155(uint256)
// 0x5274afe7: error SafeERC20FailedOperation(address token)
// 0x5461483a: function _activitiesERC20(uint256)
// 0x5aab4fd5: function setBoontySetWhitelist(address)
// 0x5af4a5e6: function setFixedFees(uint256)
// 0x5c222bad: function getAsset()
// 0x715018a6: function renounceOwnership()
// 0x7fb430dd: function getActivityERC20()
// 0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0: event OwnershipTransferred(address,address)
// 0x8da5cb5b: function owner()
// 0xb06ebf3d: error FailedDeployment()
// 0xb34b278a: function getFixedFees()
// 0xca1123c2: function setFees(uint16)
// 0xcf479181: error InsufficientBalance(uint256 balance, uint256 needed)
// 0xd0d552dd: function setAsset(address)
// 0xd0f1c12c46956c700716e9c411855dab006b2807e390e37b681889ae0573369e: event ActivityCreated(address)
// 0xdb8d55f1: function getFees()
// 0xe18cb148: function getBoontySetWhitelist()
// 0xe4f3f802: function createActivityERC20(uint256,string,string,uint256,uint16,uint16)
// 0xf21757fa: function getActivitiesERC20()
// 0xf2fde38b: function transferOwnership(address)
