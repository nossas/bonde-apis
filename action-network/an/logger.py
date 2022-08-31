import os
import logging

DEBUG = os.getenv('ENVIRONMENT', 'development') == 'development'

FORMAT = '%(asctime)s %(message)s'

if DEBUG:
    logging.basicConfig(level=logging.INFO, format=FORMAT)
else: 
    logging.basicConfig(filename='an-cli.log', level=logging.INFO, format=FORMAT)
