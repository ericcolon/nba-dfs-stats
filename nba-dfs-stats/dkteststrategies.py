from pandas import * 
import time
import pandasql
import numpy as np
import MySQLdb as mdb
import sys
import string
import pdb
import datetime
from os import listdir
from DKLineupOptimizer import LineupOptimizer

DB_HOST = 'XXX.XX.XX.XX'
DB_PORT = XXXX
DB_USER = 'xxxx'
DB_PWD = 'XXXX'
DB_NAME = 'xxxxxx'
STRATEGY_DIR = 'dkstrategies' 

Strategy_MAP = {'ShooterStrike' : '5101',
                'BoardControl' : '5102',
                'SuperStack' : '5103',
                'Model_One': '5104',
                'Last_Game': '5105',
                'Roto_Winner': '5106'}

def update_database(con, input_dataframe, table, drop=True, index=False):
    try:
        cur = con.cursor()
        if drop:
            drop_query = 'DROP TABLE IF EXISTS ' + table
            cur.execute(drop_query) 
            con.commit()
            if not index:
                input_dataframe.insert(0, 'ID', input_dataframe.index.tolist())
        input_dataframe.to_sql(table, con, 'mysql', if_exists='append', index=False)

    except mdb.Error, e:
        print "Error %d: %s" % (e.args[0], e.args[1])

def get_index(con, query):
    try:
        cur = con.cursor()
        cur.execute(query) 

    except mdb.Error, e:
        print "Error %d: %s" % (e.args[0], e.args[1])


