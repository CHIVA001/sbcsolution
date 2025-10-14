
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

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(_onScroll);

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
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: _controller.searchTerm.isNotEmpty
                          ? IconButton(
                              onPressed: () => _controller.clearShearch(),
                              icon: Icon(Icons.close),
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
                          'Customer: ${_controller.serverTotalCustomers} ',
                          style: textMeduim(),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Active: ${_controller.activeCustomersCount}',
                          style: textMeduim(),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Inactive: ${_controller.inactiveCustomersCount}',
                          style: textMeduim(),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(),
              ),
            ],
          ),
          Expanded(
            child: Obx(() {
              if (_controller.state.value == ViewState.loading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator()],
                  ),
                );
              }
              if (_controller.state.value == ViewState.network) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off,
                        size: 64.0,
                        color: AppColors.darkGrey,
                      ),
                      Text(
                        'Network not Available',
                        style: textMeduim().copyWith(color: AppColors.darkGrey),
                      ),
                      SizedBox(height: 8.0),
                      ElevatedButton.icon(
                        onPressed: () =>
                            _controller.fetchCustomers(isRefresh: true),
                        label: Text('Try again'),
                      ),
                    ],
                  ),
                );
              }
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
                      SizedBox(height: 8.0),
                      Text(
                        'Error Service: 500',
                        style: textMeduim().copyWith(color: AppColors.darkGrey),
                      ),
                      SizedBox(height: 8.0),
                      ElevatedButton.icon(
                        onPressed: () => _controller.fetchCustomers(),
                        label: Text('Try again'),
                      ),
                    ],
                  ),
                );
              }
              if (_controller.customers.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person, size: 64.0, color: AppColors.darkGrey),
                      SizedBox(height: 8.0),
                      Text(
                        'Customer Not found!',
                        style: textMeduim().copyWith(color: AppColors.darkGrey),
                      ),
                    ],
                  ),
                );
              }
              if (_controller.filteredCustomers.isEmpty &&
                  _controller.searchTerm.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: AppColors.darkGrey,
                      ),
                      Text(
                        'Not found!',
                        style: textdefualt().copyWith(
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () => _controller.fetchCustomers(isRefresh: true),
                child: AnimationLimiter(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    controller: _scrollController,
                    itemCount:
                        _controller.filteredCustomers.length +
                        (_controller.isLoadingMore.value &&
                                _controller.searchTerm.isEmpty
                            ? 1
                            : 0),
                    itemBuilder: (context, index) {
                      if (index == _controller.filteredCustomers.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    12.0,
                                  ),
                                ),
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

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _controller.fetchCustomers();
    }
  }
}
