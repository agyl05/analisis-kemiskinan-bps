-- =====================================================
-- Analisis Kemiskinan Indonesia per Provinsi (2015-2026)
-- Sumber data : BPS, Persentase Penduduk Miskin menurut
--               Provinsi dan Daerah
-- Database    : MySQL 8.4 (Laragon), diakses via HeidiSQL
-- =====================================================

-- 1. PERSIAPAN: database dan tabel
CREATE DATABASE IF NOT EXISTS latihan_sql;
USE latihan_sql;

CREATE TABLE kemiskinan (
    provinsi      VARCHAR(50),
    wilayah       VARCHAR(20),
    tahun         SMALLINT,
    semester      TINYINT,
    persen_miskin DECIMAL(5,2) NULL
);

-- 2. IMPOR DATA
-- Impor data/kemiskinan_provinsi.csv lewat HeidiSQL
-- (Tools > Import CSV file), lalu jalankan perintah di bawah.

-- Sel kosong di CSV terbaca sebagai 0, padahal artinya
-- "data tidak tersedia". Kembalikan menjadi NULL.
UPDATE kemiskinan
SET persen_miskin = NULL
WHERE persen_miskin = 0;

-- 3. PEMERIKSAAN DATA
-- Hasil yang diharapkan: 2808 baris, 460 NULL, 0 nol
SELECT COUNT(*) AS total_baris,
       SUM(persen_miskin IS NULL) AS total_null,
       SUM(persen_miskin = 0) AS total_nol
FROM kemiskinan;

-- 4. ANALISIS

-- 4.1 Lima provinsi dengan kemiskinan tertinggi, Sep 2025
-- Hasil: Papua Tengah 29,45; Papua Pegunungan 27,21;
--        Papua Barat 19,58; Papua Selatan 19,26; Papua 17,82
SELECT provinsi, persen_miskin
FROM kemiskinan
WHERE wilayah = 'Jumlah'
  AND tahun = 2025
  AND semester = 2
  AND provinsi <> 'INDONESIA'
ORDER BY persen_miskin DESC
LIMIT 5;

-- 4.2 Tren kemiskinan nasional
-- Catatan: 2023-S2 dan 2026-S2 bernilai NULL (tidak tersedia)
SELECT tahun, semester, persen_miskin
FROM kemiskinan
WHERE provinsi = 'INDONESIA'
  AND wilayah = 'Jumlah'
ORDER BY tahun, semester;

-- 4.3 Rata-rata tahunan: perdesaan vs perkotaan (nasional)
-- Hasil: selisih menyempit dari 5,89 poin (2015: 14,15 vs 8,26)
--        menjadi 4,21 poin (2025: 10,88 vs 6,67)
SELECT tahun, wilayah, ROUND(AVG(persen_miskin), 2) AS rata_rata
FROM kemiskinan
WHERE provinsi = 'INDONESIA'
  AND wilayah IN ('Perkotaan', 'Perdesaan')
GROUP BY tahun, wilayah
ORDER BY tahun, wilayah;

-- 4.4 Lima provinsi dengan lonjakan terbesar saat pandemi
--     (Sep 2019 ke Sep 2020, dalam poin persentase)
-- Hasil: Banten +1,69; Jawa Barat +1,61; DI Yogyakarta +1,36;
--        DKI Jakarta +1,27; Jawa Tengah +1,26
SELECT a.provinsi,
       a.persen_miskin AS sep_2019,
       b.persen_miskin AS sep_2020,
       ROUND(b.persen_miskin - a.persen_miskin, 2) AS perubahan
FROM kemiskinan a
JOIN kemiskinan b
  ON a.provinsi = b.provinsi
 AND a.wilayah = b.wilayah
WHERE a.wilayah = 'Jumlah'
  AND a.tahun = 2019 AND a.semester = 2
  AND b.tahun = 2020 AND b.semester = 2
  AND a.provinsi <> 'INDONESIA'
ORDER BY perubahan DESC
LIMIT 5;

-- 4.5 Provinsi yang pada Sep 2024 masih di atas level Sep 2019
-- Hasil (5 teratas): Banten +0,76; DKI Jakarta +0,72;
--        Kep. Bangka Belitung +0,58; Kalimantan Tengah +0,45;
--        Jawa Barat +0,26
SELECT a.provinsi,
       a.persen_miskin AS sep_2019,
       b.persen_miskin AS sep_2024,
       ROUND(b.persen_miskin - a.persen_miskin, 2) AS perubahan
FROM kemiskinan a
JOIN kemiskinan b
  ON a.provinsi = b.provinsi
 AND a.wilayah = b.wilayah
WHERE a.wilayah = 'Jumlah'
  AND a.tahun = 2019 AND a.semester = 2
  AND b.tahun = 2024 AND b.semester = 2
  AND a.provinsi <> 'INDONESIA'
  AND b.persen_miskin IS NOT NULL
ORDER BY perubahan DESC
LIMIT 5;