import streamlit as st
from google.cloud import bigquery
from google.oauth2 import service_account
import plotly.express as px
import pandas as pd
from streamlit_lottie import st_lottie

# Set page config
st.set_page_config(layout="wide",page_title="Wind Rose")

# Connection to BQ
gcp_credentials = service_account.Credentials.from_service_account_info(
    st.secrets["gcp_service_account"]
)

client = bigquery.Client(credentials=gcp_credentials)

# Pulling Data from BQ
@st.cache_data(ttl=6000)
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
st_lottie("https://lottie.host/bb5dc813-e48c-49d6-be29-8c6519a69cab/Stx1IKflzv.json")
st.title("Wind Rose Hourly")
st.divider()

with st.container():
    st.write(
        """ 
            Wind rose diagrams are graphical tools used in wind energy assessment to represent wind speed and direction data. They provide a visual summary of how wind speed and direction are distributed at a particular location over a specified period. The diagram resembles a flower with petals, where each petal represents the frequency of winds blowing from a particular direction. The length and color of each petal can indicate wind speed ranges or frequencies. Wind roses help in identifying prevailing wind directions and speeds, which is crucial for optimal turbine placement and understanding seasonal wind behavior.
        """
    )
    
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