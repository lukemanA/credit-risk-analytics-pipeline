import streamlit as st
import duckdb
import pandas as pd

# 1. Initialize a read-only database link to protect against database locking errors
conn = duckdb.connect("../credit_risk_warehouse.db", read_only=True)

# 2. Extract our analytical marts into pandas structures for rendering
df = conn.execute("SELECT * FROM mart_applicant_features;").df()

# 3. Configure the web page visual metadata shell header properties
st.set_page_config(page_title="Credit Risk Analytics Dashboard", layout="wide")

st.title("🛡️ Credit Risk Analytics Dashboard")
st.markdown("### Real-time Risk Segmentation & Portfolio Performance")

# 4. Construct structural row column placeholders to organize metric cards
col1, col2, col3 = st.columns(3)

with col1:
    st.metric(label="Total Applications Evaluated", value=f"{len(df):,}")

with col2:
    total_defaults = int(df['TARGET'].sum())
    st.metric(label="Total Portfolo Defaulters", value=f"{total_defaults:,}")

with col3:
    default_rate = (df['TARGET'].mean() * 100)
    st.metric(label="Overall Default Rate Ratio", value=f"{default_rate:.2f}%")

st.divider()

# 5. Build an interactive user data exploration filter mechanism grid component
st.subheader("🔍 Deep Dive: Income vs Credit Distribution Matrix")
st.dataframe(df[['SK_ID_CURR', 'AMT_INCOME_TOTAL', 'AMT_CREDIT', 'credit_income_ratio', 'TARGET']].head(100))