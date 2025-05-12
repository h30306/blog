# check param
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <Algorithm>"
  exit 1
fi

ALGORITHM=$1
ALGORITHM_DASH=$(echo "$ALGORITHM" | tr ' ' '-')
DATE=$(date +%Y-%m-%d)
TARGET_DIR="content/algorithm/${ALGORITHM_DASH}"

# check exists path
if [ -d "$TARGET_DIR" ]; then
  echo "Error: Problem already solved before."
  exit 1
fi

mkdir -p "$TARGET_DIR"

sed "s/{{DATE}}/$DATE/g; s/XXXX/$ALGORITHM/g" ./templates/algorithm/template.en.md > "$TARGET_DIR/index.en.md"

sed "s/{{DATE}}/$DATE/g; s/XXXX/$ALGORITHM/g" ./templates/algorithm/template.zh-tw.md > "$TARGET_DIR/index.zh-tw.md"

cp ./templates/algorithm/featured.png "$TARGET_DIR/featured.png"

echo "Templates generated successfully in $TARGET_DIR"