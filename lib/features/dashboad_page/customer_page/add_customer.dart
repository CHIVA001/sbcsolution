
import '/core/themes/app_colors.dart';
import '/core/themes/app_style.dart';
import '/features/dashboad_page/customer_page/controller/customer_controller.dart';
import '/features/dashboad_page/customer_page/controller/customer_group_price_controller.dart';
import '/widgets/build_app_bar.dart';
import '/widgets/build_style_input.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:remixicon/remixicon.dart';

class AddCustomer extends StatelessWidget {
  const AddCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerGroupPriceController());
    final customerCtr = Get.put(CustomerController());

    // // Fetch data once widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCustomerGroup();
      controller.fetchCustomerPriceGroup();
    });

    return Scaffold(
      appBar: buildAppBar(title: 'Add Customer'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.state == GViewState.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.state == GViewState.error ||
              controller.state == GViewState.network) {
            return Center(child: Text(controller.errorMessage.value));
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildContainer(
                        Column(
                          children: [
                            Text(
                              'Select Box',
                              style: textBold().copyWith(fontSize: 18.0),
                            ),
                            SizedBox(height: 16.0),

                            /// CUSTOMER GROUP DROPDOWN
                            DropdownSearch<String>(
                              items: (filter, loadProps) => controller
                                  .customerGroup
                                  .map((e) => e.name)
                                  .toList(),
                              dropdownBuilder: (context, selectedItem) => Text(
                                selectedItem ?? '',
                                style: const TextStyle(color: Colors.black),
                              ),

                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoratorProps: DropDownDecoratorProps(
                                decoration: defaultstyleInput(
                                  prefixIcon: RemixIcons.team_line,
                                  hint: 'Select Customer Group',
                                ),
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  final selected = controller.customerGroup
                                      .firstWhereOrNull((e) => e.name == value);
                                  controller.selectedCustomerGroup.value =
                                      selected;
                                }
                              },
                              selectedItem:
                                  controller.selectedCustomerGroup.value?.name,
                              popupProps: const PopupProps.menu(
                                showSearchBox: false,
                                fit: FlexFit.loose,
                              ),
                            ),
                            const SizedBox(height: 16),

                            /// PRICE GROUP DROPDOWN
                            DropdownSearch<String>(
                              items: (filter, loadProps) => controller
                                  .priceGroup
                                  .map((e) => e.name)
                                  .toList(),
                              dropdownBuilder: (context, selectedItem) =>
                                  Text(selectedItem ?? '', style: textMeduim()),
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onChanged: (value) {
                                if (value != null) {
                                  final selected = controller.priceGroup
                                      .firstWhereOrNull((e) => e.name == value);
                                  controller.selectedPriceGroup.value =
                                      selected;
                                }
                              },

                              decoratorProps: DropDownDecoratorProps(
                                decoration: defaultstyleInput(
                                  prefixIcon: RemixIcons.currency_line,
                                  hint: 'Select Price Group',
                                ),
                              ),
                              selectedItem:
                                  controller.selectedPriceGroup.value?.name,
                              popupProps: const PopupProps.menu(
                                showSearchBox: false,
                                fit: FlexFit.loose,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24.0),

                      _buildContainer(
                        Column(
                          children: [
                            Text(
                              'Informaion',
                              style: textBold().copyWith(fontSize: 18.0),
                            ),
                            SizedBox(height: 16.0),
                            _buildTextInput(
                              hint: 'Full Name',
                              controller: customerCtr.name,
                              icon: RemixIcons.user_3_line,
                              // validator: 'Full name',
                              // showValidator: true,
                            ),
                            const SizedBox(height: 16.0),
                            DropdownSearch<String>(
                              items: (filter, loadProps) =>
                                  controller.genderList,
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              dropdownBuilder: (context, selectedItem) =>
                                  Text(selectedItem ?? '', style: textMeduim()),

                              onChanged: (value) {
                                controller.selectedGender.value = value ?? '';
                              },

                              decoratorProps: DropDownDecoratorProps(
                                decoration: defaultstyleInput(
                                  hint: 'Gender',
                                  prefixIcon: RemixIcons.genderless_line,
                                ),
                              ),
                              selectedItem:
                                  controller.selectedGender.value.isEmpty
                                  ? null
                                  : controller.selectedGender.value,
                              popupProps: const PopupProps.menu(
                                showSearchBox: false,
                                fit: FlexFit.loose,
                              ),
                            ),

                            const SizedBox(height: 16.0),
                            _buildTextInput(
                              hint: 'Phone',
                              controller: customerCtr.phone,
                              icon: RemixIcons.phone_line,
                            ),
                            const SizedBox(height: 16.0),
                            _buildTextInput(
                              hint: 'City',
                              controller: customerCtr.city,
                              icon: RemixIcons.building_2_line,
                            ),
                            const SizedBox(height: 16.0),
                            _buildTextInput(
                              hint: 'Address',
                              controller: customerCtr.address,
                              icon: RemixIcons.map_pin_2_line,
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: customerCtr.note,
                              decoration: InputDecoration(
                                hintText: 'Note',
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(bottom: 70.0),
                                  child: Icon(RemixIcons.sticky_note_add_line),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14.0,
                                ),
                              ),
                              maxLines: 4,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.0),
                      _buildContainer(
                        Column(
                          children: [
                            Text(
                              'Locations',
                              style: textBold().copyWith(fontSize: 18.0),
                            ),
                            SizedBox(height: 16.0),
                            //
                            _buildTextInput(
                              hint: 'Name',
                              controller: customerCtr.locationName,
                            ),
                            SizedBox(height: 16.0),
                            //
                            _buildTextInput(
                              hint: 'Address',
                              controller: customerCtr.locationAddress,
                            ),
                            SizedBox(height: 16.0),
                            //
                            _buildTextInput(
                              hint: 'City',
                              controller: customerCtr.locationCity,
                            ),
                            SizedBox(height: 16.0),
                            //
                            _buildTextInput(
                              hint: 'Phone',
                              controller: customerCtr.locationPhone,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    
                    await customerCtr.addCustomer();
                  },

                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: AppColors.primaryColor,
                  ),
                  child: const Text('Add Customer'),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTextInput({
    required String hint,
    required TextEditingController controller,
    IconData? icon,
    int maxLines = 1,
    double bottom = 0,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
  }) {
    return TextFormField(
      controller: controller,
      decoration: defaultstyleInput(
        hint: hint,
        prefixIcon: icon,
        bottom: bottom,
      ),
      autovalidateMode: autovalidateMode,
      maxLines: maxLines,
    );
  }

  Widget _buildContainer(Widget child) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.primaryColor.withAlpha(80)),
      ),
      child: child,
    );
  }
}
