import pandas as pd

# Load the data
file_path = 'contract_events.csv'
df = pd.read_csv(file_path)

# Convert block_timestamp to datetime
df['block_timestamp'] = pd.to_datetime(df['block_timestamp'])

# Parameters for bot detection
ACTIONS_PER_MINUTE_THRESHOLD = 5 

suspicious_senders = []

for sender, group in df.groupby('sender'):
    group = group.sort_values('block_timestamp')
    # Calculate actions per minute
    group['minute'] = group['block_timestamp'].dt.floor('min')
    actions_per_minute = group.groupby('minute').size().max()


    is_high_freq = actions_per_minute >= ACTIONS_PER_MINUTE_THRESHOLD

    if is_high_freq:
        suspicious_senders.append({
            'sender': sender,
            'max_actions_per_minute': actions_per_minute,
        })

# Output results
if suspicious_senders:
    print('Possible bot-like senders detected:')
    for s in suspicious_senders:
        print(f"Sender: {s['sender']}")
        print(f"  Max actions/minute: {s['max_actions_per_minute']}")
        print()
else:
    print('No suspicious bot-like senders detected.') 