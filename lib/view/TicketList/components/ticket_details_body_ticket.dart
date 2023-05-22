import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../models/get_ticket_model.dart';
import 'download_item_card.dart';

class TicketDetailsBodyTicket extends StatelessWidget {
  const TicketDetailsBodyTicket({
    super.key,
    required this.ticketDetails,
  });

  final Future<GetTicketModel?>? ticketDetails;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetTicketModel?>(
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
                        height:
                            65 * snapshot.data!.data!.files.length.toDouble(),
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
    );
  }
}
