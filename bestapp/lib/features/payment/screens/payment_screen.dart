import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/widgets/bottom_nav_bar.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../models/pass_plan.dart';
import '../../../routes/app_routes.dart';
import '../../../services/app_state.dart';
import '../widgets/payment_card.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  static const String _abaQrAssetPath = 'assets/images/aba.jpg';

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _holderController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  int _step = 0;
  bool _isPassFlow = false;

  @override
  void dispose() {
    _holderController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _showAbaQrDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Scan ABA QR', style: AppTextStyles.heading),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  _abaQrAssetPath,
                  width: 220,
                  height: 220,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text('Use your ABA app to scan and continue payment.', style: AppTextStyles.caption),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close', style: AppTextStyles.body),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final passPlans = state.passPlans.where((plan) => plan.id != 'single-ride').toList();
    final title = _step == 0
        ? 'Choose Ride Type'
        : _step == 1
            ? 'Choose Pass'
            : 'Payment Info';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: title,
        showBackButton: true,
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StepIndicator(currentStep: _step),
                const SizedBox(height: 14),
                Expanded(child: _buildStepContent(state, passPlans)),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_step == 1) _buildPassStepActionBar(),
          BottomNavBar(
            currentIndex: 2,
            onTap: (index) {
              state.setCurrentNavIndex(index);
              AppRoutes.navigateByTab(context, index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(AppState state, List<PassPlan> passPlans) {
    if (_step == 0) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How do you want to ride?', style: AppTextStyles.titleMedium.copyWith(fontSize: 18)),
            const SizedBox(height: 4),
            Text('Choose between one-time ride or a subscription pass.', style: AppTextStyles.caption),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: PaymentCard(
                    title: 'Single Ride',
                    subtitle: '\$${AppConstants.singleRidePrice.toStringAsFixed(2)}',
                    isSelected: !_isPassFlow,
                    onTap: () {
                      setState(() {
                        _isPassFlow = false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: PaymentCard(
                    title: 'Pass',
                    subtitle: state.selectedPassPlan.billingCycle,
                    isSelected: _isPassFlow,
                    onTap: () {
                      setState(() {
                        _isPassFlow = true;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: _isPassFlow ? 'Continue To Pass View' : 'Continue To Payment',
              icon: Icons.arrow_forward,
              onPressed: () {
                setState(() {
                  _step = _isPassFlow ? 1 : 2;
                });
              },
            ),
          ],
        ),
      );
    }

    if (_step == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose your pass', style: AppTextStyles.titleMedium.copyWith(fontSize: 18)),
          const SizedBox(height: 4),
          Text('Select the pass plan before entering payment details.', style: AppTextStyles.caption),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 12),
              itemCount: passPlans.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final plan = passPlans[index];
                return PaymentCard(
                  title: plan.name,
                  subtitle: '${plan.billingCycle} - \$${plan.priceUsd.toStringAsFixed(2)}',
                  isSelected: state.selectedPassPlan.id == plan.id,
                  onTap: () => state.selectPassPlan(plan),
                );
              },
            ),
          ),
        ],
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Payment Method', style: AppTextStyles.heading.copyWith(fontSize: 13)),
              const Spacer(),
              Text(
                'Add New',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.available,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInputField(
            controller: _holderController,
            label: 'Card holder name',
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Required';
              }
              if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                return 'Letters only';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          _buildInputField(
            controller: _numberController,
            label: 'Card number',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              if (!RegExp(r'^\d{12,16}$').hasMatch(value)) {
                return 'Invalid card number';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  controller: _expiryController,
                  label: 'Expiry date',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                    _ExpiryDateInputFormatter(),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                      return 'Invalid expiry';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInputField(
                  controller: _cvvController,
                  label: 'CVV',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  validator: (value) => RegExp(r'^\d{3}$').hasMatch(value ?? '') ? null : 'Invalid CVV',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _showAbaQrDialog,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFECEFF1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.qr_code_2, color: AppColors.textPrimary, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text('Tap here to pay via ABA', style: AppTextStyles.caption),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Amount', style: AppTextStyles.caption),
                Text(
                  '\$${(_isPassFlow ? state.totalPrice : AppConstants.singleRidePrice).toStringAsFixed(2)}',
                  style: AppTextStyles.heading.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  label: 'Back',
                  icon: Icons.arrow_back,
                  onPressed: () {
                    setState(() {
                      _step = _isPassFlow ? 1 : 0;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CustomButton(
                  label: 'Pay Now',
                  icon: Icons.arrow_forward,
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      Navigator.pushNamed(context, AppRoutes.paymentSuccess);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Secure encrypted transaction',
              style: AppTextStyles.caption.copyWith(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassStepActionBar() {
    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        margin: const EdgeInsets.only(top: 4),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border(top: BorderSide(color: AppColors.border.withOpacity(0.5))),
        ),
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                label: 'Back',
                icon: Icons.arrow_back,
                onPressed: () {
                  setState(() {
                    _step = 0;
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomButton(
                icon: Icons.arrow_forward,
                label: 'Continue',
                onPressed: () {
                  setState(() {
                    _step = 2;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFEDEFF1),
        labelStyle: AppTextStyles.caption.copyWith(fontSize: 10),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsOnly = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();

    for (int i = 0; i < digitsOnly.length && i < 4; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(digitsOnly[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    const labels = ['Ride', 'Pass', 'Payment'];
    return Row(
      children: List.generate(labels.length, (index) {
        final bool active = index <= currentStep;
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index == labels.length - 1 ? 0 : 6),
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: active ? AppColors.primary : const Color(0xFFECEFF1),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Center(
              child: Text(
                labels[index],
                style: AppTextStyles.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
