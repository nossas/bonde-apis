import os
from sqlalchemy import create_engine

DATABASE_URL = os.getenv('DATABASE_URL', 'postgresql://')

# print(DATABASE_URL)

cnx = create_engine(DATABASE_URL)