/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../common";
import type {
  LowkickStarter,
  LowkickStarterInterface,
} from "../../LowkickStarter.sol/LowkickStarter";

const _abi = [
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "endsAt",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "goal",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "address",
        name: "organizer",
        type: "address",
      },
    ],
    name: "CampaignStarted",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "campaigns",
    outputs: [
      {
        internalType: "contract Campaign",
        name: "targetContract",
        type: "address",
      },
      {
        internalType: "bool",
        name: "claimed",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
    ],
    name: "onClaimed",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_goal",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_endsAt",
        type: "uint256",
      },
    ],
    name: "start",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

const _bytecode =
  "0x608060405234801561001057600080fd5b506109a8806100206000396000f3fe608060405234801561001057600080fd5b50600436106100415760003560e01c8063141961bc14610046578063263e0dfd146100c95780638fb4b573146100de575b600080fd5b6100996100543660046102ea565b60006020819052908152604090205473ffffffffffffffffffffffffffffffffffffffff81169074010000000000000000000000000000000000000000900460ff1682565b6040805173ffffffffffffffffffffffffffffffffffffffff909316835290151560208301520160405180910390f35b6100dc6100d73660046102ea565b6100f1565b005b6100dc6100ec366004610303565b610162565b6000818152602081905260409020805473ffffffffffffffffffffffffffffffffffffffff16331461012257600080fd5b80547fffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff167401000000000000000000000000000000000000000017905550565b6000821161016f57600080fd5b61017c62278d0042610325565b811115801561018a57504281115b61019357600080fd5b600180546101a091610325565b60018190555060008183336001546040516101ba906102dd565b938452602084019290925273ffffffffffffffffffffffffffffffffffffffff1660408301526060820152608001604051809103906000f080158015610204573d6000803e3d6000fd5b5060408051808201825273ffffffffffffffffffffffffffffffffffffffff83811682526000602080840182815260018054845283835292869020945185549151151574010000000000000000000000000000000000000000027fffffffffffffffffffffff00000000000000000000000000000000000000000090921694169390931792909217909255905482519081529081018590529081018590523360608201529091507f935db067b9c536d7ee9266d488a9f2193ed8a3e8d302e20fc7b88f556ec5afb39060800160405180910390a1505050565b61060d8061036683390190565b6000602082840312156102fc57600080fd5b5035919050565b6000806040838503121561031657600080fd5b50508035926020909101359150565b8082018082111561035f577f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b9291505056fe608060405234801561001057600080fd5b5060405161060d38038061060d83398101604081905261002f9161006c565b600093909355600191909155600480546001600160a01b039092166001600160a01b031992831617905560058054909116331790556003556100b8565b6000806000806080858703121561008257600080fd5b84516020860151604087015191955093506001600160a01b03811681146100a857600080fd5b6060959095015193969295505050565b610546806100c76000396000f3fe6080604052600436106100965760003560e01c80636120326511610069578063ae2c46581161004e578063ae2c465814610160578063aeafca2e14610180578063af640d0f1461019657600080fd5b8063612032651461010657806388ffe8671461015857600080fd5b80630a09284a1461009b5780632ffe1429146100c457806340193883146100db5780634e71d92d146100f1575b600080fd5b3480156100a757600080fd5b506100b160005481565b6040519081526020015b60405180910390f35b3480156100d057600080fd5b506100d96101ac565b005b3480156100e757600080fd5b506100b160015481565b3480156100fd57600080fd5b506100d961020f565b34801561011257600080fd5b506004546101339073ffffffffffffffffffffffffffffffffffffffff1681565b60405173ffffffffffffffffffffffffffffffffffffffff90911681526020016100bb565b6100d9610392565b34801561016c57600080fd5b506100d961017b36600461049c565b610423565b34801561018c57600080fd5b506100b160025481565b3480156101a257600080fd5b506100b160035481565b60005442116101ba57600080fd5b600154600254106101ca57600080fd5b33600081815260066020526040808220805490839055905190929183156108fc02918491818181858888f1935050505015801561020b573d6000803e3d6000fd5b5050565b600054421161021d57600080fd5b60045473ffffffffffffffffffffffffffffffffffffffff16331461024157600080fd5b600154600254101561025257600080fd5b60055474010000000000000000000000000000000000000000900460ff161561027a57600080fd5b600580547fffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff167401000000000000000000000000000000000000000017905560045460025460405173ffffffffffffffffffffffffffffffffffffffff9092169181156108fc0291906000818181858888f19350505050158015610302573d6000803e3d6000fd5b506005546003546040517f263e0dfd00000000000000000000000000000000000000000000000000000000815273ffffffffffffffffffffffffffffffffffffffff9092169163263e0dfd9161035e9160040190815260200190565b600060405180830381600087803b15801561037857600080fd5b505af115801561038c573d6000803e3d6000fd5b50505050565b6000544211156103a157600080fd5b600034116103ae57600080fd5b34600260008282546103c091906104e4565b909155505033600090815260066020526040812080543492906103e49084906104e4565b9091555050604080513481523360208201527f8d6ee36029e7d319f08944d549c7b4918800041d9893b2b88874844ba50a3540910160405180910390a1565b60005442111561043257600080fd5b33600090815260066020526040812080548392906104519084906104fd565b92505081905550806002600082825461046a91906104fd565b9091555050604051339082156108fc029083906000818181858888f1935050505015801561020b573d6000803e3d6000fd5b6000602082840312156104ae57600080fd5b5035919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b808201808211156104f7576104f76104b5565b92915050565b818103818111156104f7576104f76104b556fea2646970667358221220719f71cb39403936c6187212b9e5234ee3f8fcb0a7625acf77a88a99e02ba70d64736f6c63430008120033a2646970667358221220d94c838994232a3a269e40216810a863d88015b4400634ccc0169843cd10efab64736f6c63430008120033";

type LowkickStarterConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: LowkickStarterConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class LowkickStarter__factory extends ContractFactory {
  constructor(...args: LowkickStarterConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<LowkickStarter> {
    return super.deploy(overrides || {}) as Promise<LowkickStarter>;
  }
  override getDeployTransaction(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  override attach(address: string): LowkickStarter {
    return super.attach(address) as LowkickStarter;
  }
  override connect(signer: Signer): LowkickStarter__factory {
    return super.connect(signer) as LowkickStarter__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): LowkickStarterInterface {
    return new utils.Interface(_abi) as LowkickStarterInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): LowkickStarter {
    return new Contract(address, _abi, signerOrProvider) as LowkickStarter;
  }
}