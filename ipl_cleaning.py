import pandas as pd

# Load raw data
matches = pd.read_csv('matches.csv')
deliveries = pd.read_csv('deliveries.csv')

# Check shape and nulls
print("Matches shape:", matches.shape)
print("Deliveries shape:", deliveries.shape)
print("\nNull values in matches:\n", matches.isnull().sum())
print("\nNull values in deliveries:\n", deliveries.isnull().sum())

# Fix nulls in matches
matches['player_of_match'].fillna('Unknown', inplace=True)
matches['winner'].fillna('No Result', inplace=True)
matches['city'].fillna(matches['venue'], inplace=True)

# Fix team name inconsistencies (teams renamed over the years)
team_map = {
    'Delhi Daredevils': 'Delhi Capitals',
    'Kings XI Punjab': 'Punjab Kings',
    'Deccan Chargers': 'Sunrisers Hyderabad',
    'Rising Pune Supergiants': 'Rising Pune Supergiant'
}
matches['team1'] = matches['team1'].replace(team_map)
matches['team2'] = matches['team2'].replace(team_map)
matches['winner'] = matches['winner'].replace(team_map)
deliveries['batting_team'] = deliveries['batting_team'].replace(team_map)
deliveries['bowling_team'] = deliveries['bowling_team'].replace(team_map)

# Save cleaned files
matches.to_csv('matches_cleaned.csv', index=False)
deliveries.to_csv('deliveries_cleaned.csv', index=False)

print("\nCleaning done!")
print(f"Matches saved: {len(matches)} rows")
print(f"Deliveries saved: {len(deliveries)} rows")