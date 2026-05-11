# comp-data

This repository contains a collection of common datasets for testing lossless compression.

## Datasets

For each dataset, individual files were compressed using `xz` utility.

| Corpus        | Compressed size | Decompressed size | Path                                                     | URL                                                      |
|---------------|-----------------|-------------------|----------------------------------------------------------|----------------------------------------------------------|
| Artificial    | 88K             | 304K              | [./compressed/artificial](./compressed/artificial)       | <https://corpus.canterbury.ac.nz/descriptions/#artificl> |
| Calgary       | 916K            | 3.1M              | [./compressed/calgary](./compressed/calgary)             | <https://corpus.canterbury.ac.nz/descriptions/#calgary>  |
| Canterbury    | 500K            | 2.7M              | [./compressed/canterbury](./compressed/canterbury)       |<https://corpus.canterbury.ac.nz/descriptions/#cantrbry>  |
| Large         | 2.5M            | 11M               | [./compressed/large](./compressed/large)                 |<https://corpus.canterbury.ac.nz/descriptions/#large>     |
| Large Text    | 245M            | 1.1G              | [./compressed/large_text](./compressed/large_text)       | <https://mattmahoney.net/dc/textdata.html>               |
| Miscellaneous | 428K            | 980K              | [./compressed/miscellaneous](./compressed/miscellaneous) | <https://corpus.canterbury.ac.nz/descriptions/#misc>     |
| Neuro         | 22M             | 55M               | [./compressed/neuro](./compressed/neuro)                 | <https://github.com/neurolabusc/zlib-bench>              |
| Silesia       | 47M             | 203M              | [./compressed/silesia](./compressed/silesia)             | <https://sun.aei.polsl.pl/~sdeor/index.php?page=silesia> |
| Snappy        | 868K            | 2.9M              | [./compressed/snappy](./compressed/snappy)               | <https://github.com/google/snappy>                       |
| Squash        | 228M            | 756M              | [./compressed/squash](./compressed/squash)               | <https://github.com/nemequ/squash-corpus>                |

## Requirements

* [Git Large File Storage](https://docs.github.com/en/repositories/working-with-files/managing-large-files/installing-git-large-file-storage): to access the actual dataset files
* [XZ Utils](https://github.com/tukaani-project/xz): for decompressing the datasets using `xz`

## Usage

For simple usage, you can decompress all datasets by running the following:
```bash
./decompress.sh -a
```
After that, datasets with decompressed files can be found at `./decompressed/`.

Additionaly, you can merge each decompressed dataset into a single file by running the following:
```bash
./merge.sh -a
```
Resulting files will be stored at `./merged/`.

### Decompressing datasets

```console
$ ./decompress.sh
Decompress datasets using xz utility

Usage: ./decompress.sh [-a|--all] [-h|--help]
                       [-d|--dataset-dir <path>] [-o|--output-dir <path>]
                       {<dataset>}
Options:
   -a|--all           Decompress all datasets from --dataset-dir
   -h|--help          Print this help
   -d|--dataset-dir   Directory to find datasets for iterative decompression
                      (default: ./compressed)
   -o|--output-dir    Directory to which decompressed datasets will be saved
                      (default: ./decompressed)
```
The file search depth both for the datasets directory and individual datasets is fixed to 1.

### Merging datasets

```console
$ ./merge.sh
Merge datasets into singular large files

Usage: ./merge.sh [-a|--all] [-h|--help]
                  [-d|--dataset-dir <path>] [-o|--output-dir <path>]
                  {<dataset>}
Options:
   -a|--all           Merge all datasets from --dataset-dir
   -h|--help          Print this help
   -d|--dataset-dir   Directory to find datasets for iterative merging
                      (default: ./decompressed)
   -o|--output-dir    Directory to which merged datasets will be saved
                      (default: ./merged)
```
Before merging, the files are sorted in case-insensitive alphanumeric order.

### Examples

* Decompress all datasets and save to `~/my_datasets`:
```bash
./decompress -a -o ~/my_datasets
```
* Decompress Canterbury and Calgary:
```bash
./decompress compressed/canterbury compressed/calgary
```
* Merge all datasets from `~/my_datasets`:
```bash
./merge -a -d ~/my_datasets
```
* Merge decompressed Silesia and save to `~/my_datasets`:
```bash
./merge -o ~/my_datasets decompressed/silesia
```

## License

The selection and arrangement of datasets in this collection, along with additional scripts created by repository maintainer,
is dedicated to the public domain under the CC0 1.0 Universal license.

I don't claim any of the datasets/corpora provided. The individual datasets remain the property of their respective authors,
and are subject to their own original licenses. For any licensing information, please see the sources in the [Datasets](#datasets) section.
