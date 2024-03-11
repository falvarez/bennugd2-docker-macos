FROM bennugd2

RUN mkdir -p /opt/osxcross

WORKDIR /opt

RUN git clone https://github.com/tpoechtrager/osxcross.git

WORKDIR /opt/osxcross

RUN wget -nc https://github.com/joseluisq/macosx-sdks/releases/download/10.10/MacOSX10.10.sdk.tar.xz

RUN mv MacOSX10.10.sdk.tar.xz tarballs/

RUN ./tools/get_dependencies.sh

RUN UNATTENDED=yes ./build.sh

RUN export OSX_VERSION_MIN=10.7 \
    && export PATH=/opt/osxcross/target/bin:$PATH \
    && export SDKROOT=/opt/osxcross/target/SDK/MacOSX10.10.sdk \
    && export MACOSX_DEPLOYMENT_TARGET=10.10 \ 
    && UNATTENDED=yes osxcross-macports install libsdl2_image libsdl2_mixer libsdl2

WORKDIR /BennuGD2/vendor

RUN export OSX_VERSION_MIN=10.7 \
    && export PATH=/opt/osxcross/target/bin:$PATH \
    && export SDKROOT=/opt/osxcross/target/SDK/MacOSX10.10.sdk \
    && export MACOSX_DEPLOYMENT_TARGET=10.10 \ 
    && ./build-sdl-gpu.sh macosx clean # @TODO keep environment

WORKDIR /BennuGD2

RUN export OSX_VERSION_MIN=10.7 \
    && export PATH=/opt/osxcross/target/bin:$PATH \
    && export SDKROOT=/opt/osxcross/target/SDK/MacOSX10.10.sdk \
    && export MACOSX_DEPLOYMENT_TARGET=10.10 \ 
    && ./build.sh macosx clean # @TODO keep environment

ENTRYPOINT ["bash"]

CMD ["-i"]

# Build: docker build -f Dockerfile.mac -t bennugd2mac .
# Usage: docker run -it bennugd2mac