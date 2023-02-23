import os
from sqlalchemy import create_engine, Table, Column, Integer, String, MetaData, JSON

DATABASE_URL = os.getenv('DATABASE_URL', 'postgresql://')

engine = create_engine(DATABASE_URL,
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
                         Column("name", String),
                         Column("given_name", String),
                         Column("family_name", String),
                         Column("address_line", String, nullable=True),
                         Column("locality", String, nullable=True),
                         Column("region", String, nullable=True),
                         Column("postal_code", String, nullable=True),
                         Column("phone", String, nullable=True),
                         Column("gender", String, nullable=True),
                         Column("color", String, nullable=True),
                         Column("birthday", String, nullable=True),
                         Column("metadata", JSON, nullable=True)
                         )
