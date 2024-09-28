import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry; // 可选的重试按钮回调
  final String? retryButtonText; // 重试按钮的文本（可选）
  final IconData? icon; // 错误图标（可选）

  const ErrorDisplay({
    super.key,
    required this.errorMessage,
    this.onRetry,
    this.retryButtonText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        // 使整个 Widget 占据全屏
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: Colors.blue, // 背景颜色设为蓝色
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 显示错误图标，默认使用警告图标
              Icon(
                icon ?? Icons.sentiment_dissatisfied,
                size: 64.0,
                color: Colors.white, // 图标颜色设为白色
              ),
              const SizedBox(height: 16.0),
              // 错误信息文本
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white, // 文字颜色设为白色
                ),
              ),
              const SizedBox(height: 16.0),
              // 如果提供了重试按钮，则显示按钮
              if (onRetry != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // 按钮背景颜色设为白色
                    foregroundColor: Colors.blue, // 按钮文字颜色设为蓝色
                  ),
                  onPressed: onRetry,
                  child: Text(retryButtonText ?? '重试'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
