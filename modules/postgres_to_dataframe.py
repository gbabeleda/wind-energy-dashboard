import pandas as pd
from sqlalchemy import create_engine

def postgres_to_dataframe(view : str, dbname : str = "wind_energy",
                        user : str = "postgres", password : str = "postgres",
                        host : str = "localhost", schema : str = "wind_sites",
                        ) -> pd.DataFrame:
    
    connection_string = f"postgresql://{user}:{password}@{host}/{dbname}"
    
    engine = create_engine(url=connection_string)
    
    query = f"SELECT * FROM {schema}.{view};"
    
    try: 
        df = pd.read_sql_query(sql=query,con=engine)
        return df
    
    except Exception as e:
        raise e

    finally:
        engine.dispose()

# This works but gets a warning message
# Pandas officially supports using a sqlalchemy engine/connection or a 
# database URI string for its read_sql_query method

# def data_availability_to_df(dbname : str = "wind_energy",
#                            user : str = "postgres",
#                            password : str = "postgres",
#                            host : str = "localhost",
#                            schema : str = "wind_sites",
#                            view : str = "data_availability") -> pd.DataFrame:
#     parameters = {
#         "dbname" : dbname,
#         "user" : user,
#         "password" : password,
#         "host" : host
#     }
    
#     query = f"SELECT * FROM {schema}.{view}"
    
#     with psycopg2.connect(**parameters) as connection:
#        df = pd.read_sql_query(query,connection)
                    
#     return df