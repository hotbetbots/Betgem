-- =====================================
-- DROP EXISTING TABLES
-- =====================================
DROP TABLE IF EXISTS group_winners;
DROP TABLE IF EXISTS human_gut_index;
DROP TABLE IF EXISTS academic_models;
DROP TABLE IF EXISTS odds_movements;
DROP TABLE IF EXISTS computaform_data;
DROP TABLE IF EXISTS sectionals;
DROP TABLE IF EXISTS race_entries;
DROP TABLE IF EXISTS races;
DROP TABLE IF EXISTS breeding_analysis;
DROP TABLE IF EXISTS merit_ratings;
DROP TABLE IF EXISTS horse_form_index;
DROP TABLE IF EXISTS jockey_trainer_combos;
DROP TABLE IF EXISTS trainer_stallion_preferences;
DROP TABLE IF EXISTS horse_form_seasonal;
DROP TABLE IF EXISTS horses;
DROP TABLE IF EXISTS jockeys;
DROP TABLE IF EXISTS trainers;
DROP TABLE IF EXISTS broodmares;
DROP TABLE IF EXISTS stallions;
DROP TABLE IF EXISTS owners;
DROP TABLE IF EXISTS breeders;
DROP TABLE IF EXISTS racecourses;
DROP TABLE IF EXISTS countries;


CREATE TABLE racecourses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    country_id INT,
    track_type ENUM('Turf', 'Dirt', 'All Weather', 'Synthetic') DEFAULT 'Turf',
    surface VARCHAR(50),
    left_handed BOOLEAN DEFAULT TRUE,
    distance_configs TEXT, -- JSON string of available distances
    going_bias TEXT,
    draw_bias TEXT,
    1000m_record_time TIME,
    1200m_record_time TIME,
    1400m_record_time TIME,
    1600m_record_time TIME,
    2000m_record_time TIME,
    course_record_holder VARCHAR(255),
    elevation INT,
    climate VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CREATE TABLE breeders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    country_id INT,
    rating ENUM('Elite', 'Excellent', 'Good', 'Average', 'Below Average', 'Useless') DEFAULT 'Average',
    lifetime_runners INT DEFAULT 0,
    lifetime_winners INT DEFAULT 0,
    lifetime_win_percentage DECIMAL(5,2) AS (
        CASE WHEN lifetime_runners > 0 THEN (lifetime_winners / lifetime_runners) * 100 ELSE 0 END
    ) STORED,
    annual_runners INT DEFAULT 0,
    annual_winners INT DEFAULT 0,
    annual_win_percentage DECIMAL(5,2) AS (
        CASE WHEN annual_runners > 0 THEN (annual_winners / annual_runners) * 100 ELSE 0 END
    ) STORED,
    seasonal_runners INT DEFAULT 0,
    seasonal_winners INT DEFAULT 0,
    seasonal_win_percentage DECIMAL(5,2) AS (
        CASE WHEN seasonal_runners > 0 THEN (seasonal_winners / seasonal_runners) * 100 ELSE 0 END
    ) STORED,
    g1_winners INT DEFAULT 0,
    g2_winners INT DEFAULT 0,
    g3_winners INT DEFAULT 0,
    stakes_winners INT DEFAULT 0,
    top_breeder_by_stakes BOOLEAN DEFAULT FALSE,
    top_breeder_by_sales BOOLEAN DEFAULT FALSE,
    last_winner_date DATE,
    days_since_last_winner INT AS (DATEDIFF(CURDATE(), last_winner_date)) STORED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    
