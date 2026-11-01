# Analisis Kemiskinan Indonesia per Provinsi (2015-2026)

Proyek latihan analisis data: membersihkan data kemiskinan dari BPS dengan Python, menganalisisnya dengan SQL (MySQL), dan memvisualisasikannya dalam dashboard Tableau.

![Dashboard Kemiskinan](image/gambar.png)

## Pertanyaan yang dijawab
1. Provinsi mana yang persentase penduduk miskinnya tertinggi pada September 2025?
2. Bagaimana tren kemiskinan nasional, dan seberapa besar dampak pandemi 2020?
3. Apakah selisih kemiskinan perdesaan dan perkotaan menyempit?
4. Provinsi mana yang paling terpukul pandemi, dan mana yang pada 2024 belum kembali ke level sebelum pandemi?

## Data dan alur kerja
**Sumber:** BPS, tabel "Persentase Penduduk Miskin (P0) Menurut Provinsi dan Daerah" (Perkotaan, Perdesaan, dan Jumlah; per semester, 2015-2026).

1. **Pembersihan data (Python/pandas, Google Colab):** [`clear_data.ipynb`](clear_data.ipynb)
   - Header bertingkat diratakan menjadi tabel panjang: `provinsi, wilayah, tahun, semester, persen_miskin` (2.808 baris).
   - Kolom "Tahunan" yang kosong dan baris catatan dibuang.
   - Nilai "-" dan nilai 0 pada DKI Jakarta perdesaan (yang tidak punya wilayah perdesaan) dijadikan NULL.
   - Data yang memang belum tersedia (460 nilai) dibiarkan kosong, tidak diisi atau diperkirakan.
2. **Analisis (SQL, MySQL via Laragon dan HeidiSQL):** [`sql/analisis.sql`](sql/analisis.sql)
   - Berisi pembuatan tabel, pemeriksaan data, dan lima query analisis.
3. **Visualisasi (Tableau):** [`tableau/dashboard_kemiskinan.twbx`](tableau/dashboard_kemiskinan.twbx)
   - Tiga grafik: peringkat provinsi, tren nasional, dan perbandingan perdesaan vs perkotaan.

Data bersih tersedia di [`data/kemiskinan_provinsi.csv`](data/kemiskinan_provinsi.csv).


## Temuan

1. **Kemiskinan tertinggi terkonsentrasi di Papua.** Pada September 2025, lima provinsi teratas semuanya di wilayah Papua: Papua Tengah (29,45%), Papua Pegunungan (27,21%), Papua Barat (19,58%), Papua Selatan (19,26%), dan Papua (17,82%). Ada jurang antara dua teratas dan tiga berikutnya.

2. **Dampak pandemi bersifat sementara.** Kemiskinan nasional naik dari 9,22% (September 2019) ke 10,19% (September 2020), atau sekitar 0,97 poin. Setelah itu angkanya turun bertahap: 8,25% pada September 2025 dan 8,07% pada Maret 2026. Pada data yang tersedia, level sebelum pandemi baru terlampaui ke bawah pada Maret 2024 (9,03%).

3. **Selisih perdesaan dan perkotaan menyempit pelan.** Rata-rata tahunan nasional: 5,89 poin pada 2015 (14,15% vs 8,26%) menjadi 4,21 poin pada 2025 (10,88% vs 6,67%), dengan puncak 6,28 poin pada 2016. Penyempitan pada 2020 sebagian karena kota terpukul lebih keras (+1,00 poin) dibanding desa (+0,28 poin), bukan karena desa membaik. Perdesaan tetap sekitar 1,6 kali lipat perkotaan.

4. **Provinsi di Jawa paling terpukul pandemi.** Lonjakan terbesar September 2019 ke September 2020: Banten (+1,69 poin), Jawa Barat (+1,61), DI Yogyakarta (+1,36), DKI Jakarta (+1,27), dan Jawa Tengah (+1,26), jauh di atas kenaikan nasional. Pada September 2024, lima provinsi dengan selisih terbesar yang masih di atas level September 2019: Banten (+0,76), DKI Jakarta (+0,72), Kepulauan Bangka Belitung (+0,58), Kalimantan Tengah (+0,45), dan Jawa Barat (+0,26), padahal angka nasional sudah lebih rendah dari 2019.
