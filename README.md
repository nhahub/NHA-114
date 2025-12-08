# 🎓 Student Performance Dashboard & Ticketing System

A comprehensive data engineering solution for managing student performance data, providing analytics dashboards, and handling feedback through automated sentiment analysis and email notifications.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Data Pipeline](#data-pipeline)
- [Contributing](#contributing)

## 🌟 Overview

This system provides a complete end-to-end solution for educational institutions to:
- Manage and analyze student performance data
- Provide students with access to their scores and performance metrics
- Collect and analyze student feedback using AI-powered sentiment analysis
- Automate email notifications based on feedback sentiment
- Transform raw data into normalized relational database structures
- Visualize performance trends and attendance patterns

## ✨ Features

### For Students
- **Personal Dashboard**: View individual scores across all subjects
- **Performance Analytics**: See overall performance distributions
- **Anonymous Feedback**: Submit feedback with automatic sentiment analysis
- **Secure Access**: ID-based authentication system

### For Administrators
- **Data Management**: Upload and process student data files
- **Automated Data Cleaning**: Handle missing values, duplicates, and data validation
- **Performance Analytics**: Comprehensive visualizations of student performance
- **Attendance Tracking**: Heatmap visualization of attendance patterns
- **Feedback Monitoring**: Automated email routing based on sentiment

### Technical Features
- **ETL Pipeline**: Automated data extraction, transformation, and loading
- **dbt Transformations**: SQL-based data modeling and transformations
- **Sentiment Analysis**: Multilingual AI model for feedback analysis
- **Workflow Orchestration**: Apache Airflow for task automation
- **Data Visualization**: Interactive charts and heatmaps

## 🏗️ Architecture

```
Raw Data (CSV) 
    ↓
Streamlit Upload Interface
    ↓
Data Cleaning & Processing
    ↓
dbt Seeds & Models
    ↓
MySQL Database (Normalized Schema)
    ↓
Analytics & Visualization
```

**Feedback Pipeline:**
```
Student Feedback
    ↓
Sentiment Analysis (Transformers)
    ↓
Airflow DAG Trigger
    ↓
Conditional Email Routing
```

## 🛠️ Tech Stack

- **Frontend**: Streamlit
- **Data Processing**: Pandas, NumPy
- **Visualization**: Matplotlib
- **Database**: MySQL
- **Data Transformation**: dbt (Data Build Tool)
- **Workflow Orchestration**: Apache Airflow (Docker)
- **ML/AI**: Hugging Face Transformers (tabularisai/multilingual-sentiment-analysis)
- **Containerization**: Docker & Docker Compose

## 📦 Prerequisites

- Python 3.8+
- Docker & Docker Compose
- MySQL 8.0+
- dbt CLI
- Git

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone <repository-url>
cd <repository-name>
```

### 2. Install Python Dependencies

```bash
pip install -r src/requirements.txt
```

### 3. Set Up Airflow with Docker

```bash
cd src/Airflow
docker-compose up -d
```

Access Airflow UI at `http://localhost:8080` (default credentials: airflow/airflow)

### 4. Configure dbt

```bash
cd src/Dbt
# Edit profiles.yml with your MySQL credentials
dbt deps
dbt seed
dbt run
```

### 5. Set Up MySQL Database

```sql
-- Run the schema creation script
source src/SQL/Relational\ Schemas
```

## ⚙️ Configuration

### Email Configuration (Airflow)

Edit `src/Airflow/docker-compose.yaml`:

```yaml
AIRFLOW__SMTP__SMTP_USER: "your-email@gmail.com"
AIRFLOW__SMTP__SMTP_PASSWORD: "your-app-password"
AIRFLOW__SMTP__SMTP_MAIL_FROM: "your-email@gmail.com"
```

### Email Recipients (DAG)

Edit `src/Airflow/DAG` to configure email routing:

```python
def choose_email(**context):
    sentiment = context["dag_run"].conf.get("sentiment", "Neutral")
    if sentiment in ["Very Negative", "Negative"]:
        return "urgent-support@example.com"
    else:
        return "feedback@example.com"
```

### Database Configuration (dbt)

Update `dbt_folder/profiles.yml`:

```yaml
my_profile:
  target: dev
  outputs:
    dev:
      type: mysql
      host: localhost
      port: 3306
      user: your_username
      password: your_password
      database: student_data
      schema: student_data
```

## 💻 Usage

### Starting the Application

1. **Start Airflow** (if not already running):
```bash
cd src/Airflow
docker-compose up -d
```

2. **Launch Streamlit Dashboard**:
```bash
streamlit run src/Streamlit/main.py
```

### Workflow

#### For Administrators:

1. Access the main page and enter admin ID
2. Navigate to "admin" page to upload student data CSV
3. System automatically:
   - Cleans and validates data
   - Runs dbt transformations
   - Updates MySQL database
4. View analytics on "scores" page

#### For Students:

1. Access the main page and enter student ID
2. View personal scores on "scores" page
3. Submit feedback on "feedback" page (minimum 50 characters)
4. System automatically analyzes sentiment and routes email

### Data Upload Format

CSV file should contain the following columns:
- `Student_ID`: Unique identifier
- `First_Name`: Student's first name
- `Last_Name`: Student's last name
- `Birth_Date`: Date of birth (YYYY-MM-DD)
- `Math`, `Physics`, `Chemistry`, `Biology`, `English`, `History`: Subject scores
- `Attendance`: Attendance percentage

## 📁 Project Structure

```
src/
├── .gitignore                 # Git ignore rules
├── requirements.txt           # Python dependencies
│
├── Airflow/
│   ├── API                    # Sentiment analysis API
│   ├── DAG                    # Email workflow DAG
│   └── docker-compose.yaml    # Airflow Docker configuration
│
├── Data Manipulation/
│   ├── data cleaning          # Data preprocessing scripts
│   └── data visualization     # Visualization scripts
│
├── Dbt/
│   ├── schema.yaml           # dbt model documentation
│   ├── students.sql          # Students dimension model
│   ├── subjects.sql          # Subjects dimension model
│   ├── scores.sql            # Scores fact table
│   ├── scores_by_month.sql   # Monthly aggregations
│   └── top_performance.sql   # Top performers view
│
├── SQL/
│   ├── ER-Diagram.drawio     # Database ER diagram
│   ├── Relational Schemas    # DDL statements
│   └── Split data            # Data migration scripts
│
└── Streamlit/
    ├── main.py               # Login page
    ├── admin.py              # Admin control panel
    ├── scores.py             # Performance dashboard
    └── feedback.py           # Feedback submission
```

## 🔄 Data Pipeline

### 1. Data Ingestion
- CSV upload through Streamlit interface
- Validation and duplicate removal

### 2. Data Cleaning
- Fill missing values (scores → 0, names → "Unknown")
- Date standardization
- Calculate average scores and performance categories

### 3. Data Transformation (dbt)
- **Seeds**: Load raw data into MySQL
- **Models**:
  - `students`: Deduplicated student records
  - `subjects`: Reference table for subjects
  - `scores`: Normalized fact table (wide to long format)
  - `scores_by_month`: Monthly performance aggregations
  - `top_performance`: Best performers per subject

### 4. Data Storage
- Normalized MySQL database (3NF)
- Three main tables: Students, Subjects, Scores
- Foreign key relationships maintained

### 5. Analytics & Visualization
- Real-time dashboard updates
- Subject-wise distribution histograms
- Attendance heatmaps

## 🤖 Sentiment Analysis

The system uses the `tabularisai/multilingual-sentiment-analysis` model to classify feedback into:
- Very Negative
- Negative
- Neutral
- Positive
- Very Positive

Based on sentiment, emails are automatically routed to appropriate recipients.

## 📊 Database Schema

### ER Diagram

```
Students (1) ─────< (N) Scores (N) >───── (1) Subjects
   │                      │
   │                      │
Student_ID           Score_ID
First_Name          Student_ID (FK)
Last_Name           Subject_ID (FK)
Birth_Date          Score
```

### Tables

**students**
- `Student_ID` (PK)
- `First_Name`
- `Last_Name`
- `Birth_Date`

**subjects**
- `Subject_ID` (PK)
- `Subject_Name`

**scores**
- `Score_ID` (PK)
- `Student_ID` (FK)
- `Subject_ID` (FK)
- `Score`

## 🔐 Security Notes

- Store sensitive credentials in `.env` files (not tracked by git)
- Use app passwords for Gmail SMTP
- Implement proper access controls for production deployment
- Feedback is anonymous (no student identification in emails)

## 🐛 Troubleshooting

### Airflow Connection Issues
```bash
docker-compose down
docker-compose up -d
# Wait for all services to be healthy
```

### dbt Run Failures
```bash
dbt debug  # Check connection
dbt clean
dbt deps
dbt seed --full-refresh
dbt run --full-refresh
```

### Database Connection Errors
- Verify MySQL is running
- Check credentials in dbt profiles.yml
- Ensure database `student_data` exists

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License.

## 👥 Authors

- **Data Engineering Team** - Initial work

## 🙏 Acknowledgments

- Hugging Face for the sentiment analysis model
- Apache Airflow community
- dbt Labs for the transformation framework
- Streamlit for the dashboard framework

---

**Note**: This system is designed for educational purposes. For production deployment, implement additional security measures, scalability considerations, and data privacy compliance.
