FROM php:5.6-apache

RUN set -ex \
    && buildDeps=' \
    libjpeg62-turbo-dev \
    libpng12-dev \
    ' \
    && apt-get update && apt-get install -y --no-install-recommends $buildDeps unzip && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd \
        --with-jpeg-dir=/usr \
        --with-png-dir=/usr \
    && docker-php-ext-install -j "$(nproc)" gd mbstring mysqli \
    && apt-mark manual \
        libjpeg62-turbo \
    && apt-get purge -y --auto-remove $buildDeps

ENV ORPM_VERSION 4.2
ENV ORPM_MD5 4e7ce9bdb2d3e441d5b02c990876e141

RUN curl -fSL "https://cdn.bigprof.com/appgini-open-source-apps/online-rental-property-manager-${ORPM_VERSION}.zip" -o orpm.zip \
    && echo "${ORPM_MD5} *orpm.zip" | md5sum -c - \
    && unzip -a orpm.zip \
    && rm orpm.zip \
    && mv "online-rental-property-manager-${ORPM_VERSION}"/* . \
    && chown -R www-data:www-data images
