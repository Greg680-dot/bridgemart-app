import os
import sys

manifest_path = os.path.join("android", "app", "src", "main", "AndroidManifest.xml")
if not os.path.exists(manifest_path):
    print(f"File not found: {manifest_path}")
    sys.exit(0)

with open(manifest_path, "r", encoding="utf-8") as f:
    content = f.read()

permissions = [
    '<uses-permission android:name="android.permission.INTERNET"/>',
    '<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>',
    '<uses-permission android:name="android.permission.CAMERA"/>'
]

perms_to_add = [p for p in permissions if p not in content]
if perms_to_add:
    perms_block = "\n    " + "\n    ".join(perms_to_add) + "\n"
    if "<application" in content:
        content = content.replace("<application", perms_block + "    <application", 1)

content = content.replace('android:label="naijabenin_tissus_app"', 'android:label="BridgeMart"')

with open(manifest_path, "w", encoding="utf-8") as f:
    f.write(content)

print("AndroidManifest.xml successfully prepared with BridgeMart permissions.")
