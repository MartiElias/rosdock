#!/usr/bin/env bash
set -euo pipefail

# Config por ENV
SEARCH_ROOT="${SEARCH_ROOT:-/work}"
WS_GLOB="${WS_GLOB:-*_ws}"
WS_DEPTH="${WS_DEPTH:-3}"
WS_ORDER="${WS_ORDER:-topdown}"     # topdown|bottomup
PROJECT_RC="${PROJECT_RC:-$HOME/.project_rc}"
PROJECT_NAME="${PROJECT_NAME:-$(basename "${SEARCH_ROOT%/}")}"
REQUIRE_INSTALL="${REQUIRE_INSTALL:-1}"  # 1 => exige install/setup.bash

log(){ printf '[cdocker:ep] %s\n' "$*" >&2; }
find_order_flag(){ case "$WS_ORDER" in bottomup) printf -- "-depth";; *) printf -- "";; esac; }

# Inicializa RC
mkdir -p "$(dirname "$PROJECT_RC")"
{
  echo "# Autogenerado: $(date -Iseconds)"
  echo "export PROJECT_NAME=\"$PROJECT_NAME\""
  echo "export WORK_ROOT=\"$SEARCH_ROOT\""
  echo "export PATH=\$PATH:\$WORK_ROOT/bin"
  echo ""
} > "$PROJECT_RC"

# ROS base autodetect (si existe)
if [[ -d /opt/ros ]]; then
  for d in $(ls -1 /opt/ros | sort -r); do
    if [[ -f "/opt/ros/$d/setup.bash" ]]; then
      echo "export ROS_DISTRO=\"$d\"" >> "$PROJECT_RC"
      echo "source /opt/ros/$d/setup.bash || true" >> "$PROJECT_RC"
      echo "" >> "$PROJECT_RC"
      log "ROS base: $d"
      break
    fi
  done
fi

emit_source(){
  local ws="$1"
  local setup="$ws/install/setup.bash"
  if [[ "$REQUIRE_INSTALL" = "1" && ! -f "$setup" ]]; then
    echo "# omitido (sin install): $ws" >> "$PROJECT_RC"
    log "omitido (sin install): $ws"
    return
  fi
  {
    echo "### $ws"
    echo "[ -f \"$setup\" ] && source \"$setup\""
    echo ""
  } >> "$PROJECT_RC"
  log "source: $ws"
}

# WS: explícitos o búsqueda
if [[ -n "${WS_EXPLICIT:-}" ]]; then
  IFS=":" read -r -a list <<< "$WS_EXPLICIT"
  for ws in "${list[@]}"; do
    [[ -d "$ws" ]] && emit_source "$ws"
  done
else
  if [[ -d "$SEARCH_ROOT" ]]; then
    while IFS= read -r ws; do
      [[ -z "$ws" ]] && continue
      case "$(basename "$ws")" in .git|build|install|log|node_modules) continue;; esac
      emit_source "$ws"
    done < <(find "$SEARCH_ROOT" $(find_order_flag) -maxdepth "$WS_DEPTH" -type d -name "$WS_GLOB")
  fi
fi

# QoL + hook (por si la imagen no lo trae)
{
  echo "# QoL"
  echo "alias ll='ls -alF'"
  echo "export PS1='(ctr:\$PROJECT_NAME) \\u@\\h:\\w\\$ '"
  echo ""
} >> "$PROJECT_RC"

grep -q 'source "$HOME/.project_rc"' /etc/bash.bashrc 2>/dev/null || \
  printf '\n# Project-specific rc\n[ -f "$HOME/.project_rc" ] && source "$HOME/.project_rc"\n' >> /etc/bash.bashrc || true

# Ejecuta el comando recibido
exec "$@"
