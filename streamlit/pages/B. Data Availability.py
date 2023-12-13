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
    query = "select * from `wired-ripsaw-403910.dbt_gbabeleda.data_availability`"
    return client.query(query=query).to_dataframe()

data_availability = get_data().sort_values(by=["years","months"],ascending=False)

# Page Body
st.title("Data Availability")
st.divider()

# Plotly Graph
fig = px.bar(
    data_frame=data_availability,
    y="year_month",
    x="count_days",
    color="count_days",
    labels={"year_month" : "Month", "count_days" : "Days Counted"},
    # color_continuous_scale="sunset",
    text="count_days",
    category_orders={}
)

fig.update_traces(
    textangle=0
)

# Streamlit Page Content
with st.container():
    st.write(
        """ 
            For this application, we consider a day with even a single non-null 
            wind record exists as a day where data is available.
            
            From that definition, we can see that both January and March 2010 have incomplete data, 
            February has no data at all, and there is a single day of data in January 2011
        """
    )
    
    st.plotly_chart(
        figure_or_data=fig,
        use_container_width=True,
    )  
    
with st.container():
    st.dataframe(
        data=data_availability,
        use_container_width=True,
        hide_index=True,
        column_order=("years","months","count_days"),
        column_config={
            "years" : "Year", 
            "months" : "Month", 
            "count_days" : "Days with Data"
            }
    )