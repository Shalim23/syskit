#!/usr/bin/env bash
# Idempotent Ubuntu / WSL2 development environment bootstrap for syskit.
# Provisions C++ (Clang/GCC, sanitizers, CMake, Ninja, debuggers), Python + uv, and GitHub CLI.

set -euo pipefail

UV_VERSION="${UV_VERSION:-0.13.6}"

if ! command -v apt-get >/dev/null 2>&1; then
    echo "error: scripts/setup-ubuntu.sh requires an apt-based Debian/Ubuntu system." >&2
    exit 1
fi

if [[ "${EUID}" -eq 0 ]]; then
    SUDO=""
else
    SUDO="sudo"
fi

echo "==> [1/5] Ensuring bootstrap prerequisites (curl, gpg, ca-certificates)..."
if ! command -v curl >/dev/null 2>&1 || ! command -v gpg >/dev/null 2>&1; then
    ${SUDO} apt-get update
    ${SUDO} DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl gpg
fi

echo "==> [2/5] Configuring GitHub CLI apt repository..."
if [[ ! -f /etc/apt/sources.list.d/github-cli.list ]]; then
    ${SUDO} install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | ${SUDO} tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
    ${SUDO} chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        | ${SUDO} tee /etc/apt/sources.list.d/github-cli.list >/dev/null
fi

echo "==> [3/5] Installing C++, sanitizer, debugger, Python, and GitHub CLI packages..."
${SUDO} apt-get update
# Keep default Recommends enabled so Ubuntu installs libclang-rt-*-dev sanitizer runtimes.
${SUDO} DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    ca-certificates \
    clang \
    clang-format \
    clang-tidy \
    cmake \
    curl \
    gdb \
    gh \
    git \
    lld \
    lldb \
    ninja-build \
    pkg-config \
    python3 \
    python3-dev \
    python3-venv \
    valgrind

echo "==> [4/5] Installing pinned uv (${UV_VERSION})..."
export PATH="${HOME}/.local/bin:${PATH}"
CURRENT_UV=""
if command -v uv >/dev/null 2>&1; then
    CURRENT_UV="$(uv --version | awk '{print $2}')"
fi
if [[ "${CURRENT_UV}" != "${UV_VERSION}" ]]; then
    curl -LsSf "https://astral.sh/uv/${UV_VERSION}/install.sh" | sh
fi

echo "==> [5/5] Checking Git & WSL configuration..."
git config --global init.defaultBranch main

if [[ -n "${WSL_DISTRO_NAME:-}" ]] && [[ "${CI:-}" != "true" ]]; then
    WIN_GIT="/mnt/c/Program Files/Git/cmd/git.exe"
    if [[ -x "${WIN_GIT}" ]]; then
        if ! git config --global --get user.name >/dev/null 2>&1; then
            WIN_NAME="$("${WIN_GIT}" config --global --get user.name 2>/dev/null | tr -d '\r' || true)"
            if [[ -n "${WIN_NAME}" ]]; then
                git config --global user.name "${WIN_NAME}"
                echo "    Synced git user.name from Windows Git config."
            fi
        fi
        if ! git config --global --get user.email >/dev/null 2>&1; then
            WIN_EMAIL="$("${WIN_GIT}" config --global --get user.email 2>/dev/null | tr -d '\r' || true)"
            if [[ -n "${WIN_EMAIL}" ]]; then
                git config --global user.email "${WIN_EMAIL}"
                echo "    Synced git user.email from Windows Git config."
            fi
        fi
    fi
fi

echo "==> Verifying toolchain & Clang C++23 sanitizer link check..."
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT
printf 'int main() { return 0; }\n' > "${TMP_DIR}/probe.cpp"
clang++ -std=c++23 -Wall -Wextra -Wpedantic -Werror -fsanitize=address,undefined "${TMP_DIR}/probe.cpp" -o "${TMP_DIR}/probe"
"${TMP_DIR}/probe"

echo ""
echo "Toolchain ready:"
printf "  clang++      : %s\n" "$(clang++ --version | head -n 1)"
printf "  g++          : %s\n" "$(g++ --version | head -n 1)"
printf "  cmake        : %s\n" "$(cmake --version | head -n 1)"
printf "  ninja        : %s\n" "$(ninja --version)"
printf "  python3      : %s\n" "$(python3 --version)"
printf "  uv           : %s\n" "$(uv --version)"
printf "  gh           : %s\n" "$(gh --version | head -n 1)"

if [[ "${CI:-}" != "true" ]] && ! gh auth status >/dev/null 2>&1; then
    echo ""
    echo "Next step: authenticate GitHub CLI and wire Git credentials inside this environment:"
    echo "  gh auth login && gh auth setup-git"
fi
