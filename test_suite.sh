source ./bashert.sh

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

test_assert_files_equal() {
  printf "test_assert_files_equal\n"

  file_a=$(mktemp)
  file_b=$(mktemp)
  file_c=$(mktemp)
  head -c 419 </dev/urandom > $file_a
  cp $file_a $file_b

  assert_files_equal $file_a $file_b
}