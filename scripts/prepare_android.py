import os
import sys
import re

print("--- BridgeMart Android Pre-build Preparation ---")

# 1. Update AndroidManifest.xml
manifest_path = os.path.join("android", "app", "src", "main", "AndroidManifest.xml")
if os.path.exists(manifest_path):
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
    print(" [OK] AndroidManifest.xml updated (permissions + app label).")
else:
    print(" [WARN] AndroidManifest.xml not found at:", manifest_path)

# 2. Enforce minSdkVersion 21 in build.gradle / build.gradle.kts
gradle_files = [
    os.path.join("android", "app", "build.gradle"),
    os.path.join("android", "app", "build.gradle.kts")
]

for g_file in gradle_files:
    if os.path.exists(g_file):
        with open(g_file, "r", encoding="utf-8") as f:
            bg = f.read()
        
        # Replace minSdkVersion flutter.minSdkVersion or similar with 21
        bg = re.sub(r'minSdkVersion\s*=?\s*flutter\.minSdkVersion', 'minSdkVersion 21', bg)
        bg = re.sub(r'minSdk\s*=\s*flutter\.minSdkVersion', 'minSdk = 21', bg)
        bg = re.sub(r'minSdk\s*=\s*flutter\.minSdk', 'minSdk = 21', bg)
        bg = re.sub(r'minSdkVersion\s+1[6-9]', 'minSdkVersion 21', bg)
        bg = re.sub(r'minSdk\s*=\s*1[6-9]', 'minSdk = 21', bg)
        
        with open(g_file, "w", encoding="utf-8") as f:
            f.write(bg)
        print(f" [OK] {g_file} configured with minSdkVersion 21.")

# 3. Check local.properties
local_props = os.path.join("android", "local.properties")
if os.path.exists(local_props):
    with open(local_props, "r", encoding="utf-8") as f:
        lp = f.read()
    if "flutter.minSdkVersion" in lp:
        lp = re.sub(r'flutter\.minSdkVersion=\d+', 'flutter.minSdkVersion=21', lp)
        with open(local_props, "w", encoding="utf-8") as f:
            f.write(lp)
        print(" [OK] local.properties updated with flutter.minSdkVersion=21.")

print("--- Android Pre-build Preparation Complete ---")
