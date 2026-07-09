#!/bin/bash

# On Linux, system dependencies are roughly:
# - build-essential, r-base-dev, libxml2, and libxml2-dev for roxygen2 and package compilation
# - libnlopt-dev (or libnlopt-cxx-dev) for Rcpp, RcppEigen, and StanHeaders
# - libuv1-dev for fs
# - libhdf5-dev for hdf5r
# - libcurl4-gnutls-dev, libssl-dev, and curl for package downloads and HTTPS support
# - texlive-latex-base, texlive-fonts-recommended, texlive-fonts-extra, and texlive-latex-extra for PDF documentation
# - git and dos2unix for repository/bootstrap tooling
# Additionally, for PDF documentation generation, pdflatex should be installed
#
# sudo apt install build-essential libcurl4-gnutls-dev curl git libuv1-dev libhdf5-dev libxml2 libxml2-dev libssl-dev r-base-dev libnlopt-dev libnlopt-cxx-dev texlive-latex-base texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra dos2unix



set -e  # Exit immediately if a command fails

# Step 1: Install R dependencies
Rscript "./requirements.R"

# Step 2: Compile Rcpp attributes
echo "Running Rcpp::compileAttributes()..."
Rscript -e "Rcpp::compileAttributes()"

# Step 3: Generate documentation
echo "Running roxygen2::roxygenise()..."
Rscript -e "roxygen2::roxygenise()"

# Step 4: Get package name and version from DESCRIPTION
PKG_NAME=$(grep -E "^Package:" DESCRIPTION | awk '{print $2}')
PKG_VERSION=$(grep -E "^Version:" DESCRIPTION | awk '{print $2}')
TARBALL="${PKG_NAME}_${PKG_VERSION}.tar.gz"

# Step 5: Build tarball
echo "Building tarball..."
R CMD build .

# Step 6: Run checks
echo "Running R CMD check..."
R CMD check "$TARBALL"

# Step 7: Install the package
echo "Installing the package..."
R CMD INSTALL --preclean .

echo "Done!"