CREATE TABLE owners (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    country_id INT,
    rating ENUM('Elite', 'Excellent', 'Good', 'Average', 'Below Average', 'Useless') DEFAULT 'Average',
    investment_level ENUM('Elite', 'High', 'Medium', 'Low') DEFAULT 'Medium',
    lifetime_runners INT DEFAULT 0,
    lifetime_winners INT DEFAULT 0,
    lifetime_win_percentage DECIMAL(5,2) AS (
        CASE WHEN lifetime_runners > 0 THEN (lifetime_winners / lifetime_runners) * 100 ELSE 0 END
    ) STORED,
    annual_runners INT DEFAULT 0,
    annual_winners INT DEFAULT 0,
    annual_win_percentage DECIMAL(5,2) AS (
        CASE WHEN annual_runners > 0 THEN (annual_winners / annual_runners) * 100 ELSE 0 END
    ) STORED,
    seasonal_runners INT DEFAULT 0,
    seasonal_winners INT DEFAULT 0,
    seasonal_win_percentage DECIMAL(5,2) AS (
        CASE WHEN seasonal_runners > 0 THEN (seasonal_winners / seasonal_runners) * 100 ELSE 0 END
    ) STORED,
    g1_wins INT DEFAULT 0,
    g2_wins INT DEFAULT 0,
    g3_wins INT DEFAULT 0,
    stakes_wins INT DEFAULT 0,
    total_prize_money BIGINT DEFAULT 0,
    total_spending BIGINT DEFAULT 0,
    top_owner_by_stakes BOOLEAN DEFAULT FALSE,
    top_owner_by_spending BOOLEAN DEFAULT FALSE,
    is_breeder BOOLEAN DEFAULT FALSE,
    is_partnership BOOLEAN DEFAULT FALSE,
    last_winner_date DATE,
    days_since_last_winner INT AS (DATEDIFF(CURDATE(), last_winner_date)) STORED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Stallions
CREATE TABLE stallions (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    country_birth INT,
    rating ENUM('Elite', 'Excellent', 'Good', 'Average', 'Below Average', 'Useless') DEFAULT 'Average',
    racing_wins INT DEFAULT 0,
    racing_runs INT DEFAULT 0,
    racing_earnings BIGINT DEFAULT 0,
    progeny_runners INT DEFAULT 0,
    progeny_winners INT DEFAULT 0,
    progeny_win_percentage DECIMAL(5,2) AS (
        CASE WHEN progeny_runners > 0 THEN (progeny_winners / progeny_runners) * 100 ELSE 0 END
    ) STORED,
    distance_performance JSON, -- {sprint: rating, mile: rating, distance: rating}
    surface_performance JSON, -- {turf: rating, dirt: rating, aw: rating}
    stud_fee INT,
    ranking INT,
    g1_winners INT DEFAULT 0,
    g2_winners INT DEFAULT 0,
    g3_winners INT DEFAULT 0,
    stakes_winners INT DEFAULT 0,
    notable_offspring TEXT,
    last_winner_date DATE,
    days_since_last_winner INT AS (DATEDIFF(CURDATE(), last_winner_date)) STORED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (country_birth) REFERENCES countries(id)
);

-- Broodmares
CREATE TABLE broodmares
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    country_birth INT,
    racing_wins INT DEFAULT 0,
    racing_runs INT DEFAULT 0,
    racing_earnings BIGINT DEFAULT 0,
    progeny_runners INT DEFAULT 0,
    progeny_winners INT DEFAULT 0,
    g1_winners INT DEFAULT 0,
    g2_winners INT DEFAULT 0,
    g3_winners INT DEFAULT 0,
    stakes_winners INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (country_birth) REFERENCES countries(id)
);

-- Trainers
CREATE TABLE trainers (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    surname_only VARCHAR(100), -- For matching when trainer name changes
    country_id INT,
    rating ENUM('Elite', 'Excellent', 'Good', 'Average', 'Below Average', 'Useless') DEFAULT 'Average',
    is_private BOOLEAN DEFAULT FALSE,
    lifetime_runners INT DEFAULT 0,
    lifetime_winners INT DEFAULT 0,
    lifetime_win_percentage DECIMAL(5,2) AS (
        CASE WHEN lifetime_runners > 0 THEN (lifetime_winners / lifetime_runners) * 100 ELSE 0 END
    ) STORED,
    annual_runners INT DEFAULT 0,
    annual_winners INT DEFAULT 0,
    annual_win_percentage DECIMAL(5,2) AS (
        CASE WHEN annual_runners > 0 THEN (annual_winners / annual_runners) * 100 ELSE 0 END
    ) STORED,
    seasonal_runners INT DEFAULT 0,
    seasonal_winners INT DEFAULT 0,
    seasonal_win_percentage DECIMAL(5,2) AS (
        CASE WHEN seasonal_runners > 0 THEN (seasonal_winners / seasonal_runners) * 100 ELSE 0 END
    ) STORED,
    g1_wins INT DEFAULT 0,
    g2_wins INT DEFAULT 0,
    g3_wins INT DEFAULT 0,
    stakes_wins INT DEFAULT 0,
    total_prize_money BIGINT DEFAULT 0,
    last_winner_date DATE,
    days_since_last_winner INT AS (DATEDIFF(CURDATE(), last_winner_date)) STORED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES countries(id)
);

