# 🏏 IPL Data Analytics Dashboard

An interactive Power BI dashboard analyzing 16 seasons of IPL data 
(2008–2024) with 200,000+ ball-by-ball delivery records.

---

## 📊 Dashboard Pages

### Page 1 — IPL Overview
- Total Matches, Total Runs, Total Wickets, Toss Win % KPI cards
- IPL Wins by Team (all time)
- Top 10 Run Scorers
- Season-wise Avg Runs Per Match trend
- Top 10 Wicket Takers
- Toss Decision analysis (Bat vs Field)
- Interactive slicers — Season, Team, Venue

### Page 2 — Player Analysis
- Most Sixes in IPL history
- Most Fours in IPL history
- Most Player of the Match awards

---

## 🔍 Key Insights

- Mumbai Indians are the most successful IPL team with 140+ wins
- Virat Kohli is the all-time leading run scorer with 8000+ runs
- CH Gayle hit the most sixes in IPL history (350+)
- AB de Villiers won the most Player of Match awards (25+)
- YS Chahal is the leading wicket taker
- Teams choosing to field first after winning toss win 42% of matches
- Average runs per match increased from ~280 to ~360 over 16 seasons
- 64% of toss winners chose to field first

---

## 🛠️ Tools Used

- **Python** — Data import and preprocessing (pandas, mysql-connector)
- **MySQL** — Database storage and SQL analysis queries
- **Power BI Desktop** — Dashboard and visualization
- **SQL** — 12+ analytical queries for KPI extraction

---

## 📁 Dataset

- Source: Kaggle — IPL Complete Dataset 2008–2024
- matches_cleaned.csv — 1095 matches across 16 seasons
- deliveries_cleaned.csv — 200,000+ ball-by-ball records

---

## ⚙️ How to Run

### Python Import
```python
pip install pandas mysql-connector-python
python python/ipl_import.py
```

### SQL Analysis
- Open MySQL Workbench
- Run sql/ipl_analysis.sql

### View Dashboard
- Open dashboard/IPL_Dashboard.pbix in Power BI Desktop

---

## 📸 Screenshots

### Page 1 — IPL Overview
<img width="1125" height="691" alt="image" src="https://github.com/user-attachments/assets/d1a62c68-5ba4-4462-8914-e5a1ef3c2639" />


### Page 2 — Player Analysis
<img width="1093" height="605" alt="image" src="https://github.com/user-attachments/assets/ade492a2-07a8-4940-bbde-b5bb184997dc" />


---

## 💡 DAX Measures Created

- Total Matches
- Total Runs
- Total Wickets
- Toss Win %
- Avg Runs Per Match
- Total Sixes
- Total Fours
