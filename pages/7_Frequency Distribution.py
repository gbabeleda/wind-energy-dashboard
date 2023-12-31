import streamlit as st
from google.cloud import bigquery
from google.oauth2 import service_account
import plotly.express as px
import pandas as pd
from streamlit_lottie import st_lottie

# Set page config
st.set_page_config(layout="wide",page_title="Frequency Distribution")

# Connection to BQ
gcp_credentials = service_account.Credentials.from_service_account_info(
    st.secrets["gcp_service_account"]
)

client = bigquery.Client(credentials=gcp_credentials)

# Pulling Data from BQ
@st.cache_data(ttl=6000)
def get_data():
    query = "select * from `wired-ripsaw-403910.dbt_gbabeleda.frequency_distribution_monthly`"
    query_2 = "select * from `wired-ripsaw-403910.dbt_gbabeleda.frequency_distribution_yearly`"
    return client.query(query).to_dataframe(),client.query(query_2).to_dataframe()

freq_monthly, freq_yearly = get_data()

# Sidebar
with st.sidebar:
    years = freq_monthly["years"].unique()
    selected_year = st.radio(
        label="Year",
        options=years
    )
    
    months = freq_monthly["months"].unique()
    selected_month = st.slider(
        label="Month",
        min_value=1,
        max_value=12
    )

filtered_month = freq_monthly[(freq_monthly['years'] == selected_year) & (freq_monthly['months'] == selected_month)]
filtered_year = freq_yearly[(freq_yearly['years'] == selected_year)]

fig_1 = px.bar(
    data_frame=filtered_month,
    x="speed_bin",
    y="percent_frequency",
    color="percent_frequency",
    labels={"speed_bin" : "Wind Speed Bins", "percent_frequency" : "Frequency (%)"},
    hover_name="year_month",
    title="Monthly",
    color_continuous_scale="viridis",
    text="percent_frequency"
)

fig_2 = px.bar(
    data_frame=filtered_year,
    x="speed_bin",
    y="percent_frequency",
    color="percent_frequency",
    labels={"speed_bin" : "Wind Speed Bins", "percent_frequency" : "Frequency (%)"},
    hover_name="years",
    title="Yearly",
    color_continuous_scale="viridis",
    text="percent_frequency"
)
fig_1.update_traces(
    textangle=0
)

fig_2.update_traces(
    textangle=0
)

# Page Body
st_lottie("https://lottie.host/bb5dc813-e48c-49d6-be29-8c6519a69cab/Stx1IKflzv.json")
st.title("Frequency Distribution")
st.divider()

with st.container():
    st.write(
        """ 
            Frequency distribution in wind data analysis refers to the statistical representation of how often different wind speeds occur at a site. It is typically presented as a histogram or a table, showing the percentage of time wind speeds fall within specified ranges. This distribution is critical for estimating the potential wind energy production, as it directly influences the selection of wind turbines best suited for the site's wind regime. Sites with higher frequencies of optimal wind speeds for turbine operation are more favorable for wind farm development.
        """
    )
    
    tab1, tab2 = st.tabs(["Monthly Frequency Distribution","Yearly Frequency Distribution"])
    
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