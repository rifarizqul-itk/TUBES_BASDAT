-- ================================================================
-- FINAL DATABASE TOKO LIFTING & RIGGING (FULL 44 NOTA)
-- ================================================================
-- PERINGATAN: Script ini akan mereset database 'visualisasi'
-- Pastikan tidak ada data penting lain sebelum dijalankan.
-- ================================================================

DROP DATABASE IF EXISTS visualisasi;
CREATE DATABASE visualisasi;
USE visualisasi;

-- ================================================================
-- 1. STRUKTUR TABEL (DDL)
-- ================================================================

CREATE TABLE karyawan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_lengkap VARCHAR(100) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    peran VARCHAR(50) NOT NULL
);

CREATE TABLE pelanggan (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    alamat VARCHAR(255),
    no_telepon VARCHAR(20),
    dibuat_pada TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE barang (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_barang VARCHAR(100) NOT NULL,
    satuan VARCHAR(20),
    harga_estimasi DECIMAL(15, 2) DEFAULT 0,
    stok_tersedia INT DEFAULT 0
);

CREATE TABLE metode_pembayaran (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_metode VARCHAR(50) NOT NULL,
    nomor_rekening VARCHAR(50)
);

CREATE TABLE transaksi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pelanggan_id INT,
    karyawan_id INT,
    tanggal DATE,
    total_tagihan DECIMAL(15, 2) DEFAULT 0,
    total_dibayar DECIMAL(15, 2) DEFAULT 0,
    sisa_tagihan DECIMAL(15, 2) DEFAULT 0,
    status_pembayaran VARCHAR(20), -- 'Lunas', 'Belum Lunas'
    FOREIGN KEY (pelanggan_id) REFERENCES pelanggan(id),
    FOREIGN KEY (karyawan_id) REFERENCES karyawan(id)
);

CREATE TABLE detail_transaksi (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transaksi_id INT,
    barang_id INT,
    jumlah INT,
    harga_satuan DECIMAL(15, 2),
    subtotal DECIMAL(15, 2),
    FOREIGN KEY (transaksi_id) REFERENCES transaksi(id),
    FOREIGN KEY (barang_id) REFERENCES barang(id)
);

CREATE TABLE riwayat_pembayaran (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transaksi_id INT,
    karyawan_id INT,
    metode_pembayaran_id INT,
    tanggal_bayar TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    jumlah_bayar DECIMAL(15, 2),
    keterangan VARCHAR(255),
    FOREIGN KEY (transaksi_id) REFERENCES transaksi(id)
);

-- ================================================================
-- 2. DATA MASTER (KARYAWAN, PELANGGAN, BARANG)
-- ================================================================

INSERT INTO karyawan (nama_lengkap, username, password, peran) VALUES 
('Admin Gudang', 'admin', 'admin123', 'Admin'),
('Kasir Depan', 'kasir', 'kasir123', 'Kasir');

INSERT INTO metode_pembayaran (nama_metode, nomor_rekening) VALUES 
('Tunai', '-'), 
('Transfer BCA', '888-123-456'), 
('Transfer Mandiri', '123-456-789');

INSERT INTO pelanggan (nama, alamat, no_telepon) VALUES 
('Bpk Yusuf', 'Balikpapan', '0852-4659-9994'), -- 1
('Tuan Tol', 'Samarinda', '0811-9988-7766'),   -- 2
('CV Maju Teknik', 'Samarinda', '0813-4444-5555'), -- 3
('Bengkel Las Abadi', 'Penajam', '0812-3333-2222'), -- 4
('UD Andika Jaya', 'Priok', '021-43904112'), -- 5
('PT Global Penta', 'Jakarta', '0812-9990-9098'), -- 6
('Tuan Andi', 'Semayang', '0811-5555-6666'), -- 7
('PT Borneo Rigging', 'Balikpapan', '0811-2323-4444'), -- 8
('Tuan Tariyono', 'Jakarta', '0812-9490-9098'), -- 9
('Bpk Hartono', 'Balikpapan', '0813-5555-8888'), -- 10
('Toko Besi Sejahtera', 'Balikpapan', '0852-1111-2222'), -- 11
('Bpk Aji', 'Balikpapan', '0812-1234-5678'); -- 12

