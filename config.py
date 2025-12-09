# config.py
import mysql.connector
import pandas as pd

def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        port="3306",
        user="root",
        password="", 
        database="db_lifting" 
    )

# Mengambil Data Transaksi
def get_transaksi_data():
    conn = get_db_connection()
    query = """
        SELECT 
            t.id AS transaksi_id,
            t.tanggal,
            p.nama AS nama_pelanggan,
            p.no_telepon,
            k.nama_lengkap AS nama_karyawan,
            t.total_tagihan,
            t.sisa_tagihan,
            t.status_pembayaran
        FROM transaksi t
        JOIN pelanggan p ON t.pelanggan_id = p.id
        JOIN karyawan k ON t.karyawan_id = k.id
        ORDER BY t.tanggal DESC
    """
    df = pd.read_sql(query, conn)
    conn.close()
    return df

# Mengambil Detail Penjualan Barang
def get_product_sales_data():
    conn = get_db_connection()
    query = """
        SELECT 
            b.nama_barang,
            b.satuan,
            SUM(dt.jumlah) as total_terjual,
            SUM(dt.subtotal) as total_pendapatan
        FROM detail_transaksi dt
        JOIN barang b ON dt.barang_id = b.id
        JOIN transaksi t ON dt.transaksi_id = t.id
        GROUP BY b.id, b.nama_barang
        ORDER BY total_pendapatan DESC
    """
    df = pd.read_sql(query, conn)
    conn.close()
    return df

# Mengambil Status Hutang
def get_payment_status_data():
    conn = get_db_connection()
    query = """
        SELECT 
            status_pembayaran,
            COUNT(id) as jumlah_transaksi,
            SUM(sisa_tagihan) as total_piutang
        FROM transaksi
        GROUP BY status_pembayaran
    """
    df = pd.read_sql(query, conn)
    conn.close()
    return df

# Mengambil Detail Items per Transaksi
def get_detail_items(transaksi_id):
    conn = get_db_connection()
    query = """
        SELECT 
            b.nama_barang,
            b.satuan,
            dt.jumlah,
            dt.harga_satuan,
            dt.subtotal
        FROM detail_transaksi dt
        JOIN barang b ON dt.barang_id = b.id
        WHERE dt.transaksi_id = %s
    """
    df = pd.read_sql(query, conn, params=(transaksi_id,))
    conn.close()
    return df