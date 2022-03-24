for row in $(gh repo list withriley --no-archived -L 100 --json name | jq -r '.[] | @base64'); do
    _jq() {
        echo ${row} | base64 --decode | jq -r ${1}
    }
    echo "Configuring PRs for $(_jq '.name'):"
    for pr in $(gh pr list --repo withriley/$(_jq '.name') --json url | jq -r '.[] | @base64'); do
        _jq() {
            echo ${pr} | base64 --decode | jq -r ${1}
        }
        echo "Merging PR: $(_jq '.url')"
        gh pr merge $(_jq '.url') -m --admin
    done
    echo "----------------------------------"
done
