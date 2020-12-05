# api-bashin

![ci](https://github.com/chiefbiiko/api-bashin/workflows/ci/badge.svg)

a small suite of bash helpers to write easy api tests in pure bash :DD

find all `assert_*` helpers [in `mod.sh`](./mod.sh)

## usage (probly in a pipeline)

1. source `mod.sh` from a local copy or via the network
2. source a `bash` file containing your own test case definitions which are basically just `bash` function declarations
3. call your `bash` test case functions

```bash
source <(curl -sSf https://raw.githubusercontent.com/chiefbiiko/api-bashin/master/mod.ts)
source ./example_test_suite.sh

test_users_list_200
```

## helpers

if any of the assertions do not hold true an error is printed to `stderr` and the helper calls `exit 1`

```bash
assert_status "$header_file" $status_code
assert_equal "$a" "$b"
assert_not_equal "$a" "$b"
assert_match "$string" $pattern
assert_files_equal_ignore_space "$file_a" "$file_b"
assert_gt $a $b
assert_lt $a $b

lurc() {
  curl -sS --proto '=https' --tlsv1.2 "$@"
}
```


use `lurc` instead of plain `curl` to require `TLS 1.2` for every connection and silent `curl` as long as there are no errors

## license

[MIT](./LICENSE)