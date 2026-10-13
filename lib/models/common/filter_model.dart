
import 'package:invently/assortment/network/api_manager_models.dart';

abstract class FilterModel<T> {
  List<UrlQuery> getFilterQueries();

  T copy(T copyFrom);

  bool isAnyFilterApplied() {
    final list = getFilterQueries();

    for (final i in list) {
      if (i.value != null && i.value!.trim().isNotEmpty) {
        return true;
      }
    }

    return false;
  }
}
