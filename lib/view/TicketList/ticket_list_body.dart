import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/models/ticket_list_model.dart';
import 'package:tickets/services/ticket_list_services.dart';

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
        return const Icon(
          Icons.hourglass_top_rounded,
          size: 45,
          color: kDarkPrimaryColor,
        );
      case "CLOSE":
        return const Icon(
          Icons.lock_outline,
          size: 45,
          color: kSecondaryTextColor,
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
                        child: ListTile(
                          leading: getIcon(
                              ticketType:
                                  snapshot.data!.datas[index].ticketStatus!),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {},
                          title: Text(snapshot.data!.datas[index].subject!),
                          subtitle: Text(
                            snapshot.data!.datas[index].body!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
