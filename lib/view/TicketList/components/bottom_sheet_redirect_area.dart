import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:tickets/view/TicketList/ticket_details_body.dart';

import '../../../components/bottom_sheet_area.dart';
import '../../../components/messenger_bar_top.dart';
import '../../../components/raunded_button.dart';
import '../../../components/text_field_container.dart';
import '../../../constants.dart';
import '../../../models/category_select_list.dart';
import '../../../services/ticket_action_create_services.dart';

class BottomSheetRedirectArea extends StatefulWidget {
  const BottomSheetRedirectArea({
    super.key,
    required this.widget,
    required this.size,
    required this.categoryDropdownData,
    required GlobalKey<FormState> dropdownbuttonKey,
    required this.ticketId,
  }) : _dropdownbuttonKey = dropdownbuttonKey;

  final TicketDetailsBody widget;
  final Size size;
  final Future<CategorySelectList?>? categoryDropdownData;
  final GlobalKey<FormState> _dropdownbuttonKey;
  final int ticketId;

  @override
  State<BottomSheetRedirectArea> createState() =>
      _BottomSheetRedirectAreaState();
}

class _BottomSheetRedirectAreaState extends State<BottomSheetRedirectArea> {
  bool loading = false;
  void _loadingBar() {
    setState(() {
      loading = !loading;
    });
  }

  int categoryValue = 0;
  String categoryLabel = "";

  @override
  Widget build(BuildContext context) {
    return BottomSheetArea(
      widget: widget.widget,
      bottomsheettitle: "Yönlendir",
      child: SizedBox(
        height: widget.size.height * 0.3,
        child: Column(
          children: [
            FutureBuilder<CategorySelectList?>(
                future: widget.categoryDropdownData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(child: Text("Hata oluştu."));
                  }
                  return TextFieldContainer(
                    color: kWhiteColor,
                    child: DropdownButtonFormField2(
                        key: widget._dropdownbuttonKey,
                        hint: Text(kCatocoryTitle),
                        isExpanded: true,
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: widget.size.height * 0.3,
                          width: widget.size.width * 0.8,
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
                              onTap: () {
                                setState(() {
                                  categoryLabel =
                                      snapshot.data?.data[index].label ?? "";
                                });
                              },
                            );
                          },
                        ),
                        onChanged: (selectValue) {
                          setState(() {
                            categoryValue = selectValue;
                          });
                        }),
                  );
                }),
            RaundedButton(
              loadingText: "Gönderiliyor...",
              isLoading: loading,
              buttonText: "Gönder",
              press: () async {
                _loadingBar();
                TicketActionCreateServices ticketActionCreateServices =
                    TicketActionCreateServices();
                // ignore: unused_local_variable
                var respons = await ticketActionCreateServices.setActionCreate(
                    categoryId: categoryValue,
                    body:
                        "Talebiniz $categoryLabel Kategorisine Başarıyla Yönlendirildi!",
                    ticketId: widget.ticketId,
                    actionStatus: "REDIRECT");
                if (respons!.errors == null) {
                  // ignore: use_build_context_synchronously
                  const TopMessageBar(
                    message: "Yönlendirme Başarıyla Gerçekleştirildi.",
                  ).showTopMessageBarsuccessful(context);
                }
                _loadingBar();
                await Future.delayed(const Duration(milliseconds: 1000), () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return TicketDetailsBody(
                        id: widget.ticketId,
                      );
                    }),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
