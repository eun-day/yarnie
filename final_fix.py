import os
import re

def fix_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    changed = False

    # 1. Fix imports
    if "package:flutter_gen/gen_l10n/app_localizations.dart" in content:
        content = content.replace("package:flutter_gen/gen_l10n/app_localizations.dart", "package:yarnie/l10n/app_localizations.dart")
        changed = True

    # 2. Add import if missing but used
    if 'AppLocalizations' in content and 'import \'package:yarnie/l10n/app_localizations.dart\';' not in content:
        # Avoid double importing if it was there under another name or something
        if 'app_localizations.dart' not in content:
            import_match = re.search(r"^import '.*';", content, re.MULTILINE)
            if import_match:
                content = content[:import_match.start()] + "import 'package:yarnie/l10n/app_localizations.dart';\n" + content[import_match.start():]
                changed = True

    # 3. Remove const from lines with AppLocalizations
    lines = content.split('\n')
    new_lines = []
    for line in lines:
        if 'AppLocalizations.of(context)!' in line and 'const ' in line:
            line = line.replace('const ', '')
            changed = True
        new_lines.append(line)
    content = '\n'.join(new_lines)

    # 4. Handle specific const issues where AppLocalizations is used inside a const constructor call
    # This is harder with regex, but let's try a simple one: find "const WidgetName(" where one of arguments is AppLocalizations.of
    # Actually, often it's "const [" or "const Padding(" etc.
    # A safer way is to remove 'const' from lines that contain dynamic calls.

    if changed:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"Fixed: {filepath}")

def main():
    for root, dirs, files in os.walk('lib'):
        for file in files:
            if file.endswith('.dart'):
                fix_file(os.path.join(root, file))

if __name__ == "__main__":
    main()
