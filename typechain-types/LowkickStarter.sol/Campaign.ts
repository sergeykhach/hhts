/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumber,
  BigNumberish,
  BytesLike,
  CallOverrides,
  ContractTransaction,
  Overrides,
  PayableOverrides,
  PopulatedTransaction,
  Signer,
  utils,
} from "ethers";
import type {
  FunctionFragment,
  Result,
  EventFragment,
} from "@ethersproject/abi";
import type { Listener, Provider } from "@ethersproject/providers";
import type {
  TypedEventFilter,
  TypedEvent,
  TypedListener,
  OnEvent,
  PromiseOrValue,
} from "../common";

export interface CampaignInterface extends utils.Interface {
  functions: {
    "claim()": FunctionFragment;
    "endsAt()": FunctionFragment;
    "fullRefund()": FunctionFragment;
    "goal()": FunctionFragment;
    "id()": FunctionFragment;
    "organizer()": FunctionFragment;
    "pledge()": FunctionFragment;
    "pledged()": FunctionFragment;
    "refundPledge(uint256)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "claim"
      | "endsAt"
      | "fullRefund"
      | "goal"
      | "id"
      | "organizer"
      | "pledge"
      | "pledged"
      | "refundPledge"
  ): FunctionFragment;

  encodeFunctionData(functionFragment: "claim", values?: undefined): string;
  encodeFunctionData(functionFragment: "endsAt", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "fullRefund",
    values?: undefined
  ): string;
  encodeFunctionData(functionFragment: "goal", values?: undefined): string;
  encodeFunctionData(functionFragment: "id", values?: undefined): string;
  encodeFunctionData(functionFragment: "organizer", values?: undefined): string;
  encodeFunctionData(functionFragment: "pledge", values?: undefined): string;
  encodeFunctionData(functionFragment: "pledged", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "refundPledge",
    values: [PromiseOrValue<BigNumberish>]
  ): string;

  decodeFunctionResult(functionFragment: "claim", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "endsAt", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "fullRefund", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "goal", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "id", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "organizer", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "pledge", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "pledged", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "refundPledge",
    data: BytesLike
  ): Result;

  events: {
    "Pledged(uint256,address)": EventFragment;
  };

  getEvent(nameOrSignatureOrTopic: "Pledged"): EventFragment;
}

export interface PledgedEventObject {
  amount: BigNumber;
  pledger: string;
}
export type PledgedEvent = TypedEvent<[BigNumber, string], PledgedEventObject>;

export type PledgedEventFilter = TypedEventFilter<PledgedEvent>;

export interface Campaign extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: CampaignInterface;

  queryFilter<TEvent extends TypedEvent>(
    event: TypedEventFilter<TEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TEvent>>;

  listeners<TEvent extends TypedEvent>(
    eventFilter?: TypedEventFilter<TEvent>
  ): Array<TypedListener<TEvent>>;
  listeners(eventName?: string): Array<Listener>;
  removeAllListeners<TEvent extends TypedEvent>(
    eventFilter: TypedEventFilter<TEvent>
  ): this;
  removeAllListeners(eventName?: string): this;
  off: OnEvent<this>;
  on: OnEvent<this>;
  once: OnEvent<this>;
  removeListener: OnEvent<this>;

  functions: {
    claim(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    endsAt(overrides?: CallOverrides): Promise<[BigNumber]>;

    fullRefund(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    goal(overrides?: CallOverrides): Promise<[BigNumber]>;

    id(overrides?: CallOverrides): Promise<[BigNumber]>;

    organizer(overrides?: CallOverrides): Promise<[string]>;

    pledge(
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    pledged(overrides?: CallOverrides): Promise<[BigNumber]>;

    refundPledge(
      _amount: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;
  };

  claim(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  endsAt(overrides?: CallOverrides): Promise<BigNumber>;

  fullRefund(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  goal(overrides?: CallOverrides): Promise<BigNumber>;

  id(overrides?: CallOverrides): Promise<BigNumber>;

  organizer(overrides?: CallOverrides): Promise<string>;

  pledge(
    overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  pledged(overrides?: CallOverrides): Promise<BigNumber>;

  refundPledge(
    _amount: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  callStatic: {
    claim(overrides?: CallOverrides): Promise<void>;

    endsAt(overrides?: CallOverrides): Promise<BigNumber>;

    fullRefund(overrides?: CallOverrides): Promise<void>;

    goal(overrides?: CallOverrides): Promise<BigNumber>;

    id(overrides?: CallOverrides): Promise<BigNumber>;

    organizer(overrides?: CallOverrides): Promise<string>;

    pledge(overrides?: CallOverrides): Promise<void>;

    pledged(overrides?: CallOverrides): Promise<BigNumber>;

    refundPledge(
      _amount: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;
  };

  filters: {
    "Pledged(uint256,address)"(
      amount?: null,
      pledger?: null
    ): PledgedEventFilter;
    Pledged(amount?: null, pledger?: null): PledgedEventFilter;
  };

  estimateGas: {
    claim(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    endsAt(overrides?: CallOverrides): Promise<BigNumber>;

    fullRefund(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    goal(overrides?: CallOverrides): Promise<BigNumber>;

    id(overrides?: CallOverrides): Promise<BigNumber>;

    organizer(overrides?: CallOverrides): Promise<BigNumber>;

    pledge(
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    pledged(overrides?: CallOverrides): Promise<BigNumber>;

    refundPledge(
      _amount: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    claim(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    endsAt(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    fullRefund(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    goal(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    id(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    organizer(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    pledge(
      overrides?: PayableOverrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    pledged(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    refundPledge(
      _amount: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;
  };
}