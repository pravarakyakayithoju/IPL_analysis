-- =============================================
-- IPL ANALYSIS - DATABASE SETUP
-- =============================================

CREATE DATABASE IF NOT EXISTS ipl_analysis;
USE ipl_analysis;

-- Matches Table
CREATE TABLE IF NOT EXISTS matches (
    id INT PRIMARY KEY,
    season VARCHAR(20),
    city VARCHAR(100),
    date DATE,
    match_type VARCHAR(50),
    player_of_match VARCHAR(100),
    venue VARCHAR(150),
    team1 VARCHAR(100),
    team2 VARCHAR(100),
    toss_winner VARCHAR(100),
    toss_decision VARCHAR(10),
    winner VARCHAR(100),
    result VARCHAR(50),
    result_margin FLOAT,
    target_runs FLOAT,
    target_overs FLOAT,
    super_over VARCHAR(5),
    method VARCHAR(50),
    umpire1 VARCHAR(100),
    umpire2 VARCHAR(100)
);

-- Deliveries Table
CREATE TABLE IF NOT EXISTS deliveries (
    match_id INT,
    inning INT,
    batting_team VARCHAR(100),
    bowling_team VARCHAR(100),
    `over` INT,
    ball INT,
    batter VARCHAR(100),
    bowler VARCHAR(100),
    non_striker VARCHAR(100),
    batsman_runs INT,
    extra_runs INT,
    total_runs INT,
    extras_type VARCHAR(50),
    is_wicket INT,
    player_dismissed VARCHAR(100),
    dismissal_kind VARCHAR(50),
    fielder VARCHAR(100),
    FOREIGN KEY (match_id) REFERENCES matches(id)
);

-- =============================================
-- ANALYSIS QUERIES
-- =============================================

-- 1. VERIFY DATA
SELECT 'MATCHES COUNT' AS check_name, COUNT(*) AS total FROM matches
UNION ALL
SELECT 'DELIVERIES COUNT', COUNT(*) FROM deliveries;

-- 2. TEAM WINS
SELECT
    winner AS team,
    COUNT(*) AS total_wins
FROM matches
WHERE winner IS NOT NULL
GROUP BY winner
ORDER BY total_wins DESC;

-- 3. TOP 10 BATSMEN BY RUNS
SELECT
    batter,
    SUM(batsman_runs) AS total_runs,
    COUNT(DISTINCT match_id) AS matches_played,
    ROUND(SUM(batsman_runs) / COUNT(DISTINCT match_id), 2) AS avg_runs_per_match
FROM deliveries
GROUP BY batter
ORDER BY total_runs DESC
LIMIT 10;

-- 4. TOP 10 BOWLERS BY WICKETS
SELECT
    bowler,
    COUNT(*) AS total_wickets,
    COUNT(DISTINCT match_id) AS matches_played,
    ROUND(COUNT(*) / COUNT(DISTINCT match_id), 2) AS wickets_per_match
FROM deliveries
WHERE is_wicket = 1
  AND dismissal_kind NOT IN ('run out', 'retired hurt', 'obstructing the field')
GROUP BY bowler
ORDER BY total_wickets DESC
LIMIT 10;

-- 5. TOSS IMPACT ANALYSIS
SELECT
    toss_decision,
    COUNT(*) AS total_matches,
    SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END) AS won_after_toss,
    ROUND(
        SUM(CASE WHEN toss_winner = winner THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS win_percentage
FROM matches
WHERE winner IS NOT NULL
GROUP BY toss_decision;

-- 6. SEASON WISE TRENDS
SELECT
    m.season,
    COUNT(DISTINCT m.id) AS total_matches,
    SUM(d.total_runs) AS total_runs,
    ROUND(SUM(d.total_runs) / COUNT(DISTINCT m.id), 2) AS avg_runs_per_match
FROM matches m
JOIN deliveries d ON m.id = d.match_id
GROUP BY m.season
ORDER BY m.season;

-- 7. PLAYER OF THE MATCH AWARDS
SELECT
    player_of_match,
    COUNT(*) AS awards
FROM matches
WHERE player_of_match IS NOT NULL
GROUP BY player_of_match
ORDER BY awards DESC
LIMIT 10;

-- 8. BEST VENUES BY AVERAGE SCORE
SELECT
    m.venue,
    COUNT(DISTINCT m.id) AS matches_played,
    ROUND(SUM(d.total_runs) / COUNT(DISTINCT m.id), 2) AS avg_total_runs
FROM matches m
JOIN deliveries d ON m.id = d.match_id
GROUP BY m.venue
ORDER BY avg_total_runs DESC
LIMIT 10;

-- 9. WIN MARGIN BY TEAM
SELECT
    winner AS team,
    COUNT(*) AS total_wins,
    ROUND(AVG(result_margin), 2) AS avg_win_margin
FROM matches
WHERE winner IS NOT NULL
  AND result_margin IS NOT NULL
GROUP BY winner
ORDER BY total_wins DESC
LIMIT 10;

-- 10. MOST SIXES
SELECT
    batter,
    COUNT(*) AS total_sixes
FROM deliveries
WHERE batsman_runs = 6
GROUP BY batter
ORDER BY total_sixes DESC
LIMIT 10;

-- 11. MOST FOURS
SELECT
    batter,
    COUNT(*) AS total_fours
FROM deliveries
WHERE batsman_runs = 4
GROUP BY batter
ORDER BY total_fours DESC
LIMIT 10;

-- 12. BEST ECONOMY BOWLERS (min 20 matches)
SELECT
    bowler,
    COUNT(DISTINCT match_id) AS matches,
    SUM(total_runs) AS runs_given,
    ROUND(SUM(total_runs) / (COUNT(*) / 6.0), 2) AS economy
FROM deliveries
GROUP BY bowler
HAVING COUNT(DISTINCT match_id) >= 20
ORDER BY economy ASC
LIMIT 10;