#! /bin/bash

set -euo pipefail

DATASET_DIR_DEFAULT=./compressed
OUTPUT_DIR_DEFAULT=./decompressed

print_help() {
    printf \
"Decompress datasets using xz utility

Usage: ./decompress.sh [-a|--all] [-h|--help]
                       [-d|--dataset-dir <path>] [-o|--output-dir <path>]
                       {<dataset>}
Options:
   -a|--all           Decompress all datasets from --dataset-dir
   -h|--help          Print this help
   -d|--dataset-dir   Directory to find datasets for iterative decompression
                      (default: %s)
   -o|--output-dir    Directory to which decompressed datasets will be saved
                      (default: %s)
" "$DATASET_DIR_DEFAULT" "$OUTPUT_DIR_DEFAULT"
}

decompress_dataset() {
    local dataset_path="$1"
    local output_dir="$2"
    local dataset_name
    dataset_name=$(basename "$dataset_path")
    local decompressed_dir="$output_dir"/"$dataset_name"

    mkdir -p "$decompressed_dir"

    echo "Processing $dataset_name"
    echo "Decompressing files from $dataset_path into $decompressed_dir"

    while IFS= read -r -d "" file; do
        local file_name
        file_name=$(basename "$file")
        local decompressed_file="$decompressed_dir"/${file_name%.*}

        xz -dvcT 0 "$file" > "$decompressed_file"
    done < <(find "$dataset_path" -maxdepth 1 -type f -print0)

    echo "Done!"
}

DATASET_DIR="$DATASET_DIR_DEFAULT"
OUTPUT_DIR="$OUTPUT_DIR_DEFAULT"
DECOMPRESS_ALL=0
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
        DECOMPRESS_ALL=1
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

if [ "$DECOMPRESS_ALL" -eq 1 ]; then
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

    decompress_dataset "$dataset" "$OUTPUT_DIR"
done
