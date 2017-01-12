cd ../home/Code/nba-dfs-stats/
export PYTHONWARNINGS="ignore"
mysql -h -uroot -p nbastats< "team_stats_agg.sql"
mysql -h -uroot -p nbastats< "team_stats_agg5.sql"
python updatelineups.py
mysql -h -uroot -p nbastats< "today_training_data.sql"
mysql -h -uroot -p nbastats< "today_training_data_teams.sql"
python test_model.py
mysql -h -uroot -p nbastats< "projections.sql"
python dkteststrategies.py

