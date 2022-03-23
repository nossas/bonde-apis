export interface CommunityUser {
  user_id: number;
  role: 1 | 2;
}

export interface Community {
  id: number;
  community_users: CommunityUser[]
}

export interface DNSRecord {
  id: any;
  name: string;
  value: string;
  record_type: string;
  comment?: string;
  ttl: any;
}

export interface DNSHostedZone {
  id: number;
  comment?: string;
  domain_name: string;
  ns_ok?: boolean;
  community_id: number;
  // 2 integrations with route53
  hosted_zone_rest?: any
  hosted_zone?: any
  name_servers_rest?: any
  name_servers?: any

  dns_records: DNSRecord[]
  community: Community
}

export interface SessionVariables {
  'x-hasura-role': 'admin' | 'user';
  'x-hasura-user-id'?: string
}