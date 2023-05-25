import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tickets/components/bottom_sheet_area.dart';
import 'package:tickets/models/get_ticket_model.dart';
import 'package:tickets/models/ticket_aciton_list_model.dart';
import 'package:tickets/services/get_ticket_services.dart';
import 'package:tickets/services/ticket_action_list_services.dart';
import 'package:tickets/view/TicketList/components/ticket_action_bottom_buton.dart';

import '../../constants.dart';
import '../../models/category_select_list.dart';
import '../../models/user_model.dart';
import '../../services/category_select_list_services.dart';
import 'components/bottom_sheet_close_button.dart';
import 'components/bottom_sheet_redirect_area.dart';
import 'components/bottom_sheet_reply_area.dart';
import 'components/ticket_details_body_ticket.dart';

class TicketDetailsBody extends StatefulWidget {
  final int id;
  const TicketDetailsBody({super.key, required this.id});

  @override
  State<TicketDetailsBody> createState() => _TicketDetailsBodyState();
}

class _TicketDetailsBodyState extends State<TicketDetailsBody> {
  final FocusNode _textReplyFocusNode = FocusNode();

  late Future<GetTicketModel?>? ticketDetails;
  late Future<TicketActionListModel?>? ticketActionListData;
  late Future<CategorySelectList?>? categoryDropdownData;
  final _dropdownbuttonKey = GlobalKey<FormState>();
  int catogoryId = 0;
  bool ticketStatus = false;
  @override
  void initState() {
    super.initState();
    ticketDetails = getTicket();
    ticketActionListData = getTicketList();
    categoryDropdownData = getDropdownData();
  }

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  // api isteği
  Future<GetTicketModel?> getTicket() async {
    try {
      GetTicketServices ticketdetails = GetTicketServices();
      var result = await ticketdetails.getItem(id: widget.id.toString());
      setState(() {
        result!.data!.ticketStatus == "CLOSE"
            ? ticketStatus = false
            : ticketStatus = true;
      });
      return result;
    } catch (e) {
      if (kDebugMode) {
        print("itemler çekilirken hata oluştu");
      }
    }
    return null;
  }

  // api isteği ticket action list
  Future<TicketActionListModel?> getTicketList() async {
    try {
      TicketActionListServices ticketacionlist = TicketActionListServices();

      var respons = await ticketacionlist.getTicketActionList(
          ticketId: widget.id,
          filter: "",
          orderDir: "DESC",
          orderField: "Id",
          pageIndex: 1,
          pageSize: 100);
      return respons;
    } catch (e) {
      if (kDebugMode) {
        print("itemler çekilirken hata oluştu");
      }
    }
    return null;
  }
  // api isteği kategori için

  Future<CategorySelectList?> getDropdownData() async {
    try {
      CateGorySelectListServices categorySelectListServices =
          CateGorySelectListServices();
      return categorySelectListServices.categoryselect();
    } catch (e) {
      if (kDebugMode) {
        print("itemler çekilirken hata oluştu");
      }
    }
    return null;
  }

  IconData getActionIconData(int index, String ticketStatus) {
    if (ticketStatus == "CUSTOMER_REPLY") {
      return Icons.person_outline;
    } else {
      return Icons.business_outlined;
    }
  }

  String getActionStatus(
      AsyncSnapshot<TicketActionListModel?> snapshot, int index) {
    switch (snapshot.data!.datas[index].actionStatus) {
      case "CUSTOMER_REPLY":
        return "Müşteri Yanıtı";
      case "REPLY":
        return "Yanıt";
      case "REDIRECT":
        return "Yönlendirme";
      case "CLOSE":
        return "Kapatma İşlemi";
      default:
        return "Bilinmeyen";
    }
  }

  Icon getActionContainerIcon(int index, String ticketStatus) {
    if (ticketStatus == "REDIRECT") {
      return const Icon(
        Icons.directions_outlined,
        color: Colors.orange,
      );
    } else if (ticketStatus == "CLOSE") {
      return const Icon(
        Icons.checklist_rounded,
        color: Colors.green,
      );
    } else {
      return const Icon(
        Icons.reply,
        color: Colors.transparent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        shadowColor: kPrimaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(29),
            bottomRight: Radius.circular(29),
          ),
        ),
        backgroundColor: kPrimaryColor,
        title: Text(kTicketListDetailsTitle),
      ),
      floatingActionButton: ticketStatus
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () async {
                if (UserModel.userData!.role == 2) {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    enableDrag: true,
                    elevation: 3,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    context: context,
                    builder: (context) {
                      return BottomSheetArea(
                        widget: widget,
                        bottomsheettitle: "İşlem Seçiniz",
                        child: Column(
                          children: [
                            TicketActionBottomButon(
                                iconColor: Colors.green,
                                buttonText: "Yanıtla",
                                icon: Icons.reply_outlined,
                                press: () async {
                                  Navigator.pop(context);
                                  await showModalBottomSheet(
                                    isScrollControlled: true,
                                    enableDrag: true,
                                    elevation: 3,
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                    context: context,
                                    builder: (context) {
                                      return BottomSheetReplyArea(
                                          userRoleId: UserModel.userData!.role!,
                                          ticketId: widget.id,
                                          widget: widget,
                                          textReplyFocusNode:
                                              _textReplyFocusNode);
                                    },
                                  );
                                  refreshIndicatorKey.currentState?.show();
                                }),
                            TicketActionBottomButon(
                              iconColor: Colors.orange,
                              buttonText: "Yönlendir",
                              icon: Icons.directions_outlined,
                              press: () async {
                                Navigator.pop(context);
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  enableDrag: true,
                                  elevation: 3,
                                  backgroundColor: Colors.white,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  context: context,
                                  builder: (context) {
                                    return BottomSheetRedirectArea(
                                      ticketId: widget.id,
                                      widget: widget,
                                      size: size,
                                      categoryDropdownData:
                                          categoryDropdownData,
                                      dropdownbuttonKey: _dropdownbuttonKey,
                                    );
                                  },
                                );
                                refreshIndicatorKey.currentState?.show();
                              },
                            ),
                            TicketActionClosedButton(
                              press: () {
                                refreshIndicatorKey.currentState?.show();
                              },
                              widget: widget,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (UserModel.userData!.role == 3) {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    enableDrag: true,
                    elevation: 3,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    context: context,
                    builder: (context) {
                      return BottomSheetReplyArea(
                          userRoleId: UserModel.userData!.role!,
                          ticketId: widget.id,
                          widget: widget,
                          textReplyFocusNode: _textReplyFocusNode);
                    },
                  ).then((value) => refreshIndicatorKey.currentState?.show());
                }
              })
          : null,
      body: RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: () async {
          setState(() {
            ticketDetails = getTicket();
            ticketActionListData = getTicketList();
            categoryDropdownData = getDropdownData();
          });
        },
        child: Builder(
          builder: (BuildContext context) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TicketDetailsBodyTicket(ticketDetails: ticketDetails),
                  FutureBuilder<TicketActionListModel?>(
                    future: ticketActionListData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.totalItemsCount == 0) {
                          return const Center(
                            child: SizedBox(),
                          );
                        }
                        if (snapshot.data!.totalItemsCount! > 0) {
                          return Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.zero,
                                child: Text(
                                  "Yanıtlar",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 0),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.totalItemsCount!,
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      snapshot.data!.datas[index]
                                                  .createUserName ==
                                              UserModel.userData!.firstName +
                                                  " " +
                                                  UserModel.userData!.lastName
                                          ? const SizedBox(
                                              width: 0,
                                            )
                                          : SizedBox(
                                              width: size.width * 0.1,
                                              height: size.width * 0.1,
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    Colors.blueAccent.shade200,
                                                radius: 45,
                                                child: ClipOval(
                                                  child: Icon(
                                                    getActionIconData(
                                                        index,
                                                        snapshot
                                                            .data!
                                                            .datas[index]
                                                            .actionStatus!),
                                                    color: Colors.white,
                                                    size: 25,
                                                  ),
                                                ),
                                              ),
                                            ),
                                      Container(
                                        padding: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: kCardBoxShodow,
                                        ),
                                        margin: EdgeInsets.only(
                                            left: size.width * 0.02,
                                            right: size.width * 0.02,
                                            bottom: 5,
                                            top: 5),
                                        width: size.width * 0.70,
                                        child: Column(
                                          crossAxisAlignment: snapshot
                                                      .data!
                                                      .datas[index]
                                                      .createUserName !=
                                                  UserModel
                                                          .userData!.firstName +
                                                      " " +
                                                      UserModel
                                                          .userData!.lastName
                                              ? CrossAxisAlignment.start
                                              : CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  snapshot.data!.datas[index]
                                                      .createUserName!,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const Spacer(),
                                                getActionContainerIcon(
                                                    index,
                                                    snapshot.data!.datas[index]
                                                        .actionStatus!),
                                              ],
                                            ),
                                            Text(
                                              getActionStatus(snapshot, index),
                                              style: const TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontSize: 10,
                                                  color: Colors.grey),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Text(snapshot
                                                  .data!.datas[index].body!),
                                            ),
                                          ],
                                        ),
                                      ),
                                      snapshot.data!.datas[index]
                                                  .createUserName !=
                                              UserModel.userData!.firstName +
                                                  " " +
                                                  UserModel.userData!.lastName
                                          ? const SizedBox(
                                              width: 0,
                                            )
                                          : SizedBox(
                                              width: size.width * 0.1,
                                              height: size.width * 0.1,
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    Colors.blueAccent.shade200,
                                                radius: 45,
                                                child: ClipOval(
                                                  child: Icon(
                                                    getActionIconData(
                                                        index,
                                                        snapshot
                                                            .data!
                                                            .datas[index]
                                                            .actionStatus!),
                                                    color: Colors.white,
                                                    size: 25,
                                                  ),
                                                ),
                                              ),
                                            ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          );
                        }
                        return const SizedBox();
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text("Hata Oluştu"),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),

                  //İşlem/Yanıt Yapma Bölümü

                  // FutureBuilder<GetTicketModel?>(
                  //   future: ticketDetails,
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasData) {
                  //       if (snapshot.data!.data!.ticketStatus != "CLOSE" &&
                  //           UserModel.userData!.role == 2) {
                  //         return Padding(
                  //           padding: const EdgeInsets.only(bottom: 20),
                  //           child: RaundedButton(
                  //             buttonText: "İşlem Yap",
                  //             press: () {
                  //               showModalBottomSheet(
                  //                 isScrollControlled: true,
                  //                 enableDrag: true,
                  //                 elevation: 3,
                  //                 backgroundColor: Colors.white,
                  //                 shape: const RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.only(
                  //                     topLeft: Radius.circular(20),
                  //                     topRight: Radius.circular(20),
                  //                   ),
                  //                 ),
                  //                 context: context,
                  //                 builder: (context) {
                  //                   return BottomSheetArea(
                  //                     widget: widget,
                  //                     bottomsheettitle: "İşlem Seçiniz",
                  //                     child: Column(
                  //                       children: [
                  //                         TicketActionBottomButon(
                  //                             iconColor: Colors.green,
                  //                             buttonText: "Yanıtla",
                  //                             icon: Icons.reply_outlined,
                  //                             press: () async {
                  //                               Navigator.pop(context);
                  //                               await showModalBottomSheet(
                  //                                 isScrollControlled: true,
                  //                                 enableDrag: true,
                  //                                 elevation: 3,
                  //                                 backgroundColor: Colors.white,
                  //                                 shape: const RoundedRectangleBorder(
                  //                                     borderRadius:
                  //                                         BorderRadius.only(
                  //                                             topLeft: Radius
                  //                                                 .circular(20),
                  //                                             topRight: Radius
                  //                                                 .circular(
                  //                                                     20))),
                  //                                 context: context,
                  //                                 builder: (context) {
                  //                                   return BottomSheetReplyArea(
                  //                                       userRoleId: UserModel
                  //                                           .userData!.role!,
                  //                                       ticketId: widget.id,
                  //                                       widget: widget,
                  //                                       textReplyFocusNode:
                  //                                           _textReplyFocusNode);
                  //                                 },
                  //                               );
                  //                               refreshIndicatorKey.currentState
                  //                                   ?.show();
                  //                             }),
                  //                         TicketActionBottomButon(
                  //                           iconColor: Colors.orange,
                  //                           buttonText: "Yönlendir",
                  //                           icon: Icons.directions_outlined,
                  //                           press: () async {
                  //                             Navigator.pop(context);
                  //                             await showModalBottomSheet(
                  //                               isScrollControlled: true,
                  //                               enableDrag: true,
                  //                               elevation: 3,
                  //                               backgroundColor: Colors.white,
                  //                               shape:
                  //                                   const RoundedRectangleBorder(
                  //                                       borderRadius:
                  //                                           BorderRadius.only(
                  //                                               topLeft: Radius
                  //                                                   .circular(
                  //                                                       20),
                  //                                               topRight: Radius
                  //                                                   .circular(
                  //                                                       20))),
                  //                               context: context,
                  //                               builder: (context) {
                  //                                 return BottomSheetRedirectArea(
                  //                                   ticketId: widget.id,
                  //                                   widget: widget,
                  //                                   size: size,
                  //                                   categoryDropdownData:
                  //                                       categoryDropdownData,
                  //                                   dropdownbuttonKey:
                  //                                       _dropdownbuttonKey,
                  //                                 );
                  //                               },
                  //                             );
                  //                             refreshIndicatorKey.currentState
                  //                                 ?.show();
                  //                           },
                  //                         ),
                  //                         TicketActionClosedButton(
                  //                           press: () {
                  //                             refreshIndicatorKey.currentState
                  //                                 ?.show();
                  //                           },
                  //                           widget: widget,
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   );
                  //                 },
                  //               );
                  //             },
                  //           ),
                  //         );
                  //       }
                  //       if (snapshot.data!.data!.ticketStatus != "CLOSE" &&
                  //           UserModel.userData!.role == 3) {
                  //         return RaundedButton(
                  //             buttonText: "Yanıtla",
                  //             press: () async {
                  //               await showModalBottomSheet(
                  //                 isScrollControlled: true,
                  //                 enableDrag: true,
                  //                 elevation: 3,
                  //                 backgroundColor: Colors.white,
                  //                 shape: const RoundedRectangleBorder(
                  //                     borderRadius: BorderRadius.only(
                  //                         topLeft: Radius.circular(20),
                  //                         topRight: Radius.circular(20))),
                  //                 context: context,
                  //                 builder: (context) {
                  //                   return BottomSheetReplyArea(
                  //                       userRoleId: UserModel.userData!.role!,
                  //                       ticketId: widget.id,
                  //                       widget: widget,
                  //                       textReplyFocusNode:
                  //                           _textReplyFocusNode);
                  //                 },
                  //               );
                  //               refreshIndicatorKey.currentState?.show();
                  //             });
                  //       } else if (snapshot.data!.data!.ticketStatus ==
                  //           "CLOSE") {
                  //         return const Padding(
                  //           padding: EdgeInsets.only(bottom: 20),
                  //           child:
                  //               Center(child: Text("Bu talep kapatılmıştır.")),
                  //         );
                  //       } else {
                  //         return const Padding(
                  //           padding: EdgeInsets.only(bottom: 20),
                  //           child: Center(
                  //             child: Text(
                  //                 "Bu talep ile ilgili işlem yapılamıyor."),
                  //           ),
                  //         );
                  //       }
                  //     } else if (snapshot.hasError) {
                  //       return Center(
                  //         child: Text("${snapshot.error}"),
                  //       );
                  //     }
                  //     return const Center(
                  //       child: SizedBox(),
                  //     );
                  //   },
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
