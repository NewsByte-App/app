import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsbyte/bloc/news/news_bloc.dart';
import 'package:newsbyte/models/article_model.dart';
import 'package:newsbyte/models/news_model.dart';
import 'package:newsbyte/screens/article_screen.dart';
import 'package:newsbyte/screens/home_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});
  static const routeName = "/feed";

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final NewsBloc _newsBloc;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _newsBloc = NewsBloc();
    _newsBloc.add(GetNewsList());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _newsBloc,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomeScreen.routeName, (route) => false);
            },
          ),
          elevation: 0,
        ),
        body: BlocBuilder<NewsBloc, NewsState>(
          builder: (context, state) {
            if (state is NewsInitial) {
              return _buildLoading();
            } else if (state is NewsLoading) {
              return _buildLoading();
            } else if (state is NewsLoaded) {
              return TransformerPageView(
                  loop: false,
                  index: _index,
                  onPageChanged: (index) {
                    setState(() {
                      _index = index!;
                    });
                    const preloadThreshold = 3;
                    if (_index >= state.news.length - preloadThreshold &&
                        state is! NewsLoading) {
                      _newsBloc.add(FetchMoreNews());
                    }
                  },
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    // Directly use state.news[index] here
                    return ArticleScreen(
                        news: state.news[index], scrollablePhysics: false);
                  },
                  itemCount: state.news.length);
            } else if (state is NewsError) {
              return Container();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

Widget _buildLoading() => const Center(child: CircularProgressIndicator());
