# Define your variables
catalog = "main"
schema = "your_schema_name"
new_owner = "new_owner_principal"  # e.g., "finance_team" or "user@company.com"

# Fetch all tables in the specified schema
tables_df = spark.sql(f"SHOW TABLES IN {catalog}.{schema}")

# Loop through and update ownership for each table
for row in tables_df.collect():
    table_name = row['tableName']
    full_table_path = f"`{catalog}`.`{schema}`.`{table_name}`"
    
    print(f"Transferring ownership for {full_table_path}...")
    spark.sql(f"ALTER TABLE {full_table_path} SET OWNER TO `{new_owner}`")
