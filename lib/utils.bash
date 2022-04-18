#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/hadolint/hadolint"
TOOL_NAME="hadolint"
TOOL_TEST="hadolint --version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if hadolint is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
  curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
  sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
    LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
  git ls-remote --tags --refs "$GH_REPO" |
    grep -o 'refs/tags/.*' | cut -d/ -f3- |
    sed 's/^v//'
}

list_all_versions() {
  list_github_tags
}

download_release() {
  local version filename uname_s uname_m os arch url
  version="$1"
  filename="$2"

  uname_s="$(uname -s)"
  uname_m="$(uname -m)"

  case "$uname_s" in
    Darwin) os="Darwin" ;;
    Linux) os="Linux" ;;
    *) fail "OS not supported: $uname_s" ;;
  esac

  case "$uname_m" in
    x86_64) arch="x86_64" ;;
    aarch64) arch="arm64" ;;
    armv8l) arch="arm64" ;;
    arm64) arch="arm64" ;;
    *) fail "Architecture not supported: $uname_m" ;;
  esac

  # Ugly hack until native M1 arm64 binaries are avaliable for Darwin from hadolint
  # M1 chips can still run x86_64 binaries fine via Rosetta 2 in the meantime
  if [[ $os == "Darwin" ]]; then
    arch="x86_64"
  fi

  url="$GH_REPO/releases/download/v${version}/hadolint-${os}-${arch}"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="${3%/bin}/bin"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    mkdir -p "$install_path"
    cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

    # Asert hadolint executable exists.
    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error ocurred while installing $TOOL_NAME $version."
  )
}
