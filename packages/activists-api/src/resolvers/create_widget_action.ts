import { IActionData, IBaseAction, WidgetActionInput } from '../types';
import logger from '../logger';
import apolloFetch from '../graphql-api/client';
import makeActionResolver from './action';


export const create_widget_action = async ({ action, activist, widget }: IBaseAction<WidgetActionInput>): Promise<IActionData> => {
    // A pipeline irá processar os dados do Ativista, considerando o e-mail uma chave única usada para
    // atualizar seus dados. Sempre que o Ativista fizer uma Ação no BONDE, seus dados serão atualizados.
    const input = {
        // Dados relacionados ao Ativista executor da Ação
        first_name: activist.first_name,
        last_name: activist.last_name,
        email: activist.email,  // Usado como chave única e integração com CRM (Action Networ)
        phone_number: activist.phone,  // Qundo existe é usado na integração com Whatsapp (Turn.io)
        // Dados relacionais nos modelos do BONDE
        widget_id: widget.id,
        mobilization_id: widget.block.mobilization.id,
        community_id: widget.block.mobilization.community.id,
        activist_id: activist.id,
        // Tipo da ação, deve ser indexado para criar consultas por agrupamentos
        kind: widget.kind,
        // Campos extras dos formulários
        custom_fields: action?.custom_fields
    }

    const query = `
        mutation CreateWidgetAction(
            $input: widget_actions_insert_input!
        ) {
            insert_widget_actions_one(object: $input) {
                id
                kind
                created_at
            }
        }
    `;

    const { data, errors } = await apolloFetch({
        query,
        variables: { input }
    });

    if (errors) {
        logger.child({ errors }).error("create_widget_action_error");
    }

    return {
        data: data.insert_widget_actions_one,
    }
}

// Return a base action to resolvers pattern
export default makeActionResolver(create_widget_action);