lint:
  statix check .

format:
  nixpkgs-fmt .

switch:
  sudo nixos-rebuild switch --flake 'path:/etc/nixos#surface'

build:
  sudo nixos-rebuild build --flake 'path:/etc/nixos#surface'

alias upgrade := update
update:
  nix flake update

clean:
  sudo nix-collect-garbage -d

repair:
  sudo nix-store --verify --check-contents --repair

# === Unity Quest 3 Build Commands ===

quest-image:
  @sg docker -c "docker pull unityci/editor:ubuntu-2022.3.67f1-android-3.2.2"

quest-build project='' output='':
  @Project="{{ project }}" && \
  Output="{{ output }}" && \
  if [ -z "$Project" ]; then Project="/etc/nixos/unity-projects/mr-example-meta-openxr"; fi && \
  if [ -z "$Output" ]; then Output="$Project/build/app.apk"; fi && \
  /etc/nixos/scripts/unity-quest/build-apk.sh -p "$Project" -o "$Output"

quest-install apk='':
  @APK="{{ apk }}" && \
  if [ -z "$APK" ]; then echo "Usage: just quest-install /path/to/app.apk"; exit 1; fi && \
  adb install -r "$APK"

quest-deploy project='':
  @Project="{{ project }}" && \
  if [ -z "$Project" ]; then Project="/etc/nixos/unity-projects/mr-example-meta-openxr"; fi && \
  /etc/nixos/scripts/unity-quest/build-apk.sh -p "$Project" && \
  APK="$Project/build/app.apk" && \
  echo "Installing to Quest 3..." && \
  adb install -r "$APK"

quest-dev project='':
  @Project="{{ project }}" && \
  if [ -z "$Project" ]; then Project="/etc/nixos/unity-projects/mr-example-meta-openxr"; fi && \
  echo "=== Building ===" && \
  /etc/nixos/scripts/unity-quest/build-apk.sh -p "$Project" && \
  APK="$Project/build/app.apk" && \
  echo "=== Deploying to Quest 3 ===" && \
  adb install -r "$APK" && \
  echo "=== Done! Open app on Quest 3 ==="

quest-dev-detect:
  @sg docker -c "docker ps"
