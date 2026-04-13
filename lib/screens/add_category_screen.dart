import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../app/app_theme.dart';
import '../features/expenses/add_category_controller.dart';
import '../utils/toast_helper.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class AddCategoryScreen extends ConsumerStatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  ConsumerState<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends ConsumerState<AddCategoryScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(addCategoryControllerProvider);
    _nameController = TextEditingController(text: state.name);
    _nameController.addListener(() {
      ref.read(addCategoryControllerProvider.notifier).setName(_nameController.text);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addCategoryControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text('Add Category', style: AppTextStyles.appBarTitle),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 40.h, 16.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FadeInUp(
                duration: const Duration(milliseconds: 200),
                child: AppTextField(
                  label: 'Enter category',
                  controller: _nameController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _handleSubmit(),
                ),
              ),
              SizedBox(height: 32.h),
              FadeInUp(
                duration: const Duration(milliseconds: 200),
                delay: const Duration(milliseconds: 60),
                child: AppButton(
                  label: 'Add category',
                  enabled: state.canSubmit,
                  isLoading: state.status == AddCategoryStatus.loading,
                  onPressed: _handleSubmit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final ctrl = ref.read(addCategoryControllerProvider.notifier);
    final ok = await ctrl.submit();
    if (!mounted || !ok) return;
    AppToast.success('Category added successfully');
    context.pop();
  }
}
