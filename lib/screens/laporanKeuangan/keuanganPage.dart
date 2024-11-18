import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:umkmfirebase/models/cacatan.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:umkmfirebase/models/userModel.dart';
import 'package:umkmfirebase/services/appServices.dart';

class KeuanganPage extends StatefulWidget {
  final UserModel user;
  KeuanganPage({super.key, required this.user});

  @override
  State<KeuanganPage> createState() => _KeuanganPageState();
}

class _KeuanganPageState extends State<KeuanganPage> {
  List<Cacatan> _cacatanList = [];
  List<double> penjualan = List<double>.filled(12, 0);
  List<double> pengeluaran = List<double>.filled(12, 0);
  bool isLoading = true;
  final currencyFormatter = NumberFormat.compact(locale: 'id_ID');
  final int currentYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  double calculateListTotal(List<double> list) {
    return list.fold(0, (sum, current) => sum + current);
  }

  Future<void> loadData() async {
    try {
      await _fetchCacatanList();
      hitungTotalPerBulan();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchCacatanList() async {
    _cacatanList = await AppServices.readAllCacatan(widget.user);
    setState(() {});
  }

  void hitungTotalPerBulan() {
    List<double> totalPemasukanPerBulan = List<double>.filled(12, 0);
    List<double> totalPengeluaranPerBulan = List<double>.filled(12, 0);

    for (var cacatan in _cacatanList) {
      DateTime tanggal = DateTime.parse(cacatan.tanggal);
      if (tanggal.year == currentYear) {
        int bulan = tanggal.month - 1;
        if (cacatan.jenisCacatan == "pemasukan") {
          totalPemasukanPerBulan[bulan] += cacatan.jumlah;
        } else if (cacatan.jenisCacatan == "pengeluaran") {
          totalPengeluaranPerBulan[bulan] += cacatan.jumlah;
        }
      }
    }

    setState(() {
      penjualan = totalPemasukanPerBulan;
      pengeluaran = totalPengeluaranPerBulan;
    });
  }

  List<FlSpot> _generateSpots(List<double> data) {
    List<FlSpot> spots = [];
    for (int i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i]));
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 2, right: 40, top: 4, bottom: 4),
              decoration: BoxDecoration(
                color: Colors.teal[700],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Laporan keuangan usaha " +
                        widget.user.namaUMKM +
                        " Tahun${currentYear}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: 90,
                    width: 2,
                    color: Colors.white,
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.grey[50],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                title: Column(
                                  children: [
                                    Icon(
                                      Icons.assessment_rounded,
                                      size: 40,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Laporan Tahun ${currentYear}",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    Divider(thickness: 2),
                                  ],
                                ),
                                content: Container(
                                  width: double.maxFinite,
                                  height: 360,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        // Card Pendapatan & Biaya
                                        Card(
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Pendapatan & Biaya",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                Divider(),
                                                // Pendapatan
                                                Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 8),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Pendapatan",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                      Text(
                                                        currencyFormatter.format(calculateListTotal(penjualan)),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Biaya
                                                Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 8),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Biaya",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                      Text(
                                                        currencyFormatter.format(calculateListTotal(pengeluaran)),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.red[300],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Laba Bersih
                                                Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 8),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Laba Bersih",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        currencyFormatter.format(
                                                            calculateListTotal(penjualan) - calculateListTotal(pengeluaran)
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          color: (calculateListTotal(penjualan) - calculateListTotal(pengeluaran)) >= 0
                                                              ? Colors.green
                                                              : Colors.red,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 16),

                                        // Card Arus Kas
                                        Card(
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Arus Kas",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey[700],
                                                  ),
                                                ),
                                                Divider(),
                                                // Kas Masuk
                                                Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 8),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Kas Masuk",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                      Text(
                                                        currencyFormatter.format(calculateListTotal(penjualan)),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Kas Keluar
                                                Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 8),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Kas Keluar",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.grey[600],
                                                        ),
                                                      ),
                                                      Text(
                                                        currencyFormatter.format(calculateListTotal(pengeluaran)),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.red[300],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Arus Kas Bersih
                                                Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 8),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Arus Kas Bersih",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      Text(
                                                        currencyFormatter.format(
                                                            calculateListTotal(penjualan) - calculateListTotal(pengeluaran)
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          color: (calculateListTotal(penjualan) - calculateListTotal(pengeluaran)) >= 0
                                                              ? Colors.green
                                                              : Colors.red,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.check_circle, color: Colors.amber),
                                    label: Text(
                                      "Selesai",
                                      style: TextStyle(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      icon: Icon(
                        Icons.open_in_new,
                        color: Colors.teal[700],
                      ))
                ],
              ),
            ),

            // Grafik Pemasukan
            _buildChartCard(
                title: 'Pemasukan Tahun $currentYear',
                data: penjualan,
                totalText:
                    'Total: ${currencyFormatter.format(penjualan.reduce((a, b) => a + b))}',
                color: Colors.green),

            // Grafik Pengeluaran
            _buildChartCard(
                title: 'Pengeluaran Tahun $currentYear',
                data: pengeluaran,
                totalText:
                    'Total: ${currencyFormatter.format(pengeluaran.reduce((a, b) => a + b))}',
                color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required List<double> data,
    required String totalText,
    required Color color,
  }) {
    // Find max value for dynamic interval calculation
    final maxValue = data.reduce((curr, next) => curr > next ? curr : next);

    // Calculate appropriate interval based on max value
    double interval = 1000000; // default interval
    if (maxValue > 10000000) {
      interval = 40000000; // use 5M interval for values > 10M
    }
    if (maxValue > 50000000) {
      interval = 80000000; // use 10M interval for values > 50M
    }
    if (maxValue > 100000000) {
      interval = 200000000; // use 25M interval for values > 100M
    }

    return Container(
      child: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : data.every((value) => value == 0)
              ? Center(
                  child: Card(
                    margin: EdgeInsets.only(bottom: 20, top: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              size: 50, color: Colors.red),
                          SizedBox(height: 20),
                          Text(
                            'Tidak ada data untuk $title',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Card(
                  margin: EdgeInsets.all(16),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          totalText,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 24),
                        SizedBox(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: true,
                                horizontalInterval: interval,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Colors.grey[300],
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: interval,
                                    reservedSize: 42,
                                    getTitlesWidget: (value, meta) {
                                      // Format dalam Miliar jika nilai > 1M
                                      if (value >= 1000000) {
                                        return Text(
                                          '${(value / 1000000).toStringAsFixed(1)}M',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 10,
                                          ),
                                        );
                                      }
                                      return Text(
                                        currencyFormatter.format(value),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 10,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      const bulan = [
                                        'Jan',
                                        'Feb',
                                        'Mar',
                                        'Apr',
                                        'Mei',
                                        'Jun',
                                        'Jul',
                                        'Agu',
                                        'Sep',
                                        'Okt',
                                        'Nov',
                                        'Des'
                                      ];
                                      if (value.toInt() >= bulan.length) {
                                        return const SizedBox.shrink();
                                      }
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          bulan[value.toInt()],
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    },
                                    interval: 1,
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: _generateSpots(data),
                                  isCurved: true,
                                  color: color,
                                  barWidth: 3,
                                  dotData: FlDotData(show: true),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: color.withOpacity(0.2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
