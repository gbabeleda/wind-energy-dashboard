# Wind Energy Dashboard 

This streamlit dashboard was made to showcase the usefulness of
the modern data stack in energy applications, specifically, that 
of wind energy resource assessment of a particular site at the University of the Philippines Diliman.

The same analysis can be done to other wind sites (with improvements) and a catalogue of wind sites could (hypothetically) be done.

The latest implementation of this project uses bigquery, dbt, and streamlit. 

Prior iterations have used postgres, raw sql/psycopg, and vizro. 

## Data Declaration

The data used in this dashboard was provided via the Geodetic Engineering 
Component of the Energy Engineering 205 Laboratory class presided over by 
Engineer Rosario Ang, under the Energy Engineering Program of the University of the Philippines Diliman

The author of the dashboard would like to note the following:
- Acknowledge the Applied Geodesy and Space Technology Research Laboratory (AGST Lab) of the UP Training Center for Applied Geodesy & Photogrammetry (TCAGP), College of Engineering, UP Diliman. 
- Express that this data is only used for improvement of skill in the following fields:
  - Wind Resource Assessment
  - Python and SQl Proficiency
  - The use modern data tools to systemetically 

# Project Overview

The project has three main goals: 
- Conduct a wind resource assessment analysis to demonstrate domain knowledge
- Use the modern data stack and programming languag
- Use a dashboarding library (Vizro/Streamlit/Dash) to create a custom dashboard to demonstrate skill proficiency

# Domain Knowledge: Wind Resource Assessment

### Data Availability
Not required for the project, however it is important to understand the availability of the data for the entire year, if not simply to avoid the months where data is incomplete for data needed 30/31 days out of a month

Data Needed
- Year
- Month
- Count of Distinct Days Per Month where a wind data record was observed

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

We can do this with the average wind speeds and wind direcitons per hour, or from the raw wind data itself. Implementations of both will be done.

Data Needed
  - Year
  - Month
  - Day
  - Cardinal Direction 
  - Speed Bins 
  - Count Occuring at Certain Cardinal Direction/Speed Bin Per Day
  - Count Occuring Per Day
  - Percent Frequency 
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

### Wind Speed Distribution aka Weibull Function aka Distribution Function and Periodic Energy Production $YEY(v_m)$
Power from the wind varies with the cube of wind speed. To determine energy output and technical potential, it is important to know the wind speed distribution $f(v)$. 

The Weibull function is the most widely used to represent the distribution of the wind. This function expresses the possibility $f(v)$ to have a wind speed v during a year. This can be represtented by the function below:

$$f(v) = \frac {\pi v}{2{(v_m)}^2} exp (\frac{\pi}{4}) (\frac{v}{v_m})^2$$

For the purpose of our analysis, we will set v in f(v) to be the same speeds seen in the power curve, p(v) of our reference turbine. 

#### Periodic Energy Production  
When you combine the distribution function and the powercurve of a reference turbine, the periodic energy production can be calculated by integrating the power output at every bin width. 

$$YEY(v_m) = \sum_{v=1}^{25} f(v)P(v)8760$$

Data Needed
- Year
- Month
- Wind Shear 
- Wind Turbine Speeds
- p(v)
- f(v)
- f(v) * p(v) * 24 for Daily Energy Production
- f(v) * p(v) * 8760 for Yearly Energy Production

$$YEY(v_m) = \sum_{v=1}^{25} f(v)P(v)24$$

$$YEY(v_m) = \sum_{v=1}^{25} f(v)P(v)8760$$

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
$$A = \frac {2}{\sqrt \pi}v_m$$