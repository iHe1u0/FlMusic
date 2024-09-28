class AudioFile {
  final String path; // 音频文件的路径
  String? title; // 歌曲名称
  String? songer; // 艺术家名称

  // 构造函数
  AudioFile(this.path, {this.title, this.songer}) {
    if (title == null || title!.isEmpty) {
      title = path.split('/').last;
    }
  }
}
