import { Etcd3 } from 'etcd3';

const client = new Etcd3({
  hosts: process.env.ETCD_URL || 'http://etcd:2379'
});

export default client