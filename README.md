# Wind Energy Dashboard via Streamlit

This repository holds the project files to build a wind resource assessment dashboard of one particular wind site at the University of the Philippines Diliman designated as Version 1.0

Production for Version 1.0 officially started on Nov 2, 2023 and uses Python 3.12.0

## Data Declaration
The data used in this project was provided by the Energy Engineering 205 course under the Energy Engineering Program at the University of the Philippines Diliman.

This project is purely a educational and training endeavour, and does not aim to infringe on the copyright of the data. 

# Project Overview

The project has three main goals: 
- Conduct a wind resource assessment analysis to demonstrate domain knowledge
- Use python and SQL, either together or separately for the analysis and data visualization to demonstrate skill proficiency
- Use streamlit to create a custom dashboard to demonstrate skill proficiency

# Domain Knowledge: Wind Resource Assessment
### Data Availability
Not required for the project, however it is important to understand the availability of the data for the entire year, if not simply to avoid the months where data is incomplete for data needed 30/31 days out of a month

Data Needed
- Year
- Month
- Count of Distinct Days Per Month 

### Diurnal Variation
The diurnal variation of wind speed provides information about the availability of suitable winds for the entire 24 h of the day. To study this pattern, overall mean hourly values of wind speed should be shown

Data Needed
  - Year
  - Month
  - Day
  - Hour
  - Average Wind Speed per hour

### Wind Rose Diagram 
Another useful way of represtning wind data is the wind rose diagram. A close look at the wind rose and understanding its message correctly is important for siting wind turbines. If  a large share of wind/wind energy comes from a particular direction then the wind turbines should be placed or installed against the direction. 

From Notes: Wind roses are constructed using hourly mean wind speed and corresponding wind direction values. 

From me: What i did was count that number of occurences of the raw wind records at 5 minute intervals grouped by the speed bin and direction as well as the cumulative sum of the percent frequency. 

I can modify the code to just use hourly mean speeds instead if desired. 

Data Needed
  - Year
  - Month
  - Day
  - Direction 
  - Speed Bins 
  - Cumulative Frequency

### Frequency Distribution
Wind Speed is not constant with time. Another way of assessing wind data is the frequency distribution. Modern turbines usually start producing energy above 3.5 m/s, thus the percentage availability of wind above the cutoff speed must be determined. 

Sort wind data according to wind speed and group according to range of wind speed, using 1 m/s intervals. Count the number of occurances per range and divide by the total number of observations

Data Needed
- Year
- Month
- Speed Bin
- Frequency
- Percent Frequency Per Speed Bin

### Wind Speed Distribution aka Weibull Function aka Distribution Function
Power from the wind varies with the cube of wind speed. To determine energy output and technical potential, it is important to know the wind speed distribution $f(v)$. 

The Weibull function is the most widely used to represent the distribution of the wind. This function expresses the possibility $f(v)$ to have a wind speed v during a year.

$$f(v) = \frac {\pi v}{2{(v_m)}^2} exp (\frac{\pi}{4}) (\frac{v}{v_m})^2$$

Data Needed
- to follow

### Wind Shear

To follow


Data Needed
- to follow

### Periodic Energy Production $YEY(v_m)$ 
When you combine the distribution function and the powercurve of a reference turbine, the periodic energy production can be calculated by integrating the power output at every bin width

$$YEY(v_m) = \sum_{v=1}^{25} f(v)P(v)8760$$


Data Needed
- to follow

## Requirements
Graphs
- Averaged Diurnal Variation : 1 diagram per day for selected month
- Windrose Diagram for average 24 hours : 1 diagram per day for selected month
- Frequency Distribution of the Wind Intensities : 1 graph for whole month

Compute
- Basic Statistics (min, max, ave). In which period do these values occur
- Wind Shear and YEY
  - The Melchor Hall rooftop is approximately 84 meters above the ground. The anemometer is installed 2 m above the rooftop. What is the theoretical wind energy potential on this site if a 20 m wind turbine is installed using a mast 25 meters above the rooftop? What will be the total energy yield for a day? Assuming the distribution holds for the year, compute for 𝑌𝐸𝑌(𝑣𝑚).
  - Wind Shear
  - YEY for a day
  - YEY for a year

Answer
- Describe the directional characteristics of wind in your site. In which direction are maximum speeds dominant? In General, higher values are observed during daytime and smaller values during evening and night hours. Is this true for your site. 
- The Weibull function can also be approximated as:

$$f(v) = (\frac {k}{A}) (\frac {v}{A})^{k-1} exp - (\frac {v}{A})^k$$

Where 
$$ A = \frac {2}{\sqrt \pi}v_m$$


# SQL and Python: Analysis and Visualization

### Pure Python

Create analysis modules
- As mentioned in the jupyter notebooks, there are multiple ways to actually do analysis on the dataset including
  - Pure excel
  - Pure Python via Pandas
  - Mixed SQL and Python via PostgreSQL and Pandas
  - Possibly Google BigQuery

### Pure Python
- Created ETL function for excel/csv file into no null-containing dataframe
- Created diurnal variation function that returns subset dataframe
- Created wind rose function that returns subset dataframe
- Created frequency distribution function that returns subset dataframe





### Mixed SQL

#### SQL
We can use either raw SQL with SQLTools or pgAdmin, or "indirectly" with psycopg2. Sample implementations for psycopg2 will be stored in notebooks-sql folder

- Setup PostgreSQL server instance on local machine
- Create a new database
- Create a schema in database
- Create a table in schema
- Create views in schema for easier querying later.
  - The data found in each view can be seen in the Domain Knowledge section
  - The data can be then exported as CSVs as well. 

#### Python

We can then use a mix of psycopg2 and pandas to query those views for specific months and days. 

We can also use python to create the data visualizations via the plotly library

# Streamlit: Dashboard Project


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

### Project Setup
- Create new repository on Github
- Create .gitignore file for **/.DS_Store, .vscode/, .virtual_environment
- Create relevant folders/files for streamlit project: data, modules, static, app.py, requirements.txt
- Create virtual environment using `python3 -m venv wind_dashboard`
- Activate using `source wind_dashboard/bin/activate`
- Deactivate using `deactivate`
- Populate requirements.txt and install via `pip3 install -r requirements.txt` to virtual environment
- Data in a excel file was uploaded to data folder

# Hosting

I will use heroku