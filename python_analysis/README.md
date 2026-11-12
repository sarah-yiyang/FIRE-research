# HAIID analysis (Python)

Python pipeline for the FIRE198 Group 2 analysis of the HAIID dataset (Vodrahalli et al.): data audit, descriptives, the six planned methods, hypothesis tests H1-H5, extra analyses, 16 robustness variants and 13 figures.

Data: download haiid_dataset.csv from https://github.com/kailas-v/human-ai-interactions (MIT license).

Run everything:

    HAIID_CSV=/path/to/haiid_dataset.csv HAIID_OUT=/path/to/output bash run_all.sh

Needs Python 3 with pandas, numpy, scipy, statsmodels, scikit-learn and matplotlib. Scripts run in order s1 to s6; hload, hcommon, hdesign and hmodels are shared helpers.
