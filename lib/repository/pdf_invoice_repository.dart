import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:rentalapp_pos/base_helper/app_utils.dart';
import 'package:rentalapp_pos/global/globals.dart' as globals;
import 'package:rentalapp_pos/model/view_model/customer.dart';
import 'package:rentalapp_pos/model/view_model/invoice.dart';
import 'package:rentalapp_pos/model/view_model/merchant.dart';
import 'package:rentalapp_pos/repository/pdf_repository.dart';

class PdfInvoiceRepository {
  static Future<File> generate(Invoice invoice) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 3 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    PdfRepository.saveDocument(name: '${DateTime.now()}.pdf', pdf: pdf)
        .then((value) => print(value.path));
    return PdfRepository.saveDocument(name: '${DateTime.now()}.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice.supplier),
              Container(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: invoice.info.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.customer),
              buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(Customer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(
              '${customer.address.address1},\n${customer.address.address2},\n${customer.address.postcode} ${customer.address.city},\n${customer.address.state}'),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      'Payment Terms:',
      'Due Date:'
    ];
    final data = <String>[
      info.number,
      formatDate(info.date),
      paymentTerms,
      formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress(Merchant supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(supplier.companyName,
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(
              '${supplier.address.address1}, ${supplier.address.address2}, ${supplier.address.postcode} ${supplier.address.city}, ${supplier.address.state}'),
        ],
      );

  static Widget buildTitle(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INVOICE',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
          Text(invoice.info.description),
          SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Machine',
      'Date',
      'Quantity',
      'Renting Price',
      'Delivery Charge',
      'Total'
    ];
    final data = invoice.items.map((item) {
      final total = globals.order.getRentingPrice();

      return [
        item.machineName,
        formatDate(globals.order.startDate),
        '${globals.order.orderQuantity}',
        formatPrice(globals.order.getRentingPrice()),
        '${globals.tax * 100} %',
        formatPrice(total),
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.center,
        5: Alignment.centerRight,
      },
      defaultColumnWidth: const FractionColumnWidth(.2),
    );
  }

  static Widget buildTotal(Invoice invoice) {
    final netTotal = globals.order.getTotalRentingPrice();
    final vatPercent = globals.tax;
    final vat = globals.order.getTaxCharge();
    final total = globals.order.getTotalRentCharge();

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Net total',
                  value: formatPrice(netTotal),
                  unite: true,
                ),
                buildText(
                  title: 'SST ${vatPercent * 100} %',
                  value: formatPrice(vat),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Total amount due',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: formatPrice(total),
                  unite: true,
                ),
                // Divider(),
                // balance != null
                //     ? buildText(
                //         title: 'Balance due',
                //         titleStyle: TextStyle(
                //           fontSize: 14,
                //           fontWeight: FontWeight.bold,
                //         ),
                //         value: formatPrice(remains),
                //         unite: true,
                //       )
                //     : Container(),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'Address',
              value:
                  '${invoice.supplier.address.address1}, ${invoice.supplier.address.address2}, ${invoice.supplier.address.postcode} ${invoice.supplier.address.city}, ${invoice.supplier.address.state}'),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'Contact', value: invoice.supplier.phoneNo),
        ],
      );

  static buildSimpleText({
    String title,
    String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    String title,
    String value,
    double width = double.infinity,
    TextStyle titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
