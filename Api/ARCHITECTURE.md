# 🏗️ ARCHITECTURE — Aplikasi Inventaris Sekolah

## 1. Gambaran Umum

Arsitektur **terpisah (decoupled)**: backend REST API dan frontend SPA/SSR
berjalan sebagai dua aplikasi independen, berkomunikasi lewat HTTP/JSON.

```
┌─────────────────────┐        HTTPS / JSON         ┌──────────────────────┐
│   Next.js Frontend   │ ───────────────────────────▶│   Laravel REST API    │
│   (App Router + TW)  │ ◀─────────────────────────── │   (PHP 8.2+)          │
│   localhost:3000     │      Sanctum Cookie Auth     │   127.0.0.1:8000       │
└─────────────────────┘                              └──────────┬───────────┘
                                                                  │
                                                                  │ Eloquent / SQL
                                                                  ▼
                                                       ┌──────────────────────┐
                                                       │   MySQL 8.0+           │
                                                       │   Triggers + Generated │
                                                       │   Columns + Constraints│
                                                       └──────────────────────┘
```

**Prinsip kunci:** sebagian aturan integritas data (kode barang, audit stok,
validasi foto laporan kerusakan) **sengaja ditegakkan di level database** lewat
trigger, bukan hanya di application layer. Ini memberi lapisan pertahanan kedua
(defense in depth) — bahkan jika ada bug di service Laravel, database tetap
menolak state yang tidak valid.

---

## 2. Lapisan Backend (Laravel)

```
Request masuk
   │
   ▼
Middleware (auth:sanctum, role:XXX)
   │
   ▼
Form Request (validasi input)
   │
   ▼
Controller (orkestrasi tipis)
   │
   ▼
Policy (otorisasi aksi spesifik terhadap resource)
   │
   ▼
Service (business logic: state machine, kalkulasi, orkestrasi multi-model)
   │
   ▼
Model / Eloquent  ──────▶  MySQL (trigger bereaksi otomatis di sini)
   │
   ▼
API Resource (transformasi response JSON)
   │
   ▼
Response ke client
```

### Tanggung jawab per layer

| Layer | Tanggung Jawab | Contoh |
|---|---|---|
| Middleware | Autentikasi & pembatasan role kasar (siapa boleh menyentuh route ini sama sekali) | `auth:sanctum`, `role:KATU` |
| Form Request | Validasi bentuk & tipe data input | `jumlah` harus integer > 0 |
| Controller | Terima request, panggil service, kembalikan resource — **tanpa logika bisnis** | `MutasiBarangController::ajukan()` |
| Policy | Otorisasi granular terhadap resource spesifik (pemilik, scope lokasi) | KaProdi hanya boleh ajukan mutasi miliknya sendiri |
| Service | Logika bisnis kompleks: state transition, validasi lintas-tabel, orkestrasi | `MutasiBarangService::verifikasiSarpras()` |
| Model | Representasi tabel + relasi, tanpa logika bisnis berat | `Barang::belongsTo(Lokasi::class)` |
| Trigger (DB) | Integritas terakhir: generate kode, audit trail, validasi keras | `trg_before_insert_barang` |
| API Resource | Bentuk response konsisten, sembunyikan kolom internal jika perlu | `BarangResource` |

---

## 3. Lapisan Frontend (Next.js)

```
Page (App Router)
   │
   ▼
Custom Hook (useAuth, useBarang, dst — bungkus React Query)
   │
   ▼
Service (*.service.ts — panggilan Axios ke API)
   │
   ▼
Axios instance (src/lib/axios.ts, withCredentials + interceptor)
   │
   ▼
Laravel REST API
```

Komponen UI (`components/`) **tidak pernah** memanggil `axios` langsung — selalu
lewat hook yang membungkus service, agar caching (React Query), loading state,
dan error handling konsisten di seluruh aplikasi.

---

## 4. Alur Autentikasi (Sanctum SPA Cookie-Based)

```
1. Frontend GET  /sanctum/csrf-cookie   → set cookie XSRF-TOKEN
2. Frontend POST /api/login             → set cookie session (httpOnly)
3. Setiap request berikutnya            → cookie otomatis terlampir (withCredentials)
4. Backend cek sesi via middleware auth:sanctum
5. Frontend GET /api/me                 → ambil data user + role + lokasi untuk RBAC UI
```

> Dipilih cookie-based (bukan token Bearer manual) karena frontend adalah SPA
> first-party yang berjalan di domain yang dikonfigurasi sebagai
> `SANCTUM_STATEFUL_DOMAINS` — lebih aman dari eksposur token di `localStorage`.

---

## 5. Alur Data — Mutasi Barang (Rantai Trigger)

```
KaProdi: POST /api/mutasi (Draft)
   │
   ▼
KaProdi: POST /api/mutasi/{id}/ajukan
   │  Service: status → Pending, buat tbl_mutasi_approval urutan 1 (Sarpras)
   ▼
Sarpras: POST /api/mutasi/{id}/verifikasi-sarpras {status: Approved}
   │
   ├─ butuh_approval_kepsek = false
   │     │  Service: UPDATE tbl_mutasi_barang SET status='Approved'
   │     ▼
   │  Trigger DB: trg_after_update_mutasi_approved
   │     │  - Kurangi stok_baik barang asal
   │     │  - INSERT barang baru di lokasi tujuan (barang_asal_id = lineage)
   │     │  - Trigger kode_barang baru otomatis jalan (trg_before_insert_barang)
   │     ▼
   │  UPDATE tbl_barang (stok berubah) → Trigger trg_after_update_barang_stok
   │     │  - INSERT tbl_audit_stok (baca @audit_ref_table/@audit_ref_id/@audit_jenis
   │     │    yang di-set Service sebelum UPDATE)
   │     ▼
   │  Response 200 ke Sarpras
   │
   └─ butuh_approval_kepsek = true
         │  Service: buat tbl_mutasi_approval urutan 2 (Kepsek), status TETAP Pending
         ▼
      Kepsek: POST /api/mutasi/{id}/approval-kepsek {status: Approved}
         │  Service: UPDATE tbl_mutasi_barang SET status='Approved'
         ▼
      (lanjut ke rantai trigger yang sama seperti di atas)
```

