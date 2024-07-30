import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project_pixel_6/models/customer.dart';

class CustomerForm extends StatefulWidget {
  final Function(Customer) onSubmit;
  final Customer? initialCustomer;

  const CustomerForm({super.key, required this.onSubmit, this.initialCustomer});

  @override
  // ignore: library_private_types_in_public_api
  _CustomerFormState createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  List<Address> _addresses = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialCustomer != null) {
      _panController.text = widget.initialCustomer!.pan;
      _firstNameController.text = widget.initialCustomer!.firstName;
      _emailController.text = widget.initialCustomer!.email;
      _mobileController.text = widget.initialCustomer!.mobile;
      _addresses = widget.initialCustomer!.addresses;
    }
  }

  Future<void> verifyPan(String pan) async {
    final response = await http.post(
      Uri.parse('https://lab.pixel6.co/api/verify-pan.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'panNumber': pan}),
    );

    final data = json.decode(response.body);
    if (data['status'] == 'Success' && data['isValid']) {
      _firstNameController.text = data['fullName'];
    }
  }

  Future<void> getPostcodeDetails(String postcode) async {
    final response = await http.post(
      Uri.parse('https://lab.pixel6.co/api/get-postcode-details.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'postcode': postcode}),
    );

    final data = json.decode(response.body);
    if (data['status'] == 'Success') {
      setState(() {
        // Update the latest address entry with city and state
        _addresses.last.state = data['state'][0]['name'];
        _addresses.last.city = data['city'][0]['name'];
      });
    }
  }

  void _addAddressField() {
    if (_addresses.length < 10) {
      setState(() {
        _addresses.add(Address(
          addressLine1: '',
          addressLine2: '',
          postcode: 0,
          state: '',
          city: '',
        ));
      });
    }
  }

  void _removeAddressField(int index) {
    setState(() {
      _addresses.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.initialCustomer == null ? 'Add Customer' : 'Edit Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _panController,
                  decoration: const InputDecoration(labelText: 'PAN'),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length != 10) {
                      return 'Please enter a valid PAN';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    if (value.length == 10) {
                      verifyPan(value);
                    }
                  },
                ),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length > 140) {
                      return 'Please enter a valid first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.length > 255 ||
                        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _mobileController,
                  decoration: const InputDecoration(
                      labelText: 'Mobile Number', prefixText: '+91 '),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length != 10) {
                      return 'Please enter a valid mobile number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text('Addresses',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _addresses.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Address Line 1'),
                          initialValue: _addresses[index].addressLine1,
                          onChanged: (value) {
                            _addresses[index].addressLine1 = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter address line 1';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Address Line 2'),
                          initialValue: _addresses[index].addressLine2,
                          onChanged: (value) {
                            _addresses[index].addressLine2 = value;
                          },
                        ),
                        TextFormField(
                          decoration:
                              const InputDecoration(labelText: 'Postcode'),
                          initialValue: _addresses[index].postcode.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            if (value.length == 6) {
                              _addresses[index].postcode = int.parse(value);
                              getPostcodeDetails(value);
                            }
                          },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length != 6) {
                              return 'Please enter a valid postcode';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'State'),
                          initialValue: _addresses[index].state,
                          readOnly: true,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'City'),
                          initialValue: _addresses[index].city,
                          readOnly: true,
                        ),
                        if (_addresses.length > 1)
                          ElevatedButton(
                            onPressed: () {
                              _removeAddressField(index);
                            },
                            child: const Text('Remove Address'),
                          ),
                        const Divider(),
                      ],
                    );
                  },
                ),
                if (_addresses.length < 10)
                  ElevatedButton(
                    onPressed: _addAddressField,
                    child: const Text('Add Address'),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSubmit(Customer(
                        pan: _panController.text,
                        firstName: _firstNameController.text,
                        email: _emailController.text,
                        mobile: _mobileController.text,
                        addresses: _addresses,
                      ));
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
