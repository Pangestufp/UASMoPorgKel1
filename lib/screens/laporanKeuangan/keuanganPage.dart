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
            // Grafik Pemasukan
            _buildChartCard(
              title: 'Pemasukan Tahun $currentYear',
              data: penjualan,
              totalText:
              'Total: ${currencyFormatter.format(penjualan.reduce((a, b) => a + b))}',
              color: Colors.green
            ),

            // Grafik Pengeluaran
            _buildChartCard(
              title: 'Pengeluaran Tahun $currentYear',
              data: pengeluaran,
              totalText:
              'Total: ${currencyFormatter.format(pengeluaran.reduce((a, b) => a + b))}',
              color: Colors.red
            ),
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
                              'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
                              'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
                            ];
                            if (value.toInt() >= bulan.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
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
