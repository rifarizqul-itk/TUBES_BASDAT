import streamlit as st
import pandas as pd
from config import get_transaksi_data, get_product_sales_data, get_payment_status_data, get_detail_items

# --- 1. CONFIG HALAMAN ---
st.set_page_config(page_title="Dashboard Toko NN", layout="wide")
st.title("🏗️ Dashboard Data Penjualan Toko NN")
st.write("Jl. Pandan Sari No.45, Marga Sari, Kec. Balikpapan Bar., Kota Balikpapan, Kalimantan Timur 76123")

# --- 2. LOAD DATA ---
df_transaksi = get_transaksi_data()
df_produk = get_product_sales_data()
df_payment = get_payment_status_data()

# Convert kolom tanggal
df_transaksi['tanggal'] = pd.to_datetime(df_transaksi['tanggal'])

# --- 3. FILTER TANGGAL (Versi Simpel) ---
st.sidebar.header("Filter Tanggal")
min_date = df_transaksi['tanggal'].min()
max_date = df_transaksi['tanggal'].max()

start_date = st.sidebar.date_input("Mulai", min_date)
end_date = st.sidebar.date_input("Sampai", max_date)

# Filter data utama
filtered_df = df_transaksi[
    (df_transaksi['tanggal'] >= pd.to_datetime(start_date)) & 
    (df_transaksi['tanggal'] <= pd.to_datetime(end_date))
]

# --- 4. RINGKASAN (Metrics) ---
st.subheader("Ringkasan Performa")
col1, col2, col3 = st.columns(3)

total_omzet = filtered_df['total_tagihan'].sum()
total_trx = filtered_df.shape[0]
total_piutang = filtered_df['sisa_tagihan'].sum()

with col1:
    st.metric("Total Omzet", f"Rp {total_omzet:,.0f}")
with col2:
    st.metric("Jumlah Transaksi", f"{total_trx}")
with col3:
# Kita buat tampilan manual biar mirip st.metric tapi berwarna
    st.markdown(f"""
    <p style="font-size: 14px; margin-bottom: 0px; color: #666;">Total Piutang</p>
    <h2 style="color: #d62728; margin-top: -15px;">Rp {total_piutang:,.0f}</h2>
    """, unsafe_allow_html=True)

st.markdown("---")

# --- 5. GRAFIK  ---
col_kiri, col_kanan = st.columns([2, 1])

with col_kiri:
    st.subheader("Tren Penjualan")
    # Data disiapkan sederhana: Tanggal & Total
    daily = filtered_df.groupby('tanggal')['total_tagihan'].sum()
    st.line_chart(daily)

with col_kanan:
    st.subheader("Status Pembayaran")
    # Data disiapkan sederhana: Status & Jumlah
    status_counts = df_payment.set_index('status_pembayaran')['jumlah_transaksi']
    st.bar_chart(status_counts)

st.markdown("---")

# --- 6. DETAIL TRANSAKSI (Gaya 'Invoice' yang Kamu Suka) ---
st.subheader("📄 Detail Transaksi")

# Buat list pilihan ID yang rapi (ID - Nama Pelanggan)
# Kita pakai Dictionary Comprehension biar codingan terlihat Python banget tapi tetap mudah dimengerti
pilihan_transaksi = filtered_df['transaksi_id'].tolist()
label_transaksi = {
    row['transaksi_id']: f"ID {row['transaksi_id']} - {row['nama_pelanggan']} ({row['tanggal'].strftime('%d/%m/%Y')})"
    for i, row in filtered_df.iterrows()
}

# Dropdown Pilih Transaksi
id_dipilih = st.selectbox(
    "Cari Transaksi:", 
    options=pilihan_transaksi,
    format_func=lambda x: label_transaksi.get(x, x) # Biar tampilan di dropdown ada namanya
)

# TAMPILKAN DATA (Hanya jika ada ID yang dipilih)
if id_dipilih:
    # 1. Ambil Data Header (Pelanggan & Total) dari filtered_df
    header = filtered_df[filtered_df['transaksi_id'] == id_dipilih].iloc[0]
    
    # 2. Ambil Data Barang (Detail) dari Database via fungsi di config.py
    items = get_detail_items(id_dipilih)
    
    # --- TAMPILAN INFORMASI (Kiri Kanan) ---
    col_info1, col_info2 = st.columns(2)
    
    with col_info1:
        st.info(f"""
        **Pelanggan:**
        \n👤 Nama: {header['nama_pelanggan']}
        \n📞 Telp: {header['no_telepon']}
        """)
        
    with col_info2:
        st.success(f"""
        **Transaksi:**
        \n📅 Tanggal: {header['tanggal'].strftime('%d %B %Y')}
        \n💰 Status: {header['status_pembayaran']}
        \n👮 Kasir: {header['nama_karyawan']}
        """)

    # --- TAMPILAN TABEL BARANG ---
    st.write("#### Daftar Barang Dibeli")
    # Tampilkan tabel barang dengan format lebar penuh
    st.dataframe(items, use_container_width=True)
    
    # Total Tagihan Besar di Bawah
    st.markdown(f"### Total Tagihan: Rp {header['total_tagihan']:,.0f}")

else:
    st.warning("Data tidak ditemukan pada rentang tanggal ini.")