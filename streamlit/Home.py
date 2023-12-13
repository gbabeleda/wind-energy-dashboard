import streamlit as st
from google.cloud import bigquery
from google.oauth2 import service_account

# Connect to BQ
gcp_credentials = service_account.Credentials.from_service_account_info(
    st.secrets["gcp_service_account"]
)

client = bigquery.Client(credentials=gcp_credentials)

# Page Body
st.title("Wind Resource Assessment Dashboard")
st.write("By Jose Mari Angelo Abeleda")
st.divider()


