number=${{ env.number }}
issues=$(gh issue list --search 'Unable to play video' --json number,title,url | jq --arg num "$number" -r 'map(select(.number != ($num | tonumber))) | .[] | "- [" + .title + "](" + .url + ")"')

echo -e "Thanks for reporting @${{ evn.author }}.\nPlease check if this could be a duplicate of one of these issues:\n$issues"
