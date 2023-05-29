import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/services/delete_customer_services.dart';

import '../../../components/messenger_bar_top.dart';
import '../../../models/customer_list_model.dart';
import '../../../models/user_model.dart';
import '../../../services/customer_list_services.dart';
import '../../Login/login_screen.dart';
import '../CustomerCreate/customer_create_body.dart';

class CustomerListBody extends StatefulWidget {
  const CustomerListBody({super.key});

  @override
  State<CustomerListBody> createState() => _CustomerListBodyState();
}

class _CustomerListBodyState extends State<CustomerListBody> {
  late Future<CustomerListModel?>? customerListData;
  late final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late int pageIndeks = 1;
  int listDataPageLength = 0;
  String customerID = "";
  @override
  void initState() {
    super.initState();
    customerListData = getCustomerList();
    tokenValid();
    _scrollController.addListener(() {
      _scrollListener();
    });
  }

  tokenValid() async {
    if (CustomerListServices.isTokenValid == false) {
      QuickAlert.show(
        context: context,
        barrierDismissible: false,
        type: QuickAlertType.error,
        title: "Uyarı",
        text: "Oturumunuzun süresi doldu. Lütfen tekrar giriş yapın.",
        confirmBtnText: kOk,
        onConfirmBtnTap: () async {
          await deleteToken();
          CustomerListServices.isTokenValid = null;
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        },
      );
    }
  }

  // api isteği
  Future<CustomerListModel?> getCustomerList() async {
    try {
      CustomerListServices ticketlist = CustomerListServices();
      var listinfo = await ticketlist.getCustomerList(
          filter: "",
          orderDir: "DESC",
          orderField: "Id",
          pageIndex: pageIndeks,
          pageSize: 15);
      // print("Total Page: ${listinfo!.totalPageCount}");
      // print("Current Page: ${listinfo.currentPageIndex}");
      // print("Page Index: $pageIndeks");

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
        print("itemler çekilirken hata oluştu");
      }
    }
    return null;
  }

  Future<void> _loadNextPage() async {
    try {
      CustomerListModel? newData = await getCustomerList();
      if (newData != null && newData.totalPageCount! + 1 >= pageIndeks) {
        setState(() {
          // print("Current Page: $pageIndeks");

          //print("TotalPage: ${newData.totalPageCount}");
          customerListData!.then((oldData) {
            oldData!.datas.addAll(newData.datas);
            listDataPageLength = newData.totalPageCount!;
            return oldData;
          });
        });
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

  //scroll işlemleri
  bool _isLoading = false;
  late bool _isFinishedPage =
      true; // false ise sayfa bitmemiş demektir true ise bitmiş demektir
  Future<void> _scrollListener() async {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent * 0.60 &&
        !_scrollController.position.outOfRange) {
      if (_isLoading) {
        // print("Gereksiz istek atıldı");
        return;
      } else if (_isLoading == false && _isFinishedPage == false) {
        setState(() {
          _isLoading = true;
        });
        // print("Sayfa yüklendi yüklenen sayfa: $pageIndeks");
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
  Icon getIcon({required String customerinfo}) {
    switch (customerinfo) {
      case "false":
        return const Icon(
          Icons.close_sharp,
          size: 25,
          color: Colors.red,
        );
      case "true":
        return const Icon(
          Icons.check_circle_outline_sharp,
          size: 25,
          color: Colors.green,
        );
      case "mail":
        return const Icon(
          Icons.mail_outline_outlined,
          size: 25,
          color: Colors.green,
        );
      case "user":
        return const Icon(
          Icons.person_2_outlined,
          size: 25,
          color: Colors.green,
        );
      default:
        return const Icon(
          Icons.info_rounded,
          size: 25,
          color: Colors.orange,
        );
    }
  }

  //Talep durumu
  String getTicketStatus(
      AsyncSnapshot<CustomerListModel?> snapshot, int index) {
    switch (snapshot.data!.datas[index].isActive.toString()) {
      case "true":
        return "Aktif Kullanıcı";
      case "false":
        return "Aktif Olmayan Kullanıcı";
      default:
        return "Bilinmeyen";
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: () async {
        _isFinishedPage = true;
        pageIndeks = 1;
        customerListData = getCustomerList();
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateCustomerBody(),
                    ),
                  );
                  refreshIndicatorKey.currentState?.show();
                },
                icon: const Icon(Icons.person_add_alt),
                color: Colors.white,
              ),
            )
          ],
          centerTitle: true,
          shadowColor: kPrimaryColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(29),
              bottomRight: Radius.circular(29),
            ),
          ),
          backgroundColor: kPrimaryColor,
          title: Text(kCustomerListTitle),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 10,
              child: FutureBuilder<CustomerListModel?>(
                future: customerListData,
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
                                        "Müşteri Sil",
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
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    final result = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Müşteriyi Sil"),
                                          content: const Text(
                                              "Bu Müşteriyi silmek istediğinize emin misiniz?"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              child: const Text("İptal"),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
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
                                  DeleteCustomerServices deleteCustomer =
                                      DeleteCustomerServices();
                                  // ignore: unused_local_variable
                                  var deleterespons = await deleteCustomer
                                      .deleteCustomer(
                                    id: snapshot.data!.datas[index].id!
                                        .toString(),
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
                                child: Material(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    onTap: () async {},
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            getIcon(
                                              customerinfo: "user",
                                            ),
                                            const Text(
                                              "  Kullanıcı adı:",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              " ${snapshot.data!.datas[index].firstName!} ${snapshot.data!.datas[index].lastName!}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            getIcon(
                                              customerinfo: "mail",
                                            ),
                                            const Text(
                                              "  E-Mail:",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              " ${snapshot.data!.datas[index].email!}",
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            getIcon(
                                              customerinfo: snapshot
                                                  .data!.datas[index].isActive!
                                                  .toString(),
                                            ),
                                            const Text(
                                              "  Durum:",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              " ${getTicketStatus(snapshot, index)}",
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ],
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
      ),
    );
  }
}
