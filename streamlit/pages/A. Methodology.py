import streamlit as st
from google.cloud import bigquery
from google.oauth2 import service_account

# Page Body
st.title("Methodology")

st.divider()

with st.container():
    st.write(
    """
        The main tools used in this analysis are as follows: 
        - Google BigQuery: This is where our data is stored, it is also where the queries are run
        - Data Build Tool (dbt): This is what we used to transform our data systematically 
        - Streamlit: This is what we used to build our dashboard and deploy it
        - Plotly: This is the graphing library that was used
        
        The following software engineering practices were also done 
    """
    )
with st.container():   
    st.divider()
    st.image(
        image="/Users/gioabeleda/Desktop/wind-energy-dashboard/streamlit/assets/lineage_graph.png"
    )