FROM docker-registry.engineering.redhat.com/centralci/jnlp-slave-base:1.5
ENV PYTHON_MAJOR_VERSION=3 \
    PYTHON_MINOR_VERSION=6

ENV PYTHON_VERSION="${PYTHON_MAJOR_VERSION}.${PYTHON_MINOR_VERSION}" \
    PYTHON_SCL_NAME_VERSION="${PYTHON_MAJOR_VERSION}${PYTHON_MINOR_VERSION}"

ENV PYTHON_SCL="rh-python${PYTHON_SCL_NAME_VERSION}"
RUN yum install -y centos-release-scl-rh && \
    yum-config-manager --add-repo https://cbs.centos.org/repos/sclo7-${PYTHON_SCL}-rh-release/x86_64/os/ && \
    echo gpgcheck=0 >> /etc/yum.repos.d/cbs.centos.org_repos_sclo7-${PYTHON_SCL}-rh-release_x86_64_os_.repo && \
    INSTALL_PKGS=" \
    ${PYTHON_SCL} \
    ${PYTHON_SCL}-python-pip" && \
    yum install -y --setopt=tsflags=nodocs ${INSTALL_PKGS} && \
    yum clean all -y && \
    rpm -V ${INSTALL_PKGS}

ENV LC_ALL="en_US.UTF-8"\
    LANG="en_US.UTF-8" \
    PATH="$PATH:/opt/rh/$PYTHON_SCL/root/usr/bin" \
    LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/opt/rh/$PYTHON_SCL/root/usr/lib64" \
    MANPATH="$MANPATH:/opt/rh/$PYTHON_SCL/root/usr/share/man" \
    PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/rh/$PYTHON_SCL/root/usr/lib64/pkgconfig" \
    XDG_DATA_DIRS="$XDG_DATA_DIRS:/opt/rh/$PYTHON_SCL/root/usr/share" \
    X_SCLS="$PYTHON_SCL" \
    DEV_PI="" \
    IQE_VENV="$HOME/iqe_venv"

RUN pip install --upgrade pip setuptools wheel devpi

USER 1001

RUN devpi use $DEV_PI --set-cfg --venv $IQE_VENV

ENV PATH="$IQE_VENV/bin:$PATH"

RUN chmod -R a+rwx $IQE_VENV && \
    chmod -R a+rwx $HOME/.cache
