import 'package:flutter/material.dart';
import 'package:newsbites/models/news_model.dart';
import 'package:newsbites/widgets/custom_tag.dart';
import 'package:newsbites/widgets.dart/image_container.dart';
import 'package:stroke_text/stroke_text.dart';

class ArticleScreen extends StatelessWidget {
  final NewsModel news;
  final bool scrollablePhysics;
  final double height;
  const ArticleScreen({
    Key? key,
    required this.news,
    required this.scrollablePhysics,
    required this.height,
  }) : super(key: key);

  static const routeName = '/article';
  @override
  Widget build(BuildContext context) {
    return ImageContainer(
      width: double.infinity,
      imageUrl: news.image_url,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: CustomScrollView(
          physics: scrollablePhysics
              ? const ScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          slivers: <Widget>[
            SliverToBoxAdapter(
                child: _NewsHeadline(article: news, height: height)),
            SliverFillRemaining(
              hasScrollBody: false, // Set to false to fill the remaining space
              child: _NewsBody(article: news),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsBody extends StatelessWidget {
  const _NewsBody({
    Key? key,
    required this.article,
  }) : super(key: key);

  final NewsModel article;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomTag(
                  backgroundColor: Theme.of(context).cardColor,
                  children: [
                    const SizedBox(width: 10),
                    Text(
                      article.author,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                CustomTag(
                  backgroundColor: Theme.of(context).cardColor,
                  children: [
                    const Icon(
                      Icons.timer,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${DateTime.now().difference(DateTime.parse(article.published_date)).inHours}h',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              (article.summary).trim(),
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsHeadline extends StatelessWidget {
  const _NewsHeadline({
    Key? key,
    required this.article,
    required this.height,
  }) : super(key: key);

  final NewsModel article;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * height,
          ),
          CustomTag(
            backgroundColor: Colors.grey.withAlpha(150),
            children: [
              Text(
                article.category,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          StrokeText(
              strokeWidth: 4,
              text: article.title,
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          StrokeText(
              text: article.description,
              textStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
