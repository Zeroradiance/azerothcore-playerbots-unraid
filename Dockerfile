# AzerothCore with Playerbots - All-in-One Container for Unraid
FROM ubuntu:22.04

# Set environment variables for Unraid compatibility
ENV DEBIAN_FRONTEND=noninteractive \
    DOCKER_USER=root \
    MYSQL_ROOT_PASSWORD=acore123 \
    AC_REALM_ADDRESS=10.69.1.176 \
    AC_MAX_PLAYERBOTS=500 \
    AC_MIN_PLAYERBOTS=400

# Install all dependencies
RUN apt-get update && apt-get install -y \
    mysql-server \
    mysql-client \
    libmysqlclient21 \
    libreadline8 \
    libssl3 \
    zlib1g \
    libbz2-1.0 \
    supervisor \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create acore user but run as root for Unraid compatibility
RUN groupadd --gid 1000 acore && \
    useradd -d /azerothcore --uid 1000 --gid 1000 acore

# Set working directory
WORKDIR /azerothcore

# Copy binaries from your working coc0nut build
# We'll extract these from your successful build
COPY --from=acore/ac-wotlk-worldserver:master /azerothcore/env/dist/bin/worldserver /azerothcore/bin/
COPY --from=acore/ac-wotlk-authserver:master /azerothcore/env/dist/bin/authserver /azerothcore/bin/
COPY --from=acore/ac-wotlk-db-import:master /azerothcore/env/dist/bin/dbimport /azerothcore/bin/
COPY --from=acore/ac-wotlk-client-data:master /azerothcore/env/dist/data /azerothcore/data/

# Copy configuration files
COPY --from=acore/ac-wotlk-worldserver:master /azerothcore/env/ref/etc /azerothcore/etc/

# Create necessary directories
RUN mkdir -p /azerothcore/logs \
             /var/lib/mysql \
             /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld && \
    chown -R 1000:1000 /azerothcore

# Copy supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy startup script
COPY entrypoint.sh /azerothcore/entrypoint.sh
RUN chmod +x /azerothcore/entrypoint.sh

# Expose ports
EXPOSE 3306 3724 8085

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=120s --retries=3 \
    CMD curl -f http://localhost:8085 || exit 1

# Use supervisor to manage all services
ENTRYPOINT ["/azerothcore/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
