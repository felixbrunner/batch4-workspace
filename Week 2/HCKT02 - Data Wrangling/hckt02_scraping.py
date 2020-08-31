import pandas as pd
import numpy as np
import requests
from bs4 import BeautifulSoup

##### SCRAPING

def scrape_hackathon_website(min_page_index=1, max_page_index=762):
    #parameters
    cols = ['index','Type','min_1','min_2','min_3','min_4','min_5','min_6','min_7','min_8','min_9','min_10','game_id']
    df = pd.DataFrame(columns=cols)

    base_url = 'https://ldsa-scrap-me.herokuapp.com/items?page='

    for page in range(min_page_index,max_page_index+1):
        # get raw html
        url = base_url+str(page)
        response = requests.get(url)
        soup = BeautifulSoup(response.content, 'html.parser')
    
        # get text
        cast_list = soup.find_all('td', class_="align-middle")
        table_list = [i.get_text() for i in cast_list]
        text_list = [i for i in table_list if i != '']
    
        # append dataframe
        df_page = pd.DataFrame(np.array(text_list).reshape(-1,13),columns=cols)
        df = df.append(df_page)
        
        # print progress
        if page%10 == 0:
            print('scaped page {}/{}'.format(page,max_page_index))

    return df.set_index('index')


##### FEATURE ENGINEERING FUNCTIONS

def tidy_up_gold_df(df):
    df = df.copy()\
           .pivot(index=['game_id'], columns='Type')\
           .astype(int)
    return df

def gold_blue(df, minute=10):
    players = ['goldblueTop','goldblueJungle','goldblueMiddle','goldblueADC','goldblueSupport']
    gold = df['min_'+str(minute)][players]\
                    .astype(int)\
                    .sum(axis=1)
    return gold

def gold_red(df, minute=10):
    players = ['goldredTop','goldredJungle','goldredMiddle','goldredADC','goldredSupport']
    gold = df['min_'+str(minute)][players]\
                    .astype(int)\
                    .sum(axis=1)
    return gold

def final_gold_diff(df):
    blue = gold_blue(df,10)
    red = gold_red(df,10)
    diff = blue-red
    return diff

def all_gold_blue(df):
    gold = 0
    for minute in range(1,11):
        gold += gold_blue(df, minute=minute)
    return gold

def all_gold_red(df):
    gold = 0
    for minute in range(1,11):
        gold += gold_red(df, minute=minute)
    return gold

def last_earnings_blue(df):
    earnings = gold_blue(df, minute=10)-gold_blue(df, minute=9)
    return earnings

def last_earnings_red(df):
    earnings = gold_red(df, minute=10)-gold_red(df, minute=9)
    return earnings

def last_earnings_diff(df):
    blue = last_earnings_blue(df)
    red = last_earnings_red(df)
    diff = blue-red
    return diff

def blue_richer_count(df):
    count = 0
    for minute in range(1,11):
        count += gold_blue(df, minute=minute) > gold_red(df, minute=minute)
    return count

def generate_gold_features(df):
    features = pd.DataFrame()
    features['blue_gold'] = gold_blue(df)
    features['red_gold'] = gold_red(df)
    features['gold_diff'] = final_gold_diff(df)
    features['blue_richer'] = features['gold_diff'] >= 0
    features['blue_richer_count'] = blue_richer_count(df)
    features['blue_earn'] = last_earnings_blue(df)
    features['red_earn'] = last_earnings_red(df)
    features['earn_diff'] = last_earnings_diff(df)
    return features


###### AFTER HAVING IMPORTED THE CSV RUN THIS LINES TO GET A DATAFRAME WITH SOME FEATURES
df_gold_features = df_website.pipe(tidy_up_gold_df)\
                             .pipe(generate_gold_features)