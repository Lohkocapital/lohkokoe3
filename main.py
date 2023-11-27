import datetime
import pandas as pd
# import sqlalchemy
from sqlalchemy import create_engine

print("Repo lohkokoe3: Ensimmainen lisatty file: main.py")
aika = datetime.datetime.now()
print(f"Nyt on {aika}")

# Kokeillaan in-place editia suoraan browserin editorissa
# Toimisiko ehka Aaron devieditorina koulussa?

# Lisataan pandas ja kokeillaan samalla codespacesia
print(f"Lisataan codespacen kokeilu")

# Github Desktopin kautta pull ja siitä editointi VS Codessa
# Poistetaan aakkoset
print("Aakkoset poistettu ja koitetaan Github Desktopista Commitia ja Pushia lokaalista hubiin")
print("Commit klo 1506 etta saa muutoksia fileeseen")

# Define the database connection URL
# Replace 'your_username', 'your_password', 'your_host', 'your_database_name' with your MySQL connection details
connection_url = 'mysql+mysqlconnector://root:onkyt0nk@127.0.0.1/kahvilat'

# Create a SQLAlchemy engine to connect to the database
engine = create_engine(connection_url)

# Query to retrieve data from a table (replace 'your_table' with your table name)
query = "SELECT * FROM cafe"

# Use Pandas to read data from the database into a DataFrame
df = pd.read_sql(query, con=engine)

# Display the DataFrame
print(df)

