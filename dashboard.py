# dashboard.py
import streamlit as st
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
from config import get_transaksi_data, get_product_sales_data, get_payment_status_data

# Konfigurasi Halaman
st.set_page_config(
    page_title="Dashboard Lifting & Rigging",
    page_icon="🏗️",
    layout="wide"
)

# Judul dan Deskripsi
st.title("🏗️ Dashboard Penjualan Lifting & Rigging Balikpapan")
st.markdown("Monitoring performa penjualan, stok barang, dan status pembayaran.")

# --- LOAD DATA ---
# Kita load semua data di awal
df_transaksi = get_transaksi_data()
df_produk = get_product_sales_data()
df_payment = get_payment_status_data()

# Pastikan kolom tanggal bertipe datetime
df_transaksi['tanggal'] = pd.to_datetime(df_transaksi['tanggal'])

# --- SIDEBAR FILTER ---
st.sidebar.header("Filter Data")
# Filter Tanggal
min_date = df_transaksi['tanggal'].min()
max_date = df_transaksi['tanggal'].max()

try:
    start_date, end_date = st.sidebar.date_input(
        "Rentang Tanggal",
        value=[min_date, max_date],
        min_value=min_date,
        max_value=max_date
    )
except:
    st.sidebar.error("Data tanggal tidak cukup untuk filter rentang.")
    start_date, end_date = min_date, max_date

# Terapkan Filter ke DataFrame Transaksi
filtered_df = df_transaksi[
    (df_transaksi['tanggal'] >= pd.to_datetime(start_date)) & 
    (df_transaksi['tanggal'] <= pd.to_datetime(end_date))
]

# --- KPI / METRICS (Baris Atas) ---
st.markdown("### 📊 Ringkasan Performa")
col1, col2, col3, col4 = st.columns(4)

total_omzet = filtered_df['total_tagihan'].sum()
total_transaksi = filtered_df.shape[0]
total_piutang = filtered_df['sisa_tagihan'].sum()
avg_transaksi = filtered_df['total_tagihan'].mean()

with col1:
    st.metric("Total Omzet", f"Rp {total_omzet:,.0f}")
with col2:
    st.metric("Total Transaksi", f"{total_transaksi} Trx")
with col3:
    st.metric("Total Piutang (Belum Lunas)", f"Rp {total_piutang:,.0f}", delta_color="inverse")
with col4:
    st.metric("Rata-rata Nilai Order", f"Rp {avg_transaksi:,.0f}")

st.markdown("---")

# --- BARIS 1: GRAFIK TREN & PIUTANG ---
col_left, col_right = st.columns([2, 1])

with col_left:
    st.subheader("📈 Tren Pendapatan Harian")
    # Group by tanggal untuk grafik garis
    daily_sales = filtered_df.groupby('tanggal')['total_tagihan'].sum().reset_index()
    
    fig_trend = px.line(
        daily_sales, 
        x='tanggal', 
        y='total_tagihan',
        markers=True,
        title='Grafik Penjualan Harian',
        labels={'total_tagihan': 'Omzet (Rp)', 'tanggal': 'Tanggal'}
    )
    fig_trend.update_traces(line_color='#1f77b4', line_width=3)
    st.plotly_chart(fig_trend, use_container_width=True)

with col_right:
    st.subheader("💰 Status Pembayaran")
    # Ganti px.donut menjadi px.pie dengan parameter hole
    fig_pie = px.pie(
        df_payment, 
        values='jumlah_transaksi', 
        names='status_pembayaran',
        title='Proporsi Transaksi',
        hole=0.4, # Ini yang membuatnya jadi bentuk Donut
        color='status_pembayaran',
        color_discrete_map={'Lunas':'#2ca02c', 'Belum Lunas':'#d62728'}
    )
    st.plotly_chart(fig_pie, use_container_width=True)
    
    # Tampilkan warning jika ada piutang besar
    if total_piutang > 0:
        st.warning(f"⚠️ Perhatian: Masih ada sisa tagihan sebesar **Rp {total_piutang:,.0f}** yang belum dibayar pelanggan.")

# --- BARIS 2: ANALISIS PRODUK ---
st.subheader("🛠️ Top 10 Barang Terlaris (Revenue)")
# Ambil top 10 produk berdasarkan pendapatan
top_products = df_produk.head(10).sort_values(by='total_pendapatan', ascending=True)

fig_bar = px.bar(
    top_products, 
    x='total_pendapatan', 
    y='nama_barang', 
    orientation='h',
    text='total_pendapatan',
    title='Produk Penyumbang Omzet Terbesar',
    labels={'total_pendapatan': 'Total Pendapatan (Rp)', 'nama_barang': 'Nama Barang'},
    color='total_pendapatan',
    color_continuous_scale='Viridis'
)
fig_bar.update_traces(texttemplate='%{text:,.0f}', textposition='outside')
st.plotly_chart(fig_bar, use_container_width=True)

# --- TABEL DATA ---
with st.expander("Lihat Detail Data Transaksi"):
    st.dataframe(filtered_df, use_container_width=True)
    
    # Tombol Download
    csv = filtered_df.to_csv(index=False).encode('utf-8')
    st.download_button(
        "⬇️ Download Data CSV",
        data=csv,
        file_name="laporan_penjualan.csv",
        mime="text/csv",
    )