import 'package:cyspharama_app/core/localization/my_text.dart';
import 'package:cyspharama_app/core/themes/app_style.dart';
import 'package:cyspharama_app/widgets/build_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import '../../../core/themes/app_colors.dart';
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
      appBar: buildAppBar(title: MyText.customer),
      body: Obx(() {
        if (_controller.state.value == ViewState.loading &&
            _controller.customers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator()],
            ),
          );
        }

        if (_controller.isError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  size: 32,
                  color: AppColors.dangerColor.withOpacity(0.5),
                ),
                Text('Error something!', style: textdefualt()),
                SizedBox(height: 24.0),
                ElevatedButton.icon(
                  onPressed: () => _controller.fetchCustomers(),
                  label: Text('Try again', style: textMeduim()),
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
                  _controller.customers.length +
                  (_controller.isLoadingMore.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _controller.customers.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final customer = _controller.customers[index];
                final firstLetter = customer.name[0].toUpperCase();
                final avatarColor = listColors[firstLetter] ?? Colors.grey;

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
                          onTap: () {
                            Get.to(
                              () => CustomerDetailPage(customer: customer),
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
                              color: customer.status.toLowerCase() == 'active'
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
    );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _controller.fetchCustomers();
    }
  }
}
