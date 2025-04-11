# check param
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <LeetCode-ID> <Problem-Title> <Difficulty>"
  exit 1
fi

LEETCODE_ID=$1
PROBLEM_TITLE=$2
DIFFICULTY=$3
DATE=$(date +%Y-%m-%d)
TARGET_DIR="content/leetcode/LeetCode-${LEETCODE_ID}"

# check exists path
if [ -d "$TARGET_DIR" ]; then
  echo "Error: Problem already solved before."
  exit 1
fi

mkdir -p "$TARGET_DIR"

sed "s/{{DATE}}/$DATE/g; s/XXXX/$LEETCODE_ID/g; s/Problem Title/$PROBLEM_TITLE/g; s/difficulty/$DIFFICULTY/g" ./templates/leetcode/template.en.md > "$TARGET_DIR/index.en.md"

sed "s/{{DATE}}/$DATE/g; s/XXXX/$LEETCODE_ID/g; s/Problem Title/$PROBLEM_TITLE/g; s/difficulty/$DIFFICULTY/g" ./templates/leetcode/template.zh-tw.md > "$TARGET_DIR/index.zh-tw.md"

echo "Templates generated successfully in $TARGET_DIR"