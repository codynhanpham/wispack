
# Introduction

Wispack (pronounced "wisp package" or "wisp pack") is an R package for testing for between-group effects on spatial variation in spatial transcriptomics data. Unlike mere SVG testing (spatially variable gene) which only involves testing for spatial variation of gene expression within a group, wispack allows for testing whether a factor such as age or rearing conditions has a nonzero effect on spatial variation between groups differing on that factor.

Wispack performs this testing by first using change-point detection to find spatial variation in samples, then fitting a nonlinear mixed-effect model to the detected change points. The core of the nonlinear model is a parameterization of the found change-points as inflections in logistic functions representing gradients of gene expression change. Multiple change-points are handled by summing the component logistic functions into a "poly-sigmoid" function. Fixed effects (such as age or rearing conditions) are then modeled as effects on the underlying logistic parameters. Random (within group) effects are modeled as further nonlinear warping of the poly-sigmoid. Significance testing is performed on the effects through either bootstrapping or MCMC resampling.

Preprint: https://doi.org/10.1101/2025.06.11.659209
 
Copyright (C) 2025, Michael Barkasi
barkasi@wustl.edu

![(Top:) Horizontal slice from mouse pup with right sensorimotor cortex and RORB spots as measured by MERFISH. (Bottom:) wisp model fit to this data showing RORB upregulated in L4 with effects from age and hemisphere.](reference/figures/fig_Rorb_stacked.png)

# Installation 

1. Clone and `cd` into this git repo
2. Make `build_install.sh` executable by running `chmod +x build_install.sh` in bash terminal  
3. In terminal, run `./build_install.sh` to build and install the package  
4. To ensure a clean start, run:  

```bash
rm -f src/*.o src/*.so  
rm -rf wispack.Rcheck  
rm -f wispack_*.tar.gz  
./build_install.sh
```

## Linux

On Linux (Ubuntu/Debian), additional system dependencies are required *before* the building process: 
- `libxml2` for roxygen2
- `r-base-dev`, `libnlopt-dev` (or `libnlopt-cxx-dev`) for Rcpp, RcppEigen, and StanHeaders

For PDF documentation generation, `pdflatex` should also be installed

```bash
sudo apt install \
    libxml2 \
    r-base-dev \
    libnlopt-dev \
    libnlopt-cxx-dev \
    texlive-latex-base \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-latex-extra
```

# Demos

```R
demo("quick_start", package = "wispack")  
demo("full_options", package = "wispack")
```
