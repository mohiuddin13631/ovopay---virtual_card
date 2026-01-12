import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ovopay/core/utils/my_strings.dart';

import '../../../../core/data/models/country_model/country_model.dart';
import '../../../../core/data/services/shared_pref_service.dart';

class CardApplicationController extends GetxController {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController carNameController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController billingAddressController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  List<String> shippingMethodList = [
    MyStrings.standardShipping.tr,
    MyStrings.expressShipping.tr,
  ];

  int selectedShippingMethod = 1;
  void changeShippingMethod(int index){
    selectedShippingMethod = index;
    update();
  }


  CountryData? countryData;
  TextEditingController countryController = TextEditingController();

  void selectedCountryData(CountryData value) {
    countryData = value;
    countryController.text = value.name ?? "";
    SharedPreferenceService.setSelectedOperatingCountry(value);
    update();
  }
}