import 'dart:math';

import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsbyte/screens/navigation_drawer.dart';
import 'package:newsbyte/widgets/news_view.dart';

import 'package:provider/provider.dart';

import '../models/categories.dart';
import '../models/category_data.dart';
import '../widgets/all_transformers.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      drawer: NavDrawer(),
    );
  }
}