**Poin penting arsitektural:** Service Laravel **tidak pernah** menulis langsung
ke `tbl_audit_stok`. Service hanya men-set session variable MySQL
(`@audit_ref_table`, `@audit_ref_id`, `@audit_jenis`) tepat sebelum `UPDATE tbl_barang`,
lalu trigger generik `trg_after_update_barang_stok` yang membaca variabel tersebut
dan mencatat audit dengan referensi yang akurat. Ini menghindari duplikasi logika
insert-audit di setiap Service sumber (mutasi, laporan kerusakan, dst).

---

## 6. Alur Data — Laporan Kerusakan

```
KaProdi: POST /api/laporan-kerusakan (Draft)
   │
   ▼
KaProdi: POST /api/laporan-kerusakan/{id}/lampiran  (x3, jenis foto berbeda)
   │
   ▼
KaProdi: POST /api/laporan-kerusakan/{id}/ajukan
   │
   ▼
Trigger DB: trg_before_update_laporan_validasi_foto (BEFORE UPDATE)
   │
   ├─ foto < 3 jenis → SIGNAL SQLSTATE 45000 → QueryException di Laravel
   │                     → Service tangkap, lempar FotoLampiranBelumLengkapException
   │                     → Handler → response 422 ke frontend
   │
   └─ foto lengkap → UPDATE lanjut, status → Pending
         │
         ▼
      Sarpras: POST /api/laporan-kerusakan/{id}/verifikasi {status: Approved}
         │  Service: set @audit_ref_*, UPDATE tbl_barang
         │  (stok_baik -= jumlah_rusak, stok_rusak += jumlah_rusak)
         ▼
      Trigger trg_after_update_laporan_kerusakan_stok →
      Trigger trg_after_update_barang_stok → INSERT tbl_audit_stok
```

---

## 7. Deployment Architecture (Rekomendasi)

```
┌──────────────┐      ┌──────────────────┐      ┌─────────────────┐
│  Vercel /     │      │  VPS / Cloud       │      │  Managed MySQL   │
│  Next.js host │─────▶│  (Laravel + Nginx  │─────▶│  (mendukung       │
│  (frontend)   │      │  + PHP-FPM)         │      │  TRIGGER & SIGNAL)│
└──────────────┘      └──────────────────┘      └─────────────────┘
```

> **Syarat wajib hosting database:** provider MySQL managed harus mengizinkan
> pembuatan `TRIGGER` dan penggunaan `SIGNAL` (beberapa shared-hosting murah
> membatasi ini). Verifikasi sebelum memilih provider produksi.

Komponen tambahan yang disarankan untuk produksi:
- **Queue worker** (Laravel Queue) jika volume upload foto/notifikasi bertambah,
  agar upload tidak memblokir request.
- **Object storage** (S3-compatible) untuk `tbl_lampiran_kerusakan.file_path`
  alih-alih local disk, agar tahan restart/scaling horizontal.
- **Backup terjadwal** database mengingat trigger & generated column adalah
  bagian integral skema — backup harus mencakup struktur, bukan hanya data.

---

## 8. Keputusan Desain & Trade-off

| Keputusan | Alasan | Trade-off yang Diterima |
|---|---|---|
| Trigger DB untuk kode_barang & audit stok | Integritas terjamin walau ada bug di app layer / multi-writer | Logika bisnis tersebar antara PHP dan SQL, butuh dokumentasi ekstra |
| Referensi polimorfik di `tbl_audit_stok` (tanpa FK fisik) | Fleksibel mencatat log lintas-tabel (mutasi, kerusakan, dll) dari satu tabel | Integritas referensial dijaga di trigger, bukan constraint DB — perlu disiplin saat menambah sumber transaksi baru |
| Mutasi membuat **entri barang baru** di lokasi tujuan (bukan update `lokasi_id` in-place) | Menjaga lineage/jejak asal sesuai praktik BAST/KIB sekolah | Jumlah baris `tbl_barang` bertambah seiring mutasi — perlu strategi query yang scoped ke barang aktif saat menampilkan "stok saat ini" |
| Sanctum cookie-based, bukan token Bearer | Lebih aman untuk SPA first-party, hindari token di localStorage | Frontend & backend harus satu keluarga domain (stateful domains), sedikit lebih rumit untuk mobile app di fase depan |
| Role disimpan di tabel terpisah (`tbl_roles`), bukan ENUM di `tbl_users` | Tambah role baru tanpa migrasi skema | Query butuh join tambahan dibanding ENUM langsung (trade-off minor) |

---

## 9. Referensi Terkait

- `SCHEMA.md` — detail struktur tabel, kolom, dan trigger.
- `RULES.md` — aturan implementasi wajib yang menegakkan arsitektur ini.
- `PRD.md` — kebutuhan bisnis yang melatarbelakangi keputusan arsitektur.
