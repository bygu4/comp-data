#! /bin/sh

set -eu

merge_dataset() {
    DATASET_PATH="$1"
    DATASET_NAME=$(basename "$DATASET_PATH")

    DIR_FILES=$(echo "$DATASET_PATH"/files | tr -s "/")
    DIR_MERGED=$(echo "$DATASET_PATH"/merged | tr -s "/")

    MERGED_DATASET_PATH=$(echo "$DIR_MERGED"/"$DATASET_NAME" | tr -s "/")

    echo "Processing $DATASET_NAME"
    echo "Merging files from $DIR_FILES into file $MERGED_DATASET_PATH"

    find "$DIR_FILES" -maxdepth 1 -type f -print0 | sort -z | xargs -0 cat \
        > "$MERGED_DATASET_PATH"

    echo "Done!"
}

while [ $# -gt 0 ]; do
    case $1 in
    -a|--all)
        find . -maxdepth 1 -type d -not -name ".*" -print \
                | while IFS= read -r dataset; do
            merge_dataset "$dataset"
        done
        exit 0
        ;;
    *)
        merge_dataset "$1"
        shift
        ;;
    esac
done
