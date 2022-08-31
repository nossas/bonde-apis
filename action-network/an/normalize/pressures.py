"""
Fetch Bonde pressure actions in PostgreSQL and normalize to insert on BigQuery
"""
from normalize.base import NormalizeWorkflowInterface
from normalize.utils import find_by_ddd
from validate_docbr import CPF
import pandas as pd
import numpy as np

cpf = CPF()

class PressureNormalizeWorkflowInterface(NormalizeWorkflowInterface):

    def query(self, offset: int) -> str:
        """Query activist actions pressure"""
        return f'''
        SELECT
            'pressure'::text AS action,
            ap.id AS action_id,
            w.id AS widget_id,
            m.id AS mobilization_id,
            m.community_id AS community_id,
            ap.activist_id as activist_id,
            ap.created_at AS action_date,
            a.email AS email,
            a.name AS name,
            a.first_name AS given_name,
            a.last_name AS family_name,
            a.state AS state,
            a.phone AS phone,
            ap.form_data,
            ap.form_data->'state' AS form_state,
            ap.form_data->'name' AS form_name,
            ap.form_data->'lastname' AS form_lastname,
            ap.form_data->'phone' AS form_phone
        FROM activist_pressures ap
        JOIN activists a ON a.id = ap.activist_id
        JOIN widgets w ON w.id = ap.widget_id
        JOIN blocks b ON b.id = w.block_id
        JOIN mobilizations m ON m.id = b.mobilization_id
        WHERE m.community_id = {self.params.get('community_id')}
        ORDER BY ap.created_at ASC
        OFFSET {offset}
        LIMIT {self.limit}
        '''

    def normalize(self, df):
        """Normalize activist actions pressure"""

        df2 = df[df['form_data'].isnull()]
        df3 = df[df['form_data'].notnull()]

        df3['region'] = np.where(df3['form_state'].notnull(), df3['form_state'], df3['state'])
        df3['given_name'] = np.where(df3['form_name'].notnull(), df3['form_name'], df3['given_name'])
        df3['family_name'] = np.where(df3['form_lastname'].notnull(), df3['form_lastname'], df3['family_name'])
        df3['phone'] = np.where(df3['form_phone'].notnull(), df3['form_phone'], df3['phone'])

        df = pd.concat([df2, df3])

        df['name'] = np.where(df['name'].isnull(), df['form_name'], df['name'])

        df['given_name'] = np.where(
            df['given_name'].isnull(), df['form_name'], df['given_name'])
        df['family_name'] = np.where(
            df['family_name'].isnull(), df['form_lastname'], df['family_name'])

        df['given_name'] = np.where(df['given_name'].isnull(
        ), df['name'].str.split(pat=" ").str[0], df['given_name'])
        df['family_name'] = np.where(df['family_name'].isnull(), df['name'].str.split(
            pat=" ").str[1:].str.join(" "), df['family_name'])

        df['given_name'] = np.where(len(df['given_name'].str.split(
            pat=" ")) > 1, df['given_name'].str.split(pat=" ").str[0], df['given_name'])

        df['name'] = df['name'].str.title()
        df['given_name'] = df['given_name'].str.title()
        df['family_name'] = df['family_name'].str.title()

        df["phone"] = df["phone"].str.replace(r'[\(\) -]+', '', regex=True)
        df["phone"] = df["phone"].str.replace(
            r'^\d{1}(\d{2})(\d{1})(\d{4})(\d{4})$', r'+55 (\1) \2 \3 \4', regex=True)
        df["phone"] = df["phone"].str.replace(
            r'^\d{2}(\d{2})(\d{1})(\d{4})(\d{4})$', r'+55 (\1) \2 \3 \4', regex=True)
        df["phone"] = df["phone"].str.replace(
            r'^(\d{2})(\d{1})(\d{4})(\d{4})$', r'+55 (\1) \2 \3 \4', regex=True)
        df["phone"] = df["phone"].str.replace(
            r'^\+(\d{2})(\d{2})(\d{1})(\d{4})(\d{4})$', r'+\1 (\2) \3 \4 \5', regex=True)
        df["phone"] = df["phone"].str.replace(
            r'^(\d{2})(\d{4})(\d{4})$', r'+55 (\1) 9 \2 \3', regex=True)
        df["phone"] = df["phone"].str.replace(
            r'^\{"ddd"=>"(\d{2})","number"=>"(\d{1})(\d{8})"\}$', r'+55 (\1) \2 \3', regex=True)

        df = df[[
            "action",
            "action_id",
            "action_date",
            "widget_id",
            "mobilization_id",
            "community_id",
            "email",
            "name",
            "given_name",
            "family_name",
            # "address_lines",
            # "locality",
            "region",
            "phone"
        ]]

        df['region'] = np.where(df['region'].isnull() & df['phone'].notnull(
        ), df['phone'].str.replace(r'^\+[\d ]+\((\d{2})\)[\d ]+$', r'\1', regex=True), df['region'])

        df['region'] = df['region'].map(lambda x: find_by_ddd(x) if x else x)

        return df
