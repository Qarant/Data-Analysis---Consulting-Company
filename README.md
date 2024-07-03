# Data Analysis Tools and Projects for Consulting Firm

This project includes tools and scripts developed for a consulting firm to analyze employee data and identify potential salary disparities and growth biases across departments. It encompasses data cleaning, Exploratory Data Analysis (EDA), statistical analysis, and visualization tasks.

## Project Overview

The project involved the following key files and processes, based on a dataset sourced from the Kaggle community:

- **Cleaning_and_exploratory.sql**: SQL script used for data exploration, cleaning, and formatting. This script prepared the data for export into two final CSV files:
  
  - **Employee_Quantity_by_Department.csv**: Contains the quantity of employees per department.
  - **Cleaned_Employee_Data.csv**: Cleaned dataset ready for analysis.

- **Data_Processing_Python.ipynb**: Jupyter notebook where Python was used to simulate hybrid and local (Texas) employees by adding specific columns. The resulting CSV file, now renamed:
  
  - **Employee_Report_Table.csv**: Dataset used for creating visualizations in Tableau.

- **Dirty_Data.csv**: Original dataset before cleaning and processing.

## Repository Contents

1. **sql_scripts/**
   - Directory containing SQL scripts used for data cleaning and exploration.

2. **Data_Processing_Python.ipynb**
   - Jupyter notebook showcasing data processing techniques in Python.

3. **datasets/**
   - Directory containing all datasets used in the project.

   - **Dirty_Data.csv**: Original dataset.
   - **Employee_Quantity_by_Department.csv**: Resulting file from the first query.
   - **Cleaned_Employee_Data.csv**: Cleaned dataset after data processing.
   - **Employee_Report_Table.csv**: Final dataset prepared for Tableau visualization.

## Getting Started

To explore this project:

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/your-repo-name.git
   cd your-repo-name


## Usage
SQL Scripts: Utilize scripts in sql_scripts/ for similar data cleaning and exploration tasks in your own database environment.  

Data Processing: Refer to Data_Processing_Python.ipynb for Python techniques used in this project and adapt them to your specific data scenarios.  

Visualization: Use Employee_Report_Table.csv in Tableau or other visualization tools to create insightful visualizations.
