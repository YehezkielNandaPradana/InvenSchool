# 📋 PRD — Aplikasi Inventaris Sekolah

| | |
|---|---|
| **Versi Dokumen** | 1.0 |
| **Status** | Draft — siap development |
| **Pemilik Produk** | Tim Sarpras / TU Sekolah |

---

## 1. Latar Belakang & Masalah

Sekolah saat ini mencatat inventaris barang (elektronik, mebeulair, ATK, dsb.)
secara manual atau lewat spreadsheet terpisah per unit kerja/prodi. Masalah yang
timbul:

- Tidak ada **satu sumber data** yang akurat soal jumlah & kondisi barang per lokasi.
- Perpindahan barang antar prodi/unit (mutasi) tidak tercatat rapi — sering terjadi
  barang "hilang" secara administratif walau fisiknya masih ada.
- Laporan kerusakan tidak terverifikasi dengan bukti foto, menyulitkan validasi klaim.
- Tidak ada jejak audit (siapa mengubah apa, kapan) untuk pertanggungjawaban ke
  Kepala Sekolah maupun saat audit dana BOS/Komite.

## 2. Tujuan Produk

1. Menyediakan **pencatatan barang terpusat** dengan kode unik otomatis per sumber
   dana & lokasi.
2. Menyediakan **alur serah-terima (mutasi) barang** yang formal, dengan approval
   berjenjang sesuai nilai/skala aset.
3. Menyediakan **alur pelaporan kerusakan** yang terverifikasi (wajib bukti foto).
4. Menghasilkan **audit trail otomatis** atas setiap perubahan stok untuk keperluan
   rekap dan pertanggungjawaban.
5. Membatasi akses fitur sesuai **peran** masing-masing pengguna.

## 3. Target Pengguna & Peran

| Peran | Deskripsi | Kebutuhan Utama |
|---|---|---|
| **Kepala Sekolah (Kepsek)** | Pimpinan tertinggi, lintas-lokasi | Monitoring global, approval akhir mutasi besar & laporan tahunan |
| **Sarpras** | Penanggung jawab sarana-prasarana, lintas-lokasi | Verifikasi mutasi tahap 1, verifikasi laporan kerusakan, rekap sarpras |
| **Ka.TU (Kepala Tata Usaha)** | Admin data induk, lintas-lokasi | CRUD master data (user, lokasi, kategori dana, kategori barang), kelola akun |
| **Ka.Prodi (Kepala Program Studi)** | Penanggung jawab 1 lokasi/prodi | Input barang, ajukan mutasi, laporkan kerusakan barang di prodinya |

## 4. Ruang Lingkup Fitur (In Scope)

### 4.1 Autentikasi & Otorisasi
- Login berbasis username + password.
- Sesi per role dengan pembatasan akses fitur (RBAC).
- Ka.Prodi terikat ke satu `lokasi_id`; role lain lintas-lokasi.

### 4.2 Master Data (khusus Ka.TU)
- CRUD Roles (baku, jarang berubah), Lokasi, Kategori Dana, Kategori Barang, Users.

### 4.3 Manajemen Barang
- Tambah barang baru dengan **kode_barang auto-generate**
  (`[KODE_DANA]-[KODE_LOKASI]-[NOMOR 3 digit]`, contoh `BOS-RPL-001`).
- Kode bersifat historis/tetap, tidak berubah walau barang pindah lokasi.
- Tracking `stok_baik`, `stok_rusak`, dan `stok_total` (otomatis terhitung).
- Riwayat perubahan stok per barang (audit trail).

### 4.4 Mutasi / Serah Terima Barang
- Ka.Prodi membuat pengajuan mutasi (draft) berisi daftar barang + lokasi tujuan.
- Alur persetujuan bertingkat:
  1. Sarpras verifikasi (wajib, semua mutasi).
  2. Jika mutasi tergolong besar (`butuh_approval_kepsek = true`), lanjut ke
     approval Kepsek.
- Saat disetujui final: stok berpindah otomatis, tercatat sebagai entri barang
  baru di lokasi tujuan dengan **jejak asal (lineage)** ke barang sumber.
- Penolakan di tahap manapun tidak mengubah stok.

### 4.5 Laporan Kerusakan
- Ka.Prodi membuat laporan kerusakan untuk barang di prodinya.
- **Wajib** unggah 3 jenis foto (Tampak Depan, Tampak Samping, Detail Kerusakan)
  sebelum laporan bisa diajukan — sistem menolak pengajuan jika belum lengkap.
- Sarpras memverifikasi (approve/reject).
- Saat disetujui: kuantitas dipindah dari `stok_baik` ke `stok_rusak`
  (total stok tidak berubah, hanya rekategorisasi kondisi).

### 4.6 Audit & Rekapitulasi
- Setiap perubahan stok (dari mutasi maupun laporan kerusakan) otomatis tercatat
  dengan referensi transaksi sumbernya.
- Rekap bulanan/tahunan per jenis transaksi.
- Log aktivitas sistem (login, perubahan master data, dsb.) untuk jejak keamanan.

### 4.7 Dashboard
- Ringkasan total barang, stok baik/rusak, jumlah mutasi & laporan yang menunggu
  aksi, ter-scope sesuai role (Ka.Prodi hanya lihat lokasinya).

## 5. Di Luar Ruang Lingkup (Out of Scope) — Fase 1

- Barcode/QR code scanning fisik.
- Integrasi dengan sistem keuangan sekolah (SIMDA/SIPLah).
- Aplikasi mobile native (fase 1 fokus web responsif).
- Approval via notifikasi WhatsApp/email (fase 1 cukup in-app).
- Multi-sekolah/multi-tenant (fase 1 untuk 1 sekolah).

## 6. Alur Kerja Utama (User Journey Ringkas)

**Mutasi barang:**
```
Ka.Prodi buat draft mutasi
   → ajukan → Pending (Sarpras)
      → Sarpras approve
         → jika perlu → Pending (Kepsek) → Kepsek approve → Approved (stok pindah)
         → jika tidak perlu → langsung Approved (stok pindah)
      → Sarpras/Kepsek reject di tahap manapun → Rejected (stok tidak berubah)
```

**Laporan kerusakan:**
```
Ka.Prodi buat draft laporan → upload 3 foto wajib
   → ajukan (ditolak sistem jika foto < 3 jenis) → Pending
      → Sarpras approve → Approved (stok_baik → stok_rusak)
      → Sarpras reject → Rejected
```

## 7. Kebutuhan Non-Fungsional

| Aspek | Kebutuhan |
|---|---|
| **Keamanan** | Password ter-hash (bcrypt/argon2), tidak pernah plaintext; akses API dibatasi per role |
| **Integritas Data** | Perubahan stok hanya lewat alur resmi (mutasi/laporan approved), dijaga trigger DB, bukan hanya validasi aplikasi |
| **Auditabilitas** | Semua perubahan stok tercatat dengan referensi transaksi sumber (polimorfik) |
| **Skalabilitas peran** | Penambahan role baru (mis. "Bendahara") tidak boleh butuh migrasi skema besar |
| **Ketersediaan** | Target uptime wajar untuk aplikasi internal sekolah (bukan sistem kritikal 24/7) |
| **Kompatibilitas** | Browser modern (Chrome, Edge, Firefox versi 2 tahun terakhir), responsif di tablet/desktop |

## 8. Metrik Keberhasilan

- 100% barang baru memiliki `kode_barang` valid tanpa duplikasi.
- 0 kasus stok berubah tanpa jejak di `tbl_audit_stok`.
- Waktu rata-rata proses approval mutasi (dari diajukan sampai final) terukur
  dan dapat direkap per bulan.
- Laporan kerusakan yang diajukan tanpa lampiran lengkap = 0% (dicegah sistem).

## 9. Risiko & Mitigasi

| Risiko | Mitigasi |
|---|---|
| User salah pilih lokasi tujuan mutasi | Validasi `lokasi_asal_id <> lokasi_tujuan_id` di DB & aplikasi |
| Trigger DB gagal saat migrasi ke hosting shared/managed MySQL yang membatasi trigger | Pastikan provider hosting mendukung `TRIGGER` & `SIGNAL` sebelum deploy; dokumentasikan sebagai prasyarat infrastruktur |
| Foto lampiran kerusakan tidak representatif | Wajib 3 sudut foto berbeda, divalidasi jenis fotonya (bukan hanya jumlah) |
| Ka.Prodi mengajukan mutasi/laporan untuk barang di luar lokasinya | Otorisasi di level Policy + scope query berdasarkan `lokasi_id` user |

## 10. Referensi Teknis

Detail skema database, arsitektur sistem, dan aturan implementasi lihat:
- `ARCHITECTURE.md`
- `SCHEMA.md`
- `RULES.md`
