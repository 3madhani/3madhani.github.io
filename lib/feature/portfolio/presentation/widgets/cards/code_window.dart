import 'package:flutter/material.dart';

class CodeWindow extends StatefulWidget {
  const CodeWindow({super.key});

  @override
  State<CodeWindow> createState() => _CodeWindowState();
}

class _CodeLine extends StatelessWidget {
  final String line;

  const _CodeLine({required this.line});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (line.isEmpty) {
      return const SizedBox(height: 20);
    }

    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodySmall?.copyWith(
          fontFamily: 'monospace',
          color: theme.colorScheme.onSurface,
        ),
        children: _parseCodeLine(line, theme),
      ),
    );
  }

  List<TextSpan> _parseCodeLine(String line, ThemeData theme) {
    // Simple syntax highlighting
    if (line.contains('import')) {
      return [
        TextSpan(
          text: 'import',
          style: TextStyle(color: theme.colorScheme.primary),
        ),
        TextSpan(text: line.substring(6)),
      ];
    }

    if (line.contains('void') || line.contains('main')) {
      return [
        TextSpan(
          text: line,
          style: TextStyle(color: theme.colorScheme.secondary),
        ),
      ];
    }

    if (line.trim().startsWith('//')) {
      return [
        TextSpan(
          text: line,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            fontStyle: FontStyle.italic,
          ),
        ),
      ];
    }

    return [TextSpan(text: line)];
  }
}

class _CodeWindowState extends State<CodeWindow>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final List<String> _codeLines = [
    "import 'package:flutter/material.dart';",
    "import 'package:flutter_magic/magic.dart';",
    "",
    "void main() {",
    "  runApp(MagicalApp());",
    "}",
    "",
    "// Creating magical experiences...",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Window Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  _WindowButton(color: Colors.red.shade400),
                  const SizedBox(width: 8),
                  _WindowButton(color: Colors.yellow.shade400),
                  const SizedBox(width: 8),
                  _WindowButton(color: Colors.green.shade400),
                  const SizedBox(width: 16),
                  Text(
                    'emad_hany_portfolio.dart',
                    style: theme.textTheme.titleSmall,
                  ),
                ],
              ),
            ),

            // Code Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _codeLines.asMap().entries.map((entry) {
                  final index = entry.key;
                  final line = entry.value;

                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final progress =
                          (_controller.value * _codeLines.length - index).clamp(
                            0.0,
                            1.0,
                          );

                      return Opacity(
                        opacity: progress,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: _CodeLine(line: line),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: _codeLines.length * 500),
      vsync: this,
    )..repeat(reverse: true);
    _controller.forward();
  }
}

class _WindowButton extends StatelessWidget {
  final Color color;

  const _WindowButton({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
