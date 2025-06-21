import 'package:credbird/view/profile_views/kyc_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:credbird/viewmodel/profile_providers/registration_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:flutter/services.dart';

class RegistrationView extends StatelessWidget {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    return ChangeNotifierProvider(
      create: (_) => RegistrationProvider(),
      child: Scaffold(
        backgroundColor: theme["scaffoldBackground"],
        appBar: AppBar(
          title: const Text("Complete Registration"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: theme["textColor"],
        ),
        body: Consumer<RegistrationProvider>(
          builder: (context, provider, _) {
            if (provider.currentStep == 4) {
              return const KYCView();
            }
            return const _RegistrationStepper();
          },
        ),
      ),
    );
  }
}

class _RegistrationStepper extends StatefulWidget {
  const _RegistrationStepper();

  @override
  State<_RegistrationStepper> createState() => _RegistrationStepperState();
}

class _RegistrationStepperState extends State<_RegistrationStepper> {
  final _basicDetailsFormKey = GlobalKey<FormState>();
  final _panFormKey = GlobalKey<FormState>();
  final _bankFormKey = GlobalKey<FormState>();
  final _contactFormKey = GlobalKey<FormState>();

  // Controllers for Basic Details
  final _passportController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _pinController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();

  // Controllers for Contact Details
  final _contactNameController = TextEditingController();
  final _contactMobileController = TextEditingController();
  final _contactEmailController = TextEditingController();

