# syntax=docker/dockerfile:1

FROM ubuntu:20.04

ARG proj_name=apriltag_generation
ARG docker_build_gid=1000
ARG docker_build_uid=1000
ARG docker_build_user=apriltag_generation
ARG CI_ENABLED=false
ARG GITHUB_TOKEN=

SHELL ["/bin/bash", "-c"]

RUN echo $'Acquire::http::Pipeline-Depth 0;\n\
	Acquire::http::No-Cache true;\n\
	Acquire::BrokenProxy    true;\n'\
    >> /etc/apt/apt.conf.d/90fix-hashsum-mismatch

# leave the apt index intact after this.
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get update -o Acquire::CompressionTypes::Order::=gz && \
    apt-get install --no-install-recommends --yes \
        ant \
        default-jre \
        default-jdk \
        git \
        vim && \
    rm -rf /var/lib/apt/lists/*

# create a user/group which matches the invoking user.
RUN groupadd --gid $docker_build_gid $docker_build_user && \
    useradd --create-home --gid $docker_build_gid --uid $docker_build_uid --shell /bin/bash --groups sudo $docker_build_user && \
    echo "$docker_build_user:apriltag_generation" | chpasswd && \
    echo "root:apriltag_generation" | chpasswd && \
    echo 'set -o vi' > /home/$docker_build_user/.bashrc && \
    mkdir -p /opt/$proj_name/{source,build} && \
    chown -R $docker_build_user:$docker_build_user /opt/$proj_name /opt/$proj_name/{source,build}

#COPY . /opt/$proj_name/source
#RUN chown $docker_build_user:$docker_build_user --recursive /opt/$proj_name/source

WORKDIR /opt/$proj_name/source/
USER $docker_build_user

RUN git clone -v --progress  https://github.com/QuentinTorg/apriltag-generation.git apriltag-generation && \
    cd apriltag-generation && \
    ant

WORKDIR /opt/$proj_name/source/apriltag-generation

ENTRYPOINT ["java", "-cp", "april.jar", "april.tag.TagFamilyGenerator"]
CMD ["standard_6", "7", "/media/host/"]
