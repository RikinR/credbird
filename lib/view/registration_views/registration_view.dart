import 'package:credbird/view/profile_views/kyc_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:credbird/viewmodel/profile_providers/registration_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:credbird/view/registration_views/registration_success_view.dart';

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

class _RegistrationStepper extends StatelessWidget {
  const _RegistrationStepper();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final theme = Provider.of<ThemeProvider>(context).themeConfig;

    return Stepper(
      currentStep: provider.currentStep,
onStepContinue: () async {
  if (provider.currentStep == 0) {
    provider.goToStep(1);
  } else if (provider.currentStep == 1) {
    await provider.verifyPan();
  } else if (provider.currentStep == 2) {
    await provider.verifyBankDetails();
  } else if (provider.currentStep == 3) {
    bool success = await provider.submitRegistration();
    if (success && context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const KYCView(),
        ),
      );
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
                  child:
                      provider.isLoading
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

    final TextEditingController passport = TextEditingController();
    final TextEditingController mobile = TextEditingController();
    final TextEditingController email = TextEditingController();
    final TextEditingController address = TextEditingController();
    final TextEditingController pin = TextEditingController();
    final TextEditingController city = TextEditingController();
    final TextEditingController state = TextEditingController();
    final TextEditingController country = TextEditingController();

    return Step(
      title: const Text("Basic Details"),
      state: provider.currentStep > 0 ? StepState.complete : StepState.indexed,
      content: Column(
        children: [
          _buildTextField(context, "Passport", passport),
          _buildTextField(
            context,
            "Mobile (+91)",
            mobile,
            type: TextInputType.phone,
          ),
          _buildTextField(
            context,
            "Email",
            email,
            type: TextInputType.emailAddress,
          ),
          _buildTextField(context, "Address", address),
          _buildTextField(context, "PIN Code", pin, type: TextInputType.number),
          _buildTextField(context, "City", city),
          _buildTextField(context, "State", state),
          _buildTextField(context, "Country (IN UPPERCASE)", country),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              provider.updateBasicDetails(
                passport: passport.text,
                mobile: mobile.text,
                email: email.text,
                address: address.text,
                pin: pin.text,
                city: city.text,
                state: state.text,
                country: country.text.toUpperCase(),
              );
              provider.goToStep(1);
            },
            child: const Text("Save & Continue"),
          ),
        ],
      ),
    );
  }

  Step _panStep(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final theme = Provider.of<ThemeProvider>(context).themeConfig;

    return Step(
      title: const Text("PAN Verification"),
      state: provider.currentStep > 1 ? StepState.complete : StepState.indexed,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            context,
            "PAN Number",
            null,
            onChanged: provider.updatePan,
            enabled: provider.registrationData.fullName == null,
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
    );
  }

  Step _bankStep(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final theme = Provider.of<ThemeProvider>(context).themeConfig;

    return Step(
      title: const Text("Bank Verification"),
      state: provider.currentStep > 2 ? StepState.complete : StepState.indexed,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            context,
            "Account Number",
            null,
            onChanged: provider.updateAccountNumber,
            enabled: provider.registrationData.bankDetails.isEmpty,
          ),
          _buildTextField(
            context,
            "IFSC",
            null,
            onChanged: provider.updateIfsc,
            enabled: provider.registrationData.bankDetails.isEmpty,
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
    );
  }

  Step _contactStep(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final theme = Provider.of<ThemeProvider>(context).themeConfig;

    final TextEditingController name = TextEditingController();
    final TextEditingController mobile = TextEditingController();
    final TextEditingController email = TextEditingController();

    return Step(
      title: const Text("Contact Detail"),
      content: Column(
        children: [
          _buildTextField(context, "Full Name", name),
          _buildTextField(context, "Mobile", mobile, type: TextInputType.phone),
          _buildTextField(
            context,
            "Email",
            email,
            type: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              provider.updateContact(name.text, mobile.text, email.text);
              provider.submitRegistration();
            },
            child: const Text("Submit Registration"),
          ),
          if (provider.errorMessage != null)
            Text(
              provider.errorMessage!,
              style: TextStyle(color: theme["negativeAmount"]),
            ),
        ],
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
  }) {
    final theme =
        Provider.of<ThemeProvider>(context, listen: false).themeConfig;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        keyboardType: type,
        enabled: enabled,
        textCapitalization: TextCapitalization.characters,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: theme["cardBackground"],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        style: TextStyle(color: theme["textColor"]),
      ),
    );
  }
}
