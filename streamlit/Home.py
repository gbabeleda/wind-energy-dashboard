import streamlit as st
from google.cloud import bigquery
from google.oauth2 import service_account
from streamlit_lottie import st_lottie

# Page Layout
st.set_page_config(layout="wide",)

# Connect to BQ
gcp_credentials = service_account.Credentials.from_service_account_info(
    st.secrets["gcp_service_account"]
)

client = bigquery.Client(credentials=gcp_credentials)

# Sidebar
with st.sidebar:
    st.markdown(
        """ 
        By Jose Mari Angelo Abeleda
        
        - Email: gioabeleda@gmail.com
        - LinkedIn: [Jose Mari Angelo Abeleda](https://www.linkedin.com/in/jose-mari-angelo-abeleda/)
        - GitHub: [gbabeleda](https://github.com/gbabeleda)
        """
    )

# Page Body
st.title("Wind Resource Assessment Dashboard")
st.divider()

with st.container():
    col1, col2 = st.columns(2)
    
    with col1:
        st.write(
            """ 
                ### Hello!
                
                This streamlit dashboard was made to showcase the usefulness of
                the modern data stack in energy applications, specifically, that 
                of wind energy resource assessment. 
                
                The same analysis can be done to other wind sites (with improvements)
                and a catalogue of wind sites could (hypothetically) be done
            """
        )
    with col2:  
        st_lottie("https://lottie.host/2b0eb131-2ce3-46b2-9ccc-f712d2191987/RSW9HGixmm.json")

    col3, col4 = st.columns(2)
    
    with col3:
        st.write(
            """ 
                ### Data Declaration and Acknowledgement
                The data used in this dashboard was provided via the Geodetic Engineering 
                Component of the Energy Engineering 205 Laboratory class presided over by 
                Engineer Rosario Ang, under the Energy 
                Engineering Program of the University of the Philippines Diliman
                
                The author of the dashboard would like to note the following:
                - Acknowledge the Applied Geodesy and Space Technology Research Laboratory (AGST Lab)
                of the UP Training Center for Applied Geodesy & Photogrammetry (TCAGP), College of 
                Engineering, UP Diliman. 
                - Express that this data is only used for improvement of skill in the following fields:
                    - Wind Resource Assessment
                    - Python and SQl Proficiency
                    - The use modern data tools to systemetically 
            """
        )
        
    with col4:
        st_lottie("https://lottie.host/6a58fc08-6160-4356-b159-f344b087d53d/bqRIEly1nx.json")