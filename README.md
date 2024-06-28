<!-- docs inspired by 
- https://github.com/tailwindlabs/tailwindcss
- https://github.com/deaaprizal/cuymodoro -->

<div align="center" style="margin-bottom: 59px;">
    <b>Neo-SIPTATIF</b> was a mobile version of <a href="https://github.com/MFarhanZ1/siptatif"><b>SIPTATIF Web Based,</b></a> especially for Koordinator TA roles!
    </br>
    Cek source code <b>versi web-nya lengkap beserta backend + database</b> direpo pada link dibawah ini! 
    </br>
    👉🏻👉🏻 <b>https://github.com/MFarhanZ1/siptatif</b> 👈🏻👈🏻
</div>


<div align="center" style="margin-bottom: 59px;">
  <a href="https://github.com/MFarhanZ1/siptatif">
    <img width="650px" src="https://i.ibb.co.com/BTSYBRs/dfnepv2.png" alt="RTNEPSQL Logo" />
  </a>
</div>

<p align="center">
  SIPTATIF: Sistem Informasi Pendaftaran Tugas Akhir Teknik Informatika UIN Suska Riau
  </br> 
  <i>(build with 💚💜 using: Flutter - Dart FW, + NodeJS + ExpressJS + PostgreSQL)</i>
</p>

<div align="center">
  <a href="https://circleci.com/gh/mfarhanz1/siptatif-mobile">
    <img src="https://img.shields.io/circleci/project/github/mfarhanz1/siptatif/master.svg?style=flat-square" alt="CircleCI branch" />
  </a>
  <a href="https://github.com/mfarhanz1/siptatif-mobile/network">
    <img src="https://img.shields.io/github/forks/mfarhanz1/siptatif-mobile.svg" alt="GitHub forks" />
  </a>
  <a href="https://github.com/mfarhanz1/siptatif-mobile/stargazers">
    <img src="https://img.shields.io/github/stars/mfarhanz1/siptatif-mobile.svg" alt="GitHub stars" />
  </a>
  <a href="https://github.com/mfarhanz1/siptatif-mobile/issues">
    <img src="https://img.shields.io/github/issues/mfarhanz1/siptatif-mobile.svg" alt="GitHub issues" />
  </a>
  <a href="https://github.com/mfarhanz1/siptatif-mobile/blob/master/LICENSE">
    <img src="https://img.shields.io/github/license/mfarhanz1/siptatif.svg" alt="GitHub license" />
  </a>
  <a href="https://coveralls.io/github/mfarhanz1/siptatif-mobile">
    <img src="https://coveralls.io/repos/github/mfarhanz1/siptatif-mobile/badge.svg" alt="Coverage Status" />
  </a>

</div>

---

[underconstruction]: https://img.shields.io/badge/Status-WIP-FFFF00?style=for-the-badge&logoColor=FFFF00

## ✨ Apasih Neo-SIPTATIF Itu? ✨  // ✧˚ ༘ ⋆｡♡˚ ![underconstruction][underconstruction]

