import os
import re

def find_korean_in_file(filepath):
    korean_pattern = re.compile(r'[\uac00-\ud7af]+')
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()
        for i, line in enumerate(lines):
            if korean_pattern.search(line):
                # Ignore comments
                if line.strip().startswith('//') or line.strip().startswith('///'):
                    continue
                # Ignore arb files as they are supposed to have Korean
                if filepath.endswith('.arb'):
                    continue
                # Ignore generated files
                if filepath.endswith('.g.dart') or 'app_localizations' in filepath:
                    continue
                print(f"{filepath}:{i+1}: {line.strip()}")

def main():
    for root, dirs, files in os.walk('lib'):
        for file in files:
            if file.endswith('.dart'):
                find_korean_in_file(os.path.join(root, file))

if __name__ == "__main__":
    main()
