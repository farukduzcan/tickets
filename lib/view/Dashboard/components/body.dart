// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tickets/models/ticket_list_model.dart';
import 'package:tickets/view/Dashboard/components/ticket_status_list_body.dart';

import '../../../constants.dart';
import '../../../newhome.dart';
import '../../../services/ticket_list_services.dart';

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  late List<GDPData> _chartData = <GDPData>[];
  late TooltipBehavior _tooltipBehavior =
      TooltipBehavior(enable: true, format: 'point.x : point.y');
  late int newTicket = 0;
  late int pendingTicket = 0;
  late int completedTicket = 0;
  late int pageIndeks = 1;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await totalTicketStatus();
    _chartData = getChartData();
    _tooltipBehavior =
        TooltipBehavior(enable: true, format: 'point.x : point.y');
  }

  Future<void> totalTicketStatus() async {
    for (int i = 1; i < pageIndeks + 1; i++) {
      var listinfo = await listApi(i);
      pageIndeks = listinfo!.totalPageCount!;
      for (var item in listinfo.datas) {
        if (item.ticketStatus == "NEW") {
          setState(() {
            newTicket++;
          });
        } else if (item.ticketStatus == "WORKING") {
          setState(() {
            pendingTicket++;
          });
        } else if (item.ticketStatus == "CLOSE") {
          setState(() {
            completedTicket++;
          });
        }
      }
    }
  }

  Future<TicketListModel?> listApi(int index) async {
    TicketListServices ticketlist = TicketListServices();
    var listinfo = await ticketlist.getTicketList(
        filter: "",
        orderDir: "DESC",
        orderField: "Id",
        pageIndex: index,
        pageSize: 15);
    return listinfo;
  }

  List<GDPData> getChartData() {
    final List<GDPData> chartData = [
      GDPData('Yeni Talep', newTicket, Colors.blue.shade400),
      GDPData('İşlemde Bekleyen', pendingTicket, Colors.orange.shade400),
      GDPData('Tamamlanan', completedTicket, Colors.green.shade400),
    ];
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      child: SizedBox(
        height: size.height * 0.8,
        child: Column(
          children: [
            SfCircularChart(
              title: ChartTitle(text: 'Talep Durumları'),
              legend: Legend(
                  isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
              tooltipBehavior: _tooltipBehavior,
              series: <CircularSeries>[
                DoughnutSeries<GDPData, String>(
                  radius: '80%',
                  explode: true,
                  explodeOffset: '10%',
                  dataSource: _chartData,
                  xValueMapper: (GDPData data, _) => data.status,
                  yValueMapper: (GDPData data, _) => data.count,
                  pointColorMapper: (GDPData data, _) => data.color,
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                  ),
                  enableTooltip: true,
                )
              ],
            ),
            DashBoardListButton(
              icon: Icon(
                Icons.fiber_new_rounded,
                size: 35,
                color: Colors.blue.shade400,
              ),
              title: "Yeni Talepler",
              press: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TicketStatusListBody(
                            filter: "NEW",
                          )),
                );
              },
            ),
            DashBoardListButton(
              icon: Icon(
                Icons.pending_actions_rounded,
                size: 35,
                color: Colors.orange.shade400,
              ),
              title: "İşlemde Bekleyen Talepler",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NewHomeScreen()),
                );
              },
            ),
            DashBoardListButton(
              icon: Icon(
                Icons.check_circle_rounded,
                size: 35,
                color: Colors.green.shade400,
              ),
              title: "Tamamlanan Talepler",
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class DashBoardListButton extends StatelessWidget {
  final Function press;
  final String title;
  final Icon icon;
  const DashBoardListButton({
    super.key,
    required this.press,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: kCardBoxShodow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          trailing: const Icon(Icons.arrow_forward_ios),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onTap: () {
            press();
          },
          title: Text(title),
          leading: icon,
        ),
      ),
    );
  }
}

class GDPData {
  final Color color;
  final String status;
  final int count;
  GDPData(this.status, this.count, this.color);
}
