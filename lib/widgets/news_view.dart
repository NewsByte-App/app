import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:newsbites/models/category_data.dart';
import 'package:newsbites/utils/utils.dart';

class NewsView extends StatefulWidget {
  final Datum news;
  final Size screenSize;
  final bool isViewingBookMarks;
  bool isBookMarked;
  final void Function()? onRemove;

  NewsView({
    Key? key,
    required this.news,
    required this.screenSize,
    this.isBookMarked = false,
    this.isViewingBookMarks = false,
    this.onRemove,
  }) : super(key: key);

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GestureDetector(
          onTap: () async {
            if (widget.news.readMoreUrl == null) {
              showSnackBar(
                  context: context,
                  text: "no web url "
                      "present to navigate");
              return;
            }
          },
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: widget.news.imageUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image_rounded),
                  height: widget.screenSize.height * 0.42,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.news.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey),
                      child: Text(
                        widget.news.time,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Text(widget.news.content)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "@ ${widget.news.author}",
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          widget.news.date,
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    if (!widget.isBookMarked)
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.bookmark_border),
                      ),
                    if (widget.isBookMarked)
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.bookmark_remove_rounded),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
