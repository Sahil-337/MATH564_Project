# data/

The analysis notebook reads its inputs from this folder:

- `LINTHALL.txt` — full Linthurst dataset, 45 observations with 14 predictors
- `LINTH-5.txt`  — reduced Linthurst dataset, 45 observations with 5 predictors
  (`SAL`, `pH`, `K`, `Na`, `Zn`)

Both files are whitespace-delimited with a header row. Place them here before
running the notebook; the notebook references them as `data/LINTHALL.txt` and
`data/LINTH-5.txt`.