def main():
    con = mdb.connect(host=DB_HOST,
                      port=DB_PORT,
                      user=DB_USER,
                      passwd=DB_PWD,
                      db=DB_NAME)

    ts = time.time()
    time_stamp = datetime.datetime.fromtimestamp(ts).strftime('%H:%M')

    cur = con.cursor()
    cur.execute('(SELECT PlayerID, TeamName FROM Players)')
    teams = cur.fetchall()
    team_dict = dict(teams)

    cur = con.cursor()
    cur.execute('(SELECT PlayerID, PlayerName FROM Players)')
    players = cur.fetchall()
    players_dict = dict(players)
    
    cur.execute('SELECT PlayerID, Salary FROM Salaries WHERE System="Draftkings" AND Date=DATE(NOW())')
    dollars = cur.fetchall()
    dollars_dict = dict(dollars)

    cur.execute('SELECT CAST(PlayerID AS UNSIGNED), CAST(ROUND(BaseProj,1) AS UNSIGNED) AS Points FROM Projections')
    points = cur.fetchall()
    points_dict = dict(points)

    cur.execute('(SELECT p.PlayerID, s.GameID FROM Players p INNER JOIN Schedule s ON p.TeamID=s.HomeTeamID WHERE Date=DATE(NOW())) UNION (SELECT p.PlayerID, s.GameID FROM Players p INNER JOIN Schedule s ON p.TeamID=s.AwayTeamID WHERE Date=DATE(NOW()))')
    games = cur.fetchall()
    games_dict = dict(games)

    for strategy in listdir(STRATEGY_DIR):
        name = strategy.split('.')[0]
        print "TESTING " + name
        query = open(STRATEGY_DIR + '/' + strategy, 'r').read()

        try:
            cur = con.cursor()
            cur.execute(query)
            results = cur.fetchall()
            results = list(results)
            results_df = DataFrame(results, columns = ['Position',
                                                       'PlayerID',
                                                       'Points',
                                                       'Dollars'])

            results_df['Points'] = results_df['Points'].astype(float)
            results_df['Dollars'] = results_df['Dollars'].astype(int)

            cur.execute('SELECT Date FROM Schedule')
            sunday = cur.fetchall()
            date = str(sunday[0]).split('(')[1].split(',')[0].replace("'", "")

            CURR_DATE = datetime.datetime.now() 
            optimizer = LineupOptimizer(results_df, 
                                        CURR_DATE.year, 
                                        CURR_DATE.month, 
                                        CURR_DATE.day)
            lineup = optimizer.calc_lineup()
            lineup['Strategy'] = name 
            lineup['Date'] = date

            name_map = lambda id: players_dict[id]
            dollars_map = lambda dollars: dollars_dict[(dollars)]
            points_map = lambda points: points_dict[points]
            games_map = lambda games: games_dict[games]
            team_map = lambda team: team_dict[team]
            strategy_map = lambda strategy: Strategy_MAP[strategy]
            date_map = lambda date: str(date.split("-")[1])+str(date.split("-")[2])

            lineup['Name_PG'] = lineup['Player_ID_PG'].map(name_map)
            lineup['Name_SG'] = lineup['Player_ID_SG'].map(name_map)
            lineup['Name_SF'] = lineup['Player_ID_SF'].map(name_map)
            lineup['Name_PF'] = lineup['Player_ID_PF'].map(name_map)
            lineup['Name_C'] = lineup['Player_ID_C'].map(name_map)
            lineup['Name_G'] = lineup['Player_ID_G'].map(name_map)
            lineup['Name_F'] = lineup['Player_ID_F'].map(name_map)
            lineup['Name_UTIL'] = lineup['Player_ID_UTIL'].map(name_map)
            lineup['Points'] = None
            lineup.drop('Year', 1)
            lineup.drop('Day', 1)
            lineup.drop('Month', 1)
            lineup['Dollars_PG']=lineup['Player_ID_PG'].map(dollars_map)
            lineup['Dollars_SG']=lineup['Player_ID_SG'].map(dollars_map)
            lineup['Dollars_SF']=lineup['Player_ID_SF'].map(dollars_map)
            lineup['Dollars_PF']=lineup['Player_ID_PF'].map(dollars_map)
            lineup['Dollars_C']=lineup['Player_ID_C'].map(dollars_map)
            lineup['Dollars_G']=lineup['Player_ID_G'].map(dollars_map)
            lineup['Dollars_F']=lineup['Player_ID_F'].map(dollars_map)
            lineup['Dollars_UTIL']=lineup['Player_ID_UTIL'].map(dollars_map)
            lineup['Points_PG']=lineup['Player_ID_PG'].map(points_map)
            lineup['Points_SG']=lineup['Player_ID_SG'].map(points_map)
            lineup['Points_SF']=lineup['Player_ID_SF'].map(points_map)
            lineup['Points_PF']=lineup['Player_ID_PF'].map(points_map)
            lineup['Points_C']=lineup['Player_ID_C'].map(points_map)
            lineup['Points_G']=lineup['Player_ID_G'].map(points_map)
            lineup['Points_F']=lineup['Player_ID_F'].map(points_map)
            lineup['Points_UTIL']=lineup['Player_ID_UTIL'].map(points_map)
            lineup['System'] = 'Draftkings'
            lineup['Win_Percentage'] = None        
            lineup['Lineup_ID'] = lineup['Strategy'].map(strategy_map) + lineup['Date'].map(date_map)
            lineup['Games_PG']=lineup['Player_ID_PG'].map(games_map)
            lineup['Games_SG']=lineup['Player_ID_SG'].map(games_map)
            lineup['Games_SF']=lineup['Player_ID_SF'].map(games_map)
            lineup['Games_PF']=lineup['Player_ID_PF'].map(games_map)
            lineup['Games_C']=lineup['Player_ID_C'].map(games_map)
            lineup['Games_G']=lineup['Player_ID_G'].map(games_map)
            lineup['Games_F']=lineup['Player_ID_F'].map(games_map)
            lineup['Games_UTIL']=lineup['Player_ID_UTIL'].map(games_map)
            lineup['Team_PG']=lineup['Player_ID_PG'].map(team_map)
            lineup['Team_SG']=lineup['Player_ID_SG'].map(team_map)
            lineup['Team_SF']=lineup['Player_ID_SF'].map(team_map)
            lineup['Team_PF']=lineup['Player_ID_PF'].map(team_map)
            lineup['Team_G']=lineup['Player_ID_G'].map(team_map)
            lineup['Team_F']=lineup['Player_ID_F'].map(team_map)
            lineup['Team_C']=lineup['Player_ID_C'].map(team_map)
            lineup['Team_UTIL']=lineup['Player_ID_UTIL'].map(team_map)
            lineup['Time_Stamp'] = time_stamp
            cur.execute("""Select Player_ID_PG, Player_ID_SG, Player_ID_SF, Player_ID_PF, Player_ID_C, Player_ID_G, Player_ID_F, Player_ID_UTIL From DKLineups WHERE Date=DATE(NOW()) AND Strategy = '%s'""" % (name))
            existing = cur.fetchall()
            mapping = {0:'PG',1:'SG',2:'SF',3:'PF',4:'C',5:'G',6:'F',7:'UTIL'}
            if len(existing)==0:
                update_database(con, lineup, 'DKLineups', drop=False, index=True)
            else:
                for i in range(0, 8):
                    if str(lineup['Player_ID_' + mapping[i]]).split('\n')[0].split('    ')[1] == str(existing[0][i]):
                        continue
                    else:
                        cur.execute("""DELETE From DKLineups WHERE Date=DATE(NOW()) AND Strategy = '%s'""" % (name))
                        con.commit
                        update_database(con, lineup, 'DKLineups', drop=False, index=True)
                        break

        except:
            print "No Games Played Yesterday"
    

    con.close()


if __name__ == "__main__":
    main()
