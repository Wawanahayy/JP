#!/bin/bash

# Update sistem dan install dependencies
sudo apt update -y
sudo apt install -y wget unzip python3-pip xvfb

# Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install -y ./google-chrome-stable_current_amd64.deb

# Install ChromeDriver (sesuaikan versi dengan Google Chrome yang terinstal)
wget https://chromedriver.storage.googleapis.com/114.0.5735.90/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
sudo mv chromedriver /usr/bin/chromedriver
sudo chown root:root /usr/bin/chromedriver
sudo chmod +x /usr/bin/chromedriver

# Install Selenium dan pyvirtualdisplay
pip3 install selenium pyvirtualdisplay

# Membuat direktori untuk ekstensi Gradient
mkdir -p ~/gradient_extension

# Unduh ekstensi Gradient Sentry Node (Anda dapat menambahkannya secara manual)
echo "Silakan unduh ekstensi Gradient Sentry Node dan letakkan di ~/gradient_extension"

# Buat skrip Python bot
cat <<EOF > gradient_bot.py
from selenium import webdriver
from pyvirtualdisplay import Display
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
import time

# Membuat virtual display
display = Display(visible=0, size=(800, 600))
display.start()

# Opsi Chrome
chrome_options = Options()
chrome_options.add_argument("--no-sandbox")
chrome_options.add_argument("--disable-dev-shm-usage")
chrome_options.add_argument("--headless")  # Jalankan tanpa GUI
chrome_options.add_extension('/root/gradient_extension/gradient_sentry_node_extension.crx')

# Inisialisasi WebDriver
driver = webdriver.Chrome(options=chrome_options)

# Buka halaman ekstensi Gradient Sentry Node
driver.get("chrome-extension://caacbgbklghmpodbdafajbgdnegacfmo/home.html")

# Tunggu halaman dimuat
time.sleep(5)

# Cari input email dan masukkan email Anda
email_field = driver.find_element_by_name("email")
email_field.send_keys("your_email@example.com")
email_field.send_keys(Keys.RETURN)

# Tunggu proses login selesai
time.sleep(10)

# Logika tambahan bisa diletakkan di sini

# Tutup driver dan display setelah selesai
driver.quit()
display.stop()
EOF

# Menjalankan bot Python
python3 gradient_bot.py
