import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tickets/components/token_valid.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/models/ticket_list_model.dart';
import 'package:tickets/services/delete_ticket_services.dart';
import 'package:tickets/services/ticket_list_services.dart';
import 'package:tickets/view/TicketList/ticket_details_body.dart';

import '../../components/messenger_bar_top.dart';

class TicketListBody extends StatefulWidget {
  const TicketListBody({super.key});

  @override
  State<TicketListBody> createState() => _TicketListBodyState();
}

class _TicketListBodyState extends State<TicketListBody> {
  late Future<TicketListModel?>? ticketListData;
  late final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late int pageIndeks = 1;
  int listDataPageLength = 0;
  @override
  void initState() {
    super.initState();
    ticketListData = getTicketList();
    TokenValidation().tokenValid(context, TicketListServices.isTokenValid);
    _scrollController.addListener(() {
      _scrollListener();
    });
  }

  // api isteği
  Future<TicketListModel?> getTicketList() async {
    try {
      TicketListServices ticketlist = TicketListServices();
      var listinfo = await ticketlist.getTicketList(
          filter: "",
          orderDir: "DESC",
          orderField: "Id",
          pageIndex: pageIndeks,
          pageSize: 15);
      if (listinfo!.totalPageCount! == 1) {
        setState(() {
          _isFinishedPage = true;
        });
      }
      if (listinfo.totalPageCount! > 1) {
        setState(() {
          _isFinishedPage = false;
        });
      }
      if (listinfo.totalPageCount == pageIndeks) {
        setState(() {
          _isFinishedPage = true;
        });
      }
      setState(() {
        pageIndeks++;
      });
      return listinfo;
    } catch (e) {
      if (kDebugMode) {
        print(ErrorMessagesConstant.emptyList);
      }
    }
    return null;
  }

  Future<void> _loadNextPage() async {
    try {
      TicketListModel? newData = await getTicketList();
      if (newData != null && newData.totalPageCount! + 1 >= pageIndeks) {
        setState(() {
          // print("Current Page: $pageIndeks");

          //print("TotalPage: ${newData.totalPageCount}");
          ticketListData!.then((oldData) {
            oldData!.datas.addAll(newData.datas);
            listDataPageLength = newData.totalPageCount!;
            return oldData;
          });
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print(ErrorMessagesConstant.error);
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  //scroll işlemleri
  bool _isLoading = false;
  late bool _isFinishedPage =
      true; // false ise sayfa bitmemiş demektir true ise bitmiş demektir
  Future<void> _scrollListener() async {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent * 0.60 &&
        !_scrollController.position.outOfRange) {
      if (_isLoading) {
        return;
      } else if (_isLoading == false && _isFinishedPage == false) {
        setState(() {
          _isLoading = true;
        });
        await _loadNextPage();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // durum iconları
  Icon getIcon({required String ticketType}) {
    switch (ticketType) {
      case "NEW":
        return Icon(
          Icons.fiber_new_rounded,
          size: 35,
          color: Colors.blue.shade400,
        );
      case "APPROVED":
        return const Icon(
          Icons.fiber_new_outlined,
          size: 45,
          color: kAccentColor,
        );
      case "WORKING":
        return Icon(
          Icons.pending_actions_rounded,
          size: 30,
          color: Colors.orange.shade400,
        );
      case "CLOSE":
        return Icon(
          Icons.check_circle_outline,
          size: 30,
          color: Colors.green.shade400,
        );
      case "CANCEL":
        return const Icon(
          Icons.cancel_outlined,
          size: 45,
          color: Colors.red,
        );
      default:
        return const Icon(
          Icons.fiber_new_outlined,
          size: 45,
          color: Colors.green,
        );
    }
  }

  //Talep durumu
  String getTicketStatus(AsyncSnapshot<TicketListModel?> snapshot, int index) {
    switch (snapshot.data!.datas[index].ticketStatus) {
      case "NEW":
        return TicketConstant.newTicket;
      case "APPROVED":
        return TicketConstant.approvedTicket;
      case "WORKING":
        return TicketConstant.workingTicket;
      case "CLOSE":
        return TicketConstant.completedTicket;
      case "CANCEL":
        return TicketConstant.canceledTicket;
      default:
        return TicketConstant.unknownTicket;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: () async {
        _isFinishedPage = true;
        pageIndeks = 1;
        ticketListData = getTicketList();
      },
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: FutureBuilder<TicketListModel?>(
              future: ticketListData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.totalItemsCount == 0) {
                    return Center(
                      child: Column(
                        children: [
                          SizedBox(
                            child: Lottie.asset(
                              AssetsConstant.emptyList,
                            ),
                          ),
                          const Text(
                            ErrorMessagesConstant.emptyList,
                            style: TextStyle(color: kDividerColor),
                          )
                        ],
                      ),
                    );
                  }
                  if (snapshot.data!.totalItemsCount! > 0) {
                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      itemCount: snapshot.data!.datas.length + 1,
                      itemBuilder: (context, index) {
                        if (index < snapshot.data!.datas.length) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: kCardBoxShodow,
                            ),
                            child: Dismissible(
                              direction: DismissDirection.endToStart,
                              key: Key(
                                  snapshot.data!.datas[index].id!.toString()),
                              background: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      TicketConstant.deleteTicket,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 45,
                                    ),
                                  ],
                                ),
                              ),
                              confirmDismiss:
                                  (DismissDirection direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  final result = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(QuickAlertConstant
                                            .deleteItemErrorTitle),
                                        content: const Text(
                                          QuickAlertConstant.deleteItemMessage,
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text(
                                                QuickAlertConstant.cancel),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: const Text(
                                                QuickAlertConstant.delete),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return result ?? false;
                                }
                                return false;
                              },
                              onDismissed: (direction) async {
                                DeleteTicketServices deleteTicket =
                                    DeleteTicketServices();
                                // ignore: unused_local_variable
                                var deleterespons = await deleteTicket
                                    .deleteTicket(
                                  id: snapshot.data!.datas[index].id!
                                      .toString(),
                                )
                                    .then((value) {
                                  if (value!.data == null &&
                                      value.result!.isNegative == false) {
                                    const TopMessageBar(
                                      message: QuickAlertConstant
                                          .deleteItemSuccessMessage,
                                    ).showTopMessageBarsuccessful(context);
                                  }
                                });
                                setState(() {
                                  snapshot.data!.datas.removeAt(index);
                                });
                              },
                              dismissThresholds: const {
                                DismissDirection.endToStart: 0.5, // Yüzde 0.5
                              },
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(10),
                                  trailing: const Icon(Icons.arrow_forward_ios),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TicketDetailsBody(
                                          id: snapshot.data!.datas[index].id!,
                                        ),
                                      ),
                                    );
                                    refreshIndicatorKey.currentState?.show();
                                  },
                                  title: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      getIcon(
                                          ticketType: snapshot.data!
                                              .datas[index].ticketStatus!),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              " ${snapshot.data!.datas[index].subject!.toUpperCase()}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              getTicketStatus(snapshot, index),
                                              style: const TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 10,
                                                  color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, top: 15, right: 5, bottom: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.datas[index].body!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        Text(
                                          "\nOluşturan: ${snapshot.data!.datas[index].createUserName!}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else if (_isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (_isFinishedPage == true) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text(
                                  "Sayfa Sonu ${snapshot.data!.datas.length} /${snapshot.data!.totalItemsCount}"),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    );
                  }
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const SizedBox();
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
