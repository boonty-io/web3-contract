export enum VmSafeCallerMode {
  None,
  Broadcast,
  RecurrentBroadcast,
  Prank,
  RecurrentPrank
};

export enum VmSafeAccountAccessKind {
  Call,
  DelegateCall,
  CallCode,
  StaticCall,
  Create,
  SelfDestruct,
  Resume,
  Balance,
  Extcodesize,
  Extcodehash,
  Extcodecopy
};

export enum VmSafeForgeContext {
  TestGroup,
  Test,
  Coverage,
  Snapshot,
  ScriptGroup,
  ScriptDryRun,
  ScriptBroadcast,
  ScriptResume,
  Unknown
};

export enum VmSafeBroadcastTxType {
  Call,
  Create,
  Create2
};

export enum StdCheatsSafeAddressType {
  Payable,
  NonPayable,
  ZeroAddress,
  Precompile,
  ForgeAddress
};

export enum MathRounding {
  Floor,
  Ceil,
  Trunc,
  Expand
};
