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
    