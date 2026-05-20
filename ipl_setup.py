import pandas as pd
import mysql.connector

# ⚠️ Replace with your MySQL credentials before running
DB_HOST = 'localhost'
DB_USER = 'root'
DB_PASSWORD = 'your_password_here'  # Do not share this
DB_NAME = 'ipl_analysis'

# Connect to MySQL
conn = mysql.connector.connect(
    host=DB_HOST,
    user=DB_USER,
    password=DB_PASSWORD,
    database=DB_NAME
)
cursor = conn.cursor()

# Load cleaned CSVs
matches = pd.read_csv('data/matches_cleaned.csv')
deliveries = pd.read_csv('data/deliveries_cleaned.csv')

# Replace NaN with None (MySQL needs NULL not NaN)
matches = matches.where(pd.notnull(matches), None)
deliveries = deliveries.where(pd.notnull(deliveries), None)

# Import Matches
print("Importing matches...")
for _, row in matches.iterrows():
    cursor.execute("""
        INSERT IGNORE INTO matches
        (id, season, city, date, match_type, player_of_match, venue,
         team1, team2, toss_winner, toss_decision, winner, result,
         result_margin, target_runs, target_overs, super_over, method,
         umpire1, umpire2)
        VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
    """, tuple(row))
conn.commit()
print(f"Matches imported: {len(matches)} rows")

# Import Deliveries
print("Importing deliveries... (takes 2-3 mins)")
for _, row in deliveries.iterrows():
    cursor.execute("""
        INSERT IGNORE INTO deliveries
        (match_id, inning, batting_team, bowling_team, `over`, ball,
         batter, bowler, non_striker, batsman_runs, extra_runs, total_runs,
         extras_type, is_wicket, player_dismissed, dismissal_kind, fielder)
        VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
    """, tuple(row))
conn.commit()
print(f"Deliveries imported: {len(deliveries)} rows")

cursor.close()
conn.close()
print("All done! MySQL database is ready.")