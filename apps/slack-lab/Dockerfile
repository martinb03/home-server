FROM vbatts/slackware:14.2


# Locale fix for slackpkg warnings
ENV LC_ALL=C

COPY netreset.sh /usr/local/bin/netreset.sh
RUN chmod +x /usr/local/bin/netreset.sh

# Add local packages (they’ll be included in the build context)
COPY packages/ /tmp/

# Sanity check
RUN ls -lh /tmp

# Install everything
RUN cd /tmp && installpkg *.txz && rm -f /tmp/*.txz

# --- Create Quagga runtime users/groups ---
RUN groupadd -g 92 quagga && \
    groupadd -g 85 quaggavt && \
    useradd -u 92 -g quagga -d /var/run/quagga -s /sbin/nologin quagga && \
    usermod -a -G quaggavt quagga && \
    mkdir -p /var/run/quagga /var/log/quagga /etc/quagga && \
    chown -R quagga:quagga /var/run/quagga /var/log/quagga /etc/quagga

# --- To make 'nano' usable ---
ENV TERM=xterm
RUN echo "export TERM=xterm" >> /etc/profile

# --- Run the script automatically on container start ---
CMD ["/bin/bash", "-c", "/usr/local/bin/netreset.sh && exec /bin/bash"]
