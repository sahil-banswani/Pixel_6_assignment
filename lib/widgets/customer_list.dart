import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:project_pixel_6/models/app_state.dart';
import 'package:project_pixel_6/models/customer.dart';
import 'package:project_pixel_6/reducer/custom_reducer.dart';
import 'package:redux/redux.dart';
import 'customer_form.dart';

class CustomerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer List'),
      ),
      body: StoreConnector<AppState, List<Customer>>(
        converter: (Store<AppState> store) => store.state.customers,
        builder: (context, customers) {
          return ListView.builder(
            itemCount: customers.length,
            itemBuilder: (context, index) {
              final customer = customers[index];
              return ListTile(
                title: Text(customer.firstName),
                subtitle: Text(customer.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CustomerForm(
                              onSubmit: (updatedCustomer) {
                                StoreProvider.of<AppState>(context).dispatch(EditCustomerAction(updatedCustomer));
                              },
                              initialCustomer: customer,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        StoreProvider.of<AppState>(context).dispatch(DeleteCustomerAction(customer.pan));
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CustomerForm(
                onSubmit: (newCustomer) {
                  StoreProvider.of<AppState>(context).dispatch(AddCustomerAction(newCustomer));
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
