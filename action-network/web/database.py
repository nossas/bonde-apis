import os
from sqlalchemy import create_engine, Table, Column, Integer, String, MetaData, JSON

DATABASE_URL = os.getenv('DATABASE_URL', 'postgresql://')

cnx = create_engine(DATABASE_URL,
                    pool_size=10,
                    max_overflow=2,
                    pool_recycle=300,
                    pool_pre_ping=True,
                    pool_use_lifo=True)

analyze_metadata = MetaData(schema="analyze")

activist_actions = Table("activist_actions", analyze_metadata,
                         Column("action", String),
                         Column("action_id", Integer),
                         Column("action_date", String),
                         Column("widget_id", Integer),
                         Column("mobilization_id", Integer),
                         Column("community_id", Integer),
                         Column("email", String),
                         Column("name", String, nullable=False),
                         Column("given_name", String, nullable=False),
                         Column("family_name", String, nullable=False),
                         Column("address_line", String, nullable=False),
                         Column("locality", String, nullable=False),
                         Column("region", String, nullable=False),
                         Column("postal_code", String, nullable=False),
                         Column("phone", String, nullable=False),
                         Column("gender", String, nullable=False),
                         Column("color", String, nullable=False),
                         Column("birthday", String, nullable=False),
                         Column("amount", String, nullable=False),
                         Column("metadata", JSON, nullable=True)
                         )
