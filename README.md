# MoodSync 🎶😄

Aplikasi ini adalah platform musik berbasis Flutter yang memberikan rekomendasi lagu secara personal dengan menggabungkan teknologi pengenalan emosi dan machine learning. Menggunakan ekspresi wajah pengguna, aplikasi dapat mendeteksi emosi mereka, seperti senang, sedih, atau netral, dan merekomendasikan lagu yang sesuai dengan suasana hati tersebut. Saat pengguna mendaftar atau login, mereka juga dapat memilih genre favorit untuk semakin mempersonalisasi pengalaman mendengarkan musik.

Aplikasi ini menyediakan fitur umpan balik pengguna untuk meningkatkan akurasi dan relevansi rekomendasi. Feedback tersebut akan digunakan oleh sistem untuk mengevaluasi dan memperbaiki model rekomendasi, yang dapat diakses melalui dashboard admin. Dengan tampilan antarmuka yang intuitif dan responsif, aplikasi ini memberikan pengalaman musik yang unik dan relevan, yang terintegrasi dengan preferensi dan emosi pengguna secara real-time.

## 🎯 Fitur Utama

- **Rekomendasi Berdasarkan Ekspresi Wajah**

    Aplikasi ini mendeteksi ekspresi wajah pengguna untuk menentukan suasana hati mereka (seperti senang, sedih, marah dan netral), lalu merekomendasikan musik yang sesuai. Dengan ini, kamu bisa mendapatkan lagu yang relevan dengan suasana hatimu secara otomatis!

- **Personalisasi Genre Musik**

    Pada saat login atau pendaftaran, pengguna dapat memilih genre musik favorit mereka. Ini membantu aplikasi dalam menyusun rekomendasi musik yang lebih sesuai dengan preferensi pribadimu.

- **Feedback Pengguna untuk Pengembangan Model**

    Aplikasi menyediakan opsi bagi pengguna untuk memberikan feedback atas rekomendasi yang diberikan. Feedback ini akan membantu aplikasi meningkatkan akurasi model rekomendasi dan bisa dilihat melalui dashboard admin.

- **Antarmuka Pengguna yang Intuitif dan Responsif**

    Desain antarmuka yang sederhana dan menarik memudahkan pengguna untuk berinteraksi dengan aplikasi. Pengalaman mendengarkan musik jadi lebih menyenangkan, dengan navigasi yang cepat dan mudah digunakan.

## 📦 Teknologi yang Digunakan

- **Frontend**: Flutter
- **Backend**: Laravel
- **Database**: MySQL
  
## 🚀 Cara Menjalankan Aplikasi

Berikut langkah-langkah untuk menjalankan aplikasi dari tahap clone hingga siap di-debug di emulator atau perangkat fisik.

1. **Clone Repository**
   ```bash
   git clone https://github.com/ExpressCode-Team/MoodSync.git
   cd MoodSync

2. **Install Dependencies**
    
    Pastikan semua dependencies yang dibutuhkan tersedia:
    ``` bash
    flutter pub get
    ```

3. **Set Up Configuration**
    
    Sesuaikan file konfigurasi (misalnya `.env` atau file konfigurasi API lain) untuk environment yang tepat.

4. **Jalankan Aplikasi di Debug Mode**
    
    Pastikan device/emulator sudah terdeteksi, lalu gunakan perintah:
    ``` bash
    flutter run
    ```

## 💡 Kontribusi

Berikut adalah cara berkontribusi dalam project ini:

1. **Fork Repository** 

    Klik Fork pada repository ini untuk membuat salinan pada akun GitHub kamu.

2. **Clone Repository yang Sudah Di-fork** 
    
    Clone repository hasil fork ke lokal:
    ``` bash
    git clone https://github.com/username/forked_repo_name.git
    cd forked_repo_name
    ```

3. **Buat Branch Baru** 
    
    Buat branch baru untuk fitur atau perbaikan yang ingin kamu tambahkan:
    ``` bash
    git checkout -b nama-branch-kamu
    ```

4. **Commit Perubahan** 
    
    Pastikan kamu menuliskan pesan commit yang jelas dan deskriptif
    ``` bash
    git add .
    git commit -m "Deskripsi perubahan yang dilakukan"
    ```
5. **Push ke Repository Hasil Fork** 
    
    Kirim perubahan ke repository hasil fork:
    ``` bash
    git push origin nama-branch-kamu
    ```

6. **Buat Pull Request**

    Buka repository asli, lalu buat Pull Request dengan branch yang baru kamu push. Jelaskan detail perubahan yang dilakukan.

Kami akan meninjau Pull Request kamu dan memberikan feedback atau langsung merge ke branch utama.

## 🚀 Roadmap & Fitur Mendatang

Rencana kami ke depan untuk aplikasi ini:
- Penambahan lebih banyak genre musik
- Peningkatan akurasi deteksi emosi
- Fitur kolaborasi antar pengguna

Tetap ikuti perkembangan dan beri masukan untuk fitur-fitur yang ingin kamu lihat!

## 🌟 Penutup

Semoga aplikasi ini bisa jadi teman musik terbaikmu sehari-hari! Kalau aplikasi ini membuatmu lebih bahagia, misinya tercapai. Kalau enggak... yah, kita punya *playlist* penuh lagu semangat buat dicoba lagi. 🎶😄