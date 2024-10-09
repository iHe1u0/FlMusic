class AudioFile {
  final String path; // 音频文件的路径
  String? title; // 歌曲名称
  String? artist; // 艺术家名称
  String? coverImage; // 封面路径
  // 构造函数
  AudioFile(this.path, {this.title, this.artist, this.coverImage}) {
    if (title == null || title!.isEmpty) {
      title = path.split('/').last;
    }
    if (coverImage == null || coverImage!.isEmpty) {
      coverImage =
          "https://cdn.pixabay.com/photo/2013/07/12/18/04/dvd-152917_960_720.png";
    }
  }
}
