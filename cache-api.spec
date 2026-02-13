Name:           cache-api
Version:        1.0
Release:        1%{?dist}
Summary:        Flask cache API service - Gigadevops Project

License:        MIT
URL:            https://example.local
Source0:        %{name}-%{version}.tar.gz

BuildArch:      noarch

Requires:       python3
Requires:       python3-flask
Requires:       python3-redis
Requires:       python3-requests
Requires:       python3-pyyaml
Requires:       systemd

%description
Description

%prep
%autosetup

%build
# nothing to build

%install
rm -rf %{buildroot}

# app
install -d %{buildroot}/usr/libexec/cache-api
install -m 0755 cache-api.py %{buildroot}/usr/libexec/cache-api/cache-api.py

# config
install -d %{buildroot}/etc/cache-api
install -m 0644 config-api.yaml %{buildroot}/etc/cache-api/config.yaml

# systemd unit
install -d %{buildroot}/usr/lib/systemd/system
install -m 0644 cache-api.service %{buildroot}/usr/lib/systemd/system/cache-api.service

%pre
getent group cacheapi >/dev/null || groupadd -r cacheapi
getent passwd cacheapi >/dev/null || \
    useradd -r -g cacheapi -d / -s /sbin/nologin \
    -c "Cache API Service User" cacheapi

%post
%systemd_post cache-api.service

%preun
%systemd_preun cache-api.service

%postun
%systemd_postun cache-api.service

%files
/usr/libexec/cache-api/cache-api.py
/etc/cache-api/config.yaml
/usr/lib/systemd/system/cache-api.service

%config(noreplace) /etc/cache-api/config.yaml