-- Jockeys
CREATE TABLE jockeys (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    country_id INT,
    rating ENUM('Elite', 'Excellent', 'Good', 'Average', 'Below Average', 'Useless') DEFAULT 'Average',
    lifetime_runners INT DEFAULT 0,
    lifetime_winners INT DEFAULT 0,
    lifetime_win_percentage DECIMAL(5,2) AS (
        CASE WHEN lifetime_runners > 0 THEN (lifetime_winners / lifetime_runners) * 100 ELSE 0 END
    ) STORED,
    annual_runners INT DEFAULT 0,
    annual_winners INT DEFAULT 0,
    annual_win_percentage DECIMAL(5,2) AS (
        CASE WHEN annual_runners > 0 THEN (annual_winners / annual_runners) * 100 ELSE 0 END
    ) STORED,
    seasonal_runners INT DEFAULT 0,
    seasonal_winners INT DEFAULT 0,
    seasonal_win_percentage DECIMAL(5,2) AS (
        CASE WHEN seasonal_runners > 0 THEN (seasonal_winners / seasonal_runners) * 100 ELSE 0 END
    ) STORED,
    -- Position distribution analysis
    lifetime_seconds INT DEFAULT 0,
    lifetime_thirds INT DEFAULT 0,
    lifetime_fourths INT DEFAULT 0,
    lifetime_fifths INT DEFAULT 0,
    lifetime_lasts INT DEFAULT 0,
    lifetime_second_lasts INT DEFAULT 0,
    top_3_percentage DECIMAL(5,2) AS (
        CASE WHEN lifetime_runners > 0 THEN ((lifetime_winners + lifetime_seconds + lifetime_thirds) / lifetime_runners) * 100 ELSE 0 END
    ) STORED,
    top_4_percentage DECIMAL(5,2) AS (
        CASE WHEN lifetime_runners > 0 THEN ((lifetime_winners + lifetime_seconds + lifetime_thirds + lifetime_fourths) / lifetime_runners) * 100 ELSE 0 END
    ) STORED,
    g1_wins INT DEFAULT 0,
    g2_wins INT DEFAULT 0,
    g3_wins INT DEFAULT 0,
    stakes_wins INT DEFAULT 0,
    total_prize_money BIGINT DEFAULT 0,
    last_winner_date DATE,
    days_since_last_winner INT AS (DATEDIFF(CURDATE(), last_winner_date)) STORED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (country_id) REFERENCES countries(id)
);

-- Horses
CREATE TABLE horses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    date_of_birth DATE,
    sire_id INT,
    dam_id INT,
    owner_id INT,
    trainer_id INT,
    breeder_id INT,
    country_birth INT,
    sex ENUM('Colt', 'Filly', 'Gelding', 'Horse', 'Mare') DEFAULT 'Colt',
    color VARCHAR(50),
    last_race_date DATE,
    last_win_date DATE,
    days_since_last_win INT AS (DATEDIFF(CURDATE(), last_win_date)) STORED,
    days_since_last_race INT AS (DATEDIFF(CURDATE(), last_race_date)) STORED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (sire_id) REFERENCES stallions(id),
    FOREIGN KEY (dam_id) REFERENCES broodmares(id),
    FOREIGN KEY (owner_id) REFERENCES owners(id),
    FOREIGN KEY (trainer_id) REFERENCES trainers(id),
    FOREIGN KEY (breeder_id) REFERENCES breeders(id),
    FOREIGN KEY (country_birth) REFERENCES countries(id)
);

-- =====================================
-- PERFORMANCE TRACKING TABLES
-- =====================================

-- Horse Form Seasonal (Based on your existing structure)
CREATE TABLE horse_form_seasonal (
    id INT PRIMARY KEY AUTO_INCREMENT,
    horse_id INT NOT NULL,
    season VARCHAR(10) NOT NULL,
    runs INT DEFAULT 0,
    wins INT DEFAULT 0,
    win_percentage DECIMAL(5,2) AS (
        CASE WHEN runs > 0 THEN (wins / runs) * 100 ELSE 0 END
    ) STORED,
    seconds INT DEFAULT 0,
    thirds INT DEFAULT 0,
    fourths INT DEFAULT 0,
    fifths INT DEFAULT 0,
    other INT DEFAULT 0,
    places INT DEFAULT 0,
    place_percentage DECIMAL(5,2) AS (
        CASE WHEN runs > 0 THEN (places / runs) * 100 ELSE 0 END
    ) STORED,
    win_stake BIGINT DEFAULT 0,
    total_stake BIGINT DEFAULT 0,
    last_race_date DATE,
    last_win_date DATE,
    group_1 INT DEFAULT 0,
    group_2 INT DEFAULT 0,
    group_3 INT DEFAULT 0,
    feature_race INT DEFAULT 0,
    listed_wins INT DEFAULT 0,
    UNIQUE KEY unique_horse_season (horse_id, season),
    FOREIGN KEY (horse_id) REFERENCES horses(id) ON DELETE CASCADE
);

