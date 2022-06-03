class MetaData {
  final String createdat;
  final String createdby;

  const MetaData({
    this.createdat = '',
    this.createdby = '',
  });

  factory MetaData.fromMap(Map<String, dynamic> map) => MetaData(
        createdat: map['CreatedAt'],
        createdby: map['CreatedBy'] ?? '',
      );

  Map<String, dynamic> toMap() => <String, dynamic>{
        'CreatedAt': createdat,
        'CreatedBy': createdby,
      };
}
