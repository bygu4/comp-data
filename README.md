## comp-data

Datasets for testing lossless compression

### Datasets
* [Silesia](https://sun.aei.polsl.pl/~sdeor/index.php?page=silesia)
* [Canterbury](https://corpus.canterbury.ac.nz/descriptions/#cantrbry)
* [Large](https://corpus.canterbury.ac.nz/descriptions/#large)
* [Calgary](https://corpus.canterbury.ac.nz/descriptions/#calgary)

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
