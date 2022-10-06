import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static getUsers() {
    return FirebaseFirestore.instance.collection('device_ids');
  }

  static setLocation(String deviceId) {
    return FirebaseFirestore.instance.collection('device_ids').doc(deviceId);
  }

  static getMerchants() {
    return FirebaseFirestore.instance
        .collection('device_ids')
        .where('role', isEqualTo: 'Merchant');
  }

  static getMerchantsByID(String field, String requirement) {
    return FirebaseFirestore.instance
        .collection('device_ids')
        .where('role', isEqualTo: 'Merchant')
        .where(field, isEqualTo: requirement);
  }

  static getDeviceIds() {
    return FirebaseFirestore.instance.collection('device_ids');
  }

  static filterMerchants(String focusField, String requirement) {
    return FirebaseFirestore.instance
        .collection('device_ids')
        .where('role', isEqualTo: 'Merchant')
        .where(focusField, isEqualTo: requirement);
  }

  static getMachines() {
    return FirebaseFirestore.instance.collection('rental_machines');
  }

  static getCustomers() {
    return FirebaseFirestore.instance.collection('customers');
  }

  static filterMachine(String focusField, String requirement) {
    return FirebaseFirestore.instance
        .collection('rental_machines')
        .where(focusField, isEqualTo: requirement);
  }

  static filterMachineTypeAndMerchant(String focusField1, String machineType,
      String focusField2, String merchant) {
    return FirebaseFirestore.instance
        .collection('rental_machines')
        .where(focusField1, isEqualTo: machineType)
        .where(focusField2, isEqualTo: merchant);
  }

  static getOrders() {
    return FirebaseFirestore.instance.collection('orders');
  }

  static filterOrders(String field, String requirement) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where(field, isEqualTo: requirement);
  }

  static filterOrders2Req(
      String field1, String merchantId, String field2, String orderStatus) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where(field1, isEqualTo: merchantId)
        .where(field2, isNotEqualTo: orderStatus);
  }

  static filterTodayOrders(String field1, Timestamp time, String field2,
      String requirement, String field3, String name) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where(field1, isEqualTo: time)
        .where(field2, isEqualTo: requirement)
        .where(field3, isEqualTo: name);
  }

  static filterOrdersForNotif(String field1, String merNotif, String field2,
      String cusNotif, String field3, String reply) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where(field1, isEqualTo: merNotif)
        .where(field2, isEqualTo: cusNotif)
        .where(field3, isEqualTo: reply);
  }

  static getQueryOfisSelected() {
    return FirebaseFirestore.instance
        .collection('device_ids')
        .where('isSelected', isEqualTo: true);
  }

  static getInvoice() {
    return FirebaseFirestore.instance.collection('invoices');
  }

  static filterOrdersForPendingOrder(
      String field1, String requirement1, String field2, String requirement2) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where(field1, isEqualTo: requirement1)
        .where(field2, isNotEqualTo: requirement2);
  }

  static filterOrdersForAdmin(String field, String requirement) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where(field, isNotEqualTo: requirement);
  }

  static filterOrdersFor2Req(
      String field1, String requirement1, String field2, String requirement2) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where(field1, isEqualTo: requirement1)
        .where(field2, isEqualTo: requirement2);
  }

  static filterInvoice(String field, String requirement) {
    return FirebaseFirestore.instance
        .collection('invoices')
        .where(field, isEqualTo: requirement);
  }
}
