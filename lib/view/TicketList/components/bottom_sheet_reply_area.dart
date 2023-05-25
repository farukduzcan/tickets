import 'package:flutter/material.dart';
import 'package:tickets/components/bottom_sheet_area.dart';
import 'package:tickets/services/ticket_action_create_services.dart';
import 'package:tickets/view/TicketList/ticket_details_body.dart';

import '../../../components/messenger_bar_top.dart';
import '../../../components/raunded_button.dart';
import '../../../components/text_field_container.dart';
import '../../../constants.dart';

class BottomSheetReplyArea extends StatefulWidget {
  const BottomSheetReplyArea({
    super.key,
    required this.widget,
    required FocusNode textReplyFocusNode,
    required this.ticketId,
    required this.userRoleId,
  }) : _textReplyFocusNode = textReplyFocusNode;

  final TicketDetailsBody widget;
  final FocusNode _textReplyFocusNode;
  final int ticketId;
  final int userRoleId;

  @override
  State<BottomSheetReplyArea> createState() => _BottomSheetReplyAreaState();
}

class _BottomSheetReplyAreaState extends State<BottomSheetReplyArea> {
  bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _replyController = TextEditingController();
  void _loadingBar() {
    setState(() {
      loading = !loading;
    });
  }

  String getUserRole() {
    if (widget.userRoleId == 2) {
      return "REPLY";
    } else if (widget.userRoleId == 3) {
      return "CUSTOMER_REPLY";
    } else {
      return "REPLY";
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetArea(
      widget: widget.widget,
      bottomsheettitle: "Yanıtla",
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFieldContainer(
                color: kWhiteColor,
                child: TextFormField(
                  controller: _replyController,
                  focusNode: widget._textReplyFocusNode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Yanıtlama alanı boş olamaz';
                    }
                    return null;
                  },
                  minLines: 4,
                  maxLines: 5,
                  maxLength: 500,
                  scrollPhysics: const BouncingScrollPhysics(),
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: kCreateTicketDescription,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          RaundedButton(
            loadingText: "Gönderiliyor...",
            isLoading: loading,
            buttonText: "Gönder",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _loadingBar();
                TicketActionCreateServices ticketActionCreateServices =
                    TicketActionCreateServices();
                // ignore: unused_local_variable
                var respons = await ticketActionCreateServices.setActionCreate(
                  body: _replyController.text,
                  ticketId: widget.ticketId,
                  actionStatus: getUserRole(),
                );
                if (respons!.errors == null) {
                  // ignore: use_build_context_synchronously
                  const TopMessageBar(
                    message: "Yanıtınız Başarıyla Gönderildi!",
                  ).showTopMessageBarsuccessful(context);
                }

                await Future.delayed(const Duration(milliseconds: 1000), () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  _loadingBar();
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
