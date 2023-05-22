import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tickets/components/raunded_button.dart';
import 'package:tickets/models/get_ticket_model.dart';
import 'package:tickets/models/ticket_aciton_list_model.dart';
import 'package:tickets/services/get_ticket_services.dart';
import 'package:tickets/services/ticket_action_list_services.dart';

import '../../components/text_field_container.dart';
import '../../constants.dart';
import 'components/ticket_details_body_ticket.dart';

class TicketDetailsBody extends StatefulWidget {
  final int id;
  const TicketDetailsBody({super.key, required this.id});

  @override
  State<TicketDetailsBody> createState() => _TicketDetailsBodyState();
}

class _TicketDetailsBodyState extends State<TicketDetailsBody> {
  Future<GetTicketModel?>? ticketDetails;
  Future<TicketActionListModel?>? ticketActionListData;
  @override
  void initState() {
    super.initState();
    ticketDetails = getTicket();
    ticketActionListData = getTicketList();
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
          pageSize: 10);
    } catch (e) {
      if (kDebugMode) {
        print("itemler çekilirken hata oluştu");
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: RaundedButton(
                    buttonText: "İşlem Yap",
                    press: () {
                      showBottomSheet(
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
                            bottomsheettitle: "Yanıtla",
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                      //width: size.width,
                                      ),
                                  Form(
                                    // key: _formKey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFieldContainer(
                                        color: kWhiteColor,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Açıklama alanı boş olamaz';
                                            }
                                            return null;
                                          },
                                          //controller: _bodyController,
                                          // focusNode: _bodyFocusNode,
                                          minLines: 4,
                                          maxLines: 5,
                                          maxLength: 500,
                                          scrollPhysics:
                                              const BouncingScrollPhysics(),
                                          keyboardType: TextInputType.multiline,
                                          textInputAction:
                                              TextInputAction.newline,
                                          decoration: InputDecoration(
                                            hintText: kCreateTicketDescription,
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  RaundedButton(
                                    buttonText: "Gönder",
                                    press: () {},
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class BottomSheetArea extends StatelessWidget {
  final String bottomsheettitle;
  final Widget child;
  const BottomSheetArea({
    super.key,
    required this.widget,
    required this.bottomsheettitle,
    required this.child,
  });

  final TicketDetailsBody widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 24,
              child: Stack(
                children: [
                  Center(
                    child: Divider(
                      color: Colors.black.withOpacity(0.70),
                      thickness: 2,
                      indent: MediaQuery.of(context).size.width * 0.4,
                      endIndent: MediaQuery.of(context).size.width * 0.4,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 5,
                    height: 24,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close, color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
            Text(
              bottomsheettitle,
              style: const TextStyle(color: Colors.black),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
