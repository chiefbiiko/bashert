# Copyright (c) 2020 Noah Anabiik Schwarz. All rights reserved. MIT license.

assert_status() {
  # usage: assert_status "$header_file" $status_code
  if [[ -z "$1" ]] || [[ -z "$2" ]]; then
    >&2 printf "[assert_status] missing param \$header_file and \$status_code\n"
    exit 1
  fi

  printf -v pattern "HTTP/[1-9]\.?[1-9]? %d" $2

  if ! grep -qE "$pattern" "$1"; then
    >&2 printf "http status does not equal %d\n" $2
    >&2 cat "$1"
    exit 1
  fi
}

assert_equal() {
  # usage: assert_equal "$a" "$b"
  if [[ "$1" != "$2" ]]; then
    >&2 printf "values are not equal\n" "$1" "$2"
    exit 1
  fi
}

assert_not_equal() {
  # usage: assert_not_equal "$a" "$b"
  if [[ "$1" == "$2" ]]; then
    >&2 printf "values are not not equal\n" "$1" "$2"
    exit 1
  fi
}

assert_match() {
  # usage: assert_match "$string" $pattern
  if [[ -z "$2" ]]; then
    >&2 printf "[assert_match] missing param \$pattern\n"
    exit 1
  fi

  if [[ ! $1 =~ $2 ]]; then
    >&2 printf "string %s does not match pattern %s\n" "$1" "$2"
    exit 1
  fi
}

assert_files_equal_ignore_space() {
  # usage: assert_files_equal_ignore_space "$file_a" "$file_b"
  if [[ ! -f "$1" ]] || [[ ! -f "$2" ]]; then
    >&2 printf "[assert_files_equal_ignore_space] missing file params\n"
    exit 1
  fi

  a="$(tr -d '[:space:]' <"$1")"
  b="$(tr -d '[:space:]' <"$2")"

  if [[ "$a" != "$b" ]]; then
    >&2 printf "non-space file contents are not equal\na\n%s\nb\n%s\n" "$a" "$b"
    exit 1
  fi
}

assert_files_equal() {
  # usage: assert_files_equal "$file_a" "$file_b"
  if [[ ! -f "$1" ]] || [[ ! -f "$2" ]]; then
    >&2 printf "[assert_files_equal] missing file params\n"
    exit 1
  fi

  if ! cmp --silent "$1" "$2"; then
    >&2 printf "file contents are not equal\n"
    exit 1
  fi
}

assert_gt() {
  # usage: assert_gt $a $b
  if [[ -z "$1" ]] || [[ -z "$2" ]]; then
    >&2 printf "[assert_gt] missing params\n"
    exit 1
  fi

  if [[ ! $1 -gt $2 ]]; then
    >&2 printf "%f is not greater than %f\n" $1 $2
    exit 1
  fi
}

assert_lt() {
  # usage: assert_lt $a $b
  if [[ -z "$1" ]] || [[ -z "$2" ]]; then
    >&2 printf "[assert_lt] missing params\n"
    exit 1
  fi

  if [[ ! $1 -lt $2 ]]; then
    >&2 printf "%f is not less than %f\n" $1 $2
    exit 1
  fi
}

lurc() {
  curl -sS --proto '=https' --tlsv1.2 "$@"
}