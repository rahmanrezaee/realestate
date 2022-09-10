class Invoice {
  int? id;
  String? title;
  int ?invoiceItemId;
  String? invoiceItemPrice;
  String? invoicePurchaseDate;
  String? invoicePaymentMethod;
  String? transPaymentId;
  String? transPayerId;
  int? invoiceUserId;
  String? invoice_status;
  String ?invoicePaymentType;

  Invoice(
      {this.id,
      this.title,
      this.invoiceItemId,
      this.invoiceItemPrice,
      this.invoicePaymentMethod,
      this.invoicePaymentType,
      this.invoicePurchaseDate,
      this.invoiceUserId,
      this.invoice_status,
      this.transPayerId,
      this.transPaymentId});

  Invoice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title']['rendered'];
    invoiceItemId = json['invoice-detail']['invoice_item_id'];
    invoiceItemPrice = json['invoice-detail']['invoice_item_price'].toString();
    invoicePurchaseDate = json['invoice-detail']['invoice_purchase_date'];
    invoiceUserId = json['invoice-detail']['invoice_user_id'];
    invoicePaymentType = json['invoice-detail']['invoice_payment_type'];
    invoicePaymentMethod = json['invoice-detail']['invoice_payment_method'];
    transPaymentId = json['invoice-detail']['trans_payment_id'];
    transPayerId = json['invoice-detail']['trans_payer_id'];
    invoice_status = json['invoice-detail']['invoice_status'];
  }
}
