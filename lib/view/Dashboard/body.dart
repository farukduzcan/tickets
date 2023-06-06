// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tickets/models/ticket_list_model.dart';
import 'package:tickets/view/Dashboard/components/ticket_status_list_body.dart';

import '../../constants.dart';
import '../../services/ticket_list_services.dart';
import 'components/dashboard_list_button.dart';
import 'components/gdp_data.dart';

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<GDPData> _chartData = [];
  TooltipBehavior _tooltipBehavior =
      TooltipBehavior(enable: true, format: 'point.x : point.y');
  int newTicket = 0;
  int pendingTicket = 0;
  int completedTicket = 0;
  int pageIndeks = 1;
  int totalTicket = 0;
  int totalTicketCount = 0;
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    await totalTicketStatus();
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      format: 'point.x : point.y',
    );
  }

  Future<void> totalTicketStatus() async {
    for (int i = 1; i < pageIndeks + 1; i++) {
      var listinfo = await listApi(i);
      pageIndeks = listinfo!.totalPageCount!;
      totalTicket = listinfo.totalItemsCount!;
      if (totalTicket == 0) {
        setState(() {
          isDataLoaded = true;
          newTicket = 0;
          pendingTicket = 0;
          completedTicket = 0;
          totalTicketCount = 0;
          _chartData = getChartData();
        });
      } else if (totalTicket > 0) {
        for (var item in listinfo.datas) {
          totalTicketCount++;

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
        if (totalTicketCount >= totalTicket) {
          setState(() {
            isDataLoaded = true;
            _chartData = getChartData();
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
      GDPData(
        TicketConstant.newTicket,
        newTicket,
        Colors.blue.shade400,
        "$newTicket ",
      ),
      GDPData(
        TicketConstant.inProgressTicket,
        pendingTicket,
        Colors.orange.shade400,
        "$pendingTicket ",
      ),
      GDPData(
        TicketConstant.completedTicket,
        completedTicket,
        Colors.green.shade400,
        "$completedTicket ",
      ),
    ];
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: () async {
        setState(() {
          newTicket = 0;
          pendingTicket = 0;
          completedTicket = 0;
          totalTicketCount = 0;
          pageIndeks = 1;
          isDataLoaded = false;
        });
        await initializeData();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        child: SizedBox(
          height: size.height * 0.8,
          child: Column(
            children: [
              isDataLoaded
                  ? SfCircularChart(
                      annotations: [
                        CircularChartAnnotation(
                          widget: Container(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                "$totalTicketCount",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                      title: ChartTitle(text: TicketConstant.ticketsStatus),
                      legend: Legend(
                          isVisible: true,
                          overflowMode: LegendItemOverflowMode.wrap),
                      tooltipBehavior: _tooltipBehavior,
                      series: <CircularSeries>[
                        DoughnutSeries<GDPData, String>(
                          emptyPointSettings: EmptyPointSettings(
                            mode: EmptyPointMode.gap,
                            borderWidth: 1,
                            borderColor: Colors.black,
                            color: Colors.grey,
                          ),
                          radius: '80%',
                          explode: true,
                          explodeOffset: '10%',
                          dataSource: _chartData,
                          strokeColor: Colors.black,
                          xValueMapper: (GDPData data, _) => data.status,
                          yValueMapper: (GDPData data, _) => data.count,
                          pointColorMapper: (GDPData data, _) => data.color,
                          dataLabelMapper: (GDPData data, _) => data.text,
                          dataLabelSettings: const DataLabelSettings(
                            //  showZeroValue: false,
                            isVisible: true,
                          ),
                          enableTooltip: true,
                        )
                      ],
                    )
                  : const Center(child: CircularProgressIndicator()),
              DashBoardListButton(
                icon: Icon(
                  Icons.fiber_new_rounded,
                  size: 35,
                  color: Colors.blue.shade400,
                ),
                title: TicketConstant.newTickets,
                press: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TicketStatusListBody(
                              ticketListTitle: TicketConstant.newTickets,
                              filter: "0",
                            )),
                  );
                  refreshIndicatorKey.currentState?.show();
                },
              ),
              DashBoardListButton(
                icon: Icon(
                  Icons.pending_actions_rounded,
                  size: 35,
                  color: Colors.orange.shade400,
                ),
                title: TicketConstant.inProgressTickets,
                press: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TicketStatusListBody(
                              ticketListTitle: TicketConstant.inProgressTickets,
                              filter: "50",
                            )),
                  );
                  refreshIndicatorKey.currentState?.show();
                },
              ),
              DashBoardListButton(
                icon: Icon(
                  Icons.check_circle_rounded,
                  size: 35,
                  color: Colors.green.shade400,
                ),
                title: TicketConstant.closedTickets,
                press: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TicketStatusListBody(
                              ticketListTitle: TicketConstant.closedTickets,
                              filter: "100",
                            )),
                  );
                  refreshIndicatorKey.currentState?.show();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
