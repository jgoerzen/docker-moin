FROM jgoerzen/proxied-app-apache:buster

# fckeditor is no longer in Debian but required for proper operation.  Extract
# it from upstream.

RUN mv /usr/sbin/policy-rc.d.disabled /usr/sbin/policy-rc.d && \
    apt-get update && \
    apt-get -y -u dist-upgrade && \
    apt-get -y --no-install-recommends install python-moinmoin wamerican \
            antiword catdoc poppler-utils python-xapian  libapache2-mod-wsgi python-tz python-flup python-recaptcha && \
    apt-get clean && rm -rf /var/lib/apt/lists/*  && /usr/local/bin/docker-wipelogs && \
    mv /usr/sbin/policy-rc.d /usr/sbin/policy-rc.d.disabled

RUN cd /tmp && \
    curl -s -o /tmp/moin.tar.gz http://static.moinmo.in/files/moin-1.9.10.tar.gz && \
    echo 4a264418e886082abd457c26991f4a8f4847cd1a2ffc11e10d66231da8a5053c  moin.tar.gz | sha256sum -c && \ 
    mkdir moin && \
    cd /tmp/moin && \
    tar -zxf /tmp/moin.tar.gz && \
    cp -r /tmp/moin/moin-*/MoinMoin/web/static/htdocs/applets/FCKeditor /usr/local/fckeditor && \
    chmod -R go-w /usr/local/fckeditor && \
    chown -R root:root /usr/local/fckeditor && \
    cd / && \
    rm -r /tmp/moin.tar.gz /tmp/moin 

COPY conf-available/ /etc/apache2/conf-available/
COPY sites-available/ /etc/apache2/sites-available/

RUN a2enmod wsgi && \
    a2enconf docker-wsgi && \
    sed -i "/# Security -/i    url_prefix_static = '/moin_static'" /etc/moin/farmconfig.py && \
    apache2ctl configtest

CMD ["/usr/local/bin/boot-debian-base"]
