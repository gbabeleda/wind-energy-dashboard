# Wind Energy Dashboard via Streamlit

This repository holds the project files to build a wind resource assessment dashboard of one particular wind site at the University of the Philippines Diliman as of Version 1.0. 

Production for Version 1.0 officially started on Nov 2, 2023 and uses Python 3.12.0

## Data Declaration

The data used in this project was provided by the Energy Engineering 205 course under the Energy Engineering Program at the University of the Philippines Diliman.

This project is purely a educational and training endeavour, and does not aim to infringe on the copyright of the data. 

# Project Details

This project is a first attempt at making a streamlit project, and aims to follow a standard streamlit structure to some degree, as seen below:

- .streamlit/
  - config.toml
- app.py
- requirements.txt
- setup.sh
- data/
  - dataset.csv
- modules/  
  - data_loader.py
  - helper_function.py
- pages/
  - overview.py
  - details.py
  - settings.py
- static/
  - images/
    - logo.png
  - stles/
    - custom.css
  - js/
    - script.js
- templates/
  - custom_template.html

It uses a virtual environment, with packages seen in the requirements.txt file. 

An additional folder is the notebooks-sql folder which holds all the notebooks where most of the development actually took place. 

A brief description of the roles/parts of the streamlit app can be seen below. 

- app.py is the main entry point of the streamlit app
- .streamlit/config.toml optional configuration file for setting up thigns like theme, page title, etc. 
- requirements.txt a list of python packages that are required for the app to run
- setup.sh an optional shell script that can be used to setup environment variables or streamlit setting when deploying
- data/ directory for storing data fiels such as csvs, excel files, or sqlite databases
- modules/ if the app has complex functionality, code can be organized into modules and import them in app.py
- pages/ for a multi-page app, each scrip represents a different page in the dashboard
- static/ holds static assets like images, css files for styling, and javascript files if necessary
- templates/ if you need custom HTML templates

# Project Worklog
Setup
- Create new repository on Github
- Create .gitignore file for **/.DS_Store, .vscode/, .virtual_environment
- Create relevant folders/files for streamlit project: data, modules, static, app.py, requirements.txt
- Create virtual environment using `venv`
- Populate requirements.txt and install via pip3 install -r requirements.txt` to virtual environment
- Data in a excel file was uploaded to data folder

Create analysis modules
- As mentioned in the jupyter notebooks, there are multiple ways to actually do analysis on the dataset including
  - Pure excel
  - Pure Python via Pandas
  - Mixed SQL and Python via PostgreSQL and Pandas
  - Possibly Google BigQuery

Pure Python
- Created ETL function for excel/csv file into no null-containing dataframe
- Created diurnal variation function 

Mixed SQL

