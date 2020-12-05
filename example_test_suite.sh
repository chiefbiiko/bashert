test_myresource_list_200() {
  printf "test_myresource_list_200\n"

  resp_head="$(mktemp)"
  resp_body="$(mktemp)"

  lurc \
    -X GET \
    -D "$resp_head" \
    "https://my.api.com/myresource"

  assert_status "$resp_head" 200

  count=$(jq '.[] | length' "$resp_body")

  assert_gt $count 0

  name="$(jq -r '.[0].name' "$resp_body")"
  nick="$(jq -r '.[0].nick' "$resp_body")"

  assert_equal "$name" "lamar"
  assert_match "$nick" '^[a-zA-Z0-9_-]+$'
}