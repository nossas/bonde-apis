import os
from sqlalchemy import create_engine

DATABASE_URL = os.getenv('DATABASE_URL', 'postgresql://')

# print(DATABASE_URL)

cnx = create_engine(DATABASE_URL,
                    pool_size=10,
                    max_overflow=2,
                    pool_recycle=300,
                    pool_pre_ping=True,
                    pool_use_lifo=True)