  @override
  void dispose() {
    _passportController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _pinController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _contactNameController.dispose();
    _contactMobileController.dispose();
    _contactEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final theme = Provider.of<ThemeProvider>(context).themeConfig;

    return Stepper(
      currentStep: provider.currentStep,
      onStepContinue: () async {
        final provider =
            Provider.of<RegistrationProvider>(context, listen: false);
        if (provider.currentStep == 0) {
          if (_basicDetailsFormKey.currentState!.validate()) {
            provider.updateBasicDetails(
              passport: _passportController.text,
              mobile: _mobileController.text,
              email: _emailController.text,
              address: _addressController.text,
              pin: _pinController.text,
              city: _cityController.text,
              state: _stateController.text,
              country: _countryController.text.toUpperCase(),
            );
            provider.goToStep(1);
          }
        } else if (provider.currentStep == 1) {
          if (_panFormKey.currentState!.validate()) {
            await provider.verifyPan();
          }
        } else if (provider.currentStep == 2) {
          if (_bankFormKey.currentState!.validate()) {
            await provider.verifyBankDetails();
          }
        } else if (provider.currentStep == 3) {
          if (_contactFormKey.currentState!.validate()) {
            provider.updateContact(
              _contactNameController.text,
              _contactMobileController.text,
              _contactEmailController.text,
            );
            bool success = await provider.submitRegistration();
            if (success && mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const KYCView(),
                ),
              );
            }
          }
        }
      },
      onStepCancel: () {
        if (provider.currentStep > 0) {
          provider.goToStep(provider.currentStep - 1);
        }
      },
      controlsBuilder: (context, details) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              if (provider.currentStep > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: details.onStepCancel,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: theme["textColor"]!),
                    ),
                    child: Text(
                      "BACK",
                      style: TextStyle(color: theme["textColor"]),
                    ),
                  ),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: provider.isLoading ? null : details.onStepContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme["textColor"],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: provider.isLoading
                      ? CircularProgressIndicator(
                          color: theme["backgroundColor"],
                        )
                      : Text(
                          provider.currentStep == 3 ? "SUBMIT" : "NEXT",
                          style: TextStyle(
                            color: theme["backgroundColor"],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
      steps: [
        _basicStep(context),
        _panStep(context),
        _bankStep(context),
        _contactStep(context),
      ],
    );
  }

  Step _basicStep(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);

    return Step(
      title: const Text("Basic Details"),
      state: provider.currentStep > 0 ? StepState.complete : StepState.indexed,
      content: Form(
        key: _basicDetailsFormKey,
        child: Column(
          children: [
            _buildTextField(
              context,
              "Passport Number",
              _passportController,
              maxLength: 9,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                LengthLimitingTextInputFormatter(9),
                UpperCaseTextFormatter(),
              ],
              textCapitalization: TextCapitalization.characters,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Passport number is required';
                }
                if (value.length < 8) {
                  return 'Passport number must be at least 8 characters';
                }
                return null;
              },
            ),
            _buildTextField(
              context,
              "Mobile (+91)",
              _mobileController,
              type: TextInputType.phone,
              maxLength: 10,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mobile number is required';
                }
                if (value.length != 10) {
                  return 'Mobile number must be 10 digits';
                }
                return null;
              },
            ),
            _buildTextField(
              context,
              "Email",
              _emailController,
              type: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Email required';
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                  return 'Invalid email';
                }
                return null;
              },
            ),
            _buildTextField(context, "Address", _addressController),
            _buildTextField(context, "PIN Code", _pinController,
                type: TextInputType.number),
            _buildTextField(context, "City", _cityController),
            _buildTextField(context, "State", _stateController),
            _buildTextField(
              context,
              "Country (IN UPPERCASE)",
              _countryController,
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
      ),
    );
  }

  Step _panStep(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final theme = Provider.of<ThemeProvider>(context).themeConfig;

    return Step(
      title: const Text("PAN Verification"),
      state: provider.currentStep > 1 ? StepState.complete : StepState.indexed,
      content: Form(
        key: _panFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              context,
              "PAN Number",
              null,
              maxLength: 10,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                LengthLimitingTextInputFormatter(10),
                UpperCaseTextFormatter(),
              ],
              textCapitalization: TextCapitalization.characters,
              onChanged: provider.updatePan,
              enabled: provider.registrationData.fullName == null,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'PAN number is required';
                }
                if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(value)) {
                  return 'Invalid PAN number format';
                }
                return null;
              },
            ),
            if (provider.registrationData.fullName != null) ...[
              Text(
                "Name: ${provider.registrationData.fullName}",
                style: TextStyle(color: theme["textColor"]),
              ),
              Text(
                "TCS Rate: ${provider.registrationData.tcsRate}%",
                style: TextStyle(color: theme["textColor"]),
              ),
            ],
            if (provider.errorMessage != null)
              Text(
                provider.errorMessage!,
                style: TextStyle(color: theme["negativeAmount"]),
              ),
          ],
        ),
      ),
    );
  }

  Step _bankStep(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final theme = Provider.of<ThemeProvider>(context).themeConfig;

    return Step(
      title: const Text("Bank Verification"),
      state: provider.currentStep > 2 ? StepState.complete : StepState.indexed,
      content: Form(
        key: _bankFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              context,
              "Account Number",
              null,
              maxLength: 18,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(18),
              ],
              onChanged: provider.updateAccountNumber,
              enabled: provider.registrationData.bankDetails.isEmpty,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Account number is required';
                }
                return null;
              },
            ),
            _buildTextField(
              context,
              "IFSC",
              null,
              onChanged: provider.updateIfsc,
              enabled: provider.registrationData.bankDetails.isEmpty,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'IFSC code is required';
                }
                return null;
              },
            ),
            if (provider.registrationData.bankDetails.isNotEmpty)
              Text(
                "Account Name: ${provider.registrationData.bankDetails.first.accountName}",
                style: TextStyle(color: theme["textColor"]),
              ),
            if (provider.errorMessage != null)
              Text(
                provider.errorMessage!,
                style: TextStyle(color: theme["negativeAmount"]),
              ),
          ],
        ),
      ),
    );
  }

  Step _contactStep(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final theme = Provider.of<ThemeProvider>(context).themeConfig;

    return Step(
      title: const Text("Contact Detail"),
      content: Form(
        key: _contactFormKey,
        child: Column(
          children: [
            _buildTextField(context, "Full Name", _contactNameController,
                validator: (v) =>
                    v!.isEmpty ? "Contact name cannot be empty" : null),
            _buildTextField(context, "Mobile", _contactMobileController,
                type: TextInputType.phone,
                validator: (v) =>
                    v!.isEmpty ? "Contact mobile cannot be empty" : null),
            _buildTextField(
              context,
              "Email",
              _contactEmailController,
              type: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Email required';
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
                  return 'Invalid email';
                }
                return null;
              },
            ),
            if (provider.errorMessage != null)
              Text(
                provider.errorMessage!,
                style: TextStyle(color: theme["negativeAmount"]),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      BuildContext context,
      String label,
      TextEditingController? controller, {
        TextInputType type = TextInputType.text,
        Function(String)? onChanged,
        bool enabled = true,
        int? maxLength,
        List<TextInputFormatter>? inputFormatters,
        String? Function(String?)? validator,
        TextCapitalization textCapitalization = TextCapitalization.none,
      }) {
    final theme =
        Provider.of<ThemeProvider>(context, listen: false).themeConfig;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(
            color: (theme["textColor"] as Color).withOpacity(0.5),
            width: 1.5),
        borderRadius: BorderRadius.circular(12),
        color: theme["cardBackground"],
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: type,
        enabled: enabled,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        textCapitalization: textCapitalization,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: theme["textColor"]),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.transparent,
          counterText: '',
        ),
        style: TextStyle(color: theme["textColor"]),
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
