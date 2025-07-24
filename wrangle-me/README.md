# Blockchain Contract Events — Python Data Analysis Challenge

Welcome! This assignment is designed to assess your ability to analyze complex datasets using Python and relational thinking.

You’ll be working with a synthetic dataset of smart contract event logs, inspired by some fictious blockchain infrastructure. The data has been pre-indexed into a CSV file.

---

## Dataset

You will analyze the file: `contract_events.csv`


It contains ~20,000 records of smart contract events, each representing a transaction-level emission from a contract.

### Columns include:

| Column             | Description |
|--------------------|-------------|
| `event_id`         | Unique identifier for the event |
| `previous_event_id`| References another event, if applicable |
| `tx_hash`          | The transaction that emitted this event |
| `contract_address` | The smart contract involved |
| `sender`           | The externally owned account (EOA) initiating the tx |
| `block_number`     | The block containing the transaction |
| `block_timestamp`  | When the block was mined |
| `gas_used`         | Synthetic gas usage estimate |
| `status`           | `Confirmed`, `Pending`, or `Reorged` |
| `node_region`      | Arbitrary metadata about where it was indexed |
| `tx_index`         | Ordering index within the block (randomized) |

Note: As with real-world data, there may be inconsistencies, edge cases, or anomalies present. You are encouraged to approach the dataset critically and mention anything unusual you find.

---

## Tasks

Please use pandas (not SQL engines) to complete the following.

### Task 1: Orphan Event Detection

Find all events where `previous_event_id` does not exist in the dataset.

Expected Output:
- `event_id`
- `previous_event_id`
- `contract_address`
- `event_type`
- `block_number`

---

### Task 2: Time Delta Per Contract

For each `contract_address`, compute the number of seconds since the previous event (ordered by `block_timestamp`).

Expected Output:
- `event_id`
- `contract_address`
- `event_type`
- `block_timestamp`
- `seconds_since_last_event`

---

### Task 3: Sender Mapping

For each `sender`, find the block where they had the most events emitted, and rank them by event frequency.

Expected Output:
- `sender`
- `block_number`
- `event_count`
- `rank_in_sender_activity`

---

### Bonus (Optional but Appreciated)

Choose one or more:
- Identify and explain inconsistencies or data quality issues you noticed.
- Detect possible bot-like behavior.
- Visualize interesting patterns (e.g. frequency by `event_type` or `contract_address`).
- Trace multi-step event chains using `previous_event_id`.

---

## Setup Instructions

Use `uv` to create a virtual Python environment and install `Pandas` for data wrangling and analysis.


