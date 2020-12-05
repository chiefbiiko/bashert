test_users_list_200() {
  printf "test_users_list_200\n"

  resp_head="$(mktemp)"
  resp_body="$(mktemp)"

  lurc \
    -X GET \
    -D "$resp_head" \
    "https://jsonplaceholder.typicode.com/users"

  assert_status "$resp_head" 200

  count=$(jq '.[] | length' "$resp_body")

  assert_gt $count 0

  id="$(jq -r '.[0].id' "$resp_body")"
  name="$(jq -r '.[0].name' "$resp_body")"

  assert_equal "$id" "1"
  assert_match "$name" '^[a-zA-Z0-9_- ]+$'
}