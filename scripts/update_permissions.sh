for row in $(gh repo list withriley --no-archived -L 100 --json name | jq -r '.[] | @base64'); do
    _jq() {
        echo ${row} | base64 --decode | jq -r ${1}
    }
    echo "Updating permissions for $(_jq '.name'):"
    gh api -X PUT /orgs/withriley/teams/riley-codeowners/repos/withriley/$(_jq '.name') -F "permission=push" --silent
    gh api -X PUT /orgs/withriley/teams/riley-admins/repos/withriley/$(_jq '.name') -F "permission=admin" --silent
done

