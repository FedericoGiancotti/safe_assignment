import pandas as pd

# Load the data
df = pd.read_csv('contract_events.csv')

# Drop duplicate event_id rows
df = df.drop_duplicates(subset=['event_id'])

# Filter out rows where previous_event_id is null or empty
df_non_null = df[df['previous_event_id'].notnull() & (df['previous_event_id'] != '')]

# Find previous_event_id values not present in event_id
missing_prev = ~df_non_null['previous_event_id'].isin(df['event_id'])

# Select those rows and output the required columns
result = df_non_null[missing_prev][['event_id', 'previous_event_id', 'contract_address', 'event_type', 'block_number']]
result.to_csv('orphan_events.csv', index=False)
print(result)