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
st.divider()
st.write("By Jose Mari Angelo Abeleda")

with st.container():
    st.write(
        """ 
            ### Data Declaration and Acknowledgement
            The data used in this dashboard was provided via the Geodetic Engineering 
            Component of the Energy Engineering 205 Laboratory class presided over by 
            Engineer Rosario Ang, under the Energy 
            Engineering Program of the University of the Philippines Diliman
            
            The author of the dashboard would like to:
            - Acknowledge the Applied Geodesy and Space Technology Research Laboratory (AGST Lab)
            of the UP Training Center for Applied Geodesy & Photogrammetry (TCAGP), College of 
            Engineering, UP Diliman. 
            - Express that this data is only used for research, and to showcase skill in the following
                - Wind Resource Assessment
                - Python and SQl Proficiency
                - The use modern data tools to systemetically 
        """
    )
