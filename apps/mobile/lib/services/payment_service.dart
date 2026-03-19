import '../models/payment.dart';
import 'api_service.dart';

class PaymentService {
  static Future<({int created, int skipped, int total})> generate({String? month}) async {
    final res = await ApiService.post('/api/payments/generate', {
      if (month != null) 'month': month, // ignore: use_null_aware_elements
    });
    return (
      created: res['created'] as int,
      skipped: res['skipped'] as int,
      total: res['total'] as int,
    );
  }

  static Future<({List<Payment> data, int total})> list({
    String? status,
    String? leaseId,
    String? search,
    String? month,
    String sort = 'dueDate',
    String order = 'asc',
    int page = 1,
    int limit = 20,
  }) async {
    final query = <String, String>{
      'sort': sort,
      'order': order,
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (status != null) query['status'] = status;
    if (leaseId != null) query['leaseId'] = leaseId;
    if (search != null) query['search'] = search;
    if (month != null) query['month'] = month;

    final res = await ApiService.get('/api/payments', query: query);
    final data = (res['data'] as List).map((e) => Payment.fromJson(e)).toList();
    return (data: data, total: res['total'] as int);
  }

  static Future<Payment> markPaid(String id, {required String method, String? receipt}) async {
    final res = await ApiService.patch('/api/payments/$id/pay', {
      'method': method,
      if (receipt != null) 'receipt': receipt, // ignore: use_null_aware_elements
    });
    return Payment.fromJson(res);
  }

  static Future<PaymentReport> report({String? month}) async {
    final query = <String, String>{};
    if (month != null) query['month'] = month;
    final res = await ApiService.get('/api/payments/report', query: query);
    return PaymentReport.fromJson(res);
  }

  static Future<int> markOverdue() async {
    final res = await ApiService.post('/api/payments/mark-overdue', {});
    return res['updated'] as int;
  }
}
