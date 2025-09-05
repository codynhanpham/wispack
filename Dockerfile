FROM rocker/rstudio:4

# System dependencies for wispack
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        libcurl4-gnutls-dev \
        curl \
        git \
        libxml2 \
        libxml2-dev \
        libssl-dev \
        r-base-dev \
        libnlopt-dev \
        libnlopt-cxx-dev \
        texlive-latex-base \
        texlive-fonts-recommended \
        texlive-fonts-extra \
        texlive-latex-extra \
        dos2unix
        
# Use bash as default shell instead of sh
RUN ln -sf /bin/bash /bin/sh

# Copy the app over
RUN mkdir /app
RUN mkdir /app/wispack
WORKDIR /app/wispack

# Either copy the current project directory (this will respect .dockerignore)
COPY . /app/wispack
# Or clone from GitHub
# RUN git clone https://github.com/michaelbarkasi/wispack.git /app/wispack

# Ensure scripts have unix line endings
RUN dos2unix *.sh

# Install wispack and its R package dependencies
RUN rm -f ./src/*.o ./src/*.so && \
    rm -rf wispack.Rcheck && \
    rm -f wispack_*.tar.gz && \
    /bin/bash build_install.sh



# To build:
#   docker build -t wispack-rstudio:4.0.0 -t wispack-rstudio -f Dockerfile .
# When updating the base rstudio image, it is best to build this image with the same major version tag, e.g. `rocker/rstudio:4` -> `wispack-rstudio:4.x.x`

# See more about using the base image here: https://github.com/rocker-org/rocker/wiki/Using-the-RStudio-image
# When launching a container, make sure to replace the base image `rocker/rstudio` with this image name: `wispack-rstudio`
# Example:
#   docker run -d -p 8787:8787 -e PASSWORD=<password> --name wispack-rstudio wispack-rstudio
# Then, go to http://localhost:8787 in your browser and login with the default user `rstudio` and the password you set above.
# To add additional users, attach to the running container's shell and use the interactive `adduser <username>` command.
# Inside the RStudio session, set your working directory to `/app/wispack` to access the wispack package files and/or run the demos.