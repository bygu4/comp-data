## comp-data

Collection of common datasets for testing lossless compression

### Datasets

| Corpus        | URL                                                      |
|---------------|----------------------------------------------------------|
| Artificial    | <https://corpus.canterbury.ac.nz/descriptions/#artificl> |
| Calgary       | <https://corpus.canterbury.ac.nz/descriptions/#calgary>  |
| Canterbury    | <https://corpus.canterbury.ac.nz/descriptions/#cantrbry> |
| Large         | <https://corpus.canterbury.ac.nz/descriptions/#large>    |
| Miscellaneous | <https://corpus.canterbury.ac.nz/descriptions/#misc>     |
| Neuro         | <https://github.com/neurolabusc/zlib-bench>              |
| Silesia       | <https://sun.aei.polsl.pl/~sdeor/index.php?page=silesia> |
| Snappy        | <https://github.com/google/snappy>                       |

### Merging datasets

Each dataset can be merged into a single large file using this helper script:
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
                      (default: ./dataset)
   -o|--output-dir    Directory to which merged datasets will be saved
                      (default: ./dataset_merged)
```

Examples:
* Merge all datasets and save to `~/my_datasets`
```console
$ ./merge -a -o ~/my_datasets
```
* Merge all datasets from `~/my_datasets`
```console
$ ./merge -a -d ~/my_datasets
```
* Merge Canterbury and Calgary
```console
$ ./merge dataset/canterbury dataset/calgary
```
* Merge Silesia and save to `~/my_datasets`
```console
$ ./merge -o ~/my_datasets dataset/silesia
```

### License

The selection and arrangement of datasets in this collection, along with additional scripts created by repository maintainer,
is dedicated to the public domain under the CC0 1.0 Universal license.

I don't claim any of the datasets/corpora provided. The individual datasets remain the property of their respective authors,
and are subject to their own original licenses. For any licensing information, please see the sources in the [Datasets](#datasets) section.