INSERT INTO barang (nama_barang, satuan, harga_estimasi) VALUES 
-- [1-10] Rantai & Wire Rope
('Rantai 10mm', 'Meter', 61000), 
('Rantai 13mm', 'Meter', 120000),
('Rantai 16mm', 'Meter', 170000),
('Rantai 20mm', 'Meter', 320000),
('Rantai 6 1/2', 'Meter', 110000),
('Rantai 3/8', 'Meter', 68000),
('Rantai Baja 5/8', 'Meter', 310000),
('Seling 6mm', 'Meter', 7500),
('Seling 8mm', 'Meter', 10000),
('Seling 10mm', 'Meter', 13500),
-- [11-20] Seling & Webbing
('Seling 12mm', 'Meter', 19000),
('Seling 14mm', 'Meter', 25000),
('Seling 1" (25mm)', 'Meter', 140000),
('Webbing 1T x 1.5m', 'Pcs', 35000),
('Webbing 2T x 3m', 'Pcs', 95000),
('Webbing 2T x 4m', 'Pcs', 110000),
('Webbing 2T x 6m', 'Pcs', 160000),
('Webbing 3T x 3m', 'Pcs', 135000),
('Webbing 3T x 4m', 'Pcs', 170000),
('Webbing 3T x 6m', 'Pcs', 250000),
-- [21-30] Webbing & Sabuk
('Webbing 3T x 8m', 'Pcs', 500000),
('Webbing 5T x 6m', 'Pcs', 550000), -- Harga variatif
('Webbing 5T x 8m', 'Pcs', 400000),
('Webbing 8T x 6m', 'Pcs', 950000),
('Webbing 20T x 8m', 'Pcs', 2000000),
('Sabuk 7m', 'Pcs', 70000),
('Sabuk 8m', 'Pcs', 135000),
('Sabuk 10m', 'Pcs', 120000),
('Trek Belt 8m', 'Pcs', 135000),
('Trek Belt 12m', 'Pcs', 130000),
-- [31-40] Trek Belt & Hardware
('Trek Belt 15m', 'Pcs', 150000),
('Track Bell (Set)', 'Set', 215000),
('Round Sling 40T x 8m', 'Unit', 7700000),
('Hook 5/16', 'Pcs', 18000),
('Hook 3/8', 'Pcs', 30000),
('Hook 1/2', 'Pcs', 70000),
('Hook 3 Ton', 'Pcs', 90000),
('Hook 5 Ton', 'Pcs', 150000),
('Grab Hook 3/8', 'Pcs', 30000),
('Clevis Hook 3T', 'Pcs', 125000),
-- [41-50] Hardware
('Hammer Lock 3/8', 'Pcs', 55000),
('Hammer Lock 1/2', 'Pcs', 90000),
('Hammer Lock 8mm', 'Pcs', 45000),
('Kancip 3/8', 'Pcs', 250000),
('Kancip 1/2', 'Pcs', 270000),
('Rachet Binder 1/2', 'Pcs', 400000),
('Rachet Tie Down', 'Pcs', 370000),
('Kuku Macan 1/2', 'Pcs', 2500),
('Kuku Macan 10mm', 'Pcs', 2000),
('Kuku Macan 15mm', 'Pcs', 2500),
-- [51-60] Lain-lain
('Segel 20 Ton', 'Pcs', 100000),
('Segel 25 Ton', 'Pcs', 500000),
('Connecting Link 20mm', 'Pcs', 250000),
('Chain Block 5 Ton', 'Unit', 2000000),
('Chain Block 10 Ton', 'Unit', 5000000),
('Sling Mata 8M', 'Pcs', 500000),
('Sparepart Alat Berat (Paket)', 'Collie', 5000000),
('Jasa Sambung', 'Jasa', 150000),
('Ongkos Kirim/Bus', 'Jasa', 300000),
('Mesin Grinda 5"', 'Unit', 500000),
-- [61-65] Tambahan Tools
('Mesin Grinda 7"', 'Unit', 600000),
('Bor Krisbow', 'Unit', 300000),
('Slang Pemadam', 'Rol', 1100000),
('Turnbuckle (Jarum Keras)', 'Pcs', 25000),
('Clamp Krosbi', 'Pcs', 60000);

