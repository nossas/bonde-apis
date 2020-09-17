import fetch from './client';

export const queries = {
  get: `
    query Widgets($widget_id: Int!) {
      widgets(where: { id: { _eq: $widget_id } }) {
        id
        settings
        kind
        pressure_targets {
          identify
          label
          targets
          email_subject
          email_body
        }
        block {
          mobilization {
            id
            name
            community {
              id
              name
              mailchimp_api_key
              mailchimp_list_id
              email_template_from
            }
          }
        }
      }
    }
  `
};

export const get = async (widget_id: number): Promise<any> => {
  const { data } = await fetch({ query: queries.get, variables: { widget_id } });

  return data.widgets[0];
};