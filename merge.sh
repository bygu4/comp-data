#! /bin/bash

set -euo pipefail

DATASET_DIR="$PWD"/dataset
DATASET_MERGED_DIR="$PWD"/dataset_merged

print_help() {
    printf \
"Merge datasets into singular large files

Usage: ./merge.sh [-a|--all] [-h|--help] [-o|--output-dir <path>] {<dataset>}
Options:
   -a|--all          Merge all datasets from ./dataset directory
   -h|--help         Print this help
   -o|--output-dir   Directory to which merged datasets will be saved
"
}

merge_dataset() {
    local dataset_path="$1"
    local output_dir="$2"
    local dataset_name
    dataset_name=$(basename "$dataset_path")
    local output_file="$output_dir"/"$dataset_name"

    echo "Processing $dataset_name"
    echo "Merging files from $dataset_path into file $output_file"

    find "$dataset_path" -maxdepth 1 -type f -print0 | sort -z | xargs -0 cat \
        > "$output_file"

    echo "Done!"
}

OUTPUT_DIR="$DATASET_MERGED_DIR"
MERGE_ALL=0
TARGETS=()

if [ "$#" -eq 0 ]; then
    print_help
    exit 1
fi

while [ "$#" -gt 0 ]; do
    case "$1" in
    -h|--help)
        print_help
        exit 0
        ;;
    -o|--output-dir)
        OUTPUT_DIR="$2"
        shift
        shift
        ;;
    -a|--all)
        MERGE_ALL=1
        shift
        ;;
    *)
        TARGETS+=("$1")
        shift
        ;;
    esac
done

if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Path doesn't exist: $OUTPUT_DIR"
    exit 1
fi

if [ "$MERGE_ALL" -eq 1 ]; then
        TARGETS=()

        while IFS= read -r -d "" dataset; do
            TARGETS+=("$dataset")
        done < <(find "$DATASET_DIR" -mindepth 1 -maxdepth 1 -type d -print0)
fi

if [ "${#TARGETS[@]}" -eq 0 ]; then
    echo "No targets specified"
    exit 1
fi

for dataset in "${TARGETS[@]}"; do
    if [ ! -d "$dataset" ]; then
        echo "Path doesn't exist: $dataset"
        exit 1
    fi

    merge_dataset "$dataset" "$OUTPUT_DIR"
done
