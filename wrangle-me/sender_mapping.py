import pandas as pd

# Load the data
df = pd.read_csv('contract_events.csv')

# Drop duplicate event_id rows
df = df.drop_duplicates(subset=['event_id'])

# Count events per sender per block
event_counts = df.groupby(['sender', 'block_number']).size().reset_index(name='event_count')

# For each sender, find the block with the most events
idx = event_counts.groupby('sender')['event_count'].idxmax()
most_active_blocks = event_counts.loc[idx].reset_index(drop=True)

# Rank senders by their event_count (descending)
most_active_blocks['rank_in_sender_activity'] = most_active_blocks['event_count'].rank(method='dense', ascending=False).astype(int)

# Sort by rank
most_active_blocks = most_active_blocks.sort_values('rank_in_sender_activity')

# Select required columns
result = most_active_blocks[['sender', 'block_number', 'event_count', 'rank_in_sender_activity']]

print(result)