-- Jockey Trainer Combinations
CREATE TABLE jockey_trainer_combos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    jockey_id INT NOT NULL,
    trainer_id INT NOT NULL,
    is_stable_jockey BOOLEAN DEFAULT FALSE,
    lifetime_runs INT DEFAULT 0,
    lifetime_wins INT DEFAULT 0,
    lifetime_win_percentage DECIMAL(5,2) AS (
        CASE WHEN lifetime_runs > 0 THEN (lifetime_wins / lifetime_runs) * 100 ELSE 0 END
    ) STORED,
    annual_runs INT DEFAULT 0,
    annual_wins INT DEFAULT 0,
    annual_win_percentage DECIMAL(5,2) AS (
        CASE WHEN annual_runs > 0 THEN (annual_wins / annual_runs) * 100 ELSE 0 END
    ) STORED,
    seasonal_runs INT DEFAULT 0,
    seasonal_wins INT DEFAULT 0,
    seasonal_win_percentage DECIMAL(5,2) AS (
        CASE WHEN seasonal_runs > 0 THEN (seasonal_wins / seasonal_runs) * 100 ELSE 0 END
    ) STORED,
    last_winner_date DATE,
    days_since_last_winner INT AS (DATEDIFF(CURDATE(), last_winner_date)) STORED,
    UNIQUE KEY unique_jockey_trainer (jockey_id, trainer_id),
    FOREIGN KEY (jockey_id) REFERENCES jockeys(id),
    FOREIGN KEY (trainer_id) REFERENCES trainers(id)
);

-- Trainer Stallion Preferences
CREATE TABLE trainer_stallion_preferences (
    id INT PRIMARY KEY AUTO_INCREMENT,
    trainer_id INT NOT NULL,
    stallion_id INT NOT NULL,
    horses_trained INT DEFAULT 0,
    wins_achieved INT DEFAULT 0,
    win_percentage DECIMAL(5,2) AS (
        CASE WHEN horses_trained > 0 THEN (wins_achieved / horses_trained) * 100 ELSE 0 END
    ) STORED,
    preference_score DECIMAL(5,2) DEFAULT 0.00, -- Calculated preference score
    last_horse_date DATE,
    UNIQUE KEY unique_trainer_stallion (trainer_id, stallion_id),
    FOREIGN KEY (trainer_id) REFERENCES trainers(id),
    FOREIGN KEY (stallion_id) REFERENCES stallions(id)
);

-- Horse Form Index (Form tracking with lengths behind)
CREATE TABLE horse_form_index (
    id INT PRIMARY KEY AUTO_INCREMENT,
    horse_id INT NOT NULL,
    race_date DATE NOT NULL,
    position INT,
    lengths_behind DECIMAL(4,2),
    form_string VARCHAR(100), -- e.g., "1/2.5/3/4.25/5" representing recent form
    current_form_rating INT, -- Numerical rating based on recent form
    lifetime_form_string TEXT, -- Complete lifetime form separated by year: "2023: 1/2/3/4 \ 2024: 2/1/5/3"
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (horse_id) REFERENCES horses(id) ON DELETE CASCADE,
    INDEX idx_horse_date (horse_id, race_date)
);

-- Merit Ratings
CREATE TABLE merit_ratings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    horse_id INT NOT NULL,
    race_date DATE NOT NULL,
    age_at_race INT,
    merit_rating INT NOT NULL,
    highest_merit_rating INT, -- Track if this is the horse's highest rating
    is_highest_rating BOOLEAN DEFAULT FALSE,
    rating_improvement INT DEFAULT 0, -- Change from previous rating
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (horse_id) REFERENCES horses(id) ON DELETE CASCADE,
    INDEX idx_horse_rating (horse_id, merit_rating DESC),
    INDEX idx_horse_date (horse_id, race_date)
);

-- =====================================
-- RACE RELATED TABLES
-- =====================================

