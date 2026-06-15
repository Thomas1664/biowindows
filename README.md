# biowindows

Conda packages for bioinformatics command-line tools built for Windows.

## Available packages

| Package | Description |
| --------- | ------------- |
| [goalign](https://github.com/evolbioinfo/goalign) | Alignment manipulation tool |
| [gotree](https://github.com/evolbioinfo/gotree) | Phylogenetic tree manipulation tool |
| [iqtree](http://www.iqtree.org/) | Phylogenomic inference tool |
| [muscle](https://www.drive5.com/muscle/) | Multiple sequence aligner |
| [seqkit](https://bioinf.shenwei.me/seqkit/) | FASTA/Q file manipulation toolkit |
| [vsearch](https://github.com/torognes/vsearch) | Versatile open-source tool for metagenomics |

## Installation

Packages are available on the [biowindows](https://anaconda.org/biowindows) Anaconda channel:

```shell
conda install -c biowindows <package>
```

## Building locally

Requires conda with `conda-build` installed.

```shell
conda install conda-build conda-verify
conda build recipes/<package>
```

## License

[MIT](LICENSE)
