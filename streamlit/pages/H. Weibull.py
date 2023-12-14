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
@st.cache_data(ttl=6000)
def get_data():
    query = client.query("select * from `wired-ripsaw-403910.dbt_gbabeleda.delta_wind_height`").to_dataframe()
    query_2 = client.query("select * from `wired-ripsaw-403910.dbt_gbabeleda.weibull`").to_dataframe()
    query_3 = client.query("select * from `wired-ripsaw-403910.dbt_gbabeleda.yey`").to_dataframe()
    return query, query_2, query_3

wind_shear, weibull, yey = get_data()

with st.sidebar:
    years = sorted(wind_shear["years"].unique())
    selected_year = st.radio(
        label="Year",
        options=years
    )
    
    months = sorted(wind_shear["months"].unique())
    selected_month = st.slider(
        label="Month",
        min_value=1,
        max_value=12
    )
    
filtered_wind_shear = wind_shear[wind_shear['years'] == selected_year].sort_values(by=["years","months"])
filtered_weibull = weibull[(weibull['years'] == selected_year) & (weibull['months'] == selected_month)].sort_values(by=["years","months","speed_at_turbine"])

fig_1 = px.bar(
    data_frame=filtered_wind_shear,
    x="year_month",
    y="wind_shear",
    barmode="group",
    labels={"value": "Wind Speed (m/s)", "wind_shear": "Wind Speed @ Rotor", "year_month": "Month"},
    title="Wind Shear Per Month",
)

fig_2 = px.line(
    data_frame=weibull[weibull["months"] == 10].sort_values(by=["speed_at_turbine"]),
    x="speed_at_turbine",
    y="power_curve",
    labels={"power_curve": "Power (kW)", "speed_at_turbine": "Wind speed (m/s)"},
    title="Vestas 20/100 Power Curve",
    markers=True
)

fig_3 = px.line(
    data_frame=filtered_weibull,
    x="speed_at_turbine",
    y="f_v",
    labels={"f_v": "f(v)", "speed_at_turbine": "Wind speed (m/s)"},
    title="Weibull Function per Month",
    markers=True
)

fig_4 = px.bar(
    data_frame=yey,
    x="year_month",
    y="sum_yey_daily",
    labels={"year_month": "Month", "sum_yey_daily": "Daily Energy Production (kWh)"},
    color="sum_yey_daily",
    text="sum_yey_daily",
)

fig_5 = px.bar(
    data_frame=yey,
    x="year_month",
    y="sum_yey_yearly",
    labels={"year_month": "Month", "sum_yey_yearly": "Yearly Energy Production (kWh)"},
    color="sum_yey_yearly",
    text="sum_yey_yearly",
)

# Page Body
st.title("Wind Rose Hourly")
st.divider()

with st.container():
    st.plotly_chart(
        figure_or_data=fig_1,
        use_container_width=True
    )

    st.write(
        """ 
            # Wind Turbine Details
            - Manufacturer: Vestas
            - Model: V20/100
            - Rated Power: 100 kW
            - Rotor Diameter: 20 m
            - Cut-in wind speed: 5 m/s
            - Rated wind speed: 17.5 m/s
            - Cut-off wind speed: 25 m/s
            - Hub Height: 24 m 
        """
    )
    
    st.plotly_chart(
        figure_or_data=fig_2,
        use_container_width=True
    )

    st.plotly_chart(
        figure_or_data=fig_3,
        use_container_width=True
    )
    
    st.plotly_chart(
        figure_or_data=fig_4,
        use_container_width=True
    )
    
    st.plotly_chart(
        figure_or_data=fig_5,
        use_container_width=True
    )