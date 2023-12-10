import mysql.connector
from mysql.connector import errorcode

config = {
    "user": "financial_user",
    "password": "financing",
    "host": "127.0.0.1",
    "database": "willson_financial",
    "raise_on_warnings": True
}

def added_clients(cursor,label):
    cursor.execute(
        "SELECT f_name, l_name, join_date FROM client WHERE join_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)")
    clients = cursor.fetchall()
    print("\n-- {} --".format(label))
    for client in clients:
        print("\nFirst Name: {}\nLast Name: {}\nJoin Date: {}".format(client[0], client[1], client[2]))

def average_assets(cursor,label):

    average = 0
    count = 0
    cursor.execute(
        "select assets_currency FROM assets")

    assets = cursor.fetchall()

    for asset in assets:
        average = average + asset[0]
        count = count + 1

    average = average/count
    print("\n-- {} --".format(label))
    print("\nThe average of all the assets we maintain is: ${:.2f}".format(average))

def frequent_users(cursor,label):
    #cursor.execute("SELECT account_id, COUNT(account_id) AS transaction_count FROM transaction GROUP BY account_id HAVING COUNT(transaction_count) >= 10"
    #)
    cursor.execute(
        "SELECT transaction.account_id as Id, account_name FROM transaction INNER JOIN account ON transaction.account_id = account.account_id WHERE t_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH) GROUP BY transaction.account_ID HAVING count(transaction.account_id) >= 10"
    )

    clients = cursor.fetchall()

    print("\n-- {} --".format(label))

    for client in clients:
        print("\nAccount Name: {}".format(client[1]))

try:
    db = mysql.connector.connect(**config)

    print("\nDatabase user {} connected to MySQL on host {} with database {}".format(config["user"], config["host"], config["database"]))

    cursor = db.cursor()

    added_clients(cursor, "Displaying clients that have joined in the past six months")
    average_assets(cursor, "Average Assets")
    frequent_users(cursor,"Clients with 10+ transactions with in a month in the past year")

except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("The supplied username or password are invalid")
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("The specified database does not exist")
    else:
        print(err)

finally:
    # Close the database connection
    db.close()