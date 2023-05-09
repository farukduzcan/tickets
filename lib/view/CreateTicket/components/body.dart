import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tickets/components/background.dart';
import 'package:tickets/components/raunded_button.dart';
import 'package:tickets/components/text_field_container.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/services/category_select_list_services.dart';

import '../../../models/category_select_list.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getDropdownData();
  }

  Future<CategorySelectList?> getDropdownData() async {
    try {
      CateGorySelectListServices categorySelectListServices =
          CateGorySelectListServices();
      return categorySelectListServices.categoryselect();
    } catch (e) {
      if (kDebugMode) {
        print("itemler çekilirken hata oluşt");
      }
    }
    return null;
  }

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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<CategorySelectList?>(
                        future: getDropdownData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return const Center(child: Text("Hata oluştu."));
                          }
                          return TextFieldContainer(
                            color: kWhiteColor,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButtonFormField2(
                                  onMenuStateChange: (isOpen) {
                                    // if (isOpen == true) {
                                    //   CateGorySelectListServices
                                    //       categorySelectListServices =
                                    //       CateGorySelectListServices();
                                    //   var result =
                                    //       categorySelectListServices.categoryselect();
                                    // }
                                    print(isOpen);
                                  },
                                  hint: Text(kCatocoryTitle),
                                  isExpanded: true,
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: size.height * 0.3,
                                    width: size.width * 0.8,
                                    offset: const Offset(-20, -20), //
                                    useRootNavigator: true,
                                    useSafeArea: true,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(29),
                                    ),
                                  ),
                                  decoration: InputDecoration(
                                    hintText: kCatocoryTitle,
                                    border: InputBorder.none,
                                  ),
                                  items: List<DropdownMenuItem>.generate(
                                      snapshot.data?.data.length ?? 0, (index) {
                                    var item = snapshot.data?.data[index];
                                    return DropdownMenuItem(
                                      value: item?.value ?? 0,
                                      child: Text(item?.label ?? ""),
                                      onTap: () {},
                                    );
                                  }),
                                  onChanged: (selectValue) {
                                    print(selectValue);
                                  }),
                            ),
                          );
                        }),
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
                      press: () {
                        if (_formKey.currentState?.validate() ?? false) {}
                      },
                      loadingText: kCreateTicketLoadingText,
                      isLoading: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
