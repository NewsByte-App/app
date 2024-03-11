import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsbyte/bloc/news/news_bloc.dart';
import 'package:newsbyte/models/categories.dart';
import 'package:newsbyte/screens/article_screen.dart';
import 'package:newsbyte/screens/feed_screen.dart';
import 'package:newsbyte/screens/navigation_drawer.dart';
import 'package:newsbyte/widgets.dart/image_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<String> tabs;
  final NewsBloc _newsBloc = NewsBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> tabs = NewsCategories.values.map((e) => e.name).toList();

    return BlocProvider(
      create: (context) => _newsBloc,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        drawer: const NavDrawer(),
        appBar: AppBar(
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, FeedScreen.routeName, (route) => false);
              },
              child: Text(
                "Feed",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            )
          ],
          elevation: 0,
        ),
        body: Column(
          children: [
            const _DiscoverNews(),
            _CategoryNews(
              tabs: tabs,
            )
          ],
        ),
      ),
    );
  }
}

class _CategoryNews extends StatefulWidget {
  const _CategoryNews({
    Key? key,
    required this.tabs,
  }) : super(key: key);

  final List<String> tabs;

  @override
  State<_CategoryNews> createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<_CategoryNews>
    with SingleTickerProviderStateMixin {
  final Map<int, ScrollController> _scrollControllers = {};
  late final TabController _tabController;
  late final List<String> tabs;

  @override
  void initState() {
    for (int i = 0; i < widget.tabs.length; i++) {
      _scrollControllers[i] = ScrollController();
    }
    tabs = NewsCategories.values.map((e) => e.name).toList();
    _tabController = TabController(vsync: this, length: tabs.length);
    _tabController.addListener(_onTabChanged);
    super.initState();
  }

  void _onTabChanged() {
    if (mounted & !_tabController.indexIsChanging) {
      BlocProvider.of<NewsBloc>(context)
          .add(GetNewsByCategory(tabs[_tabController.index]));
    }
  }

  bool _isBottom(ScrollController controller) {
    if (!controller.hasClients) return false;
    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.offset;
    return currentScroll >= (maxScroll * 1.0);
  }

  @override
  void dispose() {
    for (var controller in _scrollControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: widget.tabs
              .map(
                (tab) => Tab(
                  icon: Text(
                    tab,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              )
              .toList(),
        ),
        Expanded(
          child: TabBarView(
              controller: _tabController,
              children: tabs.asMap().entries.map((entry) {
                int tabIndex = entry.key;
                String tab = entry.value;
                ScrollController scrollController = ScrollController();
                _scrollControllers[tabIndex] = scrollController;
                return BlocBuilder<NewsBloc, NewsState>(
                    builder: (context, state) {
                  if (state is NewsInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NewsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NewsLoaded) {
                    return ListView.builder(
                      controller: scrollController
                        ..addListener(() {
                          if (!mounted) return;
                          if (_tabController.index == tabIndex &&
                              _isBottom(scrollController)) {
                            context
                                .read<NewsBloc>()
                                .add(FetchMoreNewsByCategory(tab));
                          }
                        }),
                      shrinkWrap: true,
                      itemCount: state.news.length,
                      itemBuilder: ((context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArticleScreen(
                                  news: state.news[index],
                                  scrollablePhysics: true,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              ImageContainer(
                                width: 80,
                                height: 80,
                                margin: const EdgeInsets.all(10.0),
                                borderRadius: 5,
                                imageUrl: state.news[index].image_url,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      state.news[index].title,
                                      maxLines: 2,
                                      overflow: TextOverflow.clip,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.schedule,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '${DateTime.now().difference(DateTime.parse(state.news[index].published_date)).inHours} hours ago',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(width: 20),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  } else if (state is NewsError) {
                    return Container();
                  } else {
                    return Container();
                  }
                });
              }).toList()),
        ),
      ]),
    );
  }
}

class _DiscoverNews extends StatelessWidget {
  const _DiscoverNews({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'NewsByte.',
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 5),
          Text(
            'Quick Reads, Big Stories',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
