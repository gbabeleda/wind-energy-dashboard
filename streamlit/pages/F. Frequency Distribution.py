import streamlit as st
from google.cloud import bigquery
from google.oauth2 import service_account
import plotly.express as px
import pandas as pd

# Connection to BQ
gcp_credentials = service_account.Credentials.from_service_account_info(
    st.secrets["gcp_service_account"]
)

client = bigquery.Client(credentials=gcp_credentials)

# Pulling Data from BQ
@st.cache_data(ttl=600)
def get_data():
    query = "select * from `wired-ripsaw-403910.dbt_gbabeleda.frequency_distribution_monthly`"
    query_2 = "select * from `wired-ripsaw-403910.dbt_gbabeleda.frequency_distribution_yearly`"
    return client.query(query).to_dataframe(),client.query(query_2).to_dataframe()

freq_monthly = pd.DataFrame(get_data()[0])
freq_yearly = pd.DataFrame(get_data()[1])

