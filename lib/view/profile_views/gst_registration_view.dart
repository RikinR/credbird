import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:credbird/viewmodel/profile_providers/gst_registration_provider.dart';
import 'package:credbird/viewmodel/theme_provider.dart';
import 'package:credbird/view/profile_views/registration_success_view.dart';

class GstRegistrationView extends StatelessWidget {
  const GstRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeConfig;
    return ChangeNotifierProvider(
      create: (_) => GstRegistrationProvider(),
      child: Scaffold(
        backgroundColor: theme["scaffoldBackground"],
        appBar: AppBar(
          title: const Text("GST Registration"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: theme["textColor"],
        ),
        body: Consumer<GstRegistrationProvider>(
          builder: (context, provider, _) {
            if (provider.currentStep == 3) {
              return const RegistrationSuccessScreen();
            }
            return const _GstRegistrationStepper();
          },
        ),
      ),
    );
  }
}

class _GstRegistrationStepper extends StatelessWidget {
  const _GstRegistrationStepper();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GstRegistrationProvider>(context);
    final theme = Provider.of<ThemeProvider>(context).themeConfig;

    return Stepper(
      currentStep: provider.currentStep,
      onStepContinue: () async {
        if (provider.currentStep == 0) {
          await provider.verifyGst();
        } else if (provider.currentStep == 1) {
          await provider.verifyBankDetails();
        } else if (provider.currentStep == 2) {
          await provider.submitRegistration();
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
                            provider.currentStep == 2 ? "SUBMIT" : "NEXT",
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
      steps: [_gstStep(context), _bankStep(context), _contactStep(context)],
    );
  }

  Step _gstStep(BuildContext context) {
    final provider = Provider.of<GstRegistrationProvider>(context);
    final theme = Provider.of<ThemeProvider>(context).themeConfig;

    final TextEditingController pan = TextEditingController(
      text: provider.registrationData.panNumber,
    );
    final TextEditingController gst = TextEditingController(
      text: provider.registrationData.gstNumber,
    );
    final TextEditingController orgName = TextEditingController(
      text: provider.registrationData.orgName,
    );
    final TextEditingController orgType = TextEditingController(
      text: provider.registrationData.orgType,
    );
    final TextEditingController address = TextEditingController();
    final TextEditingController pin = TextEditingController();
    final TextEditingController city = TextEditingController();
    final TextEditingController state = TextEditingController();
    final TextEditingController country = TextEditingController();

    return Step(
      title: const Text("GST Details"),
      state: provider.currentStep > 0 ? StepState.complete : StepState.indexed,
      content: Column(
        children: [
          _buildTextField(context, "PAN Number", pan),
          _buildTextField(context, "GST Number", gst),
          _buildTextField(
            context,
            "Organization Name",
            orgName,
            enabled: false,
          ),
          _buildTextField(
            context,
            "Organization Type",
            orgType,
            enabled: false,
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
                panNumber: pan.text,
                gstNumber: gst.text,
                orgName: orgName.text,
                orgType: orgType.text,
                orgAddress: address.text,
                orgPin: pin.text,
                orgCity: city.text,
                orgState: state.text,
                orgCountry: country.text.toUpperCase(),
              );
              provider.verifyGst();
            },
            child: const Text("Verify GST"),
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

  Step _bankStep(BuildContext context) {
    final provider = Provider.of<GstRegistrationProvider>(context);
    final theme = Provider.of<ThemeProvider>(context).themeConfig;

    return Step(
      title: const Text("Bank Verification"),
      state: provider.currentStep > 1 ? StepState.complete : StepState.indexed,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Account Name: ${provider.registrationData.bankDetails.first.accountName}",
                  style: TextStyle(color: theme["textColor"]),
                ),
                Text(
                  "Verified ID: ${provider.registrationData.bankDetails.first.verifiedId}",
                  style: TextStyle(color: theme["textColor"]),
                ),
              ],
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
    final provider = Provider.of<GstRegistrationProvider>(context);
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