-- Races
CREATE TABLE races (
    id INT PRIMARY KEY AUTO_INCREMENT,
    racecourse_id INT,
    race_date DATE NOT NULL,
    race_time TIME,
    race_name VARCHAR(255) NOT NULL,
    race_class ENUM('Group 1', 'Group 2', 'Group 3', 'Listed', 'Handicap', 'Maiden', 'Claiming', 'Feature') DEFAULT 'Maiden',
    distance INT, -- in meters
    surface ENUM('Turf', 'Dirt', 'All Weather', 'Synthetic') DEFAULT 'Turf',
    going VARCHAR(50),
    total_prize_money BIGINT DEFAULT 0,
    winner_prize_money BIGINT DEFAULT 0,
    field_size INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (racecourse_id) REFERENCES racecourses(id)
);

-- Race Entries
CREATE TABLE race_entries (
    id INT PRIMARY KEY AUTO_INCREMENT,
    race_id INT NOT NULL,
    horse_id INT NOT NULL,
    jockey_id INT,
    trainer_id INT,
    barrier_draw INT,
    weight_carried DECIMAL(4,1),
    starting_odds_fixed DECIMAL(8,2),
    starting_odds_tote DECIMAL(8,2),
    final_odds_fixed DECIMAL(8,2),
    final_odds_tote DECIMAL(8,2),
    finishing_position INT,
    lengths_behind DECIMAL(4,2),
    margin_to_next DECIMAL(4,2),
    time_recorded TIME,
    sectional_times JSON, -- Store sectional times as JSON
    prize_money_won BIGINT DEFAULT 0,
    beaten_favourite BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (race_id) REFERENCES races(id),
    FOREIGN KEY (horse_id) REFERENCES horses(id),
    FOREIGN KEY (jockey_id) REFERENCES jockeys(id),
    FOREIGN KEY (trainer_id) REFERENCES trainers(id)
);

-- Odds Movements
CREATE TABLE odds_movements (
    id INT PRIMARY KEY AUTO_INCREMENT,
    race_entry_id INT NOT NULL,
    odds_type ENUM('Fixed', 'Tote') NOT NULL,
    odds_value DECIMAL(8,2) NOT NULL,
    timestamp TIMESTAMP NOT NULL,
    volume_matched BIGINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (race_entry_id) REFERENCES race_entries(id) ON DELETE CASCADE,
    INDEX idx_entry_time (race_entry_id, timestamp)
);

-- =====================================
-- INDEXES FOR PERFORMANCE
-- =====================================

-- Performance indexes
CREATE INDEX idx_horses_trainer ON horses(trainer_id);
CREATE INDEX idx_horses_owner ON horses(owner_id);
CREATE INDEX idx_horses_sire ON horses(sire_id);
CREATE INDEX idx_horses_last_race ON horses(last_race_date);
CREATE INDEX idx_horses_last_win ON horses(last_win_date);

CREATE INDEX idx_trainers_rating ON trainers(rating);
CREATE INDEX idx_trainers_win_pct ON trainers(lifetime_win_percentage);
CREATE INDEX idx_jockeys_rating ON jockeys(rating);
CREATE INDEX idx_jockeys_win_pct ON jockeys(lifetime_win_percentage);

CREATE INDEX idx_race_entries_race ON race_entries(race_id);
CREATE INDEX idx_race_entries_horse ON race_entries(horse_id);
CREATE INDEX idx_race_entries_position ON race_entries(finishing_position);

-- =====================================
-- SAMPLE DATA INSERTS
-- =====================================

-- Insert sample countries
INSERT INTO countries (code, name) VALUES 
('RSA', 'South Africa'),
('USA', 'United States'),
('GBR', 'Great Britain'),
('AUS', 'Australia'),
('JPN', 'Japan');

-- Sample rating calculation view for easy reference
CREATE VIEW trainer_performance_summary AS
SELECT 
    t.id,
    t.name,
    t.rating,
    t.lifetime_win_percentage,
    CASE 
        WHEN t.lifetime_win_percentage >= 20 THEN 'GOAT'
        WHEN t.lifetime_win_percentage >= 19 THEN 'Elite'
        WHEN t.lifetime_win_percentage >= 17 THEN 'Elite'
        WHEN t.lifetime_win_percentage >= 15 THEN 'Excellent'
        WHEN t.lifetime_win_percentage >= 12 THEN 'Good'
        WHEN t.lifetime_win_percentage >= 10 THEN 'Average'
        ELSE 'Below Average'
    END as performance_category,
    t.days_since_last_winner,
    t.total_prize_money
FROM trainers t;

-- Rating scale comments:
-- 10% = Average
-- 11-12% = Above Average  
-- 12-14.9% = Good
-- 15% = Excellent
-- 16-19% = Elite
-- 20%+ = GOAT