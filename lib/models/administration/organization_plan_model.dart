
import 'package:invently/models/common/common_id_value_model.dart';

class OrganizationPlanModel extends CommonKeyValueModel {
  int userCount;
  int branchCount;

  OrganizationPlanModel({required super.id, required super.value, required this.userCount, required this.branchCount});

  static OrganizationPlanModel basic() =>
      OrganizationPlanModel(id: 'Basic', value: 'Basic', userCount: 2, branchCount: 1);

  static OrganizationPlanModel diamond() =>
      OrganizationPlanModel(id: 'Diamond', value: 'Diamond', userCount: 9, branchCount: 3);

  static OrganizationPlanModel platinum() =>
      OrganizationPlanModel(id: 'Platinum', value: 'Basic', userCount: 20, branchCount: 5);

  static OrganizationPlanModel custom() =>
      OrganizationPlanModel(id: 'Custom', value: 'Custom', userCount: 1, branchCount: 1);

  static OrganizationPlanModel fromString({
    required String planId,
    required int userCount,
    required int branchCount,
  }) {
    planId = planId.toLowerCase().trim();
    if (planId == basic().id.toLowerCase().trim()) return basic();
    if (planId == diamond().id.toLowerCase().trim()) return diamond();
    if (planId == platinum().id.toLowerCase().trim()) return platinum();

    OrganizationPlanModel customPlan = custom();

    if (userCount > 0) customPlan.userCount = userCount;
    if (branchCount > 0) customPlan.branchCount = branchCount;

    return customPlan;
  }
}
