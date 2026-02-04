import pandas as pd
import FinanceDataReader as fdr
from plotly.data import stocks
from sqlalchemy import create_engine

engine = create_engine('mysql+pymysql://appuser:appuser@localhost:3306/money')
df = fdr.StockListing('KRX')
stocks_df = df[['Code','Name','Market']].rename(columns={'Code':'ticker', 'Name':'sotck_nm','Market':'market_code'})

stocks_df.to_sql(name='stocks',con=engine,index=False,if_exists='append')