{ pkgs }:
with pkgs;
let
  my-python-packages = python-packages: with python-packages; [
    (callPackage ../discordpy.nix { })
  ];
  python-with-my-packages = python3.withPackages my-python-packages;
in
  {
      description = "PROGRAMMESWAG";
      after = [ "network.target" ];

      serviceConfig = {
          Type = "simple";
          User = "thomas";
          ExecStart = python-with-my-packages + "/bin/python ./discordbot.py";
          WorkingDirectory = "/home/thomas/services/discordbot";
          Restart = "on-failure";
      };

      environment = {
          PYTHON_HOME = python-with-my-packages;
      };

      wantedBy = [ "multi-user.target" ];
}
