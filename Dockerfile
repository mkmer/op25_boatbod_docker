FROM ubuntu:22.04
ARG TZ=America/Detroit
RUN cd / && echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN export DEBIAN_FRONTEND=noninteractive && \
    export TZ=$TZ && \
    apt-get update && apt-get install -y tzdata apt-utils && \
    dpkg-reconfigure --frontend noninteractive tzdata
RUN apt-get -y dist-upgrade && apt-get update
RUN apt-get install -y git gnuradio gnuradio-dev gr-osmosdr libusb-1.0-0-dev libuhd-dev  \
                       libhackrf-dev libitpp-dev libpcap-dev cmake git swig \
                       build-essential pkg-config doxygen python3-numpy python3-waitress \
                       python3-requests python3-flask python3-pip liborc-dev alsa-utils gnuplot-x11 \
                       debhelper python3-pyramid sudo libncurses5-dev libncursesw5-dev

RUN git clone https://github.com/rtlsdrblog/rtl-sdr-blog && \
                       cd rtl-sdr-blog && \
                       dpkg-buildpackage -b --no-sign && \
                       cd .. && \
                       dpkg -i librtlsdr0_*.deb && \
                       dpkg -i librtlsdr-dev_*.deb && \
                       dpkg -i rtl-sdr_*.deb
# Make sudo dummy replacement, so we don't weaken docker security
RUN echo "#!/bin/bash\n\$@" > /usr/bin/sudo
RUN chmod +x /usr/bin/sudo

RUN git clone https://github.com/boatbod/op25.git \
    && cd ./op25 \ 
    && ./install.sh
    
COPY ./asound.conf /etc/asound.conf
