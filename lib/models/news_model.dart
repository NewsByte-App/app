// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NewsModel {
  final String id;
  final String title;
  final String content;
  final String summary;
  final String source_url;
  final String image_url;
  final String description;
  final String published_date;
  final String category;
  final String author;
  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.summary,
    required this.source_url,
    required this.image_url,
    required this.description,
    required this.published_date,
    required this.category,
    required this.author,
  });

  NewsModel copyWith({
    String? id,
    String? title,
    String? content,
    String? summary,
    String? source_url,
    String? image_url,
    String? description,
    String? published_date,
    String? category,
    String? author,
  }) {
    return NewsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      summary: summary ?? this.summary,
      source_url: source_url ?? this.source_url,
      image_url: image_url ?? this.image_url,
      description: description ?? this.description,
      published_date: published_date ?? this.published_date,
      category: category ?? this.category,
      author: author ?? this.author,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'summary': summary,
      'source_url': source_url,
      'image_url': image_url,
      'description': description,
      'published_date': published_date,
      'category': category,
      'author': author,
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      id: map['_id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      summary: map['summary'] as String,
      source_url: map['source_url'] as String,
      image_url: map['image_url'] as String,
      description: map['description'] as String,
      published_date: map['published_date'] as String,
      category: map['category'] as String,
      author: map['author'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsModel.fromJson(String source) =>
      NewsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NewsModel(id: $id, title: $title, content: $content, summary: $summary, source_url: $source_url, image_url: $image_url, description: $description, published_date: $published_date, category: $category, author: $author)';
  }

  @override
  bool operator ==(covariant NewsModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.content == content &&
        other.summary == summary &&
        other.source_url == source_url &&
        other.image_url == image_url &&
        other.description == description &&
        other.published_date == published_date &&
        other.category == category &&
        other.author == author;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        content.hashCode ^
        summary.hashCode ^
        source_url.hashCode ^
        image_url.hashCode ^
        description.hashCode ^
        published_date.hashCode ^
        category.hashCode ^
        author.hashCode;
  }
}
