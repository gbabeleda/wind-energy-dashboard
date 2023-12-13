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
    query = client.query("select * from `wired-ripsaw-403910.dbt_gbabeleda.diurnal_variation_daily`").to_dataframe()
    query_2 = client.query("select * from `wired-ripsaw-403910.dbt_gbabeleda.diurnal_variation_monthly`").to_dataframe()
    query_3 = client.query("select * from `wired-ripsaw-403910.dbt_gbabeleda.diurnal_variation_yearly`").to_dataframe()
    return query, query_2, query_3

diur_daily, diur_monthly, diur_yearly = get_data()

# Sidebar

with st.sidebar:
    years = sorted(diur_daily["years"].unique())
    selected_year = st.radio(
        label="Year",
        options=years
    )
    
    months = sorted(diur_daily["months"].unique())
    selected_month = st.slider(
        label="Month",
        min_value=1,
        max_value=12
    )
    
    days = sorted(diur_daily["days"].unique())
    selected_day = st.selectbox(
        label="Day",
        options=days
    )

filtered_day = diur_daily[(diur_daily['years'] == selected_year) & (diur_daily['months'] == selected_month) & (diur_daily['days'] == selected_day)].sort_values(by=['hours'],ascending=True)
filtered_month = diur_monthly[(diur_monthly['years'] == selected_year) & (diur_monthly['months'] == selected_month)].sort_values(by=['hours'],ascending=True)
filteered_year = diur_yearly[diur_yearly['years'] == selected_year].sort_values(by=['hours'],ascending=True)


fig_1 = px.line(
    data_frame=filtered_day,
    x="hours",
    y="avg_wind_speed",
    labels={"avg_wind_speed" : "Mean Hourly Wind Speed", "hours" : "Hour"},
    title="Daily",
    markers=True
)

fig_2 = px.line(
    data_frame=filtered_month,
    x="hours",
    y="avg_wind_speed",
    labels={"avg_wind_speed" : "Mean Hourly Wind Speed", "hours" : "Hour"},
    title="Monthly",
    markers=True
)

fig_3 = px.line(
    data_frame=filteered_year,
    x="hours",
    y="avg_wind_speed",
    labels={"avg_wind_speed" : "Mean Hourly Wind Speed", "hours" : "Hour"},
    title="Yearly",
    markers=True
)

# fig_1.update_traces(
#     textangle=0
# )

# fig_2.update_traces(
#     textangle=0
# )

# fig_3.update_traces(
#     textangle=0
# )

# Page Body
st.title("Diurnal Variation")
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