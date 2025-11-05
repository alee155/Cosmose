import 'package:cosmose/Screens/StripePaymentMethod/payment.dart';
import 'package:cosmose/Screens/StripePaymentMethod/payment_constants.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:cosmose/utils/images_assets.dart';
import 'package:cosmose/widgets/CustomElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentHomePage extends StatefulWidget {
  final String message;
  const PaymentHomePage({super.key, required this.message});

  @override
  State<PaymentHomePage> createState() => _PaymentHomePageState();
}

class _PaymentHomePageState extends State<PaymentHomePage> {
  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  final formkey = GlobalKey<FormState>();
  final formkey1 = GlobalKey<FormState>();
  final formkey2 = GlobalKey<FormState>();
  final formkey3 = GlobalKey<FormState>();
  final formkey4 = GlobalKey<FormState>();
  final formkey5 = GlobalKey<FormState>();

  List<String> currencyList = <String>[
    'USD',
    'INR',
    'EUR',
    'JPY',
    'GBP',
    'AED'
  ];
  String selectedCurrency = 'USD';

  bool hasDonated = false;

  Future<void> initPaymentSheet() async {
    try {
      final data = await createPaymentIntent(
        amount: (double.parse(amountController.text) * 100).toInt().toString(),
        currency: selectedCurrency,
      );

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Test Merchant',
          paymentIntentClientSecret: data['client_secret'],
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],
          style: ThemeMode.dark,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _setTotalFromMessage();
  }

  void _setTotalFromMessage() {
    final lines = widget.message.split('\n');
    for (var line in lines) {
      if (line.startsWith("Total:")) {
        final total = line.replaceFirst("Total:", "").trim();
        amountController.text = total.replaceAll(RegExp(r'[^\d.]'), '');
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              ImageAssets.cosmoselogo,
              width: 205.w,
              height: 171.h,
            ),
            SizedBox(height: 30.h),
            hasDonated
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Thanks for your ${amountController.text} $selectedCurrency donation",
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "We appreciate your support",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent.shade400),
                            child: Text(
                              "Donate again",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () {
                              setState(() {
                                hasDonated = false;
                                amountController.clear();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pay to Get Your Products",
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 30.h),
                          ReusableTextField(
                            formkey: formkey,
                            controller: amountController,
                            isNumber: true,
                            title: "Total Amount",
                            hint: "your total bill",
                          ),
                          SizedBox(height: 10.h),
                          DropdownMenu<String>(
                            inputDecorationTheme: InputDecorationTheme(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              filled: true,
                              fillColor: Colors.white, // White background
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Rounded border
                                borderSide: BorderSide(
                                  color: Colors.grey.shade600, // Border color
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Rounded border
                                borderSide: BorderSide(
                                  color: Colors.grey
                                      .shade600, // Border color when not focused
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Rounded border
                                borderSide: BorderSide(
                                  color:
                                      Colors.blue, // Border color when focused
                                ),
                              ),
                            ),
                            initialSelection: currencyList.first,
                            onSelected: (String? value) {
                              setState(() {
                                selectedCurrency = value!;
                              });
                            },
                            dropdownMenuEntries: currencyList
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                  value: value, label: value);
                            }).toList(),
                          ),
                          SizedBox(height: 30.h),
                          CustomElevatedButton(
                            text: "Proceed to Pay",
                            onPressed: () async {
                              await initPaymentSheet();

                              try {
                                await Stripe.instance.presentPaymentSheet();

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    "Payment Done",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.green,
                                ));

                                setState(() {
                                  hasDonated = true;
                                });
                              } catch (e) {
                                print("payment sheet failed");
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    "Payment Failed",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ));
                              }
                            },
                            color: AppColors.green,
                            borderRadius: 11.r,
                            height: 48.h,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ])),
          ],
        ),
      ),
    );
  }
}
