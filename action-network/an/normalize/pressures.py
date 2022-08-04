"""
Fetch Bonde pressure actions in PostgreSQL and normalize to insert on BigQuery
"""
from normalize.base import NormalizeWorkflowInterface
from normalize.utils import find_by_ddd
from validate_docbr import CPF
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
            a.first_name AS first_name,
            a.last_name AS last_name,
            a.state AS state,
            a.phone AS phone,
            ap.form_data->'state' AS form_state,
            ap.form_data->'name' AS form_name,
            ap.form_data->'lastname' AS form_lastname
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

        df['state'] = np.where(
            df['state'].isnull() & df['form_state'].notnull(), df['form_state'], df['state'])

        df['name'] = np.where(df['name'].isnull(), df['form_name'], df['name'])

        df['first_name'] = np.where(
            df['first_name'].isnull(), df['form_name'], df['first_name'])
        df['last_name'] = np.where(
            df['last_name'].isnull(), df['form_lastname'], df['last_name'])

        df['first_name'] = np.where(df['first_name'].isnull(
        ), df['name'].str.split(pat=" ").str[0], df['first_name'])
        df['last_name'] = np.where(df['last_name'].isnull(), df['name'].str.split(
            pat=" ").str[1:].str.join(" "), df['last_name'])

        df['first_name'] = np.where(len(df['first_name'].str.split(
            pat=" ")) > 1, df['first_name'].str.split(pat=" ").str[0], df['first_name'])

        df['name'] = df['name'].str.title()
        df['first_name'] = df['first_name'].str.title()
        df['last_name'] = df['last_name'].str.title()

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
            "widget_id",
            "mobilization_id",
            "community_id",
            "activist_id",
            "action_id",
            "action_date",
            "email",
            "name",
            "first_name",
            "last_name",
            "state",
            "phone"
        ]]

        df['state'] = np.where(df['state'].isnull() & df['phone'].notnull(
        ), df['phone'].str.replace(r'^\+[\d ]+\((\d{2})\)[\d ]+$', r'\1', regex=True), df['state'])

        df['state'] = df['state'].map(lambda x: find_by_ddd(x) if x else x)

        return df
