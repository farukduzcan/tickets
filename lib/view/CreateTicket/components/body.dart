import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tickets/components/background.dart';
import 'package:tickets/components/text_field_container.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/services/category_select_list_services.dart';
import '../../../components/raunded_button.dart';
import '../../../models/category_select_list.dart';
import 'filewidget.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> selectedFiles = [];
  List<Widget> fileWidgets = [];

  void pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      List<String> validPaths = result.paths
          .where((path) => path != null)
          .map((path) => path!)
          .toList();

      setState(() {
        selectedFiles.addAll(validPaths);
        fileWidgets = []; // fileWidgets listesini sıfırla

        for (var path in validPaths) {
          String fileName = path.split('/').last;
          fileWidgets.add(FileWidget(fileName: fileName, imagePath: path));
        }
      });
    }
  }

  Future<CategorySelectList?>? categoryDropdownData;
  @override
  void initState() {
    super.initState();
    categoryDropdownData = getDropdownData();
  }

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

  //List<String> denemeStringList = List.generate(10, (index) => "Sinan");

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginAndRegisterBackground(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder<CategorySelectList?>(
                      future: categoryDropdownData,
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
                                  snapshot.data?.data.length ?? 0,
                                  (index) {
                                    var item = snapshot.data?.data[index];
                                    return DropdownMenuItem(
                                      value: item?.value ?? 0,
                                      child: Text(item?.label ?? ""),
                                      onTap: () {},
                                    );
                                  },
                                ),
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
                          onTap: () async {
                            pickFiles();
                          },
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
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: fileWidgets.length,
                            itemBuilder: (context, index) {
                              return fileWidgets[index];
                            },
                          ),
                        ),
                      )

                      // Expanded(
                      //   flex: 1,
                      //   child: SizedBox(
                      //     height: 50,
                      //     child: ListView.builder(
                      //       scrollDirection: Axis.horizontal,
                      //       shrinkWrap: true,
                      //       itemCount: selectedFiles.length,
                      //       itemBuilder: (context, index) {
                      //         final file = selectedFiles[index];
                      //         return const SizedBox();
                      //         // Expanded(
                      //         //   flex: 3,
                      //         //   child: SizedBox(
                      //         //     width: 50,
                      //         //     child: ListTile(
                      //         //       title: Text(file),
                      //         //       trailing: IconButton(
                      //         //         icon: const Icon(Icons.delete),
                      //         //         onPressed: () {
                      //         //           setState(() {
                      //         //             selectedFiles.removeAt(index);
                      //         //           });
                      //         //         },
                      //         //       ),
                      //         //     ),
                      //         //   ),
                      //         // );
                      //       },
                      //     ),
                      //   ),
                      // )
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
        ],
      ),
    );
  }
}
