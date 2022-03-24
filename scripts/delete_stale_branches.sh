for row in $(gh repo list withriley --no-archived -L 100 --json name | jq -r '.[] | @base64'); do
    _jq() {
        echo ${row} | base64 --decode | jq -r ${1}
    }
    repo=$(echo "$(_jq '.name')")
    echo "Deleting stale branches for $repo:"
    for branch in $(gh api -X GET /repos/withriley/$(_jq '.name')/branches -q '.[] | select(.name | startswith("bot/")).name' --paginate); do
        echo $branch
        gh api -X DELETE /repos/withriley/$repo/git/refs/heads/$branch --silent
    done
done