import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:tickets/view/TicketList/components/ticket_action_bottom_buton.dart';
import 'package:tickets/view/TicketList/ticket_details_body.dart';

import '../../../components/messenger_bar_top.dart';
import '../../../services/ticket_action_create_services.dart';

class TicketActionClosedButton extends StatefulWidget {
  final Function press;
  const TicketActionClosedButton({
    super.key,
    required this.widget,
    required this.press,
  });

  final TicketDetailsBody widget;

  @override
  State<TicketActionClosedButton> createState() =>
      _TicketActionClosedButtonState();
}

class _TicketActionClosedButtonState extends State<TicketActionClosedButton> {
  bool loading = false;
  void _loadingBar() {
    setState(() {
      loading = !loading;
      loading ? loadingProgressBar(context) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TicketActionBottomButon(
        iconColor: Colors.red,
        buttonText: "Kapat",
        icon: Icons.close_outlined,
        press: () async {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.warning,
            title: "Emin misiniz?",
            text: "Talep kapatılacak, bu işlemi onaylıyor musunuz?",
            cancelBtnText: "Hayır",
            confirmBtnText: "Evet",
            showCancelBtn: true,
            onCancelBtnTap: () {
              Navigator.pop(context);
            },
            onConfirmBtnTap: () async {
              _loadingBar();
              TicketActionCreateServices ticketActionCreateServices =
                  TicketActionCreateServices();
              // ignore: unused_local_variable
              var respons = await ticketActionCreateServices.setActionCreate(
                  body: "Bu Ticket Kapatıldı!",
                  ticketId: widget.widget.id,
                  actionStatus: "CLOSE");
              if (respons!.errors == null) {
                // ignore: use_build_context_synchronously
                const TopMessageBar(
                  message: "Ticket Başarıyla Kapatıldı!",
                ).showTopMessageBarsuccessful(context);
              }
              await Future.delayed(const Duration(milliseconds: 1000), () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              });
            },
          );
          widget.press();
        });
  }

  Future<dynamic> loadingProgressBar(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            height: 100,
            width: 100,
            child: const Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );
  }
}
