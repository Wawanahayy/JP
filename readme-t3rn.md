```console
Menghentikan Service
bash
Copy code
sudo systemctl stop executor.service
Menghapus Service
bash
Copy code
sudo systemctl stop executor.service
sudo systemctl disable executor.service
sudo rm -f /etc/systemd/system/executor.service
sudo systemctl daemon-reload
Melihat Log Service
bash
Copy code
sudo journalctl -u executor.service -f
Menjalankan Node
Jika node Anda dijalankan sebagai bagian dari service, Anda dapat memulainya dengan:

bash
Copy code
sudo systemctl start executor.service
Jika Anda menjalankan node secara manual (misalnya dengan script), gunakan perintah yang sesuai untuk memulai node tersebut, seperti:

bash
Copy code
/root/executor/executor/bin/executor
Menghentikan Node
Jika node Anda dijalankan secara manual, Anda perlu menghentikannya dengan cara yang sesuai (misalnya, menghentikan proses yang sedang berjalan dengan kill atau menghentikan script jika itu adalah proses latar belakang). Jika node dijalankan sebagai service, gunakan perintah:

bash
Copy code
sudo systemctl stop executor.service
Jika Anda memerlukan bantuan lebih lanjut, beri tahu saya!
```
