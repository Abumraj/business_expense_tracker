import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../app/app_theme.dart';
import '../features/customers/add_customer_controller.dart';
import '../utils/toast_helper.dart';
import '../widgets/app_button.dart';
import '../widgets/app_dropdown_field.dart';
import '../widgets/app_text_field.dart';

class AddCustomerScreen extends ConsumerStatefulWidget {
  const AddCustomerScreen({super.key, this.isEdit = false, this.customer});

  final bool isEdit;
  final Map<String, dynamic>? customer;

  @override
  ConsumerState<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends ConsumerState<AddCustomerScreen> {
  late final TextEditingController _firstNameCtrl;
  late final TextEditingController _lastNameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;

  late final AutoDisposeStateNotifierProvider<
    AddCustomerController,
    AddCustomerState
  >
  _provider;

  static const _cities = ['Port Harcourt', 'Lagos', 'Abuja', 'Ibadan', 'Kano'];
  static const _countries = ['Nigeria', 'Ghana', 'Kenya', 'South Africa'];

  List<String> _citiesFor(String? current) {
    if (current == null || current.trim().isEmpty) return _cities;
    if (_cities.contains(current)) return _cities;
    return [current, ..._cities];
  }

  List<String> _countriesFor(String? current) {
    if (current == null || current.trim().isEmpty) return _countries;
    if (_countries.contains(current)) return _countries;
    return [current, ..._countries];
  }

  @override
  void initState() {
    super.initState();

    if (widget.isEdit && widget.customer != null) {
      final c = widget.customer!;
      final id = c['id']?.toString() ?? c['_id']?.toString() ?? '';
      _provider = editCustomerControllerProvider((
        state: AddCustomerState(
          firstName: c['firstName']?.toString() ?? '',
          lastName: c['lastName']?.toString() ?? '',
          email: c['email']?.toString() ?? '',
          phone: c['phoneNumber']?.toString() ?? '',
          city: c['city']?.toString(),
          country: c['country']?.toString(),
        ),
        id: id,
      ));
    } else {
      _provider = addCustomerControllerProvider;
    }

    final s = ref.read(_provider);
    _firstNameCtrl = TextEditingController(text: s.firstName);
    _lastNameCtrl = TextEditingController(text: s.lastName);
    _emailCtrl = TextEditingController(text: s.email);
    _phoneCtrl = TextEditingController(text: s.phone);

    _firstNameCtrl.addListener(
      () => ref.read(_provider.notifier).setFirstName(_firstNameCtrl.text),
    );
    _lastNameCtrl.addListener(
      () => ref.read(_provider.notifier).setLastName(_lastNameCtrl.text),
    );
    _emailCtrl.addListener(
      () => ref.read(_provider.notifier).setEmail(_emailCtrl.text),
    );
    _phoneCtrl.addListener(
      () => ref.read(_provider.notifier).setPhone(_phoneCtrl.text),
    );
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final ctrl = ref.read(_provider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.isEdit ? 'Edit Customer' : 'Add Customer',
          style: AppTextStyles.appBarTitle,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      child: AppTextField(
                        label: 'First name',
                        controller: _firstNameCtrl,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 40),
                      child: AppTextField(
                        label: 'Last name',
                        controller: _lastNameCtrl,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 80),
                      child: AppTextField(
                        label: 'Email Address',
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 120),
                      child: AppTextField(
                        label: 'Phone Number',
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 160),
                      child: AppDropdownField<String>(
                        label: 'City',
                        value: state.city,
                        items: _citiesFor(state.city),
                        onChanged: ctrl.setCity,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    FadeInUp(
                      duration: const Duration(milliseconds: 200),
                      delay: const Duration(milliseconds: 200),
                      child: AppDropdownField<String>(
                        label: 'Country',
                        value: state.country,
                        items: _countriesFor(state.country),
                        onChanged: ctrl.setCountry,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
              child: AppButton(
                label: widget.isEdit ? 'Save Changes' : 'Add Customer',
                enabled: state.canSubmit,
                isLoading: state.status == AddCustomerStatus.loading,
                onPressed: _handleSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final ctrl = ref.read(_provider.notifier);
    final ok = await ctrl.submit();
    if (!mounted || !ok) return;
    AppToast.success(
      widget.isEdit ? 'Customer updated' : 'Customer added successfully',
    );
    context.pop(true);
  }
}
