import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rentalapp_pos/base_helper/app_utils.dart';
import 'package:rentalapp_pos/dialog/loading_dialog.dart';
import 'package:rentalapp_pos/model/firestore_respond/firestore_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraphPage extends StatefulWidget {
  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  ChartSeriesController chartSeriesController;
  List<_ChartData> chartDataMerchants = <_ChartData>[];
  List<_ChartData> chartDataCustomers = <_ChartData>[];
  List<_ChartData> chartDataProfit = <_ChartData>[];
  List<_ChartData> chartDataOrder = <_ChartData>[];
  int merchantNum, customerNum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        leading: backwardButton(context),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          generateTitle('Analysis'),
          buildLineChartProfit(),
          buildBarChartMerchant(),
          buildBarChartCustomer(),
          buildLineChartOrder()
        ]),
      ),
    );
  }

  Widget buildBarChartMerchant() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreService.getMerchants().snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingPage(message: 'Waiting for connection...');
          }
          if (!snapshot.hasData)
            return CircularProgressIndicator();
          else {
            print(snapshot.data.docs.length);
            List<DateTime> dateTime = snapshot.data.docs.map((element) {
              return DateTime.fromMillisecondsSinceEpoch(
                  (element.get('createdDateTime')).seconds * 1000);
            }).toList();

            List<int> monthCount = detectMonthNum(dateTime);
            monthCount.retainWhere((element) => element != 0);
            for (int i = 0; i < monthCount.length; i++) {
              chartDataMerchants
                  .add(_ChartData(dateTime[i], numUser: monthCount[i]));
            }
            return SfCartesianChart(
                backgroundColor: Colors.grey.shade50,
                plotAreaBorderWidth: 0,
                primaryXAxis:
                    NumericAxis(majorGridLines: MajorGridLines(width: 0)),
                primaryYAxis: NumericAxis(
                    axisLine: AxisLine(width: 0),
                    majorTickLines: MajorTickLines(size: 0)),
                legend: Legend(
                    isVisible: true,
                    position: LegendPosition.top,
                    title: LegendTitle(
                        text: 'Merchant Number')), // Enables the legend.
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<_ChartData, int>>[
                  ColumnSeries<_ChartData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      chartSeriesController = controller;
                    },
                    dataSource: chartDataMerchants,
                    color: const Color.fromRGBO(192, 108, 132, 1),
                    xValueMapper: (_ChartData users, _) => users.dateTime.month,
                    yValueMapper: (_ChartData users, _) => users.numUser,
                    animationDuration: 1,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                    spacing: 0.2,
                  )
                ]);
          }
        });
  }

  Widget buildBarChartCustomer() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreService.getCustomers().snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingPage(message: 'Waiting for connection...');
          }
          if (!snapshot.hasData)
            return CircularProgressIndicator();
          else {
            print(snapshot.data.docs.length);
            List<DateTime> dateTime = snapshot.data.docs.map((element) {
              return DateTime.fromMillisecondsSinceEpoch(
                  (element.get('createdDateTime')).seconds * 1000);
            }).toList();

            List<int> monthCount = detectMonthNum(dateTime);

            monthCount.retainWhere((element) => element != 0);
            for (int i = 0; i < monthCount.length; i++) {
              chartDataCustomers
                  .add(_ChartData(dateTime[i], numUser: monthCount[i]));
            }

            return SfCartesianChart(
                backgroundColor: Colors.grey.shade50,
                plotAreaBorderWidth: 0,
                primaryXAxis:
                    NumericAxis(majorGridLines: MajorGridLines(width: 0)),
                primaryYAxis: NumericAxis(
                    axisLine: AxisLine(width: 0),
                    majorTickLines: MajorTickLines(size: 0)),
                legend: Legend(
                    isVisible: true,
                    position: LegendPosition.top,
                    title: LegendTitle(
                        text: 'Customer Number')), // Enables the legend.
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries<_ChartData, int>>[
                  ColumnSeries<_ChartData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      chartSeriesController = controller;
                    },
                    dataSource: chartDataCustomers,
                    color: const Color.fromRGBO(132, 200, 132, 1),
                    xValueMapper: (_ChartData users, _) => users.dateTime.month,
                    yValueMapper: (_ChartData users, _) => users.numUser,
                    animationDuration: 1,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                    spacing: 0.2,
                  )
                ]);
          }
        });
  }

  List<int> detectMonthNum(List<DateTime> dateTime) {
    List<int> monthCount = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    for (var element in dateTime) {
      switch (element.month.toInt()) {
        case 1:
          monthCount[0] += 1;
          break;
        case 2:
          monthCount[1] += 1;
          break;
        case 3:
          monthCount[2] += 1;
          break;
        case 4:
          monthCount[3] += 1;
          break;
        case 5:
          monthCount[4] += 1;
          break;
        case 6:
          monthCount[5] += 1;
          break;
        case 7:
          monthCount[6] += 1;
          break;
        case 8:
          monthCount[7] += 1;
          break;
        case 9:
          monthCount[8] += 1;
          break;
        case 10:
          monthCount[9] += 1;
          break;
        case 11:
          monthCount[10] += 1;
          break;
        case 12:
          monthCount[11] += 1;
          break;
      }
    }
    return monthCount;
  }

  Widget buildLineChartProfit() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreService.filterOrders('reply', 'COMPLETE').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingPage(message: 'Waiting for connection...');
          }
          if (!snapshot.hasData)
            return CircularProgressIndicator();
          else {
            print(snapshot.data.docs.length);
            if (snapshot.data.docs.length != 0) {
              List<DateTime> dateTime = snapshot.data.docs.map((element) {
                return DateTime.fromMillisecondsSinceEpoch(
                    (element.get('date.createdDate')).seconds * 1000);
              }).toList();

              List<double> profit = snapshot.data.docs.map((element) {
                return (element.get('profit') as num ?? 0).toDouble();
              }).toList();

              print('Profit: ${profit.first}');
              print('Profit: ${profit.last}');
              for (int i = 0; i < dateTime.length; i++) {
                chartDataProfit.add(_ChartData(dateTime[i], profit: profit[i]));
              }

              print('Profit: ${chartDataProfit.first.profit}');
            }
            return SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                legend: Legend(
                    isVisible: true,
                    position: LegendPosition.top,
                    title:
                        LegendTitle(text: 'Net Profit')), // Enables the legend.
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries>[
                  // Renders line chart
                  LineSeries<_ChartData, DateTime>(
                    dataSource: chartDataProfit,
                    xValueMapper: (_ChartData sales, _) => sales.dateTime,
                    yValueMapper: (_ChartData sales, _) => sales.profit,
                    markerSettings: MarkerSettings(isVisible: true),
                  )
                ]);
          }
        });
  }

  Widget buildLineChartOrder() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreService.getOrders().snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingPage(message: 'Waiting for connection...');
          }
          if (!snapshot.hasData)
            return CircularProgressIndicator();
          else {
            List order = snapshot.data.docs.where((element) {
              return element.get('reply') == "PLACED";
            }).toList();

            for (var element in order) {
              DateTime createdDate = DateTime.fromMillisecondsSinceEpoch(
                  (element.get('date.createdDate')).seconds * 1000);
              chartDataOrder
                  .add(_ChartData(createdDate, numUser: order.length));
            }

            return SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                legend: Legend(
                    isVisible: true,
                    position: LegendPosition.top,
                    title: LegendTitle(text: 'Order')), // Enables the legend.
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ChartSeries>[
                  // Renders line chart
                  AreaSeries<_ChartData, DateTime>(
                    dataSource: chartDataOrder,
                    xValueMapper: (_ChartData sales, _) => sales.dateTime,
                    yValueMapper: (_ChartData sales, _) => sales.numUser,
                    markerSettings: MarkerSettings(isVisible: true),
                  )
                ]);
          }
        });
  }
}

class _ChartData {
  _ChartData(this.dateTime, {this.numUser, this.profit});
  final DateTime dateTime;
  final int numUser;
  final double profit;
}
