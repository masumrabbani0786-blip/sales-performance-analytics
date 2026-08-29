import pandas as pd
df = pd.read_csv("../data/raw/sales_data_raw.csv")

print("Data loaded successfully!")
print(df.head())

print("Rows and Columns:")
print(df.shape)

print("\nColumns Name:")
print(df.columns)

print("\nData Type:")
print(df.dtypes)

print("\nDataset Infromation:")
print(df.info())

print("\nMissing Values:")
print(df.isnull().sum())

print("\nDuplicate Rows:")
print(df.duplicated().sum())

print("\nStatistical Summary:")
print(df.describe())

# Convert order_date to datetime
df['order_date'] = pd.to_datetime(df['order_date'], errors='coerce')

# Convert numeric columns
numeric_columns = [
    'quantity',
    'unit_price',
    'discount',
    'delivery_days'
]

for col in numeric_columns:
    df[col] = pd.to_numeric(df[col], errors='coerce')

# Check data types again
print(df.dtypes)


print("Invalid/Missing Dates:")
print(df['order_date'].isnull().sum())

print("\nNegative Quantity:")
print((df['quantity'] < 0).sum())

print("\nNegative Unit Price:")
print((df['unit_price'] < 0).sum())

print("\nInvalid Discount:")
print(((df['discount'] < 0) | (df['discount'] > 1)).sum())

print("\nNegative Delivery Days:")
print((df['delivery_days'] < 0).sum())

print("\nDuplicate Rows:", df.duplicated().sum())
print("Duplicate Order IDs:", df['order_id'].duplicated().sum())


# Gross Sales
df['gross_sales'] = df['quantity'] * df['unit_price']

# Discount Amount
df['discount_amount'] = df['gross_sales'] * df['discount']

# Net Sales
df['sales_amount'] = df['gross_sales'] - df['discount_amount']

print(df[['quantity', 'unit_price', 'discount',
          'gross_sales', 'discount_amount', 'sales_amount']].head())


# Extract Year and Month
df['year'] = df['order_date'].dt.year
df['month'] = df['order_date'].dt.month
df['month_name'] = df['order_date'].dt.month_name()

print(df[['order_date', 'year', 'month', 'month_name']].head())


print("\nUpdated Shape:", df.shape)

print("\nUpdated Columns:")
print(df.columns.tolist())

print("\nFinal Data:")
print(df.head())

# Round monetary columns to 2 decimal places
money_columns = [
    'unit_price',
    'gross_sales',
    'discount_amount',
    'sales_amount'
]

df[money_columns] = df[money_columns].round(2)

# Save the final analysis-ready CSV
output_file = "../data/cleaned/sales_data_final_python_output.csv"

df.to_csv(output_file, index=False)

print("Cleaned CSV saved successfully!")
print(output_file)