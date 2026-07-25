# 📐 RULES — Aturan Pengembangan Aplikasi Inventaris Sekolah

Dokumen ini adalah **aturan wajib** bagi siapa pun (manusia atau AI coding agent)
yang berkontribusi ke proyek ini. Jika ada instruksi task yang bertentangan dengan
dokumen ini, dokumen ini yang menang — konfirmasi dulu ke pemilik proyek sebelum menyimpang.

---

## 1. Tech Stack (tidak boleh diganti tanpa persetujuan)

| Layer | Teknologi | Catatan |
|---|---|---|
| Backend | Laravel 11.x, PHP 8.2+ | REST API only, tidak render Blade view untuk data aplikasi |
| Auth | Laravel Sanctum | Cookie-based SPA auth, bukan token Bearer manual |
| Database | MySQL 8.0+ | **Bukan** PostgreSQL — DDL & trigger sudah final dalam dialek MySQL |
| Frontend | Next.js 14+ (App Router) | TypeScript wajib, bukan JavaScript murni |
| Styling | Tailwind CSS | Hindari CSS custom terpisah kecuali benar-benar perlu |
| HTTP Client | Axios | `withCredentials: true` wajib untuk Sanctum |
| Data fetching FE | TanStack Query (React Query) | Hindari `useEffect` + `fetch` manual untuk data server |
| Form FE | react-hook-form + zod | Validasi client-side selalu mirror validasi server-side |

---

## 2. Aturan Skema Database — TIDAK BOLEH DILANGGAR

1. **`kode_barang` HANYA di-generate oleh trigger `trg_before_insert_barang`.**
   Aplikasi (Controller/Service) tidak pernah mengirim atau menghitung nilai ini
   secara manual. Field ini tidak muncul di form input tambah barang.
2. **`stok_total` adalah GENERATED COLUMN** (`stok_baik + stok_rusak`). Jangan pernah
   di-assign lewat Eloquent `$fillable` atau query `UPDATE ... SET stok_total = ...`.
3. **Perubahan `stok_baik`/`stok_rusak` HANYA lewat 2 jalur resmi:**
   - Mutasi barang yang statusnya berubah menjadi `Approved`.
   - Laporan kerusakan yang statusnya berubah menjadi `Approved`.
   Endpoint CRUD Barang (`PUT /api/barang/{id}`) **dilarang** mengubah kedua kolom ini.
4. **Audit trail (`tbl_audit_stok`) tidak boleh di-insert manual dari Controller.**
   Trigger `trg_after_update_barang_stok` yang bertanggung jawab, dipicu otomatis
   saat `UPDATE tbl_barang` terjadi. Service yang memicu perubahan stok wajib
   men-set session variable `@audit_ref_table`, `@audit_ref_id`, `@audit_jenis`
   **sebelum** query `UPDATE tbl_barang` dijalankan, agar trigger mencatat konteks
   yang benar.
5. **`kode_role` bersifat baku** (`KEPSEK`, `SARPRAS`, `KATU`, `KAPRODI`). Penambahan
   role baru boleh dilakukan lewat data (insert baris baru di `tbl_roles`), bukan
   lewat perubahan struktur tabel `tbl_users`.
6. **Soft-delete untuk `tbl_barang`** dilakukan dengan mengubah `status_aktif` menjadi
   `'Dihapus'`, bukan `DELETE` fisik — riwayat mutasi/kerusakan/audit terkait barang
   harus tetap dapat ditelusuri.
7. **Referensi polimorfik `tbl_audit_stok`** (`referensi_tabel` + `referensi_id`)
   sengaja tidak memiliki FK fisik. Jangan tambahkan FK constraint ke kolom ini —
   integritas dijaga di level trigger, ini keputusan desain sadar, bukan bug.

---

## 3. Konvensi Backend (Laravel)

### Penamaan
- **Model**: singular, `PascalCase` → `Barang`, `MutasiBarang` (walau nama tabel
  `tbl_barang`, `tbl_mutasi_barang`). Set `protected $table` eksplisit di setiap model.
- **Controller**: `PascalCase` + suffix `Controller` → `BarangController`, taruh di
  `app/Http/Controllers/Api/` (khusus master data di subfolder `Master/`).
- **Method controller REST standar**: `index`, `store`, `show`, `update`, `destroy`.
- **Custom action** (di luar CRUD, misal alur approval): kata kerja jelas dalam
  Bahasa Indonesia sesuai domain bisnis → `ajukan()`, `verifikasiSarpras()`,
  `approvalKepsek()`, `verifikasi()`.
- **Route URL**: `kebab-case` → `/api/laporan-kerusakan`, `/api/mutasi/{id}/ajukan`.
- **Migration file**: `snake_case` deskriptif → `create_tbl_barang_table`.

### Struktur Logika
- **Business logic kompleks wajib di Service class** (`app/Services/`), bukan di
  Controller. Controller hanya orkestrasi tipis: terima request → panggil service →
  kembalikan resource.
- **Validasi input wajib pakai Form Request class**, tidak boleh validasi inline
  `$request->validate([...])` di controller untuk endpoint yang sudah punya Request
  class terdaftar.
- **Response API wajib pakai API Resource class**, format konsisten `{"data": ...}`
  untuk single resource dan pagination default Laravel untuk list.
- **Otorisasi per role wajib pakai Policy class**, dipanggil via `$this->authorize()`
  di controller — jangan taruh pengecekan `if ($user->role === 'KATU')` tersebar
  di banyak tempat.
- Query yang perlu di-scope per lokasi (khusus Ka.Prodi) ditaruh di method
  reusable pada model/service, bukan diduplikasi di setiap controller.

