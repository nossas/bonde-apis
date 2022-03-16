import mailchimp from '../mailchimp';

type UpdateMailchimpSettingsArgs = {
  api_key: string
  list_id: string
}

export default async (_: void, args: UpdateMailchimpSettingsArgs): Promise<any> => {
  const { api_key, list_id } = args;
  const widget = {
    block: {
      mobilization: {
        community: { mailchimp_api_key: api_key, mailchimp_list_id: list_id }
      }
    }
  };
  const { merge } = mailchimp<any, any>({ activist: {}, widget });

  try {
    await merge();
    return { status: 'Ok!' };
  } catch (err: any) {
    console.log('err', err);
    throw new Error(err);
  }
};