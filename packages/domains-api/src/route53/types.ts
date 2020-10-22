export type HostedZoneConfig = {
  Comment?: string
  PrivateZone: boolean
}

export type HostedZone = {
  Id?: string
  Name: string
  CallerReference: string
  HostedZoneConfig: HostedZoneConfig
  ResourceRecordSetCount?: number
}

export type DelegationSet = {
  Id?: string
  CallerReference?: string
  NameServers: string[]
}
