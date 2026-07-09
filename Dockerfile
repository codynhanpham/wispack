FROM rocker/rstudio:4

# System dependencies for wispack
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        libcurl4-gnutls-dev \
        curl \
        git \
        libuv1-dev \
        libhdf5-dev \
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

# The root /app folder should be accessible to everyone if they want to add new projects here
RUN chmod 777 /app

# If you want the /app/wispack directory to be owned and writable by everyone, uncomment the following line:
# RUN chmod -R 777 /app/wispack
# You can always set the permissions for the running container with `docker exec -it <container_name> bash` and then `chmod -R 777 /app/wispack`


# ---------- END OF DOCKERFILE ---------- #


# To build:
#   docker build -t wispack-rstudio:4.2.5 -t wispack-rstudio -f Dockerfile .
# When updating the base rstudio image, it is best to build this image with the same major version tag, e.g. `rocker/rstudio:4` -> `wispack-rstudio:4.x.x`

# See more about using the base image here: https://github.com/rocker-org/rocker/wiki/Using-the-RStudio-image
# When launching a container, make sure to replace the base image `rocker/rstudio` with this image name: `wispack-rstudio`
# Example:
#   docker run -d -p 8787:8787 -e PASSWORD=<password> --name wispack-rstudio wispack-rstudio
# Then, go to http://localhost:8787 in your browser and login with the default user `rstudio` and the password you set above.
# To add additional users, attach to the running container's shell and use the interactive `adduser <username>` command.
# Inside the RStudio session, set your working directory to `/app/wispack` to access the wispack package files and/or run the demos.

# To mount a local directory (say, a different project that uses wispack) to the `/app/your-project` inside the container, use:
#   docker run -d -p 8787:8787 -e PASSWORD=<password> -v /path/to/your/project:/app/your-project --name wispack-rstudio wispack-rstudio

# Alternatively, you can navigate to the local directory in your terminal first (before starting the container) and then use:
#   docker run -d -p 8787:8787 -e PASSWORD=<password> -v .:/app/your-project --name wispack-rstudio wispack-rstudio
# Then, inside the RStudio session, set your working directory to `/app/your-project` to access your project files.
# Updates made inside of the container will be reflected in your local directory and vice versa.