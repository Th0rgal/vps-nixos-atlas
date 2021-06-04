{ pkgs }:
with pkgs;
let
  polymath = python38.withPackages
    (python-packages: with python-packages; [ cython aiohttp toml ]);
in {
  description = "PROGRAMMESWAG";
  after = [ "network.target" ];

  serviceConfig = {
    Type = "simple";
    User = "thomas";
    ExecStart = polymath + "/bin/python ./run";;
    WorkingDirectory = "/home/thomas/services/polymath";
    Restart = "on-failure";
  };

  environment = { PYTHON_HOME = polymath; };

  wantedBy = [ "multi-user.target" ];
}
