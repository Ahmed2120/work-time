import 'package:flutter/material.dart';
import 'package:work_time/core/services/whats_new_service.dart';
import 'package:work_time/data/models/whats_new_item.dart';

class WhatsNewViewModel with ChangeNotifier {
  List<WhatsNewItem> _items = [];
  List<WhatsNewItem> get items => _items;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasUnseen = false;
  bool get hasUnseen => _hasUnseen;

  Future<void> loadWhatsNew({bool forceRefresh = false}) async {
    _isLoading = true;
    notifyListeners();

    _items = await WhatsNewService.getWhatsNew(forceRefresh: forceRefresh);
    _hasUnseen = WhatsNewService.hasUnseenUpdates(_items);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> markSeen() async {
    if (_items.isNotEmpty) {
      await WhatsNewService.markAsSeen(_items.first.id);
      _hasUnseen = false;
      notifyListeners();
    }
  }
}

