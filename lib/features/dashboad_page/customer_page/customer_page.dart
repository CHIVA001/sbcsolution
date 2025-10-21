import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import '../../../core/localization/my_text.dart';
import '../../../core/themes/app_colors.dart';
import '../../../core/themes/app_style.dart';
import '../../../widgets/build_app_bar.dart';
import 'controller/customer_controller.dart';
import 'customer_detail.dart';

class CustomerPage extends StatelessWidget {
  CustomerPage({super.key});

  final _controller = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: buildAppBar(title: MyText.customer.tr),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Container(
                  margin: const EdgeInsets.all(16.0),
                  height: 50,
                  child: TextField(
                    controller: _controller.searchInputController,
                    decoration: InputDecoration(
                      hintText: 'Search name',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _controller.searchTerm.isNotEmpty
                          ? IconButton(
                              onPressed: _controller.clearSearch,
                              icon: const Icon(Icons.close),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onChanged: _controller.onSearchChange,
                  ),
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Customers: ${_controller.serverTotalCustomers}',
                          style: textMeduim(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _controller.state.value == ViewState.loading
                              ? 'Active:  ${_controller.activeCustomersCount}'
                              : 'Active:  ${_controller.activeCustomersCount + 1}',
                          style: textMeduim(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Inactive: ${_controller.inactiveCustomersCount}',
                          style: textMeduim(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(),
              ),
            ],
          ),

          // 📋 Customer List Body
          Expanded(
            child: Obx(() {
              // 🕑 Loading state
              if (_controller.state.value == ViewState.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              // 🌐 Network error
              if (_controller.state.value == ViewState.network) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.wifi_off,
                        size: 64.0,
                        color: AppColors.darkGrey,
                      ),
                      Text(
                        'Network not available',
                        style: textMeduim().copyWith(color: AppColors.darkGrey),
                      ),
                      const SizedBox(height: 8.0),
                      ElevatedButton.icon(
                        onPressed: _controller.fetchCustomers,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try again'),
                      ),
                    ],
                  ),
                );
              }

              // ❌ Error
              if (_controller.isError.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_outlined,
                        size: 64.0,
                        color: AppColors.dangerColor.withOpacity(0.5),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Error Service: ${_controller.errorMessage}',
                        style: textMeduim().copyWith(color: AppColors.darkGrey),
                      ),
                      const SizedBox(height: 8.0),
                      ElevatedButton.icon(
                        onPressed: _controller.fetchCustomers,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try again'),
                      ),
                    ],
                  ),
                );
              }

              // 🧍 No customers
              if (_controller.customers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.person, size: 64.0, color: AppColors.darkGrey),
                      SizedBox(height: 8.0),
                      Text(
                        'Customer not found!',
                        style: TextStyle(color: AppColors.darkGrey),
                      ),
                    ],
                  ),
                );
              }

              // 🔍 No match in search
              if (_controller.filteredCustomers.isEmpty &&
                  _controller.searchTerm.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: AppColors.darkGrey,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Not found!',
                        style: TextStyle(color: AppColors.darkGrey),
                      ),
                    ],
                  ),
                );
              }

              // ✅ Display Customer List
              return RefreshIndicator(
                onRefresh: _controller.fetchCustomers,
                child: AnimationLimiter(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemCount: _controller.filteredCustomers.length,
                    itemBuilder: (context, index) {
                      final customer = _controller.filteredCustomers[index];
                      final firstLetter = customer.name.isNotEmpty
                          ? customer.name[0].toUpperCase()
                          : '';
                      final avatarColor =
                          listColors[firstLetter] ?? Colors.grey;

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Card(
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                tileColor: AppColors.backgroundColor,
                                onTap: () {
                                  Get.to(
                                    () =>
                                        CustomerDetailPage(customer: customer),
                                    transition: Transition.downToUp,
                                    duration: const Duration(milliseconds: 300),
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundColor: avatarColor,
                                  child: Text(
                                    firstLetter,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  customer.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text('Code: ${customer.code}'),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color:
                                        customer.status.toLowerCase() ==
                                            'active'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  child: Text(
                                    customer.status,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
