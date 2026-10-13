import 'package:invently/assortment/services/navigation_service/navigation_service.dart';
import 'package:invently/gen/assets.gen.dart';
import 'package:invently/provider/printer_template_provider.dart';
import 'package:invently/ui/printer_templates/widgets/template_editor_toolbar.dart';
import 'package:invently/utils/theme/colors/colors.dart';
import 'package:invently/widgets/page_widgets/page_body_container.dart';
import 'package:invently/widgets/page_widgets/page_header_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrinterTemplatesScreen extends StatefulWidget {
  const PrinterTemplatesScreen({super.key});

  @override
  State<PrinterTemplatesScreen> createState() => _PrinterTemplatesScreenState();
}

class _PrinterTemplatesScreenState extends State<PrinterTemplatesScreen> {
  late TextEditingController headerController;

  @override
  void initState() {
    super.initState();
    headerController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = context.read<PrinterTemplateProvider>();
      provider.clearProvider();
      AppNavigator.setBreadCrumbs([AppRoutes.printerTemplates]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PrinterTemplateProvider>(
      builder: (context, provider, _) {
        return PageBodyContainer(
          child: Column(
            children: [
              // Top section with dropdowns and buttons
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // User Type Dropdown
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: provider.selectedUserType,
                            items: provider.userTypes
                                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                                .toList(),
                            onChanged: (value) => provider.updateUserType(value!),
                            underline: const SizedBox(),
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Paper Size Dropdown
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            value: provider.selectedPaperSize,
                            items: provider.paperSizes
                                .map((size) => DropdownMenuItem(value: size, child: Text(size)))
                                .toList(),
                            onChanged: (value) => provider.updatePaperSize(value!),
                            underline: const SizedBox(),
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Print Button
                      PageHeaderBorderButton(
                        label: 'Print',
                        onTap: () => {},
                        icon: Assets.icons.printerTemplates,
                        buttonColor: Colors.white,
                        textColor: Tm.color(Tc.priDef),
                        borderColor: Tm.color(Tc.priDef),
                      ),
                      const SizedBox(width: 8),
                      // Save Button
                      PageHeaderButton(
                        label: 'Save',
                        onTap: () => {},
                        icon: Assets.icons.checkSquare,
                        buttonColor: Tm.color(Tc.priDef),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Main content area with preview and editor
              Expanded(
                child: Row(
                  children: [
                    // Template Preview
                    Expanded(
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('Template Preview'),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        Text(
                                          provider.headerText,
                                          style: TextStyle(
                                            fontSize: provider.currentStyle.fontSize,
                                            fontWeight:
                                                provider.currentStyle.isBold ? FontWeight.bold : FontWeight.normal,
                                            fontStyle:
                                                provider.currentStyle.isItalic ? FontStyle.italic : FontStyle.normal,
                                            decoration:
                                                provider.currentStyle.isUnderline ? TextDecoration.underline : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Custom Text Editor
                    Expanded(
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('Set Custom Text'),
                            ),
                            const TemplateEditorToolbar(),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: TextField(
                                  controller: headerController,
                                  decoration: const InputDecoration(
                                    hintText: 'Set Header Here',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: provider.updateHeaderText,
                                  maxLines: null,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    headerController.dispose();
    super.dispose();
  }
}
