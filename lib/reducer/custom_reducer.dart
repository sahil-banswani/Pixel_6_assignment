import 'package:project_pixel_6/models/customer.dart';
import 'package:redux/redux.dart';

final customerReducer = combineReducers<List<Customer>>([
  TypedReducer<List<Customer>, AddCustomerAction>(_addCustomer),
  TypedReducer<List<Customer>, EditCustomerAction>(_editCustomer),
  TypedReducer<List<Customer>, DeleteCustomerAction>(_deleteCustomer),
]);

List<Customer> _addCustomer(List<Customer> customers, AddCustomerAction action) {
  return List.from(customers)..add(action.customer);
}

List<Customer> _editCustomer(List<Customer> customers, EditCustomerAction action) {
  return customers.map((customer) {
    return customer.pan == action.customer.pan ? action.customer : customer;
  }).toList();
}

List<Customer> _deleteCustomer(List<Customer> customers, DeleteCustomerAction action) {
  return customers.where((customer) => customer.pan != action.pan).toList();
}

class AddCustomerAction {
  final Customer customer;

  AddCustomerAction(this.customer);
}

class EditCustomerAction {
  final Customer customer;

  EditCustomerAction(this.customer);
}

class DeleteCustomerAction {
  final String pan;

  DeleteCustomerAction(this.pan);
}
