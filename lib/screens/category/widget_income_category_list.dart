import 'package:flutter/material.dart';

import '../../db/category/category_db.dart';
import '../../models/category/category_model.dart';

class IncomeCategoryList extends StatelessWidget {
  const IncomeCategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return ValueListenableBuilder(
        valueListenable: CategoryDB().incomeCategoryListListener,
        builder:
            (BuildContext context, List<CategoryModel> newList, Widget? _) {
          if (CategoryDB.instance.incomeCategoryListListener.value.isEmpty) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "No categories available.",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
                Text(
                  "Add categories by pressing + icon.",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                )
              ],
            ));
          } else {
            return ListView.separated(
                itemBuilder: (BuildContext ctx, int index) {
                  final category = newList[index];
                  return Card(
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: ListTile(
                        title: Text(category.name),
                        trailing: IconButton(
                          onPressed: () {
                            CategoryDB.instance.deleteCategory(category.id);
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        )),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 5,
                  );
                },
                itemCount: newList.length);
          }
        });
  }
}
