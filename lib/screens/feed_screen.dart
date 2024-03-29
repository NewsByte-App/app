import 'package:another_transformer_page_view/another_transformer_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsbites/bloc/news/news_bloc.dart';
import 'package:newsbites/models/article_model.dart';
import 'package:newsbites/models/news_model.dart';
import 'package:newsbites/screens/article_screen.dart';
import 'package:newsbites/screens/home_screen.dart';
import 'package:newsbites/utils/shared_prefs.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});
  static const routeName = "/feed";

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late final NewsBloc _newsBloc;
  int _index = 0;
  final Map<int, DateTime> _pageVisibleStartTime = {};
  final Map<int, Duration> _pageLifespan = {};
  final String user = PreferenceUtils.getString('user');

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
                    if (_pageVisibleStartTime.containsKey(_index)) {
                      final endTime = DateTime.now();
                      final startTime = _pageVisibleStartTime[_index]!;
                      final lifespan = endTime.difference(startTime);
                      _pageLifespan[_index] = lifespan;
                      BlocProvider.of<NewsBloc>(context).add(UpdateUserBehavior(
                        user,
                        state.news[index!].category,
                        lifespan.toString(),
                        state.news[index].id,
                      ));
                    }
                    _pageVisibleStartTime[index!] = DateTime.now();
                    setState(() {
                      _index = index;
                    });
                    const preloadThreshold = 1;
                    if (_index >= state.news.length - preloadThreshold &&
                        state is! NewsLoading) {
                      _newsBloc.add(FetchRecommendedNews(user));
                    }
                  },
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return ArticleScreen(
                        news: state.news[index],
                        scrollablePhysics: false,
                        height: 0.05);
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
