<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        DB::statement("
            CREATE TRIGGER trg_before_insert_barang
            BEFORE INSERT ON tbl_barang
            FOR EACH ROW
            BEGIN
                DECLARE v_kode_dana VARCHAR(10);
                DECLARE v_kode_lokasi VARCHAR(10);
                DECLARE v_nomor INT;

                SELECT kode_dana INTO v_kode_dana FROM tbl_kategori_dana WHERE id = NEW.kategori_dana_id;
                SELECT kode_lokasi INTO v_kode_lokasi FROM tbl_lokasi WHERE id = NEW.lokasi_id;

                INSERT INTO tbl_penomoran_kode (kategori_dana_id, lokasi_id, nomor_terakhir, created_at, updated_at)
                VALUES (NEW.kategori_dana_id, NEW.lokasi_id, 1, NOW(), NOW())
                ON DUPLICATE KEY UPDATE nomor_terakhir = nomor_terakhir + 1, updated_at = NOW();

                SELECT nomor_terakhir INTO v_nomor FROM tbl_penomoran_kode
                WHERE kategori_dana_id = NEW.kategori_dana_id AND lokasi_id = NEW.lokasi_id;

                SET NEW.kode_barang = CONCAT(v_kode_dana, '-', v_kode_lokasi, '-', LPAD(v_nomor, 3, '0'));
            END
        ");

        DB::statement("
            CREATE TRIGGER trg_after_update_barang_stok
            AFTER UPDATE ON tbl_barang
            FOR EACH ROW
            BEGIN
                IF OLD.stok_baik <> NEW.stok_baik OR OLD.stok_rusak <> NEW.stok_rusak THEN
                    INSERT INTO tbl_audit_stok (
                        barang_id, jenis_transaksi,
                        referensi_tabel, referensi_id,
                        stok_sebelum, stok_sesudah, jumlah_perubahan,
                        created_at
                    ) VALUES (
                        NEW.id,
                        COALESCE(@audit_jenis, 'Penyesuaian Manual'),
                        @audit_ref_table,
                        @audit_ref_id,
                        OLD.stok_baik + OLD.stok_rusak,
                        NEW.stok_baik + NEW.stok_rusak,
                        (NEW.stok_baik + NEW.stok_rusak) - (OLD.stok_baik + OLD.stok_rusak),
                        NOW()
                    );

                    SET @audit_ref_table = NULL;
                    SET @audit_ref_id = NULL;
                    SET @audit_jenis = NULL;
                END IF;
            END
        ");

        DB::statement("
            CREATE TRIGGER trg_after_update_mutasi_approved
            AFTER UPDATE ON tbl_mutasi_barang
            FOR EACH ROW
            BEGIN
                DECLARE done INT DEFAULT FALSE;
                DECLARE v_barang_id BIGINT;
                DECLARE v_jumlah INT;
                DECLARE v_kategori_dana_id INT;
                DECLARE v_kategori_barang_id INT;
                DECLARE v_nama_barang VARCHAR(200);
                DECLARE v_spesifikasi TEXT;
                DECLARE v_created_by BIGINT;
                DECLARE cur CURSOR FOR
                    SELECT md.barang_id, md.jumlah
                    FROM tbl_mutasi_detail md
                    WHERE md.mutasi_id = NEW.id;
                DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

                IF OLD.status <> 'Approved' AND NEW.status = 'Approved' THEN
                    SET @audit_ref_table = 'tbl_mutasi_barang';
                    SET @audit_ref_id = NEW.id;
                    SET @audit_jenis = 'Mutasi Keluar';

                    OPEN cur;

                    read_loop: LOOP
                        FETCH cur INTO v_barang_id, v_jumlah;
                        IF done THEN
                            LEAVE read_loop;
                        END IF;

                        UPDATE tbl_barang
                        SET stok_baik = stok_baik - v_jumlah
                        WHERE id = v_barang_id;

                        SELECT kategori_dana_id, kategori_barang_id, nama_barang, spesifikasi, created_by
                        INTO v_kategori_dana_id, v_kategori_barang_id, v_nama_barang, v_spesifikasi, v_created_by
                        FROM tbl_barang WHERE id = v_barang_id;

                        INSERT INTO tbl_barang (
                            kode_barang, kategori_dana_id, kategori_barang_id,
                            lokasi_id, barang_asal_id, nama_barang, spesifikasi,
                            stok_baik, stok_rusak, kondisi_umum, status_aktif, created_by
                        ) VALUES (
                            '', v_kategori_dana_id, v_kategori_barang_id,
                            NEW.lokasi_tujuan_id, v_barang_id, v_nama_barang, v_spesifikasi,
                            v_jumlah, 0, 'Baik', 'Aktif', v_created_by
                        );
                    END LOOP;

                    CLOSE cur;

                    SET @audit_ref_table = NULL;
                    SET @audit_ref_id = NULL;
                    SET @audit_jenis = NULL;
                END IF;
            END
        ");

        DB::statement("
            CREATE TRIGGER trg_before_update_laporan_validasi_foto
            BEFORE UPDATE ON tbl_laporan_kerusakan
            FOR EACH ROW
            BEGIN
                DECLARE v_jumlah_foto INT;

                IF OLD.status = 'Draft' AND NEW.status = 'Pending' THEN
                    SELECT COUNT(DISTINCT jenis_foto) INTO v_jumlah_foto
                    FROM tbl_lampiran_kerusakan
                    WHERE laporan_id = NEW.id;

                    IF v_jumlah_foto < 3 THEN
                        SIGNAL SQLSTATE '45000'
                        SET MESSAGE_TEXT = 'Laporan kerusakan harus memiliki minimal 3 jenis foto (Tampak Depan, Tampak Samping, Detail Kerusakan) sebelum diajukan';
                    END IF;
                END IF;
            END
        ");

        DB::statement("
            CREATE TRIGGER trg_after_update_laporan_kerusakan_stok
            AFTER UPDATE ON tbl_laporan_kerusakan
            FOR EACH ROW
            BEGIN
                IF OLD.status <> 'Approved' AND NEW.status = 'Approved' THEN
                    SET @audit_ref_table = 'tbl_laporan_kerusakan';
                    SET @audit_ref_id = NEW.id;
                    SET @audit_jenis = 'Kerusakan';

                    UPDATE tbl_barang
                    SET stok_baik = stok_baik - NEW.jumlah_rusak,
                        stok_rusak = stok_rusak + NEW.jumlah_rusak
                    WHERE id = NEW.barang_id;
                END IF;
            END
        ");
    }

    public function down(): void
    {
        DB::statement('DROP TRIGGER IF EXISTS trg_before_insert_barang');
        DB::statement('DROP TRIGGER IF EXISTS trg_after_update_barang_stok');
        DB::statement('DROP TRIGGER IF EXISTS trg_after_update_mutasi_approved');
        DB::statement('DROP TRIGGER IF EXISTS trg_before_update_laporan_validasi_foto');
        DB::statement('DROP TRIGGER IF EXISTS trg_after_update_laporan_kerusakan_stok');
    }
};
