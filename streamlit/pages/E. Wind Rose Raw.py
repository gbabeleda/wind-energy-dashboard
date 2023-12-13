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
    query = client.query("select * from `wired-ripsaw-403910.dbt_gbabeleda.wr_daily`").to_dataframe()
    query_2 = client.query("select * from `wired-ripsaw-403910.dbt_gbabeleda.wr_monthly`").to_dataframe()
    query_3 = client.query("select * from `wired-ripsaw-403910.dbt_gbabeleda.wr_yearly`").to_dataframe()
    return query, query_2, query_3

wr_daily, wr_monthly, wr_yearly = get_data()

with st.sidebar:
    years = sorted(wr_daily["years"].unique())
    selected_year = st.radio(
        label="Year",
        options=years
    )
    
    months = sorted(wr_daily["months"].unique())
    selected_month = st.slider(
        label="Month",
        min_value=1,
        max_value=12
    )
    
    days = sorted(wr_daily["days"].unique())
    selected_day = st.selectbox(
        label="Day",
        options=days
    )
    
filtered_day = wr_daily[(wr_daily['years'] == selected_year) & (wr_daily['months'] == selected_month) & (wr_daily['days'] == selected_day)]
filtered_month = wr_monthly[(wr_monthly['years'] == selected_year) & (wr_monthly['months'] == selected_month)]
filtered_year = wr_yearly[wr_yearly['years'] == selected_year]

fig_1 = px.bar_polar(
    data_frame=filtered_day,
    r="cumulative_perc_freq",
    theta="cardinal_direction",
    color="speed_bin",
    barmode="group",
    title="Daily",
    labels={"speed_bin" : "Wind Speed Bin"},
    category_orders={"cardinal_direction" : ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW']},
    color_continuous_scale="blugrn"
)

fig_2 = px.bar_polar(
    data_frame=filtered_month,
    r="cumulative_perc_freq",
    theta="cardinal_direction",
    color="speed_bin",
    barmode="group",
    title="Monthly",
    labels={"speed_bin" : "Wind Speed Bin"},
    category_orders={"cardinal_direction" : ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW']},
    color_continuous_scale="blugrn"
)

fig_3 = px.bar_polar(
    data_frame=filtered_year,
    r="cumulative_perc_freq",
    theta="cardinal_direction",
    color="speed_bin",
    barmode="group",
    title="Yearly",
    labels={"speed_bin" : "Wind Speed Bin"},
    category_orders={"cardinal_direction" : ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW']},
    color_continuous_scale="blugrn"
)

# Page Body
st.title("Wind Rose Hourly")
st.divider()

with st.container():
    st.plotly_chart(
        figure_or_data=fig_1,
        use_container_width=True
    )
    
    col1, col2 = st.columns(2)
    
    with col1:
        st.plotly_chart(
            figure_or_data=fig_2,
            use_container_width=True
        )
    with col2:
        st.plotly_chart(
            figure_or_data=fig_3,
            use_container_width=True
        )