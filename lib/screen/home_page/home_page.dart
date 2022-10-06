import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:provider/provider.dart';
import 'package:rentalapp_pos/base_helper/app_utils.dart';
import 'package:rentalapp_pos/custom_router.dart';
import 'package:rentalapp_pos/dialog/dialog.dart';
import 'package:rentalapp_pos/dialog/loading_dialog.dart';
import 'package:rentalapp_pos/global/globals.dart' as globals;
import 'package:rentalapp_pos/model/firestore_respond/firestore_service.dart';
import 'package:rentalapp_pos/model/view_model/address.dart';
import 'package:rentalapp_pos/model/view_model/category_item.dart';
import 'package:rentalapp_pos/model/view_model/customer.dart';
import 'package:rentalapp_pos/model/view_model/locations.dart';
import 'package:rentalapp_pos/model/view_model/machine_item.dart';
import 'package:rentalapp_pos/model/view_model/merchant.dart';
import 'package:rentalapp_pos/model/view_model/order_item.dart';
import 'package:rentalapp_pos/provider/user_state/user_state.dart';
import 'package:rentalapp_pos/repository/notifications_repository.dart';
import 'package:rentalapp_pos/screen/navigation_drawer/navigation_drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _current = 0;
  List<OrderItem> todayOrderList = [];
  List<OrderItem> orderList = [];
  List<CategoryItem> categoryItemList = [];
  OrderItem order;

  Widget notifIconButton(BuildContext context) {
    final state = Provider.of<UserState>(context, listen: false);
    return StreamBuilder<QuerySnapshot>(
        stream: ((globals.currentLoginUser.role == 'Merchant')
                ? FirestoreService.filterOrders2Req(
                    'merchant.id', state.deviceId, 'reply', 'PROGRESS')
                : FirestoreService.filterOrders('reply', 'PROGRESS'))
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData)
            return CircularProgressIndicator();
          else {
            if (snapshot.data.docs.length == 0) {
              var order = snapshot.data.docs.firstWhere(
                  (element) => element.get('clicked') == false,
                  orElse: () => null);
              print('order: ${order}');
              return IconButton(
                  icon: Icon(
                    order == null
                        ? Icons.notifications_none_outlined
                        : Icons.notifications_active_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, CustomRouter.notificationRoute,
                        arguments: orderList);
                  });
            } else {
              Map<String, dynamic> data;
              orderList.clear();
              orderList = snapshot.data.docs.map((element) {
                data = element.data();
                print('Data: ${element.data()}');
                if (!(data.containsKey('notifMer')) &&
                    globals.currentLoginUser.role == 'Merchant') {
                  for (int i = 0; i < snapshot.data.docs.length; i++) {
                    FirestoreService.getOrders()
                        .doc(snapshot.data.docs[i].reference.id)
                        .update({
                      'notifMer': {
                        'title': globals.notifications[i].title,
                        'content': globals.notifications[i].content,
                        'clicked': checkClickedStatus(
                            globals.notifications[i].clicked),
                        'sendTime': DateTime.fromMillisecondsSinceEpoch(
                            (globals.notifications[i].sendDateTime * 1000))
                      },
                    }).catchError(
                            (error) => print("Failed to add user: $error"));
                  }
                } else {
                  for (int i = 0; i < snapshot.data.docs.length; i++) {
                    FirestoreService.getOrders()
                        .doc(snapshot.data.docs[i].reference.id)
                        .update({
                      'notifAdm': {
                        'title': globals.notifications[i].title,
                        'content': globals.notifications[i].content,
                        'clicked': checkClickedStatus(
                            globals.notifications[i].clicked),
                        'sendTime': DateTime.fromMillisecondsSinceEpoch(
                            (globals.notifications[i].sendDateTime * 1000))
                      },
                    }).catchError(
                            (error) => print("Failed to add user: $error"));
                  }
                }

                DateTime startDate = DateTime.fromMillisecondsSinceEpoch(
                    ((element.get('date.startDate')).seconds * 1000));
                DateTime endDate = DateTime.fromMillisecondsSinceEpoch(
                    ((element.get('date.endDate')).seconds * 1000));
                return OrderItem(
                  id: element.reference.id,
                  machine: MachineItem.fromJson(element.get('machine')),
                  customer: Customer.fromJson(element.get('customer')),
                  destination: AddressDes.fromJson(element.get('address')),
                  orderStatus: element.get('reply'),
                  startDate: startDate,
                  endDate: endDate,
                  fileUrl: element.get('payment.fileUrl'),
                  orderQuantity: element.get('orderQuantity'),
                  amountPaid:
                      (element.get('payment.paid') as num ?? 0).toDouble(),
                  title: globals.currentLoginUser.role == 'Merchant'
                      ? data.containsKey('notifMer')
                          ? element.get('notifMer.title')
                          : null
                      : data.containsKey('notifAdm')
                          ? element.get('notifAdm.title')
                          : null,
                  content: globals.currentLoginUser.role == 'Merchant'
                      ? data.containsKey('notifMer')
                          ? element.get('notifMer.content')
                          : null
                      : data.containsKey('notifAdm')
                          ? element.get('notifAdm.content')
                          : null,
                  clicked: globals.currentLoginUser.role == 'Merchant'
                      ? data.containsKey('notifMer')
                          ? element.get('notifMer.clicked')
                          : null
                      : data.containsKey('notifAdm')
                          ? element.get('notifAdm.clicked')
                          : null,
                  sendTime: DateTime.fromMillisecondsSinceEpoch(
                      (globals.currentLoginUser.role == 'Merchant'
                              ? data.containsKey('notifMer')
                                  ? element.get('notifMer.sendTime').seconds
                                  : 0
                              : data.containsKey('notifAdm')
                                  ? element.get('notifAdm.sendTime').seconds
                                  : 0) *
                          1000),
                );
              }).toList();

              print(orderList.first.clicked);
              OrderItem order = orderList.firstWhere(
                  (element) => element.clicked == false,
                  orElse: () => null);
              print('order: ${order}');

              return IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, CustomRouter.notificationRoute,
                      arguments: orderList);
                },
                icon: Icon(
                  order == null
                      ? Icons.notifications_none_outlined
                      : Icons.notifications_active_outlined,
                  color: Colors.grey,
                ),
              );
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final currentPosition =
        Provider.of<UserState>(context, listen: false).currentPosition;

    if (globals.currentLoginUser.role == 'Merchant') {
      //TODO: test the flow of this
      if (currentPosition == null) {
        getCurrentLocation(context);
      } else {
        FirestoreService.getDeviceIds()
            .doc(globals.currentLoginUser.id)
            .get()
            .then((element) {
          if (element.get('firstTime')) globals.currentLoginUser.role == 'Merchant' ? fillInDetail(context) : getCurrentLocation(context);
        });
      }
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: NavigationDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        iconTheme: IconThemeData(color: Colors.grey),
        elevation: 0,
        actions: [
          notifIconButton(context),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirestoreService.filterMachine(
                  'merchant.id', globals.currentLoginUser.id)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingPage(message: 'Waiting for connection...');
            }
            if (!snapshot.hasData) {
              print(!snapshot.hasData);
              return CircularProgressIndicator();
            } else {
              categoryItemList.clear();
              final typeMachine = snapshot.data.docs
                  .map((element) => element.get('type'))
                  .toSet()
                  .toList();

              typeMachine.isEmpty ? null : loadMachineData(typeMachine);

              categoryItemList.add(
                CategoryItem(
                  machineType: 'add_machine',
                  machineImage: checkMachineImage('add_machine'),
                ),
              );
              return RefreshIndicator(
                onRefresh: () => Future.delayed(
                  Duration(seconds: 2),
                  () async {
                    await NotificationsRepository().getNotifications();
                    globals.notifications.clear();
                    globals.notifications =
                        NotificationsRepository.notifications;
                    for (int i = 0; i < orderList.length; i++) {
                      orderList[i].title = globals.notifications[i].title;
                      orderList[i].content = globals.notifications[i].content;
                      orderList[i].clicked =
                          checkClickedStatus(globals.notifications[i].clicked);
                      orderList[i].sendTime =
                          DateTime.fromMillisecondsSinceEpoch(
                              (globals.notifications[i].sendDateTime * 1000));
                    }
                    order = orderList.firstWhere(
                        (element) => element.clicked == false,
                        orElse: () => null);
                  },
                ),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        generateTitle('TODAY\nORDER'),
                        makeOrderList(context),
                        globals.currentLoginUser.role == 'Admin'
                            ? Container()
                            : (makeRentalMachineSection(
                                context, categoryItemList)),
                      ]),
                ),
              );
            }
          }),
    );
  }

  makeOrderList(BuildContext context) {
    DateTime today = DateTime.parse(DateTime.now().year.toString() +
        checkLengthofText(DateTime.now().month.toString()) +
        checkLengthofText(DateTime.now().day.toString()) +
        'T' +
        '000000');
    return StreamBuilder<QuerySnapshot>(
        stream: FirestoreService.filterTodayOrders(
                'date.startDate',
                Timestamp.fromDate(today),
                'reply',
                globals.currentLoginUser.role == 'Merhant'
                    ? 'COMPLETE'
                    : 'PLACED',
                'merchant.id',
                globals.currentLoginUser.id)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingPage(message: 'Waiting for connection...');
          }
          if (!snapshot.hasData)
            return CircularProgressIndicator();
          else {
            todayOrderList.clear();
            todayOrderList = snapshot.data.docs.map((element) {
              DateTime startDate = DateTime.fromMillisecondsSinceEpoch(
                  ((element.get('date.startDate')).seconds * 1000));
              DateTime endDate = DateTime.fromMillisecondsSinceEpoch(
                  ((element.get('date.endDate')).seconds * 1000));
              return OrderItem(
                machine: MachineItem.fromJson(element.get('machine')),
                customer: Customer.fromJson(element.get('customer')),
                merchant: Merchant.fromJson(element.get('merchant')),
                paymentStatus: element.get('payment.payType'),
                orderStatus: element.get('reply'),
                startDate: startDate,
                endDate: endDate,
              );
            }).toList();

            if (todayOrderList.isNotEmpty) {
              return SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.count(
                        shrinkWrap: true,
                        mainAxisSpacing: 20.0,
                        crossAxisCount: 1,
                        childAspectRatio:
                            MediaQuery.of(context).size.width / 120,
                        children: List.generate(todayOrderList.length, (index) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.yellowAccent,
                                  Colors.yellowAccent,
                                  Colors.orangeAccent,
                                  Colors.orangeAccent,
                                ],
                                stops: [0.0, 0.44, 0.44, 1.0],
                                end: Alignment.bottomCenter,
                                begin: Alignment.topCenter,
                              ),
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  print(
                                      '${todayOrderList[index].machine.machineName} is pressed');
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Image.network(
                                                todayOrderList[index]
                                                    .machine
                                                    .image,
                                                scale: MediaQuery.of(context)
                                                            .size
                                                            .height >=
                                                        400
                                                    ? 3.0
                                                    : 1.5))),
                                    Expanded(
                                      flex: 2,
                                      child: Column(children: [
                                        AutoSizeText(
                                          todayOrderList[index]
                                              .machine
                                              .machineName,
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        AutoSizeText(
                                          todayOrderList[index].customer.name,
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.grey),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        AutoSizeText(
                                          'Payment Status: ${todayOrderList[index].paymentStatus}',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        AutoSizeText(
                                          ('Order Status: ${todayOrderList[index].orderStatus}'),
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.white),
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ]),
              );
            } else {
              return Container(
                height: MediaQuery.of(context).size.height >= 400
                    ? MediaQuery.of(context).size.height * 0.35
                    : MediaQuery.of(context).size.height * 0.75,
                child: Center(
                  child: Text('No order for today',
                      style: TextStyle(color: Colors.grey)),
                ),
              );
            }
          }
        });
  }

  makeRentalMachineSection(BuildContext context, List<CategoryItem> data) {
    if (data.isEmpty) {
      return Container();
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      generateTitle('RENTAL\nMACHINE'),
      Container(
        height: MediaQuery.of(context).size.height >= 400
            ? MediaQuery.of(context).size.height * 0.3
            : MediaQuery.of(context).size.height * 0.8,
        child: Center(
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            // items: generateRentalMachineCardList(context, data),
            itemCount: data.length,
            itemBuilder: (_, int index) {
              return Align(
                  alignment: Alignment.center,
                  child: generateRentalMachineCardList(context, data[index]));
            },
          ),
        ),
      ),
    ]);
  }

  generateRentalMachineCardList(BuildContext context, CategoryItem data) {
    return GestureDetector(
      onTap: () {
        print('Test : ${data.machineType}');
        navigateToEditingPage(context, data);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Card(
            color: Colors.orangeAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: data.machineType != 'add_machine'
                        ? PopupMenuButton(
                            icon: const Icon(Icons.more_vert),
                            onSelected: (fn) {
                              assert(fn is Function);
                              if (fn != null) {
                                fn();
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              final edit = PopupMenuItem(
                                child: const Text('Edit'),
                                value: () {
                                  navigateToEditingPage(context, data);
                                },
                              );

                              final delete = PopupMenuItem(
                                  child: const Text('Delete'),
                                  value: () async {
                                    bool confirm = await Dialogs.showConfirmation(
                                        context, 'Do you confirm to delete ? ',
                                        content:
                                            'All the list of data will be delete if you delete from database');
                                    if (confirm) {
                                      final success =
                                          await deleteMachineCategory(
                                              context, data);
                                      Future.delayed(
                                          Duration(seconds: 1),
                                          () => success
                                              ? Dialogs.showMessage(context,
                                                  title: 'Success to deleted')
                                              : null);
                                    }
                                  });
                              return [edit, delete];
                            },
                          )
                        : SizedBox(height: 40),
                  ),
                  Image.network(checkMachineImage(data.machineType),
                      scale: MediaQuery.of(context).size.height >= 400
                          ? 2.6
                          : 1.3),
                  Text(
                    data.machineType.split('_').join(' '),
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height >= 400
                            ? 15
                            : 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> deleteMachineCategory(
      BuildContext context, CategoryItem data) async {
    final isSuccess =
        await FirestoreService.filterMachine('type', data.machineType)
            .get()
            .then((value) {
      for (DocumentSnapshot doc in value.docs) {
        doc.reference.delete();
      }
      return true;
    }).catchError((error) => print("Failed to delete user: $error"));
    return isSuccess;
  }

  setSearchParam(String caseNumber) {
    List<String> caseSearchList = [];
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  bool checkClickedStatus(int clicked) {
    if (clicked == 1)
      return true;
    else
      return false;
  }

  String checkLengthofText(String string) {
    if (string.length == 1)
      return '0${string}';
    else
      return string;
  }

  loadMachineData(List typeMachine) {
    for (var element in typeMachine) {
      categoryItemList.add(CategoryItem(
          machineType: element, machineImage: checkMachineImage(element)));
    }
  }

  getCurrentLocation(BuildContext context) async {
    Position _currentPosition;
    if (!(await Geolocator.isLocationServiceEnabled())) {
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) async {
        _currentPosition = position;
        print(position);
        final state = Provider.of<UserState>(context, listen: false);
        if(globals.currentLoginUser.role == 'Merchant'){
          await FirestoreService.setLocation(state.deviceId).update({
            'notifId': globals.id,
            'position': _currentPosition.toJson(),
          }).then((value) {
            return value.id;
          }).catchError((error) => print("Failed to add user: $error"));
        } else {
          await FirestoreService.setLocation(state.deviceId).update({
            'firstTime': false,
            'notifId': globals.id,
            'position': _currentPosition.toJson(),
          }).then((value) {
            return value.id;
          }).catchError((error) => print("Failed to add user: $error"));
        }
          getAddressFromLatLng(context, _currentPosition);
      }).catchError((e) {
        print(e);
        Navigator.pushNamed(context, CustomRouter.gpsRoute);
      });
    } else {
      getAddressFromLatLng(context, _currentPosition);
    }
  }

  getAddressFromLatLng(BuildContext context, Position _currentPosition) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = placemarks[0];
      final state = Provider.of<UserState>(context, listen: false);
      await FirestoreService.setLocation(state.deviceId).update({
        'location': Locations(postcode: place.postalCode, state: place.locality)
            .toJson(),
      }).then((value) {
        return value.id;
      }).catchError((error) => print("Failed to add user: $error"));
      fillInDetail(context);
    } catch (e) {
      print(e);
    }
  }
}
