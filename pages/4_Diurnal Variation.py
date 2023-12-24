import streamlit as st
from google.cloud import bigquery
from google.oauth2 import service_account
import plotly.express as px
import pandas as pd
from streamlit_lottie import st_lottie

# Set page config
st.set_page_config(layout="wide",page_title="Diurnal Variation")

# Connection to BQ
gcp_credentials = service_account.Credentials.from_service_account_info(
    st.secrets["gcp_service_account"]
)

client = bigquery.Client(credentials=gcp_credentials)

# Pulling Data from BQ
@st.cache_data(ttl=6000)
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
filtered_year = diur_yearly[diur_yearly['years'] == selected_year].sort_values(by=['hours'],ascending=True)


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
    data_frame=filtered_year,
    x="hours",
    y="avg_wind_speed",
    labels={"avg_wind_speed" : "Mean Hourly Wind Speed", "hours" : "Hour"},
    title="Yearly",
    markers=True
)

# Page Body
st_lottie("https://lottie.host/bb5dc813-e48c-49d6-be29-8c6519a69cab/Stx1IKflzv.json")
st.title("Diurnal Variation")

with st.container():
    st.write(
        """ 
            Diurnal variation refers to the changes in wind patterns over a 24-hour period. These variations are influenced by local geography, temperature gradients, and atmospheric conditions. For example, coastal areas often experience diurnal cycles due to sea breezes: winds are generally stronger and more consistent during the day due to solar heating and weaker at night. Understanding diurnal patterns is vital for predicting wind energy output, as it impacts the efficiency and reliability of wind turbines. Energy providers use this information to anticipate daily fluctuations in energy production, aiding in grid management and energy distribution planning.
        """
    )
    
    st.divider()
    
    tab1, tab2, tab3 = st.tabs(["Daily", "Monthly", "Yearly"])
    
    with tab1:
        st.plotly_chart(
            figure_or_data=fig_1,
            use_container_width=True
        )
    
    with tab2:
        st.plotly_chart(
            figure_or_data=fig_2,
            use_container_width=True
        )
    with tab3:
        st.plotly_chart(
            figure_or_data=fig_3,
            use_container_width=True
        )