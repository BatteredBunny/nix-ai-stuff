{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.services.tabbyapi;
  yamlFormat = pkgs.formats.yaml { };
  configFile = yamlFormat.generate "config.yml" cfg.settings;
in
{
  options.services.tabbyapi = {
    enable = lib.mkEnableOption "tabbyapi";

    package = lib.mkPackageOption pkgs "tabbyapi" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for the TabbyAPI port.";
    };

    settings = lib.mkOption {
      description = ''
        Configuration for TabbyAPI. More important options are exposed via nix, others can be simply defined without nix options.
      '';
      default = { };
      type = lib.types.submodule {
        freeformType = yamlFormat.type;

        options = {
          network = lib.mkOption {
            description = "Network configuration.";
            default = { };
            type = lib.types.submodule {
              freeformType = yamlFormat.type;
              options = {
                host = lib.mkOption {
                  type = lib.types.str;
                  default = "127.0.0.1";
                  description = "The IP to host on. Use 0.0.0.0 to expose on all adapters.";
                };

                port = lib.mkOption {
                  type = lib.types.port;
                  default = 5000;
                  description = "The port to host on.";
                };

                disable_auth = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Disable HTTP token authentication. WARNING: Vulnerable if exposed.";
                };

                api_servers = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [ "OAI" ];
                  description = "Select API servers to enable. Options: OAI, Kobold.";
                };
              };
            };
          };

          logging = lib.mkOption {
            description = "Logging configuration.";
            default = { };
            type = lib.types.submodule {
              freeformType = yamlFormat.type;
              options = {
                log_prompt = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Enable prompt logging.";
                };

                log_requests = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Enable request logging. Only use for debug.";
                };
              };
            };
          };

          model = lib.mkOption {
            description = "Model loading configuration.";
            default = { };
            example = {
              model_name = "qwen-8b";
              model_dir = pkgs.tabbyapiModelDir {
                qwen-8b = pkgs.fetchgit {
                  url = "https://huggingface.co/turboderp/Qwen3-VL-8B-Instruct-exl3";
                  rev = "652ab6be95b3e2880e78d87269013d98ca9c392d"; # 4bpw
                  fetchLFS = true;
                  hash = "sha256-n+9Mt7EZ3XHM0w8oGUZr4EBz91EFyp1VBpvl9Php/QM=";
                };
              };
            };
            type = lib.types.submodule {
              freeformType = yamlFormat.type;
              options = {
                model_dir = lib.mkOption {
                  type = lib.types.str;
                  default = "models";
                  description = "Directory to look for models. Relative to the state directory.";
                };

                model_name = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "The initial model to load on startup. Must exist in model_dir.";
                };

                max_seq_len = lib.mkOption {
                  type = lib.types.nullOr lib.types.int;
                  default = null;
                  description = "Max sequence length. Set null to use model defaults.";
                };

                cache_mode = lib.mkOption {
                  type = lib.types.str;
                  default = "FP16";
                  description = "Cache mode for VRAM savings. ExLlamaV2: FP16, Q8, Q6, Q4. ExLlamaV3: specific pair string (e.g., '8,8').";
                };

                gpu_split_auto = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = "Automatically allocate resources to GPUs.";
                };

                dummy_model_names = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [ "gpt-3.5-turbo" ];
                  description = "List of fake model names sent via the /v1/models endpoint.";
                };
              };
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      cfg.settings.network.port
    ];

    systemd.services.tabbyapi = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      description = "TabbyAPI - OAI compatible server for Exllamav2";

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} --config=${configFile}";
        Restart = "always";
        StateDirectory = "tabbyapi";
        WorkingDirectory = "/var/lib/tabbyapi";
        User = "tabbyapi";
        Group = "tabbyapi";
        DynamicUser = true;

        # Hardening
        ProtectSystem = "strict";
        ProtectHome = "yes";
        LockPersonality = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
      };
    };
  };
}
