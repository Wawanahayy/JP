Menghentikan Service
...bash
sudo systemctl stop executor.service
```

Menghapus Service

```bash
sudo systemctl stop executor.service
sudo systemctl disable executor.service
sudo rm -f /etc/systemd/system/executor.service
sudo systemctl daemon-reload
```
Melihat Log Service
```bash
sudo journalctl -u executor.service -f
```
Menjalankan Node
Jika node Anda dijalankan sebagai bagian dari service, Anda dapat memulainya dengan:
```bash
sudo systemctl start executor.service
```
Jika Anda menjalankan node secara manual (misalnya dengan script), gunakan perintah yang sesuai untuk memulai node tersebut, seperti:

```bash
/root/executor/executor/bin/executor
```
Menghentikan Node

```bash
sudo systemctl stop executor.service
```
