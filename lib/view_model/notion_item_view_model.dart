import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notion_api_sample/entities/model/item_model.dart';
import 'package:notion_api_sample/entities/model/item_value_model.dart';
import 'package:notion_api_sample/repositories/notion/notion_client_repository.dart';

// TODO:refactor
final itemProvider = FutureProvider<List<Item>>(
  ((ref) async {
    List<String> categoryList = [];
    final _notionRepository = NotionRepository();
    final itemList = await _notionRepository.fetchNotionItems();
    // 全ての支出のカテゴリーをリスト化
    categoryList = itemList.map((item) => item.category).toList();
    // カテゴリーリストから重複を削除
    final removeDuplicateList = itemList.toSet().toList();
    // （重複していない）カテゴリーを取り出しItemValueに変換
    var itemValueList = removeDuplicateList
        .map(
          (category) => ItemValue(
              category: category.category,
              value: 0,
              categoryColor: category.categoryColor),
        )
        .toList();
    for (var category in categoryList) {
      // （重複していない）カテゴリーのカテゴリー名のみをリスト化
      final list = removeDuplicateList.map((e) => e.category).toList();
      // 各カテゴリーのインデックスを取得
      final categoryIndex = list.indexOf(category);
      // 各カテゴリーのvalueを更新
      itemValueList[categoryIndex].value += 1.0;
    }
    ref.watch(categoriesProvider.notifier).state = itemValueList;
    return itemList;
  }),
);

// カテゴリー名、割合、カテゴリーカラーを含むItemValueのリストを
final categoriesProvider = StateProvider<List<ItemValue>>(((ref) => []));
