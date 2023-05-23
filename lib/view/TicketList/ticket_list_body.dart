import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
  Future<TicketListModel?>? ticketListData;
  final ScrollController _scrollController = ScrollController();
  int pageIndeks = 1;
  @override
  void initState() {
    super.initState();
    ticketListData = getTicketList();
    pageIndeks++;
    _scrollController.addListener(() {
      _scrollListener();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  //scroll işlemleri
  bool _isLoading = false;
  Future<void> _scrollListener() async {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent * 0.80 &&
        !_scrollController.position.outOfRange) {
      if (_isLoading) {
        // print("Gereksiz istek atıldı");
        return;
      } else if (_isLoading == false) {
        setState(() {
          _isLoading = true;
        });
        // print("Sayfa yüklendi yüklenen sayfa: $pageIndeks");
        await _loadNextPage();
      }
    }
  }

  Future<void> _loadNextPage() async {
    try {
      TicketListModel? newData = await getTicketList();
      if (newData != null && newData.totalPageCount! >= pageIndeks) {
        setState(() {
          // print("Current Page: $pageIndeks");
          pageIndeks++;
          //print("TotalPage: ${newData.totalPageCount}");
          ticketListData!.then((oldData) {
            oldData!.datas.addAll(newData.datas);
            return oldData;
          });
        });
      } else if (newData != null && newData.totalPageCount! <= pageIndeks) {
        setState(() {});
      }
    } catch (e) {
      if (kDebugMode) {
        print("Yeni veriler getirilirken hata oluştu");
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // api isteği
  Future<TicketListModel?> getTicketList() async {
    try {
      TicketListServices ticketlist = TicketListServices();
      return ticketlist.getTicketList(
          filter: "",
          orderDir: "DESC",
          orderField: "Id",
          pageIndex: pageIndeks,
          pageSize: 15);
    } catch (e) {
      if (kDebugMode) {
        print("itemler çekilirken hata oluştu");
      }
    }
    return null;
  }

  // durum iconları
  Icon getIcon({required String ticketType}) {
    switch (ticketType) {
      case "NEW":
        return const Icon(
          Icons.fiber_new_outlined,
          size: 45,
          color: kAccentColor,
        );
      case "APPROVED":
        return const Icon(
          Icons.fiber_new_outlined,
          size: 45,
          color: kAccentColor,
        );
      case "WORKING":
        return Icon(
          Icons.hourglass_top_rounded,
          size: 45,
          color: Colors.yellow.shade200,
        );
      case "CLOSE":
        return Icon(
          Icons.check_circle_outline,
          size: 45,
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

  //bildirim

  @override
  Widget build(BuildContext context) {
    return Column(
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
                            'assets/lottie/isemptylist.json',
                          ),
                        ),
                        const Text(
                          "Buralar Boş Sanırım :)",
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
                    physics: const BouncingScrollPhysics(),
                    itemCount: snapshot.data!.datas.length + 1,
                    itemBuilder: (context, index) {
                      if (index < snapshot.data!.datas.length) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Dismissible(
                            direction: DismissDirection.endToStart,
                            key:
                                Key(snapshot.data!.datas[index].id!.toString()),
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
                                    "Talep Sil",
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
                            confirmDismiss: (DismissDirection direction) async {
                              if (direction == DismissDirection.endToStart) {
                                final result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Öğeyi Sil"),
                                      content: const Text(
                                          "Bu öğeyi silmek istediğinize emin misiniz?"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text("İptal"),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text("Sil"),
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
                                id: snapshot.data!.datas[index].id!.toString(),
                              )
                                  .then((value) {
                                if (value!.data == null &&
                                    value.result!.isNegative == false) {
                                  const TopMessageBar(
                                    message: "Öğe Silindi!",
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
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(10),
                              leading: getIcon(
                                  ticketType: snapshot
                                      .data!.datas[index].ticketStatus!),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TicketDetailsBody(
                                      id: snapshot.data!.datas[index].id!,
                                    ),
                                  ),
                                );
                              },
                              title: Text(snapshot.data!.datas[index].subject!),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data!.datas[index].body!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "\nOluşturan: ${snapshot.data!.datas[index].createUserName!}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (_isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return const Center(
                          child: SizedBox(),
                        );
                      }
                    },
                  );
                }
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("${snapshot.error}"),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ],
    );
  }
}
