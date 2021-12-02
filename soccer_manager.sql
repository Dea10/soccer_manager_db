DROP DATABASE IF EXISTS soccer_manager;
CREATE DATABASE IF NOT EXISTS soccer_manager;
USE soccer_manager;

-- User
CREATE TABLE IF NOT EXISTS user (
    id_user INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    user_email VARCHAR(255) NOT NULL,
    user_password VARCHAR (255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL
);

-- Admin
CREATE TABLE IF NOT EXISTS admin (
    id_admin INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    FOREIGN KEY (id_user) REFERENCES user(id_user)
);

-- Phone
CREATE TABLE IF NOT EXISTS phone (
    id_phone INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    phone VARCHAR(255),
    FOREIGN KEY (id_user) REFERENCES user(id_user)
);

-- League owner
CREATE TABLE IF NOT EXISTS league_owner (
    id_league_owner INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    FOREIGN KEY (id_user) REFERENCES user(id_user)
);

-- League status catalog
CREATE TABLE IF NOT EXISTS league_status_cat (
    id_league_status INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    league_status_desc VARCHAR(255) NOT NULL
);

-- League
CREATE TABLE IF NOT EXISTS league (
    id_league INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_league_owner INT NOT NULL,
    id_league_status INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL,
    FOREIGN KEY (id_league_owner) REFERENCES league_owner(id_league_owner),
    FOREIGN KEY (id_league_status) REFERENCES league_status_cat(id_league_status)
);

-- Tournament type catalog
CREATE TABLE IF NOT EXISTS tournament_type_cat (
    id_tournament_type INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    tournament_type_desc VARCHAR(255) NOT NULL
); 

-- Tournament status catalog
CREATE TABLE IF NOT EXISTS tournament_status_cat (
    id_tournament_status INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    tournament_status_desc VARCHAR(255) NOT NULL
);

-- Tournament
CREATE TABLE IF NOT EXISTS tournament (
    id_tournament INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_tournament_type INT NOT NULL,
    id_tournament_status INT NOT NULL,
    id_league INT NOT NULL,
    tournament_name VARCHAR(255) NOT NULL,
    tournament_start_date DATETIME NOT NULL,
    tournament_end_date DATETIME NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL,
    FOREIGN KEY (id_tournament_type) REFERENCES tournament_type_cat(id_tournament_type),
    FOREIGN KEY (id_tournament_status) REFERENCES tournament_status_cat(id_tournament_status),
    FOREIGN KEY (id_league) REFERENCES league(id_league)
);

-- Team status catalog
CREATE TABLE IF NOT EXISTS team_status_cat (
    id_team_status INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    team_status_desc VARCHAR(255) NOT NULL
);

-- Team
CREATE TABLE IF NOT EXISTS team (
    id_team INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_tournament INT NOT NULL,
    id_team_status INT NOT NULL,
    team_name VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL,
    FOREIGN KEY (id_tournament) REFERENCES tournament(id_tournament),
    FOREIGN KEY (id_team_status) REFERENCES team_status_cat(id_team_status)
);

CREATE TABLE IF NOT EXISTS team_leader (
    id_team_leader INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_team INT NOT NULL,
    FOREIGN KEY (id_user) REFERENCES user(id_user),
    FOREIGN KEY (id_team) REFERENCES team(id_team)
);

-- Player status catalog
CREATE TABLE IF NOT EXISTS player_status_cat (
    id_player_status INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    player_status_desc VARCHAR(255) NOT NULL
);

-- Player type catalog
CREATE TABLE IF NOT EXISTS player_type_cat (
    id_player_type INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    player_type_desc VARCHAR(255) NOT NULL
);

-- Player
CREATE TABLE IF NOT EXISTS player (
    id_player INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_team INT NOT NULL,
    id_player_status INT NOT NULL,
    id_player_type INT NOT NULL,
    is_captain BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (id_user) REFERENCES user(id_user),
    FOREIGN KEY (id_team) REFERENCES team(id_team),
    FOREIGN KEY (id_player_status) REFERENCES player_status_cat(id_player_status),
    FOREIGN KEY (id_player_type) REFERENCES player_type_cat(id_player_type)
);

-- Game type catalog
CREATE TABLE IF NOT EXISTS game_type_cat (
    id_game_type INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    game_type_desc VARCHAR(255) NOT NULL
);

-- Game status catalog
CREATE TABLE IF NOT EXISTS game_status_cat (
    id_game_status INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    game_status_desc VARCHAR(255) NOT NULL
);

-- Game place
CREATE TABLE IF NOT EXISTS game_place (
    id_game_place INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    game_place_name VARCHAR(255) NOT NULL
);

-- Game
CREATE TABLE IF NOT EXISTS game (
    id_game INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_game_type INT NOT NULL,
    id_game_status INT NOT NULL,
    id_game_place INT NOT NULL,
    id_local_team INT NOT NULL,
    id_visitor_team INT NOT NULL,
    id_tournament INT NOT NULL,
    local_goals INT NOT NULL DEFAULT 0,
    visitor_goals INT NOT NULL DEFAULT 0,
    FOREIGN KEY (id_game_type) REFERENCES game_type_cat(id_game_type),
    FOREIGN KEY (id_game_status) REFERENCES game_status_cat(id_game_status),
    FOREIGN KEY (id_game_place) REFERENCES game_place(id_game_place),
    FOREIGN KEY (id_local_team) REFERENCES team(id_team),
    FOREIGN KEY (id_visitor_team) REFERENCES team(id_team),
    FOREIGN KEY (id_tournament) REFERENCES tournament(id_tournament)
);

-- Game event type catalog
CREATE TABLE IF NOT EXISTS game_event_type_cat (
    id_game_event_type INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    game_event_type_desc VARCHAR(255) NOT NULL
);

-- Game event
CREATE TABLE IF NOT EXISTS game_event (
    id_game_event INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_game INT NOT NULL,
    id_player INT NOT NULL,
    id_game_event_type INT NOT NULL,
    game_event_minute INT NOT NULL,
    FOREIGN KEY (id_game) REFERENCES game(id_game),
    FOREIGN KEY (id_player) REFERENCES player(id_player),
    FOREIGN KEY (id_game_event_type) REFERENCES game_event_type_cat(id_game_event_type)
);

-- Referee
CREATE TABLE IF NOT EXISTS referee (
    id_referee INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_user INT NOT NULL,
    id_game INT NOT NULL,
    FOREIGN KEY (id_user) REFERENCES user(id_user),
    FOREIGN KEY (id_game) REFERENCES game(id_game)
);

-- Log type catalog
CREATE TABLE IF NOT EXISTS log_type_cat (
    id_log_type INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    log_type_desc VARCHAR(255) NOT NULL
);

-- Log
CREATE TABLE IF NOT EXISTS log (
    id_log INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_log_type INT NOT NULL,
    id_tournament INT NOT NULL,
    FOREIGN KEY (id_log_type) REFERENCES log_type_cat(id_log_type),
    FOREIGN key (id_tournament) REFERENCES tournament(id_tournament)
);
