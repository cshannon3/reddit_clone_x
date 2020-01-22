final List<String> possibleTypes = [
  "image",
  "link",
  "hosted:video",
  "rich:video"
];

final List<PostType> pos = [
  PostType.link,
  PostType.image,
  PostType.link,
  PostType.hostedvideo,
  PostType.richvideo
];

class Post {
  final String id;
  final String subreddit;
  final String title;

  final String selftext;
  final String url;
  final String thumbnail;
  int thumbnailHeight;
  int thumbnailWidth;

  final PostType postType;

  bool likes;
  int score;
  bool clicked;
  int numcomments;
  int gilded;
  final String author;
  final bool over18;
  bool stickied;
  final DateTime postedTime;
  Post({
    this.id,
    this.title,
    this.selftext,
    this.postType,
    this.url,
    this.thumbnail,
    this.subreddit,
    this.score,
    this.likes,
    this.clicked,
    this.numcomments,
    this.over18,
    this.gilded,
    this.stickied,
    this.author,
    this.postedTime,
  });

  String get fullId => "t3_" + id;

  Post.fromJson(Map jsonMap)
      : id = jsonMap['id'],
        title = jsonMap['title'],
        selftext = jsonMap['selftext'],
        url = jsonMap['url'],
        thumbnail = jsonMap['thumbnail'],
        thumbnailHeight = jsonMap['thumbnail_height'],
        thumbnailWidth = jsonMap['thumbnail_width'],
        postType = (jsonMap['url'].toString().contains("www.reddit.com"))
            ? PostType.self
            : pos[possibleTypes.indexOf(jsonMap['post_hint']) + 1],
        subreddit = jsonMap['subreddit'],
        likes = jsonMap['likes'],
        clicked = jsonMap['clicked'],
        score = jsonMap['score'],
        numcomments = jsonMap['num_comments'],
        gilded = jsonMap['gilded'],
        author = jsonMap['author'],
        over18 = jsonMap['over_18'],
        stickied = jsonMap['stickied'],
        postedTime = DateTime.fromMillisecondsSinceEpoch(
            (jsonMap['created_utc'] * 1000).floor(),
            isUtc: true);
}

enum PostType {
  image,
  hostedvideo,
  richvideo,
  link,
  self,
}
