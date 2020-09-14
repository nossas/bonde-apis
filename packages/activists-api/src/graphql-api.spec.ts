import { mocked } from 'ts-jest/utils';
import fetch from './graphql-api/client';
import * as ActionsAPI from './graphql-api/actions';
import * as ActivistsAPI from './graphql-api/activists';
import * as NotificationsAPI from './graphql-api/notifications';
import * as WidgetsAPI from './graphql-api/widgets';

jest.mock('./graphql-api/client');
const fetchMocked = mocked(fetch, true);

describe('tests on api graphql', () => {
  
  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should notifications.send on api mail', () => {
    const input = {
      email_from: 'from-reply@nossas.org',
      email_to: 'to-reply@nossas.org',
      subject: 'subject',
      body: 'body'
    };

    const graphqQLResponse: any = { data: { status: 'OK!' } };
    fetchMocked.mockResolvedValue(graphqQLResponse);

    return NotificationsAPI
      .send(input)
      .then(({ data }) => {
        expect(fetchMocked).toBeCalledWith({
          query: NotificationsAPI.queries.send,
          variables: { input }
        });
        expect(data).toEqual({ status: 'OK!' });
      });
  });

  it('should activists.get_or_create on api graphql', () => {
    const input = {
      email: 'test@nossas.org',
      name: 'Activist Test Name',
      first_name: 'Activist',
      last_name: 'Test Name'
    };

    const graphqQLResponse: any = { data: { insert_activists: { returning: [{...input, id: 2}] }}};
    fetchMocked.mockResolvedValue(graphqQLResponse);

    return ActivistsAPI
      .get_or_create(input)
      .then((activist) => {
        expect(fetchMocked).toBeCalledWith({
          query: ActivistsAPI.queries.get_or_create,
          variables: { activist: input }
        });
        expect(activist).toEqual({ ...input, id: 2 });
      });
  });

  it('should widgets.get on api graphql', () => {
    const widgetReturned = {
      id: 2,
      settings: {},
      block: { mobilization: { id: 1, community: { id: 1 } } }
    }
    const graphqQLResponse = { data: { widgets: [widgetReturned] } };
    fetchMocked.mockResolvedValue(graphqQLResponse as any);

    return WidgetsAPI
      .get(widgetReturned.id)
      .then((widget) => {
        expect(fetchMocked).toBeCalledWith({
          query: WidgetsAPI.queries.get,
          variables: { widget_id: widgetReturned.id }
        });
        expect(widget).toEqual(widgetReturned);
      });
  });

  it('should actions.pressure on api graphql', () => {
    const input = {
      activist_id: 2,
      cached_community_id: 1,
      mobilization_id: 3,
      widget_id: 2
    }
    const graphqQLResponse = { data: { insert_activist_pressures: { returning: [{ id: 2 }] } } };
    fetchMocked.mockResolvedValue(graphqQLResponse as any);

    return ActionsAPI
      .pressure(input)
      .then((activist_pressure) => {
        expect(fetchMocked).toBeCalledWith({
          query: ActionsAPI.queries.pressure,
          variables: { input }
        });
        expect(activist_pressure).toEqual({ id: 2 });
      });
  });

  it('should actions.pressure_sync_done on api graphql', () => {
    const input = {
      id: 2,
      sync_at: new Date().toISOString()
    }
    const graphqQLResponse = { data: { update_activist_pressures: { returning: [{ id: 2 }] } } };
    fetchMocked.mockResolvedValue(graphqQLResponse as any);

    return ActionsAPI
      .pressure_sync_done(input)
      .then((activist_pressure: any) => {
        expect(fetchMocked).toBeCalledWith({
          query: ActionsAPI.queries.pressure_sync_done,
          variables: input
        });
        expect(activist_pressure).toEqual({ id: 2 });
      })
  });
});