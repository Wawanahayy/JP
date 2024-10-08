
Update dan Install Docker:

``` bash
Copy code
sudo apt-get update
sudo apt-get install docker.io -y
Install Docker Compose:
```
```bash
VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')
DESTINATION=/usr/local/bin/docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m) -o $DESTINATION
sudo chmod 755 $DESTINATION
Install Node.js dan Yarn:
```
```bash
sudo apt-get install npm -y
sudo npm install n -g
sudo n stable
sudo npm i -g yarn
```
Clone Repository dan Install Dependencies:

```bash
git clone https://github.com/CATProtocol/cat-token-box
cd cat-token-box
sudo yarn install
sudo yarn build
```
Set Permissions dan Jalankan Docker Compose:
```bash
cd ./packages/tracker/
sudo chmod 777 docker/data
sudo chmod 777 docker/pgdata
sudo docker-compose up -d
```
Build dan Jalankan Docker Container:
```bash
cd ../../ && docker build -t tracker:latest .
```
```
sudo docker run -d \
    --name tracker \
    --add-host="host.docker.internal:host-gateway" \
    -e DATABASE_HOST="host.docker.internal" \
    -e RPC_HOST="host.docker.internal" \
    -p 3000:3000 \
    tracker:latest
```
Konfigurasi CLI:
```
cd packages/cli
vim config.json
```
Isi config.json dengan:

json
```bash
{
  "network": "fractal-mainnet",
  "tracker": "http://127.0.0.1:3000",
  "dataDir": ".",
  "maxFeeRate": 30,
  "rpc": {
      "url": "http://127.0.0.1:8332",
      "username": "bitcoin",
      "password": "opcatAwesome"
  }
}
```
Create Wallet dan Mint Token:

```bash
sudo yarn cli wallet create
sudo yarn cli mint -i 45ee725c2c5993b3e4d308842d87e973bf1951f5f7a804b21e4dd964ecd12d6b_0 5
Script untuk Mengulangi Mint Token:
```

```bash
#!/bin/bash

command="sudo yarn cli mint -i  5"

while true; do
    $command

    if [ $? -ne 0 ]; then
        echo "命令执行失败，退出循环"
        exit 1
    fi

    sleep 1
done
```
Jika ada pertanyaan lebih lanjut atau jika Anda memerlukan penjelasan lebih detail tentang salah satu langkah, beri tahu saya!
