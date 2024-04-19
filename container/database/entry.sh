#!/bin/sh

echo "Starting Initialization of SkyFire 548 DB..."

upload_sql_files() {
    local directory="$1"
    local database="$2"

    if [ ! -d "$directory" ]; then
        echo "Directory $directory does not exist"
        return 1
    fi

    if [ -z "$database" ]; then
        echo "Database name is required"
        return 1
    fi

    # Iterate over all SQL files in the directory
    for sql_file in "$directory"/*.sql; do
        if [ -f "$sql_file" ]; then
            # Upload the SQL file to the specified database
            echo -n "Working on: $sql_file "
            if mariadb -u "$MYSQL_USERNAME" -p"$MYSQL_PASSWORD" "$database" < "$sql_file"; then
	            echo "done"
            fi
        fi
    done

    echo "All SQL files in $directory have been uploaded to database $database"
}

echo "Removing old database and users"
mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "DROP DATABASE IF EXISTS auth;"
mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "DROP DATABASE IF EXISTS characters"
mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "DROP DATABASE IF EXISTS world"
mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "DROP USER IF EXISTS $SERVER_DB_USER"

echo "Creating databases"
mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "CREATE DATABASE auth CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"
mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "CREATE DATABASE characters CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"
mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "CREATE DATABASE world CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"

echo "Create user"
mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "CREATE USER '$SERVER_DB_USER'@'%' IDENTIFIED BY '$SERVER_DB_PASSWORD'"
mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "GRANT ALL PRIVILEGES ON auth.* to '$SERVER_DB_USER'@'%'"
mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "GRANT ALL PRIVILEGES ON characters.* to '$SERVER_DB_USER'@'%'"
mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "GRANT ALL PRIVILEGES ON world.* to '$SERVER_DB_USER'@'%'"
mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "FLUSH PRIVILEGES"

echo "Populate database"
mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD auth < $SOURCE_PREFIX/sql/base/auth_database.sql
mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD characters < $SOURCE_PREFIX/sql/base/characters_database.sql

# if [ ! -f "$ROOT_DIRECTORY/sources/world.zip" ]; then
if [ ! -f "/tmp/world.zip" ]; then
    echo "Download latest world database"
    # wget --progress=bar:force:noscroll $DATABASE_URL -O $ROOT_DIRECTORY/sources/world.zip
    wget --progress=bar:force:noscroll $DATABASE_URL -O /tmp/world.zip
fi
    
echo "Unzipping latest db"
# unzip $ROOT_DIRECTORY/build/world.zip -d /tmp
unzip /tmp/world.zip -d /tmp

echo "Populate database with latest world db"

sed -i 's/utf8mb4_0900_ai_ci/utf8mb4_general_ci/g' /tmp/SFDB_full_548_24.000_2024_03_17_Release/main_db/world/SFDB_full_548_24.000_2024_03_17_Release.sql
sed -i 's/utf8mb4_0900_ai_ci/utf8mb4_general_ci/g' /tmp/SFDB_full_548_24.000_2024_03_17_Release/main_db/procs/stored_procs.sql

mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD world < /tmp/SFDB_full_548_24.000_2024_03_17_Release/main_db/world/SFDB_full_548_24.000_2024_03_17_Release.sql
mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD world < /tmp/SFDB_full_548_24.000_2024_03_17_Release/main_db/procs/stored_procs.sql || true

echo "Update databases to latest"
upload_sql_files "$SOURCE_PREFIX/sql/updates/auth" "auth"
upload_sql_files "$SOURCE_PREFIX/sql/updates/characters" "characters"
upload_sql_files "$SOURCE_PREFIX/sql/updates/world" "world"

echo "User cleanup"
mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD auth -e "DELETE FROM account"
mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD auth -e "DELETE FROM account_access"

echo "Adding admin user"
mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD auth -e "INSERT INTO account (id, username, sha_pass_hash) VALUES (1, 'admin', '8301316d0d8448a34fa6d0c6bf1cbfa2b4a1a93a')"
mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD auth -e "INSERT INTO account_access (id, gmlevel , RealmID) VALUES (1, 100, -1)";

echo "Update realmd info"
mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD auth -e "DELETE FROM realmlist"
mariadb -u $MYSQL_USERNAME -p$MYSQL_PASSWORD auth -e "INSERT INTO realmlist (id, name, address, localAddress, localSubnetMask, port, icon, flag, timezone, allowedSecurityLevel, population, gamebuild) VALUES (1, '$REALM_NAME', '$REALM_ADDRESS', '$REALM_LOCAL_ADDRESS', '$REALM_LOCAL_SUBNETMASK', $REALM_PORT, $REALM_ICON,  $REALM_FLAG, $REALM_TIMEZONE, $REALM_SECURITY, $REALM_POP, $REALM_BUILD)"

# echo "Removing files"
# yes | rm /tmp/*.sql