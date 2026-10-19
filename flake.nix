{
  description = "docker-than-light development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [ "aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (pkgs:
        let
          postgresql = pkgs.postgresql_17;

          # Per-project cluster in $PGDATA, reachable only via the unix socket in $PGHOST.
          pg-start = pkgs.writeShellScriptBin "pg-start" ''
            set -euo pipefail
            if [ ! -f "$PGDATA/PG_VERSION" ]; then
              ${postgresql}/bin/initdb --auth=trust --username="$USER" --encoding=UTF8 -D "$PGDATA" >/dev/null
            fi
            mkdir -p "$PGHOST"
            ${postgresql}/bin/pg_ctl -D "$PGDATA" -l "$PGDATA/postgres.log" \
              -o "-c listen_addresses= -k $PGHOST" start
          '';

          pg-stop = pkgs.writeShellScriptBin "pg-stop" ''
            ${postgresql}/bin/pg_ctl -D "$PGDATA" stop
          '';
        in
        {
          default = pkgs.mkShell {
            packages = [ postgresql pg-start pg-stop ];

            shellHook = ''
              export PGDATA="$PWD/tmp/postgres/data"
              export PGHOST="$PWD/tmp/postgres"
            '';
          };
        });
    };
}
