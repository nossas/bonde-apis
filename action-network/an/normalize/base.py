"""
Normalize Workflow Interface
"""
import abc
import enlighten
import pandas as pd
from logger import logging
from database.bigquery import insert_activist_actions as insert
from database.postgres import cnx

# Setup progress bar
STATUS_FORMAT = '{program}{fill}Stage: {stage}{fill} Status {status}'


class NormalizeWorkflowInterface:
    """
    Normalize Workflow Interface
    """

    def __init__(self, params: dict, limit=500000, page=0):
        self.limit = limit
        self.page = page
        self.params = params
        self.total = 0

        logging.info(f'Normalize {params["action"]} on community {params["community_id"]}')
        self.manager = enlighten.get_manager()
        self.sbar = self.manager.status_bar(status_format=STATUS_FORMAT,
                          color='bold_slategray',
                          program='Demo',
                          stage=f'Normalize {params["action"]} on community {params["community_id"]}',
                          status='START')

    @abc.abstractmethod
    def query(self, offset: int) -> str:
        """
        query
        """
        raise NotImplementedError

    @abc.abstractmethod
    def normalize(self, df):
        """
        normalize
        """
        raise NotImplementedError

    def run(self):
        """run"""
        while True:
            self.sbar.update(stage=f'Initializing {self.page}', status='LOADING')
            logging.info(f'Initializing {self.page}')

            df = pd.read_sql_query(
                self.query(self.page * self.limit), cnx)

            if len(df) == 0:
                self.sbar.update(stage='Not found items', status='DONE')
                logging.info('Not found items')
                break
            
            self.sbar.update(stage=f'Parsing {self.page}', status='PROCESSING')
            df = self.normalize(df)
            insert(df)

            self.page += 1
            self.total += len(df)
            if len(df) < self.limit:
                break
        
        logging.info(f'Success to process and insert {self.total}')
        self.sbar.update(stage=f'Success to process and insert {self.total}', status='DONE')
