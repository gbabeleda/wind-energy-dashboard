import streamlit as st
from google.cloud import bigquery
from google.oauth2 import service_account

st.title("Data Availability")

gcp_credentials = service_account.Credentials.from_service_account_info(
    st.secrets["gcp_service_account"]
)

client = bigquery.Client(credentials=gcp_credentials)

data_availability = client.query("select * from `wired-ripsaw-403910.dbt_gbabeleda.data_availability`").to_dataframe()