**Neo-SIPTATIF** merupakan versi mobile dari [SIPTATIF Web Based](https://github.com/mfarhanz1/siptatif) yang telah saya kembangkan sebelumnya, untuk saat ini, aplikasi Neo-SIPTATIF masih diperuntukan khususnya bagi role Koordinator TA, **SIPTATIF** sendiri merupakan singkatan dari _Sistem Informasi Pendaftaran Tugas Akhir Teknik Infomatika_, aplikasi ini dibangun untuk memfasilitasi proses pendaftaran judul tugas akhir khususnya bagi mahasiswa program studi Teknik Informatika dikampus [Universitas Islam Negeri Sultan Syarif Kasim Riau](https://www.uin-suska.ac.id/), aplikasi ini juga dikembangkan untuk membantu kinerja koordinator tugas akhir dalam mengelola data dosen penguji, dosen pembimbing, dan status pendaftaran TA mahasiswa.

## ⚙️ Before You Begin
Before you begin we recommend you read about the basic building blocks that assemble a Dart mobile native application with Flutter Framework, Node.js, Express, and PostgreSQL:
* Flutter Framework - Start with the [Flutter Official Website.](https://flutter.dev/) The Getting Started guide is very helpful.
* Dart Programming Language - Visit the [Dart Official Website.](https://dart.dev/) The Dart Language Tour is a great place to start.
* Node.js - Begin with the [Node.js Official Website](http://nodejs.org/) and refer to this [StackOverflow Thread](http://stackoverflow.com/questions/2353818/how-do-i-get-started-with-node-js) for additional resources.
* Express - Understand Express through its [Official Website](http://expressjs.com/), which includes a [Getting Started](http://expressjs.com/starter/installing.html) guide and an [ExpressJS Guide](http://expressjs.com/en/guide/routing.html) for general topics. You can also explore this [StackOverflow Thread](http://stackoverflow.com/questions/8144214/learning-express-for-node-js) for more resources.
* PostgreSQL - Go through the [PostgreSQL Official Website](https://www.postgresql.org/), and proceed to the [Documentation](https://www.postgresql.org/docs/) to better understand PostgreSQL.

## 📝 Prerequisites
Make sure you have installed all of the following prerequisites on your development machine:
* Git - [Download & Install Git](https://git-scm.com/downloads). OSX and Linux machines typically have this already installed.
* Node.js - [Download & Install Node.js](https://nodejs.org/en/download/) and the npm package manager. If you encounter any problems, you can also use this [GitHub Gist](https://gist.github.com/isaacs/579814) to install Node.js.
* PostgreSQL - [Download & Install PostgreSQL](https://www.postgresql.org/download/), and make sure it's running on the default port (5432).

## 🚀 Fitur Utama SIPTATIF

Aplikasi ini dirancang untuk memudahkan koordinator tugas akhir serta mahasiswa dalam mengelola berbagai aspek penting dari proses tugas akhir. Berikut adalah fitur-fitur utama yang disediakan:

**Bagi Aktor Koordinator TA:**
- Manajemen Dosen Penguji: Tambahkan atau perbarui data dosen penguji, termasuk kuota yang tersedia untuk setiap dosen.
- Manajemen Dosen Pembimbing: Kelola atau tambahkan informasi dosen pembimbing yang akan terlibat dalam proses tugas akhir, termasuk kuota yang tersedia.
- Pengelolaan Data Mahasiswa, Meliputi: Periksa data mahasiswa, termasuk kelengkapan berkas yang telah diunggah, Berikan catatan atau feedback kepada mahasiswa terkait kekeliruan atau kekurangan berkas, Tetapkan status pendaftaran tugas akhir mahasiswa, apakah ditolak atau diterima.
- Semisal koordinator ta menyetujui pengajuan TA mahasiswa, koordinator TA pun berhak menetapkan siapa penguji 1 dan penguji 2 bagi mahasiswa tersebut, lalu bisa di revisi nantinya jika penguji terkait berhalangan

## 👣 Skenario Penggunaan

Sebelumnya disini saya menggunakan metode API security dengan JWT Access Token, serta JWT Refresh Token, dimana, saat user login, backend akan mengembalikan JSON accessToken + refreshToken yang pada aplikasi mobile kami ini disimpan di SecureStorage keduanya sebagai pengganti LocalStorage dan Cookies yang tak tersedia di mobile. Nah, kami juga menggunakan DIO Api Client agar mempermudah kami memasang interceptor dalam upaya melakukan percobaan pembuatan access token baru ketika ada request gagal dengan refresh token yang telah tersimpan di secure storage juga sebelumnya.

**Berikut skenario sederhana jika kita login sebagai aktor koordinator TA:**
- Role Admin Prodi yang terdapat di [SIPTATIF Web Based](https://github.com/mfarhanz1/siptatif) akan melakukan pemberian jabatan atau wewenang terhadap suatu dosen.
- Lalu, backend akan otomatis menjalankan procedure yang telah dibuat di-database, yang mana output akhirnya akan membuatkan akun dengan email beserta nidn sebagai password defaultnya
- Setelah mendapatkan akun, Koordinator TA pun dapat melakukan reset password default yang telah ditetapkan sebelumnya untuk alasan keamanan
- Login: Masuk menggunakan akun koordinator tugas akhir.
- Manajemen Dosen Penguji: Tambahkan atau perbarui data dosen penguji, seperti kuota yang tersedia.
- Manajemen Dosen Pembimbing: Kelola atau tambahkan informasi dosen pembimbing yang akan terlibat dalam proses tugas akhir, seperti kuota yang akan tersedia.
- Pengelolaan Data Mahasiswa: Periksa data mahasiswa (berupa kelengkapan berkas dan lain sebagainya), Anda juga dapat memberikan catatan kepada mahasiswa terkait jika terdapat kekeliruan perihal berkas menurut anda, terakhir anda dapat memberikan status pendaftaran TA mahasiswa, apakah ditolak atau diterima.

## 🤝 Kontribusi
Kontribusi sangatlah penting karena memberikan kesempatan untuk belajar dan mendapatkan inspirasi dari proyek ini. Setiap kontribusi yang kamu berikan **sangat dihargai.**

Jika kamu memiliki saran untuk meningkatkan proyek ini, kamu bisa melakukan fork dan membuat pull request, atau membuat issue baru untuk mendiskusikan perubahan yang diinginkan. Jangan lupa berikan bintang ya! Terima kasih!

## 📙 License
[AGPL 3.0 Coverage](LICENSE.md)  // ✧˚ ༘ ⋆｡♡˚ 
[![License](https://img.shields.io/github/license/mfarhanz1/siptatif.svg)](https://github.com/mfarhanz1/siptatif-mobile/blob/master/LICENSE)