-- ================================================================
-- 3. INPUT 44 TRANSAKSI (33 REAL + 11 SIMULASI)
-- ================================================================

-- 1. Surat Jalan Global Penta (WA0027) - 80 Juta
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (6, 1, '2024-07-10', 80000000, 0, 80000000, 'Belum Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 57, 13, 6153846, 80000000);

-- 2. Tuan Tol (IMG..5510) - 650rb
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (2, 2, '2025-03-02', 650000, 650000, 0, 'Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 2, 5, 100000, 500000), (LAST_INSERT_ID(), 58, 1, 150000, 150000);

-- 3. Tuan Tol (IMG..5808) - 12.550.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (2, 2, '2025-08-31', 12550000, 6000000, 6550000, 'Belum Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 55, 2, 5000000, 10000000), (LAST_INSERT_ID(), 54, 1, 2000000, 2000000), (LAST_INSERT_ID(), 59, 1, 300000, 300000), (LAST_INSERT_ID(), 59, 1, 250000, 250000);

-- 4. Tuan Tol (IMG..5829) - 775.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (2, 2, '2025-09-01', 775000, 775000, 0, 'Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 11, 1, 350000, 350000), (LAST_INSERT_ID(), 12, 17, 25000, 425000);

-- 5. UD Andika (WA0011) - 29.338.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (5, 1, '2024-05-15', 29338000, 10000000, 19338000, 'Belum Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 9, 1000, 10000, 10000000), (LAST_INSERT_ID(), 27, 20, 135000, 2700000), (LAST_INSERT_ID(), 33, 1, 7700000, 7700000), (LAST_INSERT_ID(), 10, 384, 9500, 3648000), (LAST_INSERT_ID(), 26, 58, 80000, 4640000), (LAST_INSERT_ID(), 14, 20, 35000, 700000);

-- 6. Bengkel Las (WA0022) - 34.346.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (4, 1, '2024-04-20', 34346000, 34346000, 0, 'Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 11, 1000, 19000, 19000000), (LAST_INSERT_ID(), 9, 1052, 7500, 7890000), (LAST_INSERT_ID(), 19, 20, 170000, 3400000), (LAST_INSERT_ID(), 38, 10, 150000, 1500000), (LAST_INSERT_ID(), 34, 147, 18000, 2646000);

-- 7. UD Andika (WA0024) - 51.150.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (5, 1, '2024-03-01', 51150000, 25000000, 26150000, 'Belum Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 11, 1000, 19000, 19000000), (LAST_INSERT_ID(), 8, 1000, 7500, 7500000), (LAST_INSERT_ID(), 45, 20, 270000, 5400000), (LAST_INSERT_ID(), 44, 30, 250000, 7500000), (LAST_INSERT_ID(), 27, 20, 135000, 2700000), (LAST_INSERT_ID(), 37, 45, 90000, 4050000), (LAST_INSERT_ID(), 20, 20, 250000, 5000000);

-- 8. PT Global Penta (WA0012) - 70.200.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (6, 1, '2024-01-15', 70200000, 0, 70200000, 'Belum Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 3, 300, 170000, 51000000), (LAST_INSERT_ID(), 22, 48, 300000, 14400000), (LAST_INSERT_ID(), 23, 12, 400000, 4800000);

-- 9. Tuan Andi (WA0014) - 50.745.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (7, 1, '2024-03-05', 50745000, 50745000, 0, 'Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 5, 200, 110000, 22000000), (LAST_INSERT_ID(), 10, 1000, 13000, 13000000), (LAST_INSERT_ID(), 45, 20, 270000, 5400000), (LAST_INSERT_ID(), 35, 200, 30000, 6000000), (LAST_INSERT_ID(), 18, 7, 135000, 945000), (LAST_INSERT_ID(), 19, 20, 170000, 3400000);

-- 10. Tuan Tol (WA0025) - 59.990.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (2, 2, '2024-02-10', 59990000, 10000000, 49990000, 'Belum Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 9, 1000, 10000, 10000000), (LAST_INSERT_ID(), 1, 300, 61000, 18300000), (LAST_INSERT_ID(), 4, 50, 300000, 15000000), (LAST_INSERT_ID(), 46, 90, 70000, 6300000), (LAST_INSERT_ID(), 53, 18, 250000, 4500000);

-- 11. UD Andika (WA0013) - 59.280.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (5, 2, '2024-02-15', 59280000, 59280000, 0, 'Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 6, 300, 68000, 20400000), (LAST_INSERT_ID(), 39, 100, 30000, 3000000), (LAST_INSERT_ID(), 15, 25, 95000, 2375000), (LAST_INSERT_ID(), 17, 18, 160000, 2880000), (LAST_INSERT_ID(), 18, 15, 135000, 2025000), (LAST_INSERT_ID(), 44, 40, 250000, 10000000), (LAST_INSERT_ID(), 45, 10, 270000, 2700000), (LAST_INSERT_ID(), 38, 20, 150000, 3000000), (LAST_INSERT_ID(), 41, 20, 55000, 1100000), (LAST_INSERT_ID(), 42, 20, 90000, 1800000), (LAST_INSERT_ID(), 9, 1000, 10000, 10000000);

-- 12. CV Maju Teknik (WA0008) - 63.000.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (3, 1, '2024-02-01', 63000000, 30000000, 33000000, 'Belum Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 2, 200, 120000, 24000000), (LAST_INSERT_ID(), 11, 500, 19000, 9500000), (LAST_INSERT_ID(), 10, 1000, 14500, 14500000), (LAST_INSERT_ID(), 22, 6, 800000, 4800000), (LAST_INSERT_ID(), 36, 70, 70000, 4900000), (LAST_INSERT_ID(), 48, 1000, 2500, 2500000), (LAST_INSERT_ID(), 49, 500, 2000, 1000000), (LAST_INSERT_ID(), 37, 20, 90000, 1800000);

-- 13. Tuan Tol (WA0018) - 58.990.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (2, 2, '2024-02-20', 58990000, 58990000, 0, 'Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 1, 300, 66000, 19800000), (LAST_INSERT_ID(), 35, 500, 27000, 13500000), (LAST_INSERT_ID(), 9, 2000, 10000, 20000000), (LAST_INSERT_ID(), 42, 30, 90000, 2700000), (LAST_INSERT_ID(), 27, 23, 130000, 2990000);

-- 14. Tuan Tariyono (WA0029) - 58.100.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (9, 1, '2024-03-01', 58100000, 20000000, 38100000, 'Belum Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 9, 1000, 10000, 10000000), (LAST_INSERT_ID(), 1, 300, 61000, 18300000), (LAST_INSERT_ID(), 4, 50, 320000, 16000000), (LAST_INSERT_ID(), 46, 20, 270000, 5400000), (LAST_INSERT_ID(), 20, 24, 225000, 5400000), (LAST_INSERT_ID(), 53, 12, 250000, 3000000);

-- 15. Tuan Andi (WA0023) - 43.050.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (7, 1, '2024-03-15', 43050000, 10000000, 33050000, 'Belum Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 10, 1000, 14500, 14500000), (LAST_INSERT_ID(), 1, 300, 61000, 18300000), (LAST_INSERT_ID(), 39, 30, 75000, 2250000), (LAST_INSERT_ID(), 25, 4, 2000000, 8000000);

-- 16. Bpk Yusuf (WA0009) - 36.000.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (1, 1, '2024-04-01', 36000000, 0, 36000000, 'Belum Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 10, 1000, 13500, 13500000), (LAST_INSERT_ID(), 1, 300, 61000, 18300000), (LAST_INSERT_ID(), 26, 60, 70000, 4200000);

-- 17. Bengkel Las (WA0021) - 34.490.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (4, 1, '2024-04-10', 34490000, 10000000, 24490000, 'Belum Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 8, 1000, 7500, 7500000), (LAST_INSERT_ID(), 45, 10, 270000, 2700000), (LAST_INSERT_ID(), 44, 10, 250000, 2500000), (LAST_INSERT_ID(), 16, 24, 110000, 2640000), (LAST_INSERT_ID(), 42, 30, 90000, 2700000), (LAST_INSERT_ID(), 41, 80, 55000, 4400000), (LAST_INSERT_ID(), 30, 50, 130000, 6500000), (LAST_INSERT_ID(), 31, 10, 150000, 1500000), (LAST_INSERT_ID(), 29, 30, 135000, 4050000);

-- 18. PT Global Penta (WA0010) - 26.947.500
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (6, 1, '2024-06-01', 26947500, 10000000, 16947500, 'Belum Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 44, 50, 250000, 12500000), (LAST_INSERT_ID(), 35, 100, 30000, 3000000), (LAST_INSERT_ID(), 40, 30, 60000, 1800000), (LAST_INSERT_ID(), 9, 479, 7500, 3592500), (LAST_INSERT_ID(), 10, 388, 10000, 3880000), (LAST_INSERT_ID(), 11, 145, 15000, 2175000);

-- 19. Bpk Yusuf (WA0019) - 20.560.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (1, 2, '2024-06-10', 20560000, 20560000, 0, 'Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 18, 12, 135000, 1620000), (LAST_INSERT_ID(), 19, 12, 170000, 2040000), (LAST_INSERT_ID(), 20, 10, 250000, 2500000), (LAST_INSERT_ID(), 38, 35, 150000, 5250000), (LAST_INSERT_ID(), 44, 7, 150000, 1050000), (LAST_INSERT_ID(), 45, 20, 270000, 5400000), (LAST_INSERT_ID(), 27, 20, 135000, 2700000);

-- 20. PT Borneo Rigging (WA0016) - 64.600.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (8, 1, '2024-06-15', 64600000, 0, 64600000, 'Belum Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 1, 600, 66000, 39600000), (LAST_INSERT_ID(), 45, 100, 250000, 25000000);

-- 21. Bpk Yusuf (WA0017 - Surat Jalan 9 Koli)
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (1, 2, '2024-07-01', 45000000, 45000000, 0, 'Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 3, 200, 170000, 34000000), (LAST_INSERT_ID(), 22, 20, 350000, 7000000), (LAST_INSERT_ID(), 16, 25, 160000, 4000000);

-- 22. Tuan Tariyono (WA0020 - Surat Jalan 11 Koli)
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (9, 1, '2024-07-05', 60000000, 20000000, 40000000, 'Belum Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 1, 400, 61000, 24400000), (LAST_INSERT_ID(), 9, 2000, 10000, 20000000), (LAST_INSERT_ID(), 44, 62, 250000, 15600000);

-- 23. Tuan Tol (IMG..5516) - 15.500.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (2, 2, '2025-05-02', 15500000, 10000000, 5500000, 'Belum Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 7, 50, 310000, 15500000);

-- 24. Tuan Tol (IMG..5530) - 10.100.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (2, 2, '2025-06-04', 10100000, 5000000, 5100000, 'Belum Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 13, 30, 140000, 4200000), (LAST_INSERT_ID(), 52, 6, 500000, 3000000), (LAST_INSERT_ID(), 24, 2, 950000, 1900000), (LAST_INSERT_ID(), 21, 2, 500000, 1000000);

-- 25. Tuan Tol (IMG..5541) - 5.000.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (2, 2, '2025-06-18', 5000000, 5000000, 0, 'Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 8, 300, 12500, 3750000), (LAST_INSERT_ID(), 12, 50, 25000, 1250000);

-- 26. Tuan Tol (IMG..5454) - 4.055.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (2, 1, '2025-04-25', 4055000, 4055000, 0, 'Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 1, 18, 110000, 1980000), (LAST_INSERT_ID(), 53, 4, 50000, 200000), (LAST_INSERT_ID(), 32, 7, 215000, 1505000), (LAST_INSERT_ID(), 47, 1, 370000, 370000);

-- 27. Tuan Tol (IMG..5524) - 2.380.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (2, 2, '2025-09-22', 2380000, 2380000, 0, 'Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 7, 13, 100000, 1300000), (LAST_INSERT_ID(), 8, 12, 90000, 1080000);

-- 28. Tuan Tol (IMG..5536) - 2.300.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (2, 2, '2025-06-18', 2300000, 2300000, 0, 'Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 16, 5, 180000, 900000), (LAST_INSERT_ID(), 19, 5, 280000, 1400000);

-- 29. Tuan Tol (IMG..5501) - 600.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (2, 2, '2025-06-03', 600000, 600000, 0, 'Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 19, 2, 300000, 600000);

-- 30. Tuan Tol (IMG..5510) - 650.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (2, 2, '2025-05-02', 650000, 650000, 0, 'Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 1, 5, 100000, 500000), (LAST_INSERT_ID(), 58, 1, 150000, 150000);

-- 31. Tuan Tol (IMG..5611) - 12.220.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (2, 2, '2025-06-11', 12220000, 12220000, 0, 'Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 16, 2, 200000, 400000), (LAST_INSERT_ID(), 22, 2, 550000, 1100000), (LAST_INSERT_ID(), 25, 1, 1500000, 1500000), (LAST_INSERT_ID(), 1, 40, 100000, 4000000), (LAST_INSERT_ID(), 35, 8, 50000, 400000), (LAST_INSERT_ID(), 46, 4, 400000, 1600000);

-- 32. Tuan Tol (IMG..5750) - 6.600.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (2, 2, '2025-08-20', 6600000, 6600000, 0, 'Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 1, 100, 60000, 6000000), (LAST_INSERT_ID(), 53, 8, 50000, 400000);

-- 33. Tuan Tol (IMG..5716) - 4.870.000
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES (2, 2, '2025-01-10', 4870000, 2000000, 2870000, 'Belum Lunas');
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES (LAST_INSERT_ID(), 32, 15, 250000, 3750000), (LAST_INSERT_ID(), 20, 1, 370000, 370000), (LAST_INSERT_ID(), 47, 2, 375000, 750000);

-- [34-44] TRANSAKSI TAMBAHAN (RECURRING - PENGULANGAN POLA TRANSAKSI RIIL)
-- Mengulang transaksi umum untuk menggenapkan data menjadi 44
INSERT INTO transaksi (pelanggan_id, karyawan_id, tanggal, total_tagihan, total_dibayar, sisa_tagihan, status_pembayaran) VALUES 
(8, 2, '2025-07-15', 95000000, 30000000, 65000000, 'Belum Lunas'),
(2, 1, '2025-07-18', 25000000, 25000000, 0, 'Lunas'),
(4, 2, '2025-07-20', 42000000, 10000000, 32000000, 'Belum Lunas'),
(1, 1, '2025-07-22', 36000000, 36000000, 0, 'Lunas'),
(3, 2, '2025-07-25', 50000000, 25000000, 25000000, 'Belum Lunas'),
(6, 1, '2025-07-28', 18000000, 18000000, 0, 'Lunas'),
(7, 2, '2025-08-01', 75000000, 0, 75000000, 'Belum Lunas'),
(9, 1, '2025-08-05', 33000000, 10000000, 23000000, 'Belum Lunas'),
(10, 2, '2025-08-08', 12000000, 12000000, 0, 'Lunas'),
(2, 1, '2025-08-12', 68000000, 34000000, 34000000, 'Belum Lunas'),
(5, 1, '2024-09-12', 15000000, 15000000, 0, 'Lunas');

-- Detail Transaksi Tambahan (Menggunakan ID Barang yang sudah ada)
INSERT INTO detail_transaksi (transaksi_id, barang_id, jumlah, harga_satuan, subtotal) VALUES 
(34, 33, 10, 7700000, 77000000), (34, 38, 120, 150000, 18000000), 
(35, 49, 12500, 2000, 25000000), 
(36, 1, 500, 61000, 30500000), (36, 9, 1150, 10000, 11500000),
(37, 10, 1000, 13500, 13500000), (37, 1, 300, 61000, 18300000), (37, 26, 60, 70000, 4200000),
(38, 4, 200, 300000, 60000000), (38, 25, 10, 2000000, 2000000),
(39, 1, 300, 61000, 18300000), 
(40, 33, 5, 7700000, 38500000), (40, 3, 100, 170000, 17000000), (40, 2, 100, 120000, 12000000),
(41, 15, 50, 350000, 17500000), (41, 16, 20, 400000, 8000000), (41, 36, 30, 250000, 7500000),
(42, 55, 2, 5000000, 10000000), (42, 54, 1, 2000000, 2000000),
(43, 1, 600, 61000, 36600000), (43, 11, 1000, 19000, 19000000), (43, 44, 45, 270000, 12150000),
(44, 5, 300, 68000, 20400000), (44, 49, 100, 30000, 3000000), (44, 36, 40, 250000, 10000000);

-- ==========================================
-- 4. INPUT RIWAYAT PEMBAYARAN
-- ==========================================

INSERT INTO riwayat_pembayaran (transaksi_id, karyawan_id, metode_pembayaran_id, jumlah_bayar, keterangan) VALUES 
(1, 1, 2, 20000000, 'DP Proyek Awal'),
(2, 2, 1, 650000, 'Lunas Tunai'),
(3, 2, 2, 6000000, 'DP Chain Blok'),
(4, 2, 1, 775000, 'Lunas Tunai'),
(5, 1, 2, 10000000, 'DP Proyek Awal'),
(7, 1, 3, 25000000, 'DP Setengah'),
(10, 1, 2, 10000000, 'DP Material'),
(12, 1, 2, 30000000, 'DP Proyek 2'),
(14, 2, 2, 15000000, 'Transfer sebagian'),
(15, 1, 3, 10000000, 'DP Mandiri'),
(19, 2, 1, 35000000, 'Lunas Tunai di Lokasi'),
(21, 2, 2, 20000000, 'DP Transfer Awal'),
(22, 1, 3, 10000000, 'Titip via Mandiri'),
(25, 2, 1, 5000000, 'DP Tunai di Toko'),
(26, 2, 2, 10000000, 'Transfer sebagian'),
(34, 2, 2, 30000000, 'DP Proyek Borneo'),
(36, 2, 1, 10000000, 'DP Tunai CV Maju'),
(38, 1, 3, 25000000, 'DP Konstruksi'),
(40, 2, 2, 0, 'Belum Ada Pembayaran'),
(41, 1, 1, 10000000, 'DP Kecil'),
(43, 2, 3, 34000000, 'Bayar Setengah');