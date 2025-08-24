enum ReportStatus { pending, resolved, rejected }

ReportStatus reportStatusFromString(String? s) {
  switch (s) {
    case 'resolved':
      return ReportStatus.resolved;
    case 'rejected':
      return ReportStatus.rejected;
    case 'pending':
    default:
      return ReportStatus.pending;
  }
}

String reportStatusToString(ReportStatus status) {
  switch (status) {
    case ReportStatus.pending:
      return 'pending';
    case ReportStatus.resolved:
      return 'resolved';
    case ReportStatus.rejected:
      return 'rejected';
  }
}

class Report {
  final String id;
  final String? toiletId;
  final String? reportedBy;
  final String reason;
  final ReportStatus status;
  final DateTime? resolvedAt;
  final String? resolvedBy;
  final DateTime createdAt;

  Report({
    required this.id,
    this.toiletId,
    this.reportedBy,
    required this.reason,
    required this.status,
    this.resolvedAt,
    this.resolvedBy,
    required this.createdAt,
  });

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      id: map['id']?.toString() ?? '',
      toiletId: map['toilet_id']?.toString(),
      reportedBy: map['reported_by']?.toString(),
      reason: map['reason']?.toString() ?? '',
      status: reportStatusFromString(map['status']?.toString()),
      resolvedAt: _asDate(map['resolved_at']),
      resolvedBy: map['resolved_by']?.toString(),
      createdAt: _asDate(map['created_at']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'toilet_id': toiletId,
      'reported_by': reportedBy,
      'reason': reason,
      'status': reportStatusToString(status),
      'resolved_at': resolvedAt?.toIso8601String(),
      'resolved_by': resolvedBy,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

DateTime? _asDate(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  return DateTime.tryParse(v.toString());
}
