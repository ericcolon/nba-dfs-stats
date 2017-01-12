from pandas import * 
import pandasql
import numpy as np
import MySQLdb as mdb
import sys
import string
import pdb
import datetime

DB_HOST = 'XXX.XXX.XX.XX'
DB_PORT = XXXX
DB_USER = 'xxxx'
DB_PWD = 'xxxxx'
DB_NAME = 'xxxxx'
DOLLAR_LIMIT = 50000 
YEAR = datetime.datetime.now().year
MONTH = datetime.datetime.now().month
DAY = datetime.datetime.now().day

class LineupOptimizer(object):
    def __init__(self,
                 input_data, 
                 year=YEAR, 
                 month=MONTH, 
                 day=DAY, 
                 dollars=DOLLAR_LIMIT,
                 strategy=None):
  
        self.data = input_data
        self.year = year
        self.month = month
        self.day = day
        self.dollars = dollars
        self.strategy = None

    def _prune_list(self, combined_df):
        combined_df = combined_df.dropna()
        combined_df.sort(['Points', 'Dollars'], 
                         ascending=[False, True],
                         inplace = True)

        combined_df['Duplicates'] = combined_df['Points'].shift()
        msk = combined_df['Points'] != combined_df['Duplicates']
        combined_df = combined_df.loc[msk]
        combined_df.drop(['Duplicates'], inplace=True, axis=1)

        combined_df.sort(['Dollars', 'Points'], 
                         ascending=[True, False],
                         inplace = True)

        combined_df['Duplicates'] = combined_df['Dollars'].shift()
        msk = combined_df['Dollars'] != combined_df['Duplicates']
        combined_df = combined_df.loc[msk]
        combined_df.drop(['Duplicates'], inplace=True, axis=1)

        combined_df.sort('Points', ascending=False, inplace=True)

        return combined_df

    def calc_lineup(self):
        points = self.data
        day = self.day
        month = self.month
        year = self.year

        con = mdb.connect(host=DB_HOST,
                          port=DB_PORT,
                          user=DB_USER,
                          passwd=DB_PWD,
                          db=DB_NAME)

        cur = con.cursor()
        cur.execute('(SELECT PlayerID, TeamName FROM Players)')
        players = cur.fetchall()
        players_dict = dict(players)

        all_dfs = [self.filter_and_rename(points, 'PG', 'PG')]
        all_dfs.append(self.filter_and_rename(points, 'SG', 'SG'))
        all_dfs.append(self.filter_and_rename(points, 'SF', 'SF'))
        all_dfs.append(self.filter_and_rename(points, 'PF', 'PF'))
        all_dfs.append(self.filter_and_rename(points, 'C', 'C'))
        all_dfs.append(self.filter_and_rename(points, 'G', 'G')) 
        all_dfs.append(self.filter_and_rename(points, 'F', 'F'))
        all_dfs.append(self.filter_and_rename(points, 'UTIL', 'UTIL'))

        combined_df = all_dfs[0]

        for i in range(1, len(all_dfs)):
            combined_df = combined_df.merge(all_dfs[i])

            if i == 1:
                combined_df['Dollars'] = (combined_df['Dollars_PG'] +
                                          combined_df['Dollars_SG']) 
                combined_df['Points'] = (combined_df['Points_PG'] +
                                         combined_df['Points_SG'])

                combined_df.drop(['Position_PG',
                                  'Dollars_PG',
                                  'Points_PG',
                                  'Position_SG',
                                  'Dollars_SG',
                                  'Points_SG'], inplace=True, axis=1)
                combined_df = self._prune_list(combined_df)

            if i == 2:
                combined_df['Dollars'] = (combined_df['Dollars'] +
                                          combined_df['Dollars_SF']) 
                combined_df['Points'] = (combined_df['Points'] +
                                         combined_df['Points_SF'])


                combined_df.drop(['Position_SF',
                                  'Dollars_SF',
                                  'Points_SF'], inplace=True, axis=1)
                combined_df = self._prune_list(combined_df)

            if i == 3:
                combined_df['Dollars'] = (combined_df['Dollars'] +
                                          combined_df['Dollars_PF']) 
                combined_df['Points'] = (combined_df['Points'] +
                                         combined_df['Points_PF'])

                combined_df.drop(['Position_PF',
                                  'Dollars_PF',
                                  'Points_PF'], inplace=True, axis=1)

                combined_df = self._prune_list(combined_df)

            if i == 4:
                combined_df['Dollars'] = (combined_df['Dollars'] +
                                          combined_df['Dollars_C']) 
                combined_df['Points'] = (combined_df['Points'] +
                                         combined_df['Points_C'])

                combined_df.drop(['Position_C',
                                  'Dollars_C',
                                  'Points_C'], inplace=True, axis=1)

                combined_df = self._prune_list(combined_df)

            if i == 5:
                combined_df['Dollars'] = (combined_df['Dollars'] +
                                          combined_df['Dollars_G']) 
                combined_df['Points'] = (combined_df['Points'] +
                                         combined_df['Points_G'])

                combined_df.drop(['Position_G',
                                  'Dollars_G',
                                  'Points_G'], inplace=True, axis=1)

                combined_df = combined_df[combined_df['Player_ID_PG'] != combined_df['Player_ID_G']]
                combined_df = combined_df[combined_df['Player_ID_SG'] != combined_df['Player_ID_G']]
                combined_df = self._prune_list(combined_df)

            if i == 6:
                combined_df['Dollars'] = (combined_df['Dollars'] +
                                          combined_df['Dollars_F'])
                combined_df['Points'] = (combined_df['Points'] +
                                         combined_df['Points_F'])

                combined_df.drop(['Position_F',
                                  'Dollars_F',
                                  'Points_F'], inplace=True, axis=1)

                combined_df = combined_df[combined_df['Player_ID_SF'] != combined_df['Player_ID_F']]
                combined_df = combined_df[combined_df['Player_ID_PF'] != combined_df['Player_ID_F']]

                combined_df = self._prune_list(combined_df)


            if i == 7:
                combined_df['Dollars'] = (combined_df['Dollars'] +
                                          combined_df['Dollars_UTIL']) 
                combined_df['Points'] = (combined_df['Points'] +
                                         combined_df['Points_UTIL'])

                combined_df.drop(['Position_UTIL',
                                  'Dollars_UTIL',
                                  'Points_UTIL'], inplace=True, axis=1)
                combined_df = combined_df[combined_df['Player_ID_PG'] != combined_df['Player_ID_UTIL']]
                combined_df = combined_df[combined_df['Player_ID_SG'] != combined_df['Player_ID_UTIL']]
                combined_df = combined_df[combined_df['Player_ID_SF'] != combined_df['Player_ID_UTIL']]
                combined_df = combined_df[combined_df['Player_ID_PF'] != combined_df['Player_ID_UTIL']]
                combined_df = combined_df[combined_df['Player_ID_C'] != combined_df['Player_ID_UTIL']]
                combined_df = combined_df[combined_df['Player_ID_G'] != combined_df['Player_ID_UTIL']]
                combined_df = combined_df[combined_df['Player_ID_F'] != combined_df['Player_ID_UTIL']]

                combined_df = self._prune_list(combined_df)

        # Remove Expensive and sort
        combined_df = combined_df[combined_df['Dollars'] <= self.dollars]
        combined_df = combined_df[combined_df['Dollars'] > 40000]
        combined_df.sort('Dollars', 
                         ascending= False,
                         inplace = True)


        players_map = lambda id: players_dict[int(id)]
        combined_df['Team_PG']=combined_df['Player_ID_PG'].map(players_map)
        combined_df['Team_SG']=combined_df['Player_ID_SG'].map(players_map)
        combined_df['Team_SF']=combined_df['Player_ID_SF'].map(players_map)
        combined_df['Team_PF']=combined_df['Player_ID_PF'].map(players_map)
        combined_df['Team_C']=combined_df['Player_ID_C'].map(players_map)
        combined_df['Team_G']=combined_df['Player_ID_G'].map(players_map)
        combined_df['Team_F']=combined_df['Player_ID_F'].map(players_map)
        combined_df['Team_UTIL']=combined_df['Player_ID_UTIL'].map(players_map)
        combined_df=combined_df.reset_index()
        combined_df['Unique'] = None
        for i in range(0,len(combined_df)):
            combined_df['Unique'][i:i+1]=len(np.unique(combined_df[i:i+1]))
        combined_df=combined_df[combined_df['Unique']>16]

        max_id = combined_df['Points'].idxmax()
        optimal_lineup = combined_df.loc[[max_id]]
        optimal_lineup = optimal_lineup[['Player_ID_PG',
                                         'Player_ID_SG',
                                         'Player_ID_SF',
                                         'Player_ID_PF',
                                         'Player_ID_C',
                                         'Player_ID_G',
                                         'Player_ID_F',
                                         'Player_ID_UTIL',
                                         'Dollars',
                                         'Points']]
          
        optimal_lineup['Year'] = year
        optimal_lineup['Month'] = month
        optimal_lineup['Day'] = day

        return optimal_lineup

    def filter_and_rename(self, df, position, append=None):
        if position == 'G':
            ret_df = df[df['Position'].isin(['SG','PG','G'])]
            ret_df['join_key'] = 1
            ret_df = ret_df.rename(columns={'Position': 'Position_' + append,
                                            'PlayerID': 'Player_ID_' + append,
                                            'Points': 'Points_' + append,
                                            'Dollars': 'Dollars_' + append})
        else:
            if position == 'F':
                ret_df = df[df['Position'].isin(['SF','PF','F'])]
                ret_df['join_key'] = 1
                ret_df = ret_df.rename(columns={'Position': 'Position_' + append,
                                                'PlayerID': 'Player_ID_' + append,
                                                'Points': 'Points_' + append,
                                                'Dollars': 'Dollars_' + append})

            else:
                if position == 'UTIL':
                    ret_df = df[df['Position'].isin(['SG','PG','G','SF','PF','F','C'])]
                    ret_df['join_key'] = 1
                    ret_df = ret_df.rename(columns={'Position': 'Position_' + append,
                                                    'PlayerID': 'Player_ID_' + append,
                                                    'Points': 'Points_' + append,
                                                    'Dollars': 'Dollars_' + append})
                else:
                    ret_df = df[df['Position'] == position]
                    ret_df['join_key'] = 1
                    ret_df = ret_df.rename(columns={'Position': 'Position_' + append,
                                                    'PlayerID': 'Player_ID_' + append,
                                                    'Points': 'Points_' + append,
                                                    'Dollars': 'Dollars_' + append})

        return ret_df

def main():
    FIELDS = ['Position',
              'PlayerID',
              'Points',
              'Dollars']

    data = [('C', 'Center1', 50, 1000),
            ('C', 'Center2', 25, 2000),
            ('PF', 'PowerForward1', 50, 1000),
            ('PF', 'PowerForward2', 50, 1000),
            ('PF', 'PowerForward3', 100, 1000),
            ('SF', 'SmallForward1', 50, 1000),
            ('SF', 'SmallForward2', 50, 1000),
            ('SG', 'ShootingGuard1', 50, 1000),
            ('SG', 'ShootingGuard2', 50, 1000),
            ('SG', 'ShootingGuard3', 50, 1000),
            ('PG', 'PointGuard1', 50, 1000),
            ('PG', 'PointGuard2', 50, 1000)]

    df = DataFrame(data, columns=FIELDS)
    lineup_calculator = LineupOptimizer(df)
    opt_lineup = lineup_calculator.calc_lineup()

if __name__ == "__main__":
    main()
