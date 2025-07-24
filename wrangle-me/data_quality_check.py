import pandas as pd

def check_missing(df):
    output = []
    output.append('Missing values per column:')
    output.append(str(df.isnull().sum()))
    output.append('\nEmpty string values per column:')
    for col in df.columns:
        if df[col].dtype == object:
            output.append(f"{col}: {(df[col] == '').sum()}")
    return '\n'.join(output)

def check_duplicates(df):
    dup_rows = df.duplicated().sum()
    return f'Number of duplicate rows: {dup_rows}'

def check_unique_event_id(df):
    unique = df['event_id'].is_unique
    output = [f'Are event_id values unique? {unique}']
    if not unique:
        output.append('Duplicate event_id values:')
        output.append(str(df['event_id'][df['event_id'].duplicated(keep=False)]))
    return '\n'.join(output)

def run_all_checks(df):
    print('--- Data Quality Report ---')
    print('\n[1] Missing Values')
    print(check_missing(df))
    print('\n[2] Duplicate Rows')
    print(check_duplicates(df))
    print('\n[3] Unique event_id')
    print(check_unique_event_id(df))

if __name__ == "__main__":
    df = pd.read_csv('contract_events.csv')
    run_all_checks(df) 