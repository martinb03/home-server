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


# --- Run the script automatically on container start ---
CMD ["/bin/bash", "-c", "/usr/local/bin/netreset.sh && exec /bin/bash"]
