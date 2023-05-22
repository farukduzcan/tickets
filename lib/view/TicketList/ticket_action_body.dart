import 'package:flutter/material.dart';
import 'package:tickets/components/raunded_button.dart';

import '../../components/text_field_container.dart';
import '../../constants.dart';

class TicketActionBody extends StatefulWidget {
  final int ticketid;
  const TicketActionBody({super.key, required this.ticketid});

  @override
  State<TicketActionBody> createState() => _TicketActionBodyState();
}

class _TicketActionBodyState extends State<TicketActionBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _bodyController = TextEditingController();
  final FocusNode _bodyFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        title: Text(kTicketActionReply),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFieldContainer(
                  color: kWhiteColor,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Açıklama alanı boş olamaz';
                      }
                      return null;
                    },
                    controller: _bodyController,
                    focusNode: _bodyFocusNode,
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
              buttonText: "Gönder",
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}
