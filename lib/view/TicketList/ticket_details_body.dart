import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tickets/components/bottom_sheet_area.dart';
import 'package:tickets/components/raunded_button.dart';
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

  Future<GetTicketModel?>? ticketDetails;
  Future<TicketActionListModel?>? ticketActionListData;
  Future<CategorySelectList?>? categoryDropdownData;
  final _dropdownbuttonKey = GlobalKey<FormState>();
  int catogoryId = 0;
  @override
  void initState() {
    super.initState();
    ticketDetails = getTicket();
    ticketActionListData = getTicketList();
    categoryDropdownData = getDropdownData();
  }

  // api isteği
  Future<GetTicketModel?> getTicket() async {
    try {
      GetTicketServices ticketdetails = GetTicketServices();
      return ticketdetails.getItem(id: widget.id.toString());
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
      return ticketacionlist.getTicketActionList(
          ticketId: widget.id,
          filter: "",
          orderDir: "ASC",
          orderField: "Id",
          pageIndex: 1,
          pageSize: 100);
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
      body: Builder(
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
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    title: Text(snapshot
                                        .data!.datas[index].createUserName!),
                                    subtitle:
                                        Text(snapshot.data!.datas[index].body!),
                                    trailing: Text(snapshot
                                        .data!.datas[index].actionStatus!),
                                  ),
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
                //if (ticketStatus != "CLOSE" && UserModel.userData!.role == 2)
                FutureBuilder<GetTicketModel?>(
                  future: ticketDetails,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.data!.ticketStatus != "CLOSE" &&
                          UserModel.userData!.role == 2) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: RaundedButton(
                            buttonText: "İşlem Yap",
                            press: () {
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
                                  return BottomSheetArea(
                                    widget: widget,
                                    bottomsheettitle: "İşlem Seçiniz",
                                    child: Column(
                                      children: [
                                        TicketActionBottomButon(
                                            iconColor: Colors.green,
                                            buttonText: "Yanıtla",
                                            icon: Icons.reply_outlined,
                                            press: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                enableDrag: true,
                                                elevation: 3,
                                                backgroundColor: Colors.white,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                topRight: Radius
                                                                    .circular(
                                                                        20))),
                                                context: context,
                                                builder: (context) {
                                                  return BottomSheetReplyArea(
                                                      userRoleId: UserModel
                                                          .userData!.role!,
                                                      ticketId: widget.id,
                                                      widget: widget,
                                                      textReplyFocusNode:
                                                          _textReplyFocusNode);
                                                },
                                              );
                                            }),
                                        TicketActionBottomButon(
                                            iconColor: Colors.orange,
                                            buttonText: "Yönlendir",
                                            icon: Icons.directions_outlined,
                                            press: () {
                                              showModalBottomSheet(
                                                isScrollControlled: true,
                                                enableDrag: true,
                                                elevation: 3,
                                                backgroundColor: Colors.white,
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                topRight: Radius
                                                                    .circular(
                                                                        20))),
                                                context: context,
                                                builder: (context) {
                                                  return BottomSheetRedirectArea(
                                                    ticketId: widget.id,
                                                    widget: widget,
                                                    size: size,
                                                    categoryDropdownData:
                                                        categoryDropdownData,
                                                    dropdownbuttonKey:
                                                        _dropdownbuttonKey,
                                                  );
                                                },
                                              );
                                            }),
                                        TicketActionClosedButton(
                                            widget: widget),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }
                      if (snapshot.data!.data!.ticketStatus != "CLOSE" &&
                          UserModel.userData!.role == 3) {
                        return RaundedButton(
                            buttonText: "Yanıtla",
                            press: () {
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
                              );
                            });
                      } else if (snapshot.data!.data!.ticketStatus == "CLOSE") {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Center(child: Text("Bu talep kapatılmıştır.")),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Center(
                            child:
                                Text("Bu talep ile ilgili işlem yapılamıyor."),
                          ),
                        );
                      }
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("${snapshot.error}"),
                      );
                    }
                    return const Center(
                      child: SizedBox(),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
