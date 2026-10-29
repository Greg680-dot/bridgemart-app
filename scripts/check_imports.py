import os
import re

lib_dir = r"C:\Users\Past HOUNGBEDJI Léon\.gemini\antigravity\scratch\naijabenin_tissus_app\lib"
all_errors = []

for root, _, files in os.walk(lib_dir):
    for f in files:
        if f.endswith(".dart"):
            filepath = os.path.join(root, f)
            with open(filepath, "r", encoding="utf-8") as file:
                lines = file.readlines()
            for idx, line in enumerate(lines):
                line = line.strip()
                if line.startswith("import ") and ("'" in line or '"' in line):
                    match = re.search(r"['\"]([^'\"]+)['\"]", line)
                    if match:
                        import_path = match.group(1)
                        if not import_path.startswith("package:") and not import_path.startswith("dart:"):
                            # Relative import
                            target = os.path.normpath(os.path.join(root, import_path))
                            if not os.path.exists(target):
                                all_errors.append(f"{filepath}:{idx+1} -> Missing file: {target} (import: {import_path})")

if all_errors:
    print(f"Found {len(all_errors)} broken imports:")
    for err in all_errors:
        print("  " + err)
else:
    print("ALL DART IMPORTS ARE 100% VALID!")
