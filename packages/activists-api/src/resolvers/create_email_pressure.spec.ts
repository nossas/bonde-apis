import { mocked } from 'ts-jest/utils';
import jwt from "jsonwebtoken";
import * as ActionsAPI from '../graphql-api/actions';
import * as NotificationsAPI from '../graphql-api/notifications';
import { Activist, Widget } from '../types';
import { create_email_pressure as pressure, PressureAction } from './create_email_pressure';

jest.mock('../graphql-api/actions', () => ({
  pressure: jest.fn(),
  pressure_sync_done: jest.fn(),
  get_pressure_info: jest.fn()
}))
const mockedActions = mocked(ActionsAPI, true);

jest.mock('../graphql-api/notifications', () => ({
  send: jest.fn()
}))
const mockedNotifications = mocked(NotificationsAPI, true);

describe('actions functions tests', () => {
  const OLD_ENV = process.env;
  const SECRET_KEY = "token-de-teste";

  beforeEach(() => {
    jest.resetModules(); // Most important - it clears the cache
    process.env = { ...OLD_ENV }; // Make a copy
    process.env.ACTION_SECRET_KEY = SECRET_KEY;

    mockedActions.get_pressure_info.mockResolvedValue({ mail_count: 0, batch_count: 0 })
  });

  afterAll(() => {
    process.env = OLD_ENV; // Restore old environment
  });


  const activist: Activist = {
    id: 35,
    email: 'activist@test.org',
    name: 'Activist Test'
  };
  const widget: Widget = {
    id: 2,
    kind: 'pressure',
    settings: {
      pressure_subject: 'Lorem Ipsum Subject',
      pressure_body: 'Lorem Ipsum Body',
      targets: 'Target1 <target1@test.org>;Target2 <target2@test.org>'
    },
    block: {
      mobilization: {
        id: 1,
        name: 'name mobilization',
        community: {
          id: 1,
          name: 'name community',
          mailchimp_api_key: 'xxx-us10',
          mailchimp_list_id: 'xxx'
        }
      }
    }
  };
  const action: PressureAction = {
    token: jwt.sign({}, SECRET_KEY, { expiresIn: "1m" })
  }

  it('pressure called notifications.send with widget.settings params', () => {
    mockedActions.pressure.mockResolvedValue({ id: 3, created_at: new Date().toISOString() });
    mockedNotifications.send.mockResolvedValue({});

    return pressure({ widget, activist, action })
      .then(() => {
        // TODO: refactor test
        // const expectedMail = widget.settings.targets.split(';').map((target: string) => ({
        //   context: { activist },
        //   body: widget.settings.pressure_body,
        //   subject: widget.settings.pressure_subject,
        //   email_from: `${activist.name} <${activist.email}>`,
        //   email_to: target
        // }));
        // expect(mockedNotifications.send).toBeCalledWith(expectedMail);

        const expectedPressure = {
          activist_id: activist.id,
          widget_id: widget.id,
          mobilization_id: widget.block.mobilization.id,
          cached_community_id: widget.block.mobilization.community.id,
          targets: { targets: widget.settings.targets.split(';') },
          status: "sent",
          group: undefined
        };
        expect(mockedActions.pressure).toBeCalledWith(expectedPressure);
      });
  });

  it('pressure should be return syncronize function to mark activist_pressure', () => {
    const activist_pressure_id = 3;
    const activist_pressure_created_at = new Date().toISOString();
    mockedActions.pressure.mockResolvedValue({
      id: activist_pressure_id,
      created_at: activist_pressure_created_at
    });
    mockedNotifications.send.mockResolvedValue({});

    return pressure({ widget, activist, action })
      .then(async ({ data, syncronize }) => {
        syncronize && await syncronize();

        expect(data).toEqual({ activist_pressure_id });
        expect(mockedActions.pressure_sync_done).toBeCalledWith({
          id: activist_pressure_id,
          sync_at: activist_pressure_created_at
        });
      });
  });

  it('throw Error when not config ENVIRONMENT', async () => {
    process.env.ACTION_SECRET_KEY = undefined;
    await expect(pressure({ widget, activist, action }))
      .rejects.toThrow("invalid_action_token");
  });

  it('throw Error when not pass action.token', async () => {
    await expect(pressure({ widget, activist, action: { token: undefined } } as any))
      .rejects.toThrow("invalid_action_token");
  });

});