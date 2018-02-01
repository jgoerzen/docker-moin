# Docker image for MoinMoin (moin) Wiki

This image is a moinmoin wiki in a Debian container.

# Feature List

 - Moin from Debian, including Xapian search, etc.
 - Fast mod_wsgi support
 - Based on my
   [proxied-app-apache](https://github.com/jgoerzen/docker-apache-proxy),
   inheriting its features:
   - Correct source IP logging
   - Good integration with my reverse-proxy-apache and its automatic
     letsencrypt SSL cert handling
   - automated security patches for the OS, openssl, and Apache
   - Real init with zombie process reaping
   - Clean shutdown support
   - See the above URL for details.
 - Support for automating the process of requesting and updating your
   SSL certificates from letsencrypt, making the process completely
   transparent and automatic - should you wish to use it.
 - Low memory requirements and efficient.
 - Based on Apache, so it's what you (probably) already know.

# Use

Start with `FROM jgoerzen/moin`.

If using behind a reverse proxy, set the environment variable
`PROXYCLIENT_AUTHORIZED` to the IP or IP+netmask of the authorized
proxies.  This step is not necessary if you are listening directly.

Drop files in /etc/apache2/sites-avaialable, looking something like
this:

    <VirtualHost *:80>
    ServerName www.example.com
    Include sites-available/moin-common-sites
    </VirtualHost>

Don't forget to `a2ensite` each one in your donfig.

Set up the config files in /etc/moin, especially farmconfig, as
documented in `/usr/share/doc/python-moinmoin`.

Your moin installation directories, wherever you put them, should be
owned by the user `www-data`.  The moin `url_prefix_static` should be
`/moin_static` in the default configuration.


## Final note

Finally, make sure to end your Dockerfile with `CMD ["/usr/local/bin/boot-debian-base"]`.


# Recommended Parameters

I recommend you to run your containers with:

`--stop-signal=SIGPWR -t -d --net=whatever`

# Recommended Volumes

I recommend that you add `VOLUME ["/var/log/apache2"]` to your
Dockerfile.  When rebuilding and restarting your containers, use a
sequence such as:

    docker stop web
    docker rename web web.old
    docker run <<parameters>> --volumes-from=web.old  --name-web ....
    docker rm web.old
   
This will let your logs persist, and will avoid unnecessary calls to
letsencrypt to obtain new certs.  The latter is important to avoid
false expiration emails and hitting their rate limiting.

Of course, you will also want your moin directory, wherever you put
it, to be persistent.  Most would probably mount it as a volume from
the host machine.

# Copyright

Docker scripts, etc. are
Copyright (c) 2018 John Goerzen
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:
1. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in the
   documentation and/or other materials provided with the distribution.
3. Neither the name of the University nor the names of its contributors
   may be used to endorse or promote products derived from this software
   without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHORS AND CONTRIBUTORS ``AS IS'' AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
SUCH DAMAGE.

Additional software copyrights as noted.

# See Also

 - [Github page](https://github.com/jgoerzen/docker-apache-moin)
 - [Docker hub page: jgoerzen/moin](https://hub.docker.com/r/jgoerzen/moin]

