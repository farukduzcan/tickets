import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:tickets/constants.dart';

import '../../../components/messenger_bar_top.dart';
import '../../../models/category_list_model.dart';
import '../../../models/user_model.dart';
import '../../../services/category_list_services.dart';
import '../../../services/customer_list_services.dart';
import '../../../services/delete_category_services.dart';
import '../../Login/login_screen.dart';

class CategoryListBody extends StatefulWidget {
  const CategoryListBody({super.key});

  @override
  State<CategoryListBody> createState() => _CategoryListBodyState();
}

class _CategoryListBodyState extends State<CategoryListBody> {
  late Future<CategoryListModel?>? categoryListData;
  late final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late int pageIndeks = 1;
  int listDataPageLength = 0;
  String customerID = "";
  @override
  void initState() {
    super.initState();
    categoryListData = getCategoryList();
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
  Future<CategoryListModel?> getCategoryList() async {
    try {
      CategoryListServices ticketlist = CategoryListServices();
      var listinfo = await ticketlist.getCategoryList(
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
      CategoryListModel? newData = await getCategoryList();
      if (newData != null && newData.totalPageCount! + 1 >= pageIndeks) {
        setState(() {
          // print("Current Page: $pageIndeks");

          //print("TotalPage: ${newData.totalPageCount}");
          categoryListData!.then((oldData) {
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
  Icon getIcon({required String categoryinfo}) {
    switch (categoryinfo) {
      case "category":
        return const Icon(
          Icons.category,
          size: 25,
          color: Colors.green,
        );
      case "mail":
        return const Icon(
          Icons.mail_outline_outlined,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.only(right: 10),
      //       child: IconButton(
      //         onPressed: () async {
      //           // await Navigator.push(
      //           //   context,
      //           //   MaterialPageRoute(
      //           //     builder: (context) => const CreateCustomerBody(),
      //           //   ),
      //           // );
      //           refreshIndicatorKey.currentState?.show();
      //         },
      //         icon: const Icon(Icons.person_add_alt),
      //         color: Colors.white,
      //       ),
      //     )
      //   ],
      //   centerTitle: true,
      //   shadowColor: kPrimaryColor,
      //   shape: const RoundedRectangleBorder(
      //     borderRadius: BorderRadius.only(
      //       bottomLeft: Radius.circular(29),
      //       bottomRight: Radius.circular(29),
      //     ),
      //   ),
      //   backgroundColor: kPrimaryColor,
      //   title: Text(kCustomerListTitle),
      // ),
      body: RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: () async {
          _isFinishedPage = true;
          pageIndeks = 1;
          categoryListData = getCategoryList();
        },
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: FutureBuilder<CategoryListModel?>(
                future: categoryListData,
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
                                        "Kategoriyi Sil",
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
                                          title: const Text("Kategoriyi Sil"),
                                          content: const Text(
                                              "Bu Kategoriyi silmek istediğinize emin misiniz?"),
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
                                  DeleteCategoryServices deleteCustomer =
                                      DeleteCategoryServices();
                                  // ignore: unused_local_variable
                                  var deleterespons = await deleteCustomer
                                      .deleteCategory(
                                    id: snapshot.data!.datas[index].id!
                                        .toString(),
                                  )
                                      .then((value) {
                                    if (value!.data == null &&
                                        value.result!.isNegative == false) {
                                      const TopMessageBar(
                                        message: "Kategori Silindi!",
                                      ).showTopMessageBarsuccessful(context);
                                    } else {
                                      const TopMessageBar(
                                        message:
                                            "Kategori Silinemedi Sonra Tekrar Deneyiniz!",
                                      ).showTopMessageBarError(context);
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
                                              categoryinfo: "category",
                                            ),
                                            const Text(
                                              "  Kategori Adı:",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              " ${snapshot.data!.datas[index].name!} ",
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
                                              categoryinfo: "mail",
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
