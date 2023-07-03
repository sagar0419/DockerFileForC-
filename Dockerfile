FROM ubuntu:latest
 
# ARG for non-root user
ARG USERNAME=sagar
ARG USER_UID=1001
ARG USER_GID=$USER_UID

# Setting WorkDir
WORKDIR /app

# Adding non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
# Remove "gdb" if debug is not required
    &&  apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    gdb \
    && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the source code
COPY . .

# Build C++
RUN cmake . \
  && make

# Changing User
USER $USERNAME

# Replace '<helo>' with the actual name of your executable
CMD ["./helo"]