### Error Handling
- `QueryException` dari trigger `SIGNAL` (SQLSTATE `45000`) wajib ditangkap dan
  dipetakan ke response `422` dengan pesan yang jelas, bukan dibiarkan bocor jadi
  `500` dengan stack trace SQL mentah.
- Buat custom Exception class untuk kasus bisnis spesifik (misal
  `FotoLampiranBelumLengkapException`) dan daftarkan handler-nya di
  `app/Exceptions/Handler.php`.

### Komentar Kode
- Beri komentar singkat **hanya** di bagian kompleks/tidak obvious: state machine,
  raw SQL, penanganan trigger, session variable audit.
- Jangan komentari kode yang sudah self-explanatory (misal `// ambil user` di atas
  `$user = auth()->user();`).

---

## 4. Konvensi Frontend (Next.js)

- **Komponen**: `PascalCase.tsx` → `BarangTable.tsx`, `MutasiStatusBadge.tsx`.
- **Hook custom**: `camelCase` prefix `use` → `useAuth.ts`, `useRoleGuard.ts`.
- **Service/API wrapper**: `kebab-case.service.ts` per domain → `laporan-kerusakan.service.ts`.
- **Route folder** (App Router): `kebab-case` mengikuti URL → `app/(dashboard)/laporan-kerusakan/`.
- **Type/interface**: `PascalCase`, dikelompokkan per domain di `src/types/*.d.ts`.
- Semua pemanggilan API lewat `src/services/*.service.ts`, komponen tidak boleh
  `axios.get()` langsung — memudahkan mock saat testing dan konsistensi error handling.
- Data server (dari API) selalu lewat React Query (`useQuery`/`useMutation`), bukan
  `useState` + `useEffect` manual.
- UI yang menampilkan aksi kontekstual (tombol approve/reject) **wajib** cek role
  user dari `useAuth()` sebelum render tombol — jangan andalkan API sebagai satu-satunya
  lapisan otorisasi (defense in depth, tapi backend tetap sumber kebenaran akhir).

---

## 5. Aturan Alur Bisnis (State Machine)

### Mutasi Barang
- Transisi valid **hanya**: `Draft → Pending → Approved`, `Draft → Pending → Pending
  (Kepsek) → Approved`, atau `→ Rejected` dari tahap `Pending` manapun.
- Dilarang: transisi langsung `Draft → Approved` (harus melalui verifikasi Sarpras),
  atau approval Kepsek dieksekusi sebelum Sarpras menyetujui.
- `butuh_approval_kepsek` ditentukan aplikasi (bukan trigger) berdasarkan aturan
  nilai/kuantitas aset yang disepakati tim produk — dokumentasikan threshold-nya
  begitu ditentukan.

### Laporan Kerusakan
- Transisi `Draft → Pending` **wajib divalidasi** minimal 3 jenis foto berbeda
  (`Tampak Depan`, `Tampak Samping`, `Detail Kerusakan`) sudah terunggah — validasi
  ini sengaja ada di trigger DB (`trg_before_update_laporan_validasi_foto`) sebagai
  lapisan terakhir, meski frontend/backend juga harus validasi di awal untuk UX
  yang baik (fail fast, jangan andalkan trigger sebagai satu-satunya validasi).
- Field `verifikator_id` dan `tanggal_verifikasi` hanya diisi Sarpras saat aksi
  `verifikasi()`, tidak boleh diisi user lain.

---

## 6. Keamanan

- Password **wajib** di-hash pakai `Hash::make()` bawaan Laravel (bcrypt/argon2),
  tidak pernah disimpan atau di-log plaintext.
- `APP_DEBUG=false` di production — dilarang commit `.env` production ke Git.
- CORS (`config/cors.php`) hanya mengizinkan domain frontend resmi, dilarang
  `allowed_origins => ['*']` di production.
- Setiap endpoint yang mengubah data wajib melalui middleware `auth:sanctum` +
  Policy/role check — tidak ada endpoint "telanjang" tanpa otorisasi selain
  `login` dan `csrf-cookie`.

---

## 7. Git & Version Control

- Commit message format: `<tipe>: <deskripsi singkat>` — tipe: `feat`, `fix`,
  `chore`, `refactor`, `docs`, `test`. Contoh: `feat: tambah endpoint verifikasi mutasi sarpras`.
- File `.env`, `.env.local`, `vendor/`, `node_modules/` **wajib** masuk `.gitignore`,
  tidak pernah di-commit.
- Migration yang sudah di-push/dijalankan di environment bersama **tidak boleh
  diedit ulang** — buat migration baru untuk perubahan skema lanjutan.

---

## 8. Larangan Eksplisit untuk AI Coding Agent

Saat menggunakan AI agent (Claude Code atau lainnya) di proyek ini, AI **dilarang**:

1. Membuat ulang logika generate `kode_barang` di application layer.
2. Mengubah `stok_baik`/`stok_rusak` langsung dari endpoint selain alur mutasi/laporan
   kerusakan yang approved.
3. Menghapus/mengubah trigger DB tanpa instruksi eksplisit dan pemahaman dampaknya
   ke `tbl_audit_stok`.
4. Mengganti dialek DDL dari MySQL ke SQL engine lain.
5. Melewati Form Request/Policy demi "mempercepat" implementasi endpoint.
6. Melakukan hard delete pada `tbl_barang` (harus soft-delete via `status_aktif`).

Jika sebuah task tampak mengharuskan salah satu di atas, AI harus berhenti dan
menanyakan konfirmasi eksplisit ke developer, bukan langsung mengeksekusi.
