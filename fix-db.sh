#!/usr/bin/env bash
# One-shot: create the MySQL user the app uses, point the container at it, verify.
# Usage: curl -fsSL https://raw.githubusercontent.com/udayps10/GoFitApp/main/fix-db.sh | sudo bash
set -uo pipefail

ROOTPW='Uday@2006'
APPPW='GoFitApp#2026SecurePass!'
export MYSQL_PWD="$ROOTPW"

echo "==> can we log into MySQL as root?"
if ! mysql -uroot -e "SELECT 1;" >/dev/null 2>&1; then
  echo "!! cannot log in as root with password [$ROOTPW]" >&2
  exit 1
fi
echo "  yes"

echo "==> password policy MySQL enforces"
mysql -uroot -e "SHOW VARIABLES LIKE 'validate_password%';" || true

echo "==> importing schema"
curl -fsSL -o /tmp/gofit-schema.sql https://raw.githubusercontent.com/udayps10/GoFitApp/main/database_setup.sql
mysql -uroot < /tmp/gofit-schema.sql && echo "  schema OK"

echo "==> creating MySQL user 'gofit'"
mysql -uroot -e "CREATE USER IF NOT EXISTS 'gofit'@'%';"
if ! mysql -uroot -e "ALTER USER 'gofit'@'%' IDENTIFIED BY '$APPPW';"; then
  echo "!! MySQL password policy rejected [$APPPW] - see policy above" >&2
  exit 1
fi
mysql -uroot -e "GRANT ALL PRIVILEGES ON gofit.* TO 'gofit'@'%'; FLUSH PRIVILEGES;"

echo "==> testing login as the app would"
if MYSQL_PWD="$APPPW" mysql -ugofit -e "SELECT 1;" >/dev/null 2>&1; then
  echo "  OK"
else
  echo "  FAILED" >&2
  exit 1
fi

echo "==> writing setenv.sh into the gofit container"
GW=$(docker inspect gofit -f '{{range .NetworkSettings.Networks}}{{.Gateway}}{{end}}')
echo "  host gateway: $GW"
docker exec -i gofit bash -c 'cat > /usr/local/tomcat/bin/setenv.sh' <<EOF
export DB_URL='jdbc:mysql://$GW:3306/gofit?allowPublicKeyRetrieval=true&useSSL=false'
export DB_USER='gofit'
export DB_PASSWORD='$APPPW'
EOF

echo "==> restarting gofit (waits 25s)"
docker restart gofit >/dev/null
sleep 25

echo "==> live check"
curl -fsS "https://gofit.udaycodes.site/dbtest.jsp" | sed -e 's/<[^>]*>//g' \
  | grep -E "Database connection|Users table|SQL error|DB_" || echo "  (could not read dbtest.jsp)"
echo "==> done"
