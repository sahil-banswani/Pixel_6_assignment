// ignore_for_file: public_member_api_docs, sort_constructors_first

class Customer {
  final String pan;
  final String firstName;
  final String email;
  final String mobile;
  final List<Address> addresses;
  Customer({
    required this.pan,
    required this.firstName,
    required this.email,
    required this.mobile,
    required this.addresses,
  });
}

class Address {
  String addressLine1;
  String? addressLine2;
  int postcode;
  String state;
  String city;

  Address({
    required this.addressLine1,
    this.addressLine2,
    required this.postcode,
    required this.state,
    required this.city,
  });
}
