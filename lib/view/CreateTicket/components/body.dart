import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:tickets/components/background.dart';
import 'package:tickets/components/raunded_button.dart';
import 'package:tickets/components/text_field_container.dart';
import 'package:tickets/constants.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginAndRegisterBackground(
      child: Column(
        children: [
          Container(
            height: size.height * 0.02,
            decoration: BoxDecoration(
              boxShadow: kContainerBoxShodow,
              color: kPrimaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFieldContainer(
                    color: kWhiteColor,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField2(
                          hint: Text(kCatocoryTitle),
                          isExpanded: true,
                          dropdownStyleData: DropdownStyleData(
                            offset: const Offset(0, -20), //
                            useRootNavigator: true,
                            useSafeArea: true,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          decoration: InputDecoration(
                            hintText: kCatocoryTitle,
                            border: InputBorder.none,
                          ),
                          items: const [
                            DropdownMenuItem(
                              child: Text("bir"),
                            ),
                          ],
                          onChanged: (selectValue) {}),
                    ),
                  ),
                  //title
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFieldContainer(
                      color: kWhiteColor,
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: kCreateTicketTitle,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFieldContainer(
                      color: kWhiteColor,
                      child: TextFormField(
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
                  Row(
                    children: [
                      Card(
                        shadowColor: kPrimaryColor,
                        shape: const StadiumBorder(),
                        elevation: 2,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {},
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(13.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.add),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(kCreateTicketFileAdd),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  RaundedButton(
                    buttonText: kCreateTicketButton,
                    press: () {},
                    loadingText: kCreateTicketLoadingText,
                    isLoading: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
