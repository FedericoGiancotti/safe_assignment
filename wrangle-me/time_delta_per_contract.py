import pandas as pd

# Load the data
df = pd.read_csv('contract_events.csv')

# Convert block_timestamp to datetime
df['block_timestamp'] = pd.to_datetime(df['block_timestamp'])

# Drop duplicate event_id rows
df = df.drop_duplicates(subset=['event_id'])

# Sort by contract_address and block_timestamp
df = df.sort_values(['contract_address', 'block_timestamp'])

# Compute seconds since last event for each contract_address
df['seconds_since_last_event'] = df.groupby('contract_address')['block_timestamp'].diff().dt.total_seconds()

# Select required columns
result = df[['event_id', 'contract_address', 'event_type', 'block_timestamp', 'seconds_since_last_event']]

# Order by block_timestamp
result = result.sort_values('block_timestamp')

print(result)
