class StaticKeys {
  static String accessTokenLocation() => 'accessTokenLocation';
  static String role() => 'role';
  static String refreshTokenLocation() => 'refreshTokenLocation';
  static String commonDbLocation() => 'commonDbLocation';
  static String logDbLocation() => 'logDbLocation';
  static String usersDataKey() => 'usersDataKey';
  static String rememberUserKey() => 'rememberUserKey';
  static String scaleKey() => 'autoScaleKey';
}

enum BucketKeys {
  customerImage(value: 'customer-image'),
  supplierImage(value: 'supplier-image'),
  idProof(value: 'id-proof'),
  inventoryImage(value: 'inventory'),
  employeeImage(value: 'employee-image'),
  itemImage(value: 'item-image'),
  organizationImage(value: 'organization-image');

  const BucketKeys({required this.value});
  final String value;
}
