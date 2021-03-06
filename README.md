# bashert

![ci](https://github.com/chiefbiiko/bashert/workflows/ci/badge.svg) [![bash](https://badges.frapsoft.com/bash/v1/bash.png?v=103)](./mod.sh)

a small set of bash `assert_*` functions 4u2 write test suites in pure bash :DD

## helpers

if any of the assertions do not hold true an error is printed to `stderr` and the helper calls `exit 1`

```bash
assert_status ./curl_header_dump 204
assert_equal twin twin
assert_not_equal fraud fr@ud
assert_match acab '^acab|ACAB$'
assert_files_equal ./a ./b
assert_files_equal_ignore_space ./a ./b
assert_gt 419 255
assert_lt -1 0

lurc() {
  curl -sS --proto '=https' --tlsv1.2 "$@"
}
```

2 save u headache when using `assert_match` make sure 2 use single quotes around the second pattern arg

use `lurc` instead of plain `curl` to require `TLS 1.2` for every connection and silent `curl` as long as there are no errors

## usage

`touch` two files `test_suite.sh` and `.github/workflows/ci.yml` as below
### `test_suite.sh`

source `bashert.sh` from a local copy or via the network, then define test cases with simple `bash` function declarations making use of the provided assertion helpers, fx:

```bash
source <(curl -sSf https://raw.githubusercontent.com/chiefbiiko/bashert/v1.1.0/bashert.sh)

test_users_list_200() {
  printf "test_users_list_200\n"

  resp_head=$(mktemp)
  resp_body=$(mktemp)

  lurc \
    -X GET \
    -D $resp_head \
    https://jsonplaceholder.typicode.com/users \
  > $resp_body

  assert_status $resp_head 200

  count=$(jq length $resp_body)

  assert_gt $count 0

  id=$(jq -r '.[0].id' $resp_body)
  username="$(jq -r '.[0].username' $resp_body)"

  assert_equal $id 1
  assert_match "$username" '^[a-zA-Z0-9_-]+$'
}
```

> `source`ing from a url like above only works on `ubuntu` runners

### `.github/workflows/ci.yml`

1. source your custom `test_suite.sh`
2. call your `bash` test case functions

```bash
    steps:
      - uses: actions/checkout@v2.3.4
      - run: |
          source ./test_suite.sh
          test_users_list_200
```

> obviously, this needs 2 run in `bash` and you probly also want tools like `curl` and `jq` available in that shell - fortunately, when using github actions `ubuntu-*` and `macos-*` runners we get `curl` and `jq` preinstalled amongst other things

## license

[MIT](./LICENSE)