# 🗄️ SCHEMA — Skema Database Aplikasi Inventaris Sekolah

**DBMS: MySQL 8.0+** (memanfaatkan `GENERATED COLUMN`, `CHECK CONSTRAINT`, `SIGNAL`)

> DDL lengkap (siap `CREATE TABLE`) dan kode trigger penuh ada di dokumen sumber
> *"Arsitektur Database — Aplikasi Inventaris Sekolah"* bagian D & E. File ini adalah
> **referensi ringkas** struktur, relasi, dan aturan tiap tabel untuk kebutuhan
> sehari-hari development (bikin model, nulis query, review PR).

---

## 1. Entity Relationship Diagram (ringkas)

```
tbl_roles ─┬──< tbl_users >──┬── tbl_lokasi
           │                  │
           │                  ├──< tbl_barang >── tbl_kategori_dana
           │                  │        │      └── tbl_kategori_barang
           │                  │        │
           │                  │        └── (self FK) barang_asal_id → lineage mutasi
           │                  │
           │                  ├──< tbl_mutasi_barang >──< tbl_mutasi_detail >── tbl_barang
           │                  │        │
           │                  │        └──< tbl_mutasi_approval >── tbl_roles
           │                  │
           │                  ├──< tbl_laporan_kerusakan >──< tbl_lampiran_kerusakan
           │                  │        └── tbl_barang, tbl_lokasi
           │                  │
           │                  └──< tbl_log_aktivitas

tbl_kategori_dana ─┬──< tbl_penomoran_kode >── tbl_lokasi   (counter atomik kode_barang)
tbl_barang ──< tbl_audit_stok   (riwayat perubahan stok, referensi polimorfik)
```

> Diagram Mermaid.js lengkap dengan kardinalitas tersedia di dokumen arsitektur
> sumber bagian A — tempel ke [mermaid.live](https://mermaid.live) untuk visualisasi interaktif.

---

## 2. Daftar Tabel & Fungsinya

| Tabel | Fungsi | Tipe |
|---|---|---|
| `tbl_roles` | Master 4 peran pengguna | Master |
| `tbl_users` | Akun pengguna sistem | Master |
| `tbl_lokasi` | Prodi / Unit Kerja / Gudang | Master |
| `tbl_kategori_dana` | Sumber dana (BOS, KMT) | Master |
| `tbl_kategori_barang` | Jenis barang (Elektronik, Mebeulair, ATK) | Master |
| `tbl_penomoran_kode` | Counter atomik untuk generate `kode_barang` | Helper |
| `tbl_barang` | Data & stok barang inventaris | Transaksional |
| `tbl_mutasi_barang` | Header pengajuan mutasi/serah-terima | Transaksional |
| `tbl_mutasi_detail` | Item barang dalam satu mutasi | Transaksional |
| `tbl_mutasi_approval` | Tahapan approval mutasi (Sarpras/Kepsek) | Transaksional |
| `tbl_laporan_kerusakan` | Laporan kerusakan barang | Transaksional |
| `tbl_lampiran_kerusakan` | Foto bukti kerusakan (3 jenis wajib) | Transaksional |
| `tbl_audit_stok` | Riwayat semua perubahan stok | Log |
| `tbl_log_aktivitas` | Jejak aktivitas sistem (keamanan) | Log |

---

## 3. Detail Kolom Kunci per Tabel

### `tbl_roles`
| Kolom | Tipe | Catatan |
|---|---|---|
| id | INT PK AI | |
| kode_role | VARCHAR(20) UNIQUE | `KEPSEK`, `SARPRAS`, `KATU`, `KAPRODI` |
| nama_role | VARCHAR(50) | |

### `tbl_users`
| Kolom | Tipe | Catatan |
|---|---|---|
| id | BIGINT PK AI | |
| nip_nik | VARCHAR(30) UNIQUE, NULL | |
| username | VARCHAR(50) UNIQUE | |
| password_hash | VARCHAR(255) | bcrypt/argon2, **jangan pernah plaintext** |
| role_id | INT FK → tbl_roles | |
| lokasi_id | INT FK → tbl_lokasi, NULL | Diisi khusus Ka.Prodi; NULL untuk role lintas-lokasi |
| status_aktif | ENUM('Aktif','Nonaktif') | |

### `tbl_lokasi`
| Kolom | Tipe | Catatan |
|---|---|---|
| kode_lokasi | VARCHAR(10) UNIQUE | cth: `RPL`, `TKJ`, `TU`, `GDG` |
| jenis_lokasi | ENUM('Prodi','Unit Kerja','Gudang') | |

### `tbl_barang` ⭐ (tabel paling kritikal)
| Kolom | Tipe | Catatan |
|---|---|---|
| id | BIGINT PK AI | |
| kode_barang | VARCHAR(30) UNIQUE | **Auto-generate trigger**, format `[DANA]-[LOKASI]-[NNN]` |
| kategori_dana_id | INT FK | |
| kategori_barang_id | INT FK | |
| lokasi_id | INT FK | Lokasi **saat ini** |
| barang_asal_id | BIGINT FK → tbl_barang, NULL | Self-reference, lineage hasil mutasi |
| stok_baik | INT, CHECK ≥ 0 | |
| stok_rusak | INT, CHECK ≥ 0 | |
| stok_total | INT **GENERATED ALWAYS AS** (stok_baik + stok_rusak) STORED | Read-only, jangan di-assign manual |
| kondisi_umum | ENUM('Baik','Rusak Ringan','Rusak Berat') | |
| status_aktif | ENUM('Aktif','Non-Aktif','Dihapus') | Soft-delete pakai `'Dihapus'` |
| created_by | BIGINT FK → tbl_users | |

### `tbl_penomoran_kode` (helper counter)
| Kolom | Tipe | Catatan |
|---|---|---|
| kategori_dana_id + lokasi_id | UNIQUE gabungan | Satu counter per kombinasi dana+lokasi |
| nomor_terakhir | INT | Di-increment trigger via `ON DUPLICATE KEY UPDATE` |

### `tbl_mutasi_barang`
| Kolom | Tipe | Catatan |
|---|---|---|
| no_mutasi | VARCHAR(30) UNIQUE | cth: `MUT-2026-0001` |
| lokasi_asal_id / lokasi_tujuan_id | INT FK, CHECK ≠ | |
| butuh_approval_kepsek | BOOLEAN | Ditentukan aplikasi (bukan trigger), berdasar nilai/kuantitas |
| status | ENUM('Draft','Pending','Approved','Rejected') | State machine |

### `tbl_mutasi_detail`
| Kolom | Tipe | Catatan |
|---|---|---|
| mutasi_id | FK → tbl_mutasi_barang, `ON DELETE CASCADE` | |
| barang_id | FK → tbl_barang | |
| jumlah | INT, CHECK > 0 | |

### `tbl_mutasi_approval`
| Kolom | Tipe | Catatan |
|---|---|---|
| mutasi_id + urutan_approval | UNIQUE gabungan | `1` = Sarpras, `2` = Kepsek |
| approver_role_id | FK → tbl_roles | |
| approver_id | FK → tbl_users, NULL | Diisi saat approval dieksekusi |
| status | ENUM('Menunggu','Approved','Rejected') | |

### `tbl_laporan_kerusakan`
| Kolom | Tipe | Catatan |
|---|---|---|
| no_laporan | VARCHAR(30) UNIQUE | |
| barang_id, lokasi_id | FK | |
| jumlah_rusak | INT, CHECK > 0 | |
| status | ENUM('Draft','Pending','Approved','Rejected') | |
| verifikator_id | FK → tbl_users, NULL | Diisi Sarpras saat verifikasi |

### `tbl_lampiran_kerusakan`
| Kolom | Tipe | Catatan |
|---|---|---|
| laporan_id | FK → tbl_laporan_kerusakan, `ON DELETE CASCADE` | |
| jenis_foto | ENUM('Tampak Depan','Tampak Samping','Detail Kerusakan') | Wajib 3 jenis berbeda sebelum ajukan |
| file_path | VARCHAR(255) | |

### `tbl_audit_stok`
| Kolom | Tipe | Catatan |
|---|---|---|
| barang_id | FK → tbl_barang | Satu-satunya FK fisik di tabel ini |
| jenis_transaksi | ENUM('Barang Baru','Mutasi Masuk','Mutasi Keluar','Kerusakan','Perbaikan','Penyesuaian Manual') | |
| referensi_tabel, referensi_id | VARCHAR/BIGINT, **tanpa FK fisik** | Referensi polimorfik, integritas dijaga trigger |
| stok_sebelum, stok_sesudah, jumlah_perubahan | INT | Snapshot `stok_total` sebelum/sesudah |

### `tbl_log_aktivitas`
| Kolom | Tipe | Catatan |
|---|---|---|
| user_id | FK → tbl_users, NULL | NULL jika aktivitas sistem/anonim |
| aktivitas | VARCHAR(255) | cth: "Login", "Ubah Master Kategori" |
| alamat_ip | VARCHAR(45) | |

---

## 4. Ringkasan Trigger

| Trigger | Event | Fungsi |
|---|---|---|
| `trg_before_insert_barang` | `BEFORE INSERT tbl_barang` | Generate `kode_barang` otomatis dari counter `tbl_penomoran_kode` |
| `trg_after_update_barang_stok` | `AFTER UPDATE tbl_barang` | Insert `tbl_audit_stok` generik, baca session var `@audit_ref_*` |
| `trg_after_update_mutasi_approved` | `AFTER UPDATE tbl_mutasi_barang` | Saat status → `Approved`: kurangi stok asal, buat barang baru di lokasi tujuan |
| `trg_before_update_laporan_validasi_foto` | `BEFORE UPDATE tbl_laporan_kerusakan` | Tolak (`SIGNAL 45000`) transisi Draft→Pending jika foto < 3 jenis |
| `trg_after_update_laporan_kerusakan_stok` | `AFTER UPDATE tbl_laporan_kerusakan` | Saat status → `Approved`: pindahkan `stok_baik → stok_rusak` |

**Rantai eksekusi:** trigger sumber (mutasi/laporan) men-set `@audit_ref_table`,
`@audit_ref_id`, `@audit_jenis` sesaat sebelum `UPDATE tbl_barang` → memicu
`trg_after_update_barang_stok` yang mencatat audit dengan referensi akurat tanpa
duplikasi logika di tiap trigger sumber.

---

## 5. Index yang Sudah Didefinisikan

```sql
idx_users_role, idx_users_lokasi
idx_barang_lokasi, idx_barang_dana, idx_barang_kategori, idx_barang_status
idx_mutasi_status, idx_mutasi_tanggal
idx_mutasidetail_barang
idx_laporan_status, idx_laporan_barang
idx_lampiran_laporan
idx_audit_barang, idx_audit_created
```

Tambahkan index baru sesuai kebutuhan query production (misal composite index
`(lokasi_id, status_aktif)` di `tbl_barang` jika dashboard sering filter kombinasi
keduanya) — evaluasi lewat `EXPLAIN` sebelum menambah, hindari index berlebihan.

---

## 6. Constraint Penting (CHECK)

```sql
-- tbl_barang
CHECK (stok_baik >= 0 AND stok_rusak >= 0)

-- tbl_mutasi_barang
CHECK (lokasi_asal_id <> lokasi_tujuan_id)

-- tbl_mutasi_detail
CHECK (jumlah > 0)

-- tbl_laporan_kerusakan
CHECK (jumlah_rusak > 0)
```

---

## 7. Mapping ke Eloquent Model

| Tabel | Model | `$table` |
|---|---|---|
| tbl_roles | `Role` | `tbl_roles` |
| tbl_users | `User` | `tbl_users` |
| tbl_lokasi | `Lokasi` | `tbl_lokasi` |
| tbl_kategori_dana | `KategoriDana` | `tbl_kategori_dana` |
| tbl_kategori_barang | `KategoriBarang` | `tbl_kategori_barang` |
| tbl_penomoran_kode | `PenomoranKode` | `tbl_penomoran_kode` |
| tbl_barang | `Barang` | `tbl_barang` |
| tbl_mutasi_barang | `MutasiBarang` | `tbl_mutasi_barang` |
| tbl_mutasi_detail | `MutasiDetail` | `tbl_mutasi_detail` |
| tbl_mutasi_approval | `MutasiApproval` | `tbl_mutasi_approval` |
| tbl_laporan_kerusakan | `LaporanKerusakan` | `tbl_laporan_kerusakan` |
| tbl_lampiran_kerusakan | `LampiranKerusakan` | `tbl_lampiran_kerusakan` |
| tbl_audit_stok | `AuditStok` | `tbl_audit_stok` |
| tbl_log_aktivitas | `LogAktivitas` | `tbl_log_aktivitas` |

> Karena nama tabel memakai prefix `tbl_` dan tidak mengikuti konvensi plural
> default Laravel, **setiap model wajib** mendeklarasikan `protected $table` secara eksplisit.

---

## 8. Catatan Migrasi Skema (Laravel Limitation)

Laravel Schema Builder **tidak punya API native** untuk:
- `GENERATED ALWAYS AS (...) STORED` → gunakan `DB::statement()` setelah `Schema::create()`.
- `TRIGGER` + `SIGNAL` → gunakan `DB::unprepared()` di migration khusus, baca dari
  file `.sql` terpisah (`database/sql/triggers.sql`) agar mudah di-review.

Lihat contoh implementasi lengkap di `01-PANDUAN-INSTALASI.md` bagian 3.4–3.5.

---

## 9. Referensi Terkait

- `ARCHITECTURE.md` — bagaimana skema ini dipakai di alur aplikasi (rantai trigger, dsb).
- `RULES.md` — aturan wajib yang menjaga integritas skema ini tidak dilanggar oleh kode aplikasi.
- Dokumen sumber *"Arsitektur Database — Aplikasi Inventaris Sekolah"* — DDL & trigger lengkap siap `CREATE TABLE`.
