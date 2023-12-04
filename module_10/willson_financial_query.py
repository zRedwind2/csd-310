import mysql.connector
from mysql.connector import errorcode

config = {
    "user": "financial_user",
    "password": "financing",
    "host": "127.0.0.1",
    "database": "willson_financial",
    "raise_on_warnings": True
}
def show_accounts(cursor, title):
    cursor.execute(
        "select account_id, account_name FROM account")

    accounts = cursor.fetchall()
    print("\n -- {} --\n".format(title))

    for account in accounts:
        print("Account Id: {}\nAccount Name: {}\n".format(account[0],account[1]))

def show_advisors(cursor, title):
    cursor.execute(
        "select advisor_id, f_name, l_name FROM advisor")

    advisors = cursor.fetchall()
    print("\n -- {} --\n".format(title))

    for advisor in advisors:
        print("Advisor Id: {}\nFirst Name: {}\nLast Name: {}\n".format(advisor[0],advisor[1],advisor[2]))
def show_assets(cursor, title):
    cursor.execute(
        "select assets_id, assets_type, assets_currency FROM assets")

    assets = cursor.fetchall()
    print("\n -- {} --\n".format(title))

    for asset in assets:
        print("Asset Id: {}\nAsset Type {}\nAsset Value: {}\n".format(asset[0],asset[1],asset[2]))

def show_clients(cursor, title):
    cursor.execute(
        "select client_id, f_name, l_name, join_date FROM client")

    clients = cursor.fetchall()
    print("\n -- {} --\n".format(title))

    for client in clients:
        print("Client Id: {}\nFirst Name: {}\nLast Name: {}\nJoin Date: {}\n".format(client[0],client[1],client[2],client[3]))

def show_transactions(cursor, title):
    cursor.execute(
        "select transaction_id, t_date, t_summary, value_start, value_end FROM transaction"
    )

    transactions = cursor.fetchall();
    print("\n -- {} --\n".format(title))
    for transaction in transactions:
        print("Transaction Id: {}\nTransaction Date: {}\nTransaction Summary: {}\nInital Value: {}\nFinal Value: {}\n".format(transaction[0],transaction[1],transaction[2],transaction[3],transaction[4]))

try:
    db = mysql.connector.connect(**config)

    print("\nDatabase user {} connected to MySQL on host {} with database {}".format(config["user"], config["host"], config["database"]))

    cursor = db.cursor()

    show_accounts(cursor,"DISPLAYING ACCOUNTS")
    show_advisors(cursor,"DISPLAYING ADVISORS")
    show_assets(cursor,"DISPLAYING ASSETS")
    show_clients(cursor, "DISPLAYING CLIENTS")
    show_transactions(cursor, "DISPLAYING TRANSACTIONS")

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