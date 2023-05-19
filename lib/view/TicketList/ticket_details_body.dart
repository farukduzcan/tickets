import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tickets/models/get_ticket_model.dart';
import 'package:tickets/services/get_ticket_services.dart';

import '../../constants.dart';
import 'components/download_item_card.dart';

class TicketDetailsBody extends StatefulWidget {
  final String id;
  const TicketDetailsBody({super.key, required this.id});

  @override
  State<TicketDetailsBody> createState() => _TicketDetailsBodyState();
}

class _TicketDetailsBodyState extends State<TicketDetailsBody> {
  Future<GetTicketModel?>? ticketDetails;
  @override
  void initState() {
    super.initState();
    ticketDetails = getTicket();
  }

  // api isteği
  Future<GetTicketModel?> getTicket() async {
    try {
      GetTicketServices ticketdetails = GetTicketServices();
      return ticketdetails.getItem(id: widget.id);
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FutureBuilder<GetTicketModel?>(
            future: ticketDetails,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: kCardBoxShodow,
                  ),
                  margin: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              kPrimaryColor,
                              kDarkPrimaryColor,
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                "Konu Başlığı:  ${snapshot.data!.data!.subject!.toUpperCase()}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text("Mesaj:  \n${snapshot.data!.data!.body!}"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                            "Katagori:  ${snapshot.data!.data!.categoryName!}\n"
                            "Oluşturan:  ${snapshot.data!.data!.createUserName!}"),
                      ),
                      snapshot.data!.data!.files.isEmpty
                          ? const SizedBox()
                          : Container(
                              margin: const EdgeInsets.all(10),
                              height: 65 *
                                  snapshot.data!.data!.files.length.toDouble(),
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: snapshot.data!.data!.files.length,
                                  itemBuilder: (context, index) {
                                    return TicketDownloadButton(
                                      index: index,
                                      snapshot: snapshot,
                                    );
                                  }),
                            ),
                    ],
                  ),
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
        ],
      ),
    );
  }
}