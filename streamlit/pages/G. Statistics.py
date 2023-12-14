import streamlit as st
from google.cloud import bigquery
from google.oauth2 import service_account
import plotly.express as px
import pandas as pd

# Set page config
st.set_page_config(layout="wide")

# Connection to BQ
gcp_credentials = service_account.Credentials.from_service_account_info(
    st.secrets["gcp_service_account"]
)

client = bigquery.Client(credentials=gcp_credentials)

# Pulling Data from BQ
@st.cache_data(ttl=6000)
def get_data():
    query = client.query("select * from `wired-ripsaw-403910.dbt_gbabeleda.monthly_stats`").to_dataframe()
    query_2 = client.query("select * from `wired-ripsaw-403910.dbt_gbabeleda.min_wind_instances`").to_dataframe()
    query_3 = client.query("select * from `wired-ripsaw-403910.dbt_gbabeleda.max_wind_instances`").to_dataframe()
    return query, query_2, query_3

monthly_stats, min_wind, max_wind = get_data()

with st.sidebar:
    year_months = sorted(min_wind["year_month"].unique())
    selected_year_month = st.radio(
        label="Year Month",
        options=year_months
    )
    
filtered_month = min_wind[(min_wind['year_month'] == selected_year_month)].sort_values(by=["year_month"],ascending=False)

fig_1 = px.bar(
    data_frame=monthly_stats,
    x="max_speed",
    y="year_month",
    color="max_speed",
    labels={"year_month" : "Month", "max_speed" : "Max Speed"},
    title="Maximum Wind Speeds Per Month",
    text="max_speed",
    color_continuous_scale="plotly3"
)

fig_2 = px.scatter(
    data_frame=monthly_stats,
    x="min_speed",
    y="year_month",
    color="min_speed",
    labels={"year_month" : "Month", "min_speed" : "Min Speed"},
    title="Mininimum Wind Speeds Per Month",
    color_continuous_scale="plasma"
)

fig_3 = px.bar(
    data_frame=monthly_stats,
    y="avg_speed",
    x="year_month",
    color="avg_speed",
    labels={"year_month" : "Month", "avg_speed" : "Avg Speed"},
    title="Average Wind Speeds Per Month",
    color_continuous_scale="dense",
    text="avg_speed",
)

fig_4 = px.scatter(
    data_frame=max_wind,
    x="year_month",
    y="hours",
    color="days",
    size="max_speed",
    hover_data=["year_month","max_speed"],
    labels={"hours": "Hour", "days": "Day", "msc_speed": "Wind Speed", "year_month" : "Month"},
    title="Occurences of Maximum Wind Speed",
    color_continuous_scale="twilight"
)

fig_5 = px.scatter(
    data_frame=min_wind,
    x="days",
    y="hours",
    color="hours",
    hover_data=["year_month","min_speed"],
    labels={"hours": "Hour", "days": "Day", "min_speed": "Wind Speed"},
    title="Occurences of Minimum Wind Speed",
    color_continuous_scale="plasma"
)

# Page Body
st.title("Wind Rose Hourly")
st.divider()

with st.container():
    col1, col2 = st.columns(2)
    
    with col1:
        st.plotly_chart(
            figure_or_data=fig_1,
            use_container_width=True
        )
    with col2:
        st.plotly_chart(
            figure_or_data=fig_2,
            use_container_width=True
        )
        
    st.plotly_chart(
        figure_or_data=fig_3,
        use_container_width=True
    )
        
with st.container():
    col3, col4 = st.columns(2)
    
    with col3:
        st.plotly_chart(
            figure_or_data=fig_4,
            use_container_width=True
        )
    with col4:
        st.plotly_chart(
            figure_or_data=fig_5,
            use_container_width=True
        )
        