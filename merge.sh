#! /bin/bash

set -euo pipefail

DATASET_DIR_DEFAULT=./decompressed
OUTPUT_DIR_DEFAULT=./merged

print_help() {
    printf \
"Merge datasets into singular large files

Usage: ./merge.sh [-a|--all] [-h|--help]
                  [-d|--dataset-dir <path>] [-o|--output-dir <path>]
                  {<dataset>}
Options:
   -a|--all           Merge all datasets from --dataset-dir
   -h|--help          Print this help
   -d|--dataset-dir   Directory to find datasets for iterative merging
                      (default: %s)
   -o|--output-dir    Directory to which merged datasets will be saved
                      (default: %s)
" "$DATASET_DIR_DEFAULT" "$OUTPUT_DIR_DEFAULT"
}

merge_dataset() {
    local dataset_path="$1"
    local output_dir="$2"
    local dataset_name
    dataset_name=$(basename "$dataset_path")
    local merged_file="$output_dir"/"$dataset_name"

    echo "Processing $dataset_name"
    echo "Merging files from $dataset_path into file $merged_file"

    true > "$merged_file"

    while IFS= read -r -d "" file; do
        echo "$file"

        cat "$file" >> "$merged_file"
    done < <(find "$dataset_path" -maxdepth 1 -type f -print0 | sort -zfV)

    echo "Done!"
}

DATASET_DIR="$DATASET_DIR_DEFAULT"
OUTPUT_DIR="$OUTPUT_DIR_DEFAULT"
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
    -d|--dataset-dir)
        DATASET_DIR="$2"
        shift
        shift
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

if [ ! -d "$DATASET_DIR" ]; then
    echo "Path doesn't exist: $DATASET_DIR"
    exit 1
fi

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
