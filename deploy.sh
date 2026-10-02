#!/usr/bin/env bash
# GoFit deploy: pulls the prebuilt WAR from GitHub and installs it as Tomcat's ROOT.
# Usage:  curl -fsSL https://raw.githubusercontent.com/udayps10/GoFitApp/main/deploy.sh | bash
set -euo pipefail

RAW="https://raw.githubusercontent.com/udayps10/GoFitApp/main"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT
cd "$WORK"

echo "==> downloading GOFIT.war (prebuilt, Java 21)"
curl -fsSL -o ROOT.war "$RAW/GOFIT.war"
ls -l ROOT.war

CTR=""
if command -v docker >/dev/null 2>&1; then
  CTR="$(docker ps --format '{{.Names}}' | grep -iE 'tomcat|gofit' | head -1 || true)"
fi

if [ -n "$CTR" ]; then
  echo "==> installing into container: $CTR"
  docker exec "$CTR" rm -rf /usr/local/tomcat/webapps/ROOT /usr/local/tomcat/webapps/ROOT.war
  docker cp ROOT.war "$CTR:/usr/local/tomcat/webapps/ROOT.war"
  docker restart "$CTR"
else
  echo "==> no container found; using Tomcat on this host"
  if [ -z "${CATALINA_HOME:-}" ]; then
    if command -v catalina.sh >/dev/null 2>&1; then
      CATALINA_HOME="$(cd "$(dirname "$(readlink -f "$(command -v catalina.sh)")")/.." && pwd)"
    elif [ -d /usr/local/tomcat ]; then
      CATALINA_HOME=/usr/local/tomcat
    else
      echo "!! Could not find Tomcat. Re-run with CATALINA_HOME=/path/to/tomcat" >&2
      exit 1
    fi
  fi
  echo "==> CATALINA_HOME=$CATALINA_HOME"
  "$CATALINA_HOME/bin/shutdown.sh" || true
  for _ in $(seq 1 20); do
    pgrep -f 'org.apache.catalina.startup.Bootstrap' >/dev/null 2>&1 || break
    sleep 1
  done
  rm -rf "$CATALINA_HOME/webapps/ROOT" "$CATALINA_HOME/webapps/ROOT.war"
  cp ROOT.war "$CATALINA_HOME/webapps/ROOT.war"
  "$CATALINA_HOME/bin/startup.sh"
fi

echo "==> waiting for Tomcat"
sleep 20

echo "==> database status"
curl -fsS "https://gofit.udaycodes.site/dbtest.jsp" \
  | sed -e 's/<[^>]*>//g' \
  | grep -E 'Database connection|Users table|SQL error|DB_URL|DB_USER|DB_PASSWORD|GEMINI' \
  || echo "(could not read dbtest.jsp)"
echo "==> done"
