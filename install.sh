#!/bin/bash
# Installations-Script für Netcup VPS (Ubuntu 22.04)
# Ziel: Apache + MySQL + Python + Flask-Anwendung

set -e  # Script bei Fehler beenden

# --- System aktualisieren ---
echo "[1/9] System aktualisieren..."
sudo apt update && sudo apt upgrade -y

# Apache bereits installiert

# --- MySQL installieren ---
echo "[3/9] MySQL installieren..."
sudo add-apt-repository universe
sudo apt update

sudo apt install mysql-server -y
sudo systemctl enable mysql
sudo systemctl start mysql

# --- Python & venv installieren ---
echo "[4/9] Python 3 + venv installieren..."
sudo apt install python3 python3-pip python3-venv -y

# --- Projektverzeichnis vorbereiten ---
echo "[5/9] Projektverzeichnis anlegen..."
sudo mkdir -p /var/www/rechnungsapp
sudo chown $USER:$USER /var/www/rechnungsapp
cd /var/www/rechnungsapp

# --- Virtuelle Umgebung erstellen und aktivieren ---
echo "[6/9] Virtuelle Umgebung aufsetzen..."
python3 -m venv venv
source venv/bin/activate

# --- Flask & weitere Pakete installieren ---
echo "[7/9] Flask und MySQL Connector installieren..."
pip install flask mysql-connector-python

# --- Beispiel-App erstellen ---
echo "[8/9] Beispiel-Flask-App anlegen..."
cat <<EOF > /var/www/rechnungsapp/app.py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "<h1>Hallo Georg – deine Flask-App läuft! \U0001F680</h1>"

if __name__ == '__main__':
    app.run()
EOF

# --- Apache + mod_wsgi installieren ---
echo "[9/9] mod_wsgi installieren und Apache konfigurieren..."
sudo apt install libapache2-mod-wsgi-py3 -y

# Beispiel-Konfiguration speichern (optional, weitere Schritte folgen manuell)
echo "Konfiguration abgeschlossen. Flask-App erreichbar nach Apache-Konfiguration."
echo "Denk daran: app.py in WSGI-kompatiblen Einstiegspunkt umbauen (z. B. wsgi.py)"

echo "Fertig! Server ist vorbereitet."

# --- Hinweis zur Apache-Konfiguration ---
echo -e "\n>> Jetzt musst du noch eine Apache VirtualHost-Konfiguration erstellen, z. B.:"
echo "sudo nano /etc/apache2/sites-available/rechnungsapp.conf"
echo -e "\nDanach aktivieren mit:"
echo "sudo a2ensite rechnungsapp.conf && sudo systemctl reload apache2"
