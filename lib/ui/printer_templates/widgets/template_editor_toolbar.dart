import 'package:invently/models/printer/printer_template_model.dart';
import 'package:invently/provider/printer_template_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TemplateEditorToolbar extends StatelessWidget {
  const TemplateEditorToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrinterTemplateProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              // Font size dropdown
              DropdownButton<double>(
                value: provider.currentStyle.fontSize,
                items: [12.0, 14.0, 16.0, 18.0, 20.0, 24.0]
                    .map(
                      (size) => DropdownMenuItem(
                        value: size,
                        child: Text('$size'),
                      ),
                    )
                    .toList(),
                onChanged: (value) => provider.updateStyle(fontSize: value),
              ),
              const SizedBox(width: 8),

              // Style buttons
              IconButton(
                icon: Icon(Icons.format_bold, color: provider.currentStyle.isBold ? Colors.blue : Colors.grey),
                onPressed: () => provider.updateStyle(isBold: !provider.currentStyle.isBold),
              ),
              IconButton(
                icon: Icon(Icons.format_italic, color: provider.currentStyle.isItalic ? Colors.blue : Colors.grey),
                onPressed: () => provider.updateStyle(isItalic: !provider.currentStyle.isItalic),
              ),
              IconButton(
                icon:
                    Icon(Icons.format_underline, color: provider.currentStyle.isUnderline ? Colors.blue : Colors.grey),
                onPressed: () => provider.updateStyle(isUnderline: !provider.currentStyle.isUnderline),
              ),

              // Alignment buttons
              IconButton(
                icon: const Icon(Icons.format_align_left),
                onPressed: () => provider.updateStyle(alignment: TextAlignment.left),
              ),
              IconButton(
                icon: const Icon(Icons.format_align_center),
                onPressed: () => provider.updateStyle(alignment: TextAlignment.center),
              ),
              IconButton(
                icon: const Icon(Icons.format_align_right),
                onPressed: () => provider.updateStyle(alignment: TextAlignment.right),
              ),
            ],
          ),
        );
      },
    );
  }
}
