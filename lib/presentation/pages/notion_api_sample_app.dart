import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import 'package:notion_api_sample/view_model/notion_item_view_model.dart';

class NotionApiSampleApp extends ConsumerWidget {
  const NotionApiSampleApp({Key? key}) : super(key: key);

  final _primaryColor = const Color.fromARGB(255, 67, 122, 210);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: _buildAppBar(ref),
      body: _buildBody(ref),
    );
  }

  AppBar _buildAppBar(WidgetRef ref) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: NeumorphicText(
        "家計簿",
        style: NeumorphicStyle(
          depth: 1,
          color: _primaryColor,
        ),
        textStyle: NeumorphicTextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () async {
            HapticFeedback.heavyImpact();
            ref.refresh(itemProvider);
          },
          icon: Icon(
            Icons.cached,
            color: _primaryColor,
          ),
        )
      ],
    );
  }

  Widget _buildBody(WidgetRef ref) {
    final items = ref.watch(itemProvider);
    final categories = ref.watch(categoriesProvider);
    return items.when(
      data: (data) => data.isEmpty
          ? Center(
              child: Column(
                children: [
                  Lottie.network(
                    'https://assets5.lottiefiles.com/packages/lf20_bhw1ul4g.json',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  NeumorphicText(
                    "データはありません",
                    style: NeumorphicStyle(
                      depth: 1,
                      color: _primaryColor,
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          for (int i = 0; i < categories.length; i++)
                            PieChartSectionData(
                              color:
                                  setColor(color: categories[i].categoryColor),
                              value: categories[i].value,
                              title: categories[i].category,
                              radius: 80,
                              titleStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                        ],
                        borderData: FlBorderData(
                          show: false,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  NeumorphicText(
                    "支出一覧",
                    style: NeumorphicStyle(
                      depth: 1,
                      color: _primaryColor,
                    ),
                    textStyle: NeumorphicTextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: ((context, index) {
                      final item = data[index];
                      return Card(
                        child: ListTile(
                          title: DefaultTextStyle.merge(
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item.date.year}/${item.date.month}/${item.date.day}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  item.name,
                                  style: TextStyle(
                                    color: setColor(color: item.categoryColor),
                                  ),
                                ),
                                Text(
                                  '${addCommaToNum(num: (item.price).round())} 円',
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: Chip(
                            label: Text(
                              item.category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            backgroundColor:
                                setColor(color: item.categoryColor),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
      error: (error, stack) => const Text('error'),
      loading: () => Center(
        child: Lottie.network(
          'https://assets1.lottiefiles.com/private_files/lf30_8ovwz3n6.json',
        ),
      ),
    );
  }

  // priceにカンマを追加
  String addCommaToNum({required int num}) {
    final formatter = NumberFormat("#,###");
    return formatter.format(num);
  }

  // notionAPIからresponseされるString型のカラーをHexカラーに変換
  Color setColor({required String color}) {
    late Color hexColor;
    switch (color) {
      case 'gray':
        hexColor = const Color(0xff979A9B);
        break;
      case 'brown':
        hexColor = const Color(0xff937264);
        break;
      case 'orange':
        hexColor = const Color(0xffFFA344);
        break;
      case 'yellow':
        hexColor = const Color(0xffFFDC49);
        break;
      case 'green':
        hexColor = const Color(0xff4DAB9A);
        break;
      case 'blue':
        hexColor = const Color(0xff529CCA);
        break;
      case 'purple':
        hexColor = const Color(0xff9A6DD7);
        break;
      case 'pink':
        hexColor = const Color(0xffE255A1);
        break;
      case 'red':
        hexColor = const Color(0xffFF7369);
        break;
      default:
        hexColor = const Color(0xff505558);
    }
    return hexColor;
  }
}
