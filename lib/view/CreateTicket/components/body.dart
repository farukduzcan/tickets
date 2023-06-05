import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:tickets/components/text_field_container.dart';
import 'package:tickets/constants.dart';
import 'package:tickets/extensions/error_extensions.dart';
import 'package:tickets/models/customer_selectlist_model.dart';
import 'package:tickets/services/category_select_list_services.dart';
import 'package:tickets/services/create_ticket_addfile.dart';
import 'package:tickets/services/customer_selectlist_services.dart';
import '../../../components/raunded_button.dart';
import '../../../models/category_select_list.dart';
import '../../../models/user_model.dart';
import '../../../services/create_ticket_services.dart';
import 'filewidget.dart';

class CreateTicketBody extends StatefulWidget {
  static bool isComplated = false;

  const CreateTicketBody({super.key});

  @override
  State<CreateTicketBody> createState() => _CreateTicketBodyState();
}

class _CreateTicketBodyState extends State<CreateTicketBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _dropdownbuttonKey = GlobalKey<FormState>();

  List<String> selectedFiles = [];
  List<Widget> fileWidgets = [];
  List<File> fileList = [];

  void pickFiles() async {
    fileList.clear();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      List<String> validPaths = result.paths
          .where((path) => path != null)
          .map((path) => path!)
          .toList();

      for (var path in validPaths) {
        fileList.add(File(path));
      }
      //base64'e çevir
      //apiye array olarak gönder

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
  Future<CustomerSelectListModel?>? customerDropdownData;
  @override
  void initState() {
    super.initState();
    categoryDropdownData = getDropdownData();

    UserModel.userData!.role == 2
        ? customerDropdownData = getCustomerDropdownData()
        : null;
  }

  Future<CustomerSelectListModel?> getCustomerDropdownData() async {
    try {
      CustomerSelectListServices customerList = CustomerSelectListServices();
      return customerList.customerList();
    } catch (e) {
      if (kDebugMode) {
        print(ErrorMessagesConstant.itemsNotFound);
      }
    }
    return null;
  }

  Future<CategorySelectList?> getDropdownData() async {
    try {
      CateGorySelectListServices categorySelectListServices =
          CateGorySelectListServices();
      return categorySelectListServices.categoryselect();
    } catch (e) {
      if (kDebugMode) {
        print(ErrorMessagesConstant.itemsNotFound);
      }
    }
    return null;
  }

  //Controllerlar
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final FocusNode _subjectFocusNode = FocusNode();
  final FocusNode _bodyFocusNode = FocusNode();
  int catogoryId = 0;
  int customerId = 0;

  //List<String> denemeStringList = List.generate(10, (index) => "Sinan");

  // Buton Loadin Bar
  bool loading = false;
  void _loadingBar() {
    setState(() {
      loading = !loading;
    });
  }

  //API sonuc

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // kullanıcı seçimi
                UserModel.userData!.role == 2
                    ? FutureBuilder<CustomerSelectListModel?>(
                        future: customerDropdownData,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return const Center(
                                child: Text(ErrorMessagesConstant.error));
                          }
                          return TextFieldContainer(
                            color: kWhiteColor,
                            child: DropdownButtonFormField2(
                                validator: (value) {
                                  if (value == null) {
                                    return EmptyErrorMessagesConstant
                                        .emptyCustomer;
                                  }
                                  return null;
                                },
                                //key: _dropdownbuttonKey,
                                hint: Text(kCustomerTitle),
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
                                  customerId = selectValue;
                                }),
                          );
                        })
                    : const SizedBox(),

                //Kategori Seçimi
                FutureBuilder<CategorySelectList?>(
                    future: categoryDropdownData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text(ErrorMessagesConstant.error));
                      }
                      return TextFieldContainer(
                        color: kWhiteColor,
                        child: DropdownButtonFormField2(
                            validator: (value) {
                              if (value == null) {
                                return EmptyErrorMessagesConstant.emptyCategory;
                              }
                              return null;
                            },
                            key: _dropdownbuttonKey,
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
                              catogoryId = selectValue;
                            }),
                      );
                    }),
                //title
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFieldContainer(
                    color: kWhiteColor,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return EmptyErrorMessagesConstant.emptyTitle;
                        }
                        return null;
                      },
                      controller: _subjectController,
                      focusNode: _subjectFocusNode,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return EmptyErrorMessagesConstant.emptyDescription;
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
                                  const Icon(Icons.attach_file),
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
                  ],
                ),
                RaundedButton(
                  buttonText: kCreateTicketButton,
                  press: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      {
                        try {
                          _loadingBar();
                          CreateTicketServices createTicketServices =
                              CreateTicketServices();
                          var result = await createTicketServices.create(
                            customerId: customerId,
                            subject: _subjectController.text,
                            body: _bodyController.text,
                            categoryId: catogoryId,
                          );

                          if (result != null &&
                              result.result?.isNegative == false) {
                            CreateTicketServices.fileUploadId = result.result;
                            CreateTicketBody.isComplated = false;
                            if (fileList.isNotEmpty) {
                              CreateTicketServicesFileAdd fileAdd =
                                  CreateTicketServicesFileAdd();

                              await fileAdd.sendFiles(fileList);
                            }
                            // ignore: use_build_context_synchronously
                            QuickAlert.show(
                              confirmBtnText: QuickAlertConstant.ok,
                              onConfirmBtnTap: () {
                                _bodyController.clear();
                                _subjectController.clear();
                                setState(() {
                                  fileList.clear();
                                  fileWidgets.clear();
                                  _dropdownbuttonKey.currentState?.reset();
                                });
                                Navigator.pop(context);
                              },
                              context: context,
                              type: QuickAlertType.success,
                              title: QuickAlertConstant.success,
                              text: CreateTicketBody.isComplated
                                  ? QuickAlertConstant.createTicketMessage
                                  : QuickAlertConstant.createTicketMessage,
                            );
                          } else {
                            // ignore: use_build_context_synchronously
                            QuickAlert.show(
                                confirmBtnText: QuickAlertConstant.ok,
                                context: context,
                                type: QuickAlertType.error,
                                title: QuickAlertConstant.error,
                                text: result?.errors.errorToString() ??
                                    ErrorMessagesConstant.error);
                          }
                          _loadingBar();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: Colors.red,
                          ));
                        }
                      }
                    }
                  },
                  loadingText: kCreateTicketLoadingText,
                  isLoading: loading,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
