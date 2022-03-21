import CertificatesController from './certificates-controller';

test.skip('should create certificate', () => {
  const mockReq = {
    body: {
      payload: {
        event: {
          data: {
            new: {
              status: "propagated",
              domain_name: "lutarnaoecrime.org",
              id: 33,
              ns_ok: true,
            }
          }
        }
      }
    }
  };
  // const mockData = {
  //   dns_hosted_zones_by_pk: {
  //     hosted_zone: 'aaa.com',
  //     name_servers: 'aaaaa.com'
  //   }
  // };
  // const mockFn = {
  //   request: jest.fn().mockReturnValue({
  //     data: mockData,
  //     errors: {}
  //   })
  // };
  const mRes = { status: jest.fn().mockReturnThis(), json: jest.fn(), body: mockReq.body };

  const certificatesController = new CertificatesController(jest.fn());
  certificatesController.createCertificate(mockReq, mRes);

  expect(mRes.json).toBeCalled();
  expect(mRes.body).toBe(mockReq.body);
});


// {
//   "payload": {
//       "event": {
//           "session_variables": {
//               "x-hasura-role": "admin"
//           },
//           "op": "MANUAL",
//           "data": {
//               "old": null,
//               "new": {
//                   "status": "propagated",
//                   "domain_name": "lutarnaoecrime.org",
//                   "response": {
//                       "VPCs": [],
//                       "HostedZone": {
//                           "Config": {
//                               "PrivateZone": false,
//                               "Comment": "Created by Rafael"
//                           },
//                           "Name": "lutarnaoecrime.org.",
//                           "Id": "/hostedzone/Z04814551FTACBM3429JO",
//                           "ResourceRecordSetCount": 2,
//                           "CallerReference": "2021-09-23T17:27:36.690Z-0.6008227140620364"
//                       },
//                       "DelegationSet": {
//                           "NameServers": [
//                               "ns-482.awsdns-60.com",
//                               "ns-1295.awsdns-33.org",
//                               "ns-936.awsdns-53.net",
//                               "ns-1650.awsdns-14.co.uk"
//                           ]
//                       }
//                   },
//                   "community_id": 263,
//                   "updated_at": "2022-03-18T19:59:42.075017",
//                   "created_at": "2021-09-23T20:32:18.712061",
//                   "id": 512,
//                   "comment": "Created by Rafael",
//                   "ns_ok": null
//               }
//           },
//           "trace_context": {
//               "trace_id": "02328f2340971953",
//               "span_id": "b3f3058918f31294"
//           }
//       },
//       "created_at": "2022-03-18T20:00:24.420229Z",
//       "id": "3db208b0-a3b9-4fb5-8238-ae67a5367a07",
//       "delivery_info": {
//           "max_retries": 0,
//           "current_retry": 0
//       },
//       "trigger": {
//           "name": "create_certificate"
//       },
//       "table": {
//           "schema": "public",
//           "name": "dns_hosted_zones"
//       }
//   },
//   "headers": [
//       {
//           "value": "application/json",
//           "name": "Content-Type"
//       },
//       {
//           "value": "hasura-graphql-engine/v2.3.0",
//           "name": "User-Agent"
//       }
//   ],
//   "version": "2"
// }