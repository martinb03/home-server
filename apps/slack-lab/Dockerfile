FROM vbatts/slackware:14.2
# --- Basic network and editing utilities ---
# Create a minimal /etc/resolv.conf so slackpkg and wget can reach mirrors
RUN mkdir -p /etc && \
    echo "nameserver 1.1.1.1" > /etc/resolv.conf && \
    echo "nameserver 8.8.8.8" >> /etc/resolv.conf

# Install nano and iputils (for ping)
RUN wget http://slackware.uk/slackware/slackware64-14.2/slackware/ap/nano-2.5.3-x86_64-1.txz && \
    installpkg nano-2.5.3-x86_64-1.txz && rm nano-2.5.3-x86_64-1.txz && \
    wget http://slackware.uk/slackware/slackware64-14.2/slackware/n/iputils-s20160308-x86_64-1.txz && \
    installpkg iputils-s20160308-x86_64-1.txz && rm iputils-s20160308-x86_64-1.txz

# Install tcpdump
RUN wget http://slackware.uk/slackware/slackware64-14.2/slackware/n/tcpdump-4.9.0-x86_64-1.txz && \
    installpkg tcpdump-4.9.0-x86_64-1.txz && rm tcpdump-4.9.0-x86_64-1.txz

# --- Quagga (build from SlackBuilds) ---
RUN wget https://slackbuilds.org/slackbuilds/14.2/network/quagga.tar.gz && \
    tar xf quagga.tar.gz && cd quagga && \
    wget ftp://ftp.quagga.net/pub/quagga/quagga-1.2.4.tar.gz && \
    sh quagga.SlackBuild && \
    installpkg /tmp/quagga-1.2.4-x86_64-1_SBo.tgz && \
    cd / && rm -rf quagga quagga.tar.gz

# Locale fix for slackpkg warnings
ENV LC_ALL=C
COPY netreset.sh /usr/local/bin/netreset.sh
RUN chmod +x /usr/local/bin/netreset.sh
