{ nixpkgs ? <nixpkgs>
, src ? (import <nixpkgs/lib/sources.nix>).cleanSource ./. }:

with import nixpkgs {};

let
    pkgs = import <nixpkgs> {};
    modules = python27.modules;
    buildFromGitHub = { rev, owner, repo, sha256, curlOpts ? "", name ? repo, ... }@args: buildPythonPackage (args // {
    name = "python-${stdenv.lib.toLower name}-${stdenv.lib.strings.substring 0 7 rev}";
    src = if curlOpts == ""
      then fetchFromGitHub { inherit rev owner repo sha256; }
      else fetchzip { inherit sha256 curlOpts; url = "https://github.com/${owner}/${repo}/archive/${rev}.zip"; };
    });
    buildFromPyPI = { package, version, md5, name ? package, file ? "${package}-${version}.tar.gz", ... }@args: buildPythonPackage (args // {
        inherit version;
        name = "python-${stdenv.lib.toLower name}-${version}";
        src = fetchurl {
          inherit md5;
          url = "https://pypi.python.org/packages/source/${stdenv.lib.strings.substring 0 1 package}/${package}/${file}";
        };
    });

    python-crontab = buildFromPyPI {
        package = "python-crontab";
        version = "1.9.3";
        md5 = "4c19daa37bccd26d82c151138fe448ff";
        propagatedBuildInputs = with pkgs.python27Packages; [ dateutil ];

    };

    python-django = buildFromPyPI {
        package = "Django";
        version = "1.8.3";
        md5 = "31760322115c3ae51fbd8ac85c9ac428";
    };

    python-xmltodict = buildFromPyPI {
        package = "xmltodict";
        version = "0.9.2";
        md5 = "ab17e53214a8613ad87968e9674d75dd";
        buildInputs = [
          python-coverage
          python-nose
        ];
    };

    python-coverage = buildFromPyPI {
        package = "coverage";
        version = "4.0a6";
        md5 = "67d4e393f4c6a5ffc18605409d2aa1ac";
        };
        python-requests = buildFromPyPI {
        package = "requests";
        version = "2.7.0";
        md5 = "29b173fd5fa572ec0764d1fd7b527260";
        propagatedBuildInputs = [
        python-urllib3
        ];
    };

    python-certifi = buildFromPyPI {
        package = "certifi";
        version = "2015.04.28";
        md5 = "315ea4e50673a16ab047099f816fd32a";
    };

    python-cffi = buildFromPyPI {
        package = "cffi";
        version = "1.1.2";
        md5 = "ca6e6c45b45caa87aee9adc7c796eaea";
        propagatedBuildInputs = [
        libffi
        python-pycparser
        ];
    };

    python-pycparser = buildFromPyPI {
        package = "pycparser";
        version = "2.14";
        md5 = "d87aed98c8a9f386aa56d365fe4d515f";
    };

    python-mock = buildFromPyPI {
        package = "mock";
        version = "1.0.1";
        md5 = "c3971991738caa55ec7c356bbc154ee2";
        buildInputs = [
        python-unittest2
        ];
    };

    python-unittest2 = buildFromPyPI {
        package = "unittest2";
        version = "0.5.1";
        md5 = "a0af5cac92bbbfa0c3b0e99571390e0f";
    };

    python-nose = buildFromPyPI {
        package = "nose";
        version = "1.3.7";
        md5 = "4d3ad0ff07b61373d2cefc89c5d0b20b";
        doCheck = !stdenv.isDarwin;
    };

    python-pandas = buildFromPyPI {
      package = "pandas";
      version = "0.15.2";
      md5 = "d74481b57fda726a9ed60b223f0ad4b7";
      doCheck = false;
      buildInputs = [
        python-nose
      ];
      propagatedBuildInputs = with pkgs.python27Packages; [ dateutil numpy pytz modules.sqlite3 ];
    };

    python-backports-ssl_match_hostname = buildFromPyPI {
        package = "backports.ssl_match_hostname";
        name = "backports-ssl_match_hostname";
        version = "3.4.0.2";
        md5 = "788214f20214c64631f0859dc79f23c6";
    };

    python-tornado = buildFromPyPI {
        package = "tornado";
        version = "4.2";
        md5 = "c548d7b77a11d523c3d7255bd7fd6df8";
        propagatedBuildInputs = [
        python-backports-ssl_match_hostname
        python-certifi
        ];
    };

    python-urllib3 = buildFromPyPI {
        package = "urllib3";
        version = "1.10.4";
        md5 = "517e6c293e1d144ff3e67486d69249c6";
        buildInputs = [
        python-mock
        python-nose
        python-tornado
        ];
        propagatedBuildInputs = [
        python-ndg-httpsclient
        python-pyopenssl
        ];
        doCheck = false;  # Long test time
    };

    python-ndg-httpsclient = buildFromPyPI rec {
        package = "ndg-httpsclient";
        version = "0.4.0";
        file = "ndg_httpsclient-${version}.tar.gz";
        md5 = "81972c0267d5a47d678211ac854838f5";
        propagatedBuildInputs = [
        python-pyopenssl
        ];
    };

    python-pyopenssl = buildFromPyPI {
        package = "pyOpenSSL";
        version = "0.15.1";
        md5 = "f447644afcbd5f0a1f47350fec63a4c6";
        propagatedBuildInputs = [
        python-cryptography
        python-six
        ];
        doCheck = false;  # Tests fail
    };

    python-enum = buildFromPyPI {
        name = "enum";
        package = "enum34";
        version = "1.0.4";
        md5 = "ac80f432ac9373e7d162834b264034b6";
    };

    python-idna = buildFromPyPI {
        package = "idna";
        version = "2.0";
        md5 = "bd17a9d15e755375f48a62c13b25b801";
    };

    python-ipaddress = buildFromPyPI {
        package = "ipaddress";
        version = "1.0.7";
        md5 = "5d9ecf415cced476f7781cf5b9ef70c4";
    };

    python-iso8601 = buildFromPyPI {
        package = "iso8601";
        version = "0.1.10";
        md5 = "23acb1029acfef9c32069c6c851c3a41";
    };

    python-pretend = buildFromPyPI {
        package = "pretend";
        version = "1.0.8";
        md5 = "7147050a95c9f494248557b42b58ad79";
    };

    python-pyasn1 = buildFromPyPI {
        package = "pyasn1";
        version = "0.1.8";
        md5 = "2cbd80fcd4c7b1c82180d3d76fee18c8";
    };

    python-cryptography = buildFromPyPI {
        package = "cryptography";
        version = "0.9.1";
        md5 = "6c45d87896f5155f25cdc4d7e0a57526";
        propagatedBuildInputs = [
        openssl
        python-cffi
        python-cryptography-vectors
        python-enum
        python-idna
        python-ipaddress
        python-iso8601
        python-pretend
        python-pyasn1
        python-pytest
        python-six
        ] ++ stdenv.lib.optional stdenv.isDarwin darwin.Security;
        };
        python-pytest = buildFromPyPI {
        package = "pytest";
        version = "2.7.2";
        md5 = "dcd8e891474d605b81fc7fcc8711e95b";
        propagatedBuildInputs = [
        python-py
        ];
        doCheck = false;  # Requires compgen which isn't included in the build environment
        };
        python-py = buildFromPyPI {
        package = "py";
        version = "1.4.30";
        md5 = "a904aabfe4765cb754f2db84ec7bb03a";
    };

    python-cryptography-vectors = buildFromPyPI rec {
        package = "cryptography-vectors";
        version = "0.9.1";
        file = "cryptography_vectors-${version}.tar.gz";
        md5 = "75458f08804aafe4585a10f751c9c51a";
    };

    python-pytz = buildFromPyPI {
        package = "pytz";
        version = "2015.4";
        md5 = "417a47b1c432d90333e42084a605d3d8";
    };

    python-httplib2 = buildFromPyPI {
        package = "httplib2";
        version = "0.9.1";
        md5 = "c49590437e4c5729505d034cd34a8528";
    };

    python-six = buildFromPyPI {
        package = "six";
        version = "1.9.0";
        md5 = "476881ef4012262dfc8adc645ee786c4";
    };

    python-twilio = buildFromGitHub {
        repo = "twilio-python";
        owner = "twilio";
        rev = "2b691507d0d631fa3ad1416625a03a81ccac3567";
        sha256 = "0flwhvxjm1lb6n48vky4jsvz9a6vvrbby9kllkvl711jc9phql34";
        doCheck = false;  # Tests fail
        propagatedBuildInputs = [
        python-pytz
        python-six
        python-httplib2
        ];
    };

    python-mintapi = buildFromGitHub {
        repo = "mintapi";
        owner = "mrooney";
        rev = "432a3b5c0f5f80cf0bab349658006b04b84fb2d1";
        sha256 = "0fhhqr597v8115pc96x17i1si5klr8b6zbkk2ai5zf6n3vbzg3zg";
        doCheck = false;
        propagatedBuildInputs = [
            python-requests
            python-xmltodict
        ];
    };

in buildPythonPackage {
      name = "susan-personal";
      src = src;
      propagatedBuildInputs = [
        python-twilio
        python-mintapi
        python-pandas
        python-crontab
        python-django
     ];
    